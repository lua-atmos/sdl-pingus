local IMG = require "SDL.image"

local G = 0.2

function Sprite (pos, n, path)
    local sfc = assert(IMG.load(path))
    local img = assert(REN:createTextureFromSurface(sfc))
    local _,_,W,h = img:query()
    local w = math.floor(W / n)

    local i
    par(function ()
        i = 0
        every(clock{ms=25}, function ()
            i = (i+w) % W
        end)
    end, function ()
        every('sdl.draw', function ()
            local rect = {x=pos.x, y=pos.y, w=w, h=h}
            local crop = { x=i, y=0, w=w, h=h }
            REN:copy(img, crop, rect)
        end)
    end)
end

function Pingu (pos)
    local spd = {x=0,y=0}

    local Faller = function ()
        local _ <close> = defer(function ()
            spd.y = 0
        end)
        spawn(Sprite, pos, 8, "data/images/faller.png")
        catch('out', function ()
            every('clock', function (_,ms)
                spd.y = spd.y + ((ms*G) / 1000)
                if pos.y > 400 then
                    throw 'out'
                end
            end)
        end)
    end

    local Walker = function ()
        while true do
            do
                spd.x = 0.05
                local _ <close> = spawn(Sprite, pos, 8, "data/images/right.png")
                await(function ()
                    return pos.x > 600
                end)
            end
            do
                spd.x = -0.05
                local _ <close> = spawn(Sprite, pos, 8, "data/images/left.png")
                await(function ()
                    return pos.x < 40
                end)
            end
        end
    end

    spawn(function ()
        await(spawn(Faller))
        await(spawn(Walker))
    end)

    every('clock', function (_,ms)
        pos.x = math.floor(pos.x + (ms*spd.x))
        pos.y = math.floor(pos.y + (ms*spd.y))
    end)
end

return Pingu
