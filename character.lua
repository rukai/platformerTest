function newCharacter(x, y)
   local character = {}
    character.drawOffsetX = 8
    character.drawOffsetY = 7
    character.x = x + character.drawOffsetX
    character.y = y + character.drawOffsetY
    character.w = 15
    character.h = 24
    character.actor = "character"
    character.spritesheet = love.graphics.newImage("character.png")
    character.graphic = love.graphics.newCanvas(32, 32)

    character.walking = false
    --[[
    -- Possible States:
    -- ground
    -- air
    --]]
    character.state = "ground"
    character.xVelocity = 0
    character.yVelocity = 0 --Positive is up, negative is down
    character.dir = 1
    character.walkCounter = 0
    character.frame = 0

    function character:act()
        character:checkGrounded()
        if character.state == "air" then
            character:strafe()
            character:airPhysics()
        else
            character:jump()
            character:walk()
            character:walkCounters()
        end
        character:physics()
    end

    function character:physics()
        --hitbox checks!
        local minXMovement = character.xVelocity
        if minXMovement < 0 then
            --collision to the left
            for _, actor in ipairs(getCollidingActors(character.x - 32, character.y, 32, character.h)) do
                local newXMovement = actor.x + actor.w - character.x + 1 -- the 1 means that at a distance of 1 pixel from each other no movement will occur.
                if newXMovement > minXMovement then -- smallest yMovement is actually of a bigger value as it is negative.
                    minXMovement = newXMovement
                end
            end
        else
            --collision to the right
            for _, actor in ipairs(getCollidingActors(character.x + character.w, character.y, 32, character.h)) do
                local newXMovement = actor.x - (character.x + character.w + 1)
                if newXMovement < minXMovement then
                    minXMovement = newXMovement
                end
            end
        end
        character.x = character.x + minXMovement
    end

    function character:checkGrounded()
        if checkCollision(character.x , character.y + character.h + 1, character.w, 1) then
            character.state = "ground"
            character.yVelocity = 0
        else
            character.state = "air"
        end
    end

    function character:airPhysics()
        --min magnitude not including + or -
        local minYMovement = character.yVelocity
        if minYMovement < 0 then
            --collision below character
            for _, actor in ipairs(getCollidingActors(character.x, character.y + character.h, character.w, 32)) do
                local newYMovement = character.y + character.h - actor.y + 1 -- the 1 means that at a distance of 1 pixel from each other no movement will occur.
                if newYMovement > minYMovement then -- smallest yMovement is actually of a bigger value as it is negative.
                    minYMovement = newYMovement
                end
            end
        else
            --collision above character
            for _, actor in ipairs(getCollidingActors(character.x, character.y - 32, character.w, 32)) do
                local newYMovement = character.y - (actor.y + actor.h + 1)
                if newYMovement < minYMovement then
                    minYMovement = newYMovement
                    character.yVelocity = 0
                end
            end
        end
        character.y = character.y - minYMovement

        --accelleration due to gravity
        if character.yVelocity > -6 then
            character.yVelocity = character.yVelocity - 0.5
        end
    end

    function character:strafe()
        if love.keyboard.isDown("left") then
            character.xVelocity = -3.5
        elseif love.keyboard.isDown("right") then
            character.xVelocity = 3.5
        else
            character.xVelocity = character.xVelocity / 2
        end
    end

    function character:jump()
        if love.keyboard.isDown(" ") then
            character.yVelocity = 10
            character.y = character.y - 1
            character.walking = false
            character.state = "air"
        end
    end

    function character:walk()
        if love.keyboard.isDown("left") then
            character.xVelocity = -4
            character.walking = true
            character.dir = -1
        elseif love.keyboard.isDown("right") then
            character.xVelocity = 4
            character.walking = true
            character.dir = 1
        else
            character.walking = false
            character.xVelocity = 0
        end
    end

    function character:walkCounters()
        --walking counter
        character.walkCounter = character.walkCounter + 1
        if character.walkCounter == 6 then
            character.walkCounter = 0
            character.frame = character.frame + 1
            if character.frame == 3 then
                character.frame = 0
            end
        end
    end

    function character:draw()
        --current frame
        local frame = 0
        if character.walking then
            frame = character.frame
        elseif character.state == "air" then
            frame = 2
        end

        --mirror offset
        local xOffset = 0
        if character.dir == -1 then
            xOffset = 32;
        end

        --draw to graphic canvas
        love.graphics.setCanvas(character.graphic)
        --love.graphics.setBackgroundColor(255, 0, 255) --debug
        love.graphics.setBackgroundColor(0, 0, 0, 0)
        love.graphics.clear()
        quad = love.graphics.newQuad(32 * frame, 0, 32, 32, character.spritesheet:getDimensions())
        love.graphics.draw(character.spritesheet, quad, 0, 0, 0, character.dir, 1, xOffset, 0)
    end

    return character
end
