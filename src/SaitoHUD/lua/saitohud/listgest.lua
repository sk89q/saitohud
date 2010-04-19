-- SaitoHUD
-- Copyright (c) 2009-2010 sk89q <http://www.sk89q.com>
-- Copyright (c) 2010 BoJaN
-- 
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 2 of the License, or
-- (at your option) any later version.
-- 
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
-- 
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
-- 
-- $Id$

-- This modules provides list gesturing features.

SaitoHUD.Gesturing = false

local menu = {}
local lastIndex = 0

--- Builds the list gesture menu.
local function GetMenu()
    local menu = {}
    local numHooks = SaitoHUD.CountHooks("SaitoHUDListGestures")
    local registered = SaitoHUD.CallHookAggregate("SaitoHUDListGestures", numHooks)
    
    for _, items in pairs(registered) do
        table.Merge(menu, items)
    end
    
    table.insert(menu, 1, {
        text = "Cancel",
    })
    
    return menu
end

--- Starts list gesture; called from the +listgest concmd.
local function StartGesture(ply, cmd, args)
	SaitoHUD.Gesturing = true
    menu = GetMenu()
    lastIndex = 0
	gui.EnableScreenClicker(true)
end

--- Ends list gesture; called from the -listgest concmd.
local function EndGesture(ply, cmd, args)
	SaitoHUD.Gesturing = false
	gui.EnableScreenClicker(false)
    surface.PlaySound("ui/buttonclickrelease.wav")
    
    if menu[lastIndex] then
        local entry = menu[lastIndex]
        if type(entry.action) == "function" then
            entry.action(entry)
        elseif type(entry.action) == "string" then
            LocalPlayer():ConCommand(entry.action .. "\n")
        end
    end
end

local function HUDPaint()
	if not SaitoHUD.Gesturing then return end
    
    local offsetX, offsetY = ScrW() - 210, ScrH() * 0.1
    local mX, mY = gui.MousePos()
    local scX, scY = ScrW() / 2, ScrH() / 2
    local mDistance = math.max(math.abs(scY - mY) - 5, 0)
    local index = 1
    
    if mY > scY then
        index = math.min(math.floor(mDistance / 15) + 1, table.Count(menu))
    else
        index = 1
        --index = table.Count(menu) - math.min(math.floor(mDistance / 15), table.Count(menu) - 1)
    end
    
    if index ~= lastIndex then
        surface.PlaySound("weapons/pistol/pistol_empty.wav")
    end
    
    lastIndex = index
    
    for i, entry in pairs(menu) do
        local bgColor = entry.bgColor and entry.bgColor or Color(0, 0, 0, 255)
        local x, y = offsetX, offsetY + i * 30
        
        surface.SetFont("HudHintTextLarge")
        local w, h = surface.GetTextSize(entry.text)
        draw.RoundedBox(4, x - 3, y - h/2,
                        200 + 3, h + 12,
                        index == i and Color(255, 50, 50, 255) or bgColor)
        surface.SetTextColor(255, 255, 255, 200)
        surface.SetTextPos(x, y)
        surface.DrawText(entry.text)
    end
end

concommand.Add("+listgest", StartGesture)
concommand.Add("-listgest", EndGesture)
hook.Add("HUDPaint", "SaitoHUD.ListGest", HUDPaint)