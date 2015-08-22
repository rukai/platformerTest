--[[
-- color pallete
-- e0f8d0
-- 88c070
-- 306850
-- 081820
--]]

require("block")
require("character")
require("collision")

function love.load()
    love.window.setMode(1280, 960)
    canvas = love.graphics.newCanvas(640, 480)

    dtFrameWait = 0
    actors = {}

    --[[
    -- b = block
    -- c = character
    --]]
    stage = {
        {'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b'},
        {'b', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'b'},
        {'b', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'b'},
        {'b', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'b', 'b', 'b', ' ', ' ', ' ', ' ', ' ', ' ', 'b'},
        {'b', ' ', ' ', ' ', ' ', 'b', 'b', 'b', 'b', 'b', ' ', ' ', ' ', ' ', ' ', ' ', 'b', 'b', ' ', 'b'},
        {'b', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'b', 'b', ' ', 'b'},
        {'b', ' ', ' ', ' ', 'b', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'b'},
        {'b', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'b'},
        {'b', ' ', ' ', 'b', 'b', 'b', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'b'},
        {'b', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'b', ' ', ' ', 'b'},
        {'b', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'b', 'b', ' ', ' ', 'b'},
        {'b', ' ', ' ', ' ', ' ', ' ', 'b', 'b', 'b', 'b', 'b', ' ', ' ', ' ', 'b', 'b', 'b', ' ', ' ', 'b'},
        {'b', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'b', 'b', 'b', 'b', ' ', ' ', 'b'},
        {'b', ' ', 'c', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'b', 'b', 'b', 'b', 'b', ' ', ' ', 'b'},
        {'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b'},
    }
    for y = 1, #stage do
        for x = 1, #stage[y] do
            actorX = (x-1) * 32
            actorY = (y-1) * 32
            if stage[y][x] == 'c' then
                table.insert(actors, newCharacter(actorX, actorY))
            elseif stage[y][x] == 'b' then
                table.insert(actors, newBlock(actorX, actorY))
            end
        end
    end
end

hitboxes = {}
function love.update(dt)
    --timing
    dtFrameWait = dtFrameWait + dt
    if dtFrameWait > 1 / 60 then
        dtFrameWait = 0

        --hitbox debug
        hitboxes = {}

        --call actors
        for _, actor in ipairs(actors) do
            actor:act()
        end

    end
end

function love.draw()
    --update actors graphic
    for _, actor in ipairs(actors) do
        actor:draw()
    end

    love.graphics.setCanvas(canvas)
    
    --background
    love.graphics.setBackgroundColor(0xe0, 0xf8, 0xd0)
    love.graphics.clear()
    
    --draw actors
    for _, actor in ipairs(actors) do
        love.graphics.draw(actor.graphic, actor.x - actor.drawOffsetX, actor.y - actor.drawOffsetY)
    end

    --draw hitboxes
    if love.keyboard.isDown("z") then
        for _, hitbox in ipairs(hitboxes) do
            x, y, w, h = unpack(hitbox)
            love.graphics.setColor(255, 0, 0, 160)
            love.graphics.rectangle("fill", x, y, w, h)
        end
        love.graphics.setColor(255, 255, 255)
    end
    
    --draw canvas to screen
    love.graphics.setCanvas()
    canvas:setFilter("nearest", "nearest")
    love.graphics.draw(canvas, 0, 0, 0, 2, 2)
end
