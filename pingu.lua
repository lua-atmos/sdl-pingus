local sdl = require "atmos.env.sdl"
local IMG = require "SDL.image"

local G = 0.2

Sprite = task(function (pos, n, path)
    local sfc = assert(IMG.load(path))
    local img = assert(REN:createTextureFromSurface(sfc))
    local _,_,W,h = img:query()
    local w = W / n

    local i
    par(function ()
        i = 0
        loop_on(50*_ms_, function ()
            i = (i+w) % W
        end)
    end, function ()
        loop_on('sdl.draw', function ()
            local rect = {x=pos.x, y=pos.y, w=w, h=h}
            local crop = { x=i, y=0, w=w, h=h }
            REN:copy(img, crop, sdl.ints(rect))
        end)
    end)
end)

Pingu = task(function (pos)
    local spd = {x=0,y=0}

    local Faller = task(function ()
        local _ <close> = defer(function ()
            spd.y = 0
        end)
        spawn(Sprite, pos, 8, "data/images/faller.png")
        catch('out', function ()
            loop_on('clock', function (us)
                local ms = us / 1000
                spd.y = spd.y + ((ms*G) / 1000)
                if pos.y > 400 then
                    throw 'out'
                end
            end)
        end)
    end)

    local Walker = task(function ()
        while true do
            do
                spd.x = 0.05
                local _ <close> = spawn(Sprite, pos, 8, "data/images/right.png")
                await {tag='until', function ()
                    return pos.x > 600
                end}
            end
            do
                spd.x = -0.05
                local _ <close> = spawn(Sprite, pos, 8, "data/images/left.png")
                await {tag='until', function ()
                    return pos.x < 40
                end}
            end
        end
    end)

    do_spawn(function ()
        await(spawn(Faller))
        await(spawn(Walker))
    end)

    loop_on('clock', function (us)
        local ms = us / 1000
        pos.x = pos.x + (ms*spd.x)
        pos.y = pos.y + (ms*spd.y)
    end)
end)

return Pingu
