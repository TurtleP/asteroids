local world = {}

local function can_interact(a, b)
    return a ~= b and a:active() and b:active() and a:screen() == b:screen()
end

local function can_delete(object)
    return object.delete and object:delete()
end

function world:init()
    self._objects = {}
    self._delete_pool = {}
end

function world:addObject(object)
    table.insert(self._objects, object)
end

function world:countObjects(type)
    local count = 0
    for _, value in ipairs(self._objects) do
        if value.type and value:type() == type then
            count = count + 1
        end
    end
    return count
end

function world:__checkDeleted(dt)
    for index = #self._objects, 1, -1 do
        if can_delete(self._objects[index]) or self._objects[index]:update(dt) then
            table.remove(self._objects, index)
        end
    end
end

function world:update(dt)
    world.__checkDeleted(self, dt)

    for _, object in ipairs(self._objects) do
        for _, other in ipairs(self._objects) do
            if can_interact(object, other) then
                if other:active() and intersect.point_in_poly(object._position, other:points()) then
                    if object.collide then
                        object:collide(other:type(), other)
                    end

                    if other.collide then
                        other:collide(object:type(), object)
                    end
                end
            end
        end
    end
end

function world:draw(screen)
    for _, object in ipairs(self._objects) do
        if object.draw and isOnScreen(screen, object) then
            object:draw()
        end
    end
end

return world
