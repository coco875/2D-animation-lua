local vec = require("vector.vec")

local Object3D = {}

Object3D.__index = Object3D

function Object3D:new()
    local self = setmetatable({}, Object3D)
    self.position = vec:new(0, 0, 0, 1)
    self.rotation = vec:new(0, 0, 0)
    self.size3d = vec:new(1, 1, 1)
    self.children = {}
    self.parent = nil
    self.points = vec:new(
        vec:new(0, 0, 0, 1),
        vec:new(0, 1, 0, 1),
        vec:new(1, 1, 0, 1),
        vec:new(1, 0, 0, 1),
        vec:new(0, 0, 1, 1),
        vec:new(0, 1, 1, 1),
        vec:new(1, 1, 1, 1),
        vec:new(1, 0, 1, 1)
    )
    return self
end

function Object3D:rotate(x, y, z)
    if y == nil and type(x) ~= "table" then
        y = 0
        z = 0
    end
    self.rotation = self.rotation + vec:new(x, y, z)
end

function Object3D:translate(x, y, z)
    self.position = self.position + vec:new(x, y, z, 0)
end

function Object3D:scale(x, y, z)
    if y == nil and type(x) ~= "table" then
        y = x
        z = x
    end
    self.size3d = self.size3d:multiple(vec:new(x, y, z))
end

function Object3D:apply_matrix()
    local points = vec:new(self.points)
    -- scale
    points = points * vec:new(
        vec:new(self.size3d.x, 0, 0, 0),
        vec:new(0, self.size3d.y, 0, 0),
        vec:new(0, 0, self.size3d.z, 0),
        vec:new(0, 0, 0, 1)
    )

    -- rotation x
    points = points * vec:new(
        vec:new(1,0,0,0),
        vec:new(0,math.cos(self.rotation.x),math.sin(self.rotation.x),0),
        vec:new(0,-math.sin(self.rotation.x),math.cos(self.rotation.x),0),
        vec:new(0,0,0,1)
    )

    -- rotation y
    points = points * vec:new(
        vec:new(math.cos(self.rotation.y),0,-math.sin(self.rotation.y),0),
        vec:new(0,1,0,0),
        vec:new(math.sin(self.rotation.y),0,math.cos(self.rotation.y),0),
        vec:new(0,0,0,1)
    )

    -- rotation z
    points = points * vec:new(
        vec:new(math.cos(self.rotation.z),math.sin(self.rotation.z),0,0),
        vec:new(-math.sin(self.rotation.z),math.cos(self.rotation.z),0,0),
        vec:new(0,0,1,0),
        vec:new(0,0,0,1)
    )

    -- translation
    points = points * vec:new(
        vec:new(1, 0, 0, 0),
        vec:new(0, 1, 0, 0),
        vec:new(0, 0, 1, 0),
        vec:new(self.position.x, self.position.y, self.position.z, 1)
    )
    return points
end

function Object3D:__tostring()
    return "Object3D: " .. tostring(self.position) .. " " .. tostring(self.rotation) .. " " .. tostring(self.size3d)
end

function Object3D:draw(camera)
    local points = self:apply_matrix()
    points = camera:transform_point(points)
    love.graphics.setColor(1, 1, 1)
    for i = 0, points.size-1 do
        local point = points[i]
        if point.z > 0 then
            love.graphics.circle("fill", point.x, point.y, 5)
        end
    end
end

return Object3D