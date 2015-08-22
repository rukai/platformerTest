function AABB(x1, y1, w1, h1, x2, y2, w2, h2)
    local xCheck = x1 + w1 > x2 and x1 < x2 + w2
    local yCheck = y1 + h1 > y2 and y1 < y2 + h2
    return xCheck and yCheck
end

function checkCollision(x, y, w, h)
    table.insert(hitboxes, {x, y, w, h})
    for _, actor in ipairs(actors) do
        if AABB(x, y, w, h, actor.x, actor.y, actor.w, actor.h) and actor.actor ~= "character" then
            return true
        end
    end
    return false
end

function getCollidingActors(x, y, w, h)
    collides = {}
    table.insert(hitboxes, {x, y, w, h})
    for _, actor in ipairs(actors) do
        if AABB(x, y, w, h, actor.x, actor.y, actor.w, actor.h) and actor.actor ~= "character" then
            table.insert(collides, actor)
        end
    end
    return collides
end
