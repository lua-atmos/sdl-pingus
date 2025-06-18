local SDL = require "SDL"
local IMG = require "SDL.image"
local sdl = require "atmos.env.sdl"

local PP  = sdl.pct_to_pos

local Menu = {}

function Menu.Button (pos, tit)
    local sfc = assert(IMG.load("data/images/menuitem.png"))
    local img = assert(REN:createTextureFromSurface(sfc))
    local dim = totable('w', 'h', sfc:getSize())
    local rect = sdl.rect(pos, dim)
    spawn(function ()
        every('SDL.Draw', function ()
            REN:copy(img, nil, rect)
            sdl.write(FNT, tit, pos)
        end)
    end)
    await(SDL.event.MouseButtonDown, function (e)
        return sdl.point_vs_rect(e, rect)
    end)
end

function Menu.Main ()
    return par_or(function ()
        await(spawn(Menu.Button, PP(25,25), "Story"))
        return 'Menu.Story'
    end, function ()
        await(spawn(Menu.Button, PP(75,25), "Editor"))
        return 'Menu.Editor'
    end, function ()
        await(spawn(Menu.Button, PP(25,50), "Levelsets"))
        return 'Menu.Levelsets'
    end, function ()
        await(spawn(Menu.Button, PP(75,50), "Options"))
        return 'Menu.Options'
    end, function ()
        await(spawn(Menu.Button, PP(50,75), "Exit"))
        return 'Menu.Exit'
    end)
end

return Menu
