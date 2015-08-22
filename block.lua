function newBlock(x, y)
    local block = {}
    block.x = x
    block.y = y
    block.w = 32
    block.h = 32
    block.drawOffsetX = 0
    block.drawOffsetY = 0
    block.actor = "block"

    block.graphic = love.graphics.newImage("block.png")
    block.draw = function () end
    block.act = function () end

    return block
end
