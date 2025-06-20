local SDL = require "SDL"
local IMG = require "SDL.image"
local TTF = require "SDL.ttf"

require "atmos"
local sdl = require "atmos.env.sdl"

local Menu  = require "menu"
local Level = require "level"

local PP = sdl.pct_to_pos

assert(TTF.init())
local _ <close> = defer(function ()
    TTF.quit()
    SDL.quit()
end)

WIN = assert(SDL.createWindow {
	title  = "Pingus",
	width  = 640,
	height = 480,
    flags  = { SDL.flags.OpenGL },
})
REN = assert(SDL.createRenderer(WIN,-1))

FNT = assert(TTF.open("data/fonts/film-cryptic/Filmcryptic.ttf", 45))

--pico.set.color.clear <- [200,200,200,255]

--[[
spawn {
    every @1 {
        ;;println(pico.v.CPU)
    }
}
]]

spawn(function ()
    --await spawn Level ()
    while true do
        local opt = await(spawn(Menu.Main))
        local cnt = PP(50, 50)
        if false then
        elseif opt == 'Menu.Story' then
            await(spawn(Level))
        elseif opt == 'Menu.Editor' then
            await(spawn(Menu.Button, cnt, "Editor"))
        elseif opt == 'Menu.Levelsets' then
            await(spawn(Menu.Button, cnt, "Levelsets"))
        elseif opt == 'Menu.Options' then
            await(spawn(Menu.Button, cnt, "Options"))
        elseif opt == 'Menu.Exit' then
            sdl.quit()
        else
            error "bug found"
        end
    end
end)

sdl.loop(REN)
