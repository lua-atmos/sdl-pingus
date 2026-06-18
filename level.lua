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

Level = task(function ()
    local pingus <close> = tasks()
    loop_on(1*_s_, function ()
        print(#pingus._.dns)
        local pos = sdl.pct_to_pos(50, 25)
        spawn_in(pingus, Pingu, pos)
        --await(false)
    end)
end)

return Level
