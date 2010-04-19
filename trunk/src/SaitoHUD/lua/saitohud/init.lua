-- SaitoHUD
-- Copyright (c) 2009, 2010 sk89q <http://www.sk89q.com>
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

SaitoHUD = {}

local additionalModules = CreateClientConVar("saitohud_modules", "", false, false)

local function load(module)
    path = "saitohud/" .. module .. ".lua"
    Msg("Loading: " .. path .. "...\n")
    include(path)
end

Msg("====== Loading SaitoHUD ======\n")

load("filters") -- Entity filtering engine
load("lib")
load("base")
load("drawing")
load("light")
load("listgest")
load("overlays") -- Entity overlay information
load("sampling") -- Entity path tracking
load("aimtrace")
load("stranded")
load("sandbox")
load("lua")
load("cinematography")

Msg("Loading additional modules...\n")

local modules = string.Explode(",", additionalModules:GetString())
for _, module in pairs(modules) do
    local module = string.Trim(module)
    if module ~= "" then
        load(module)
    end
end

Msg("==============================\n")