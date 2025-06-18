local sdl = require "atmos.env.sdl"
local Pingu = require "pingu"

--[[
type Tile = [pos:Point, path:_(char*)] + <
    Background = ()
    Liquid     = ()
    Hotspot    = ()
    Ground     = ()
>
var tiles = ...
]]

function Level ()
    local pingus <close> = tasks()
    every(clock{s=1}, function ()
        print(#pingus._.dns)
        local pos = sdl.pct_to_pos(50, 25)
        spawn_in(pingus, Pingu, pos)
        --await(false)
    end)
end

return Level
