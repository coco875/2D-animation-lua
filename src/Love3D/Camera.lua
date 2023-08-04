local vec = require("vector").vec

local Camera = {}
Camera.__index = Camera

function Camera:new(pos, angle)
    self = setmetatable({}, Camera)
    self.position = vec:new(pos or {0, 0, 0, 1})
    self.angle = vec:new(angle or {0.0, 0.0, 0.0})
    self.fov = math.pi/2
    self.nearClip = 0.1
    self.farClip = 100
    self.aspectRatio = love.graphics.getWidth()/love.graphics.getHeight()
    self:caclulate_projection()
    return self
end

function Camera:caclulate_projection()
    self.projection_matrix = vec:new{
        {-1/(self.aspectRatio*math.tan(self.fov/2)), 0, 0, 0},
        {0, -1/math.tan(self.fov/2), 0, 0},
        {0, 0, (self.farClip+self.nearClip)/(self.farClip-self.nearClip), 1},
        {love.graphics.getWidth()/2, love.graphics.getHeight()/2, -(2*self.farClip*self.nearClip)/(self.farClip-self.nearClip), 0}
    }
end

function Camera:control()
    local speed = 1
    if love.keyboard.isDown("s") then
        self.position = self.position + vec:new(0, 0, -speed, 0)
    end
    if love.keyboard.isDown("z") then
        self.position = self.position + vec:new(0, 0, speed, 0)
    end
    if love.keyboard.isDown("q") then
        self.position = self.position + vec:new(-speed, 0, 0, 0)
    end
    if love.keyboard.isDown("d") then
        self.position = self.position + vec:new(speed, 0, 0, 0)
    end
    if love.keyboard.isDown("space") then
        self.position = self.position + vec:new(0, speed, 0, 0)
    end
    if love.keyboard.isDown("lshift") then
        self.position = self.position + vec:new(0, -speed, 0, 0)
    end
    angular_speed = 0.01
    if love.keyboard.isDown("left") then
        self.angle = self.angle + vec:new(0, angular_speed, 0)
    end
    if love.keyboard.isDown("right") then
        self.angle = self.angle + vec:new(0, -angular_speed, 0)
    end
    if love.keyboard.isDown("down") then
        self.angle = self.angle + vec:new(-angular_speed, 0, 0)
    end
    if love.keyboard.isDown("up") then
        self.angle = self.angle + vec:new(angular_speed, 0, 0)
    end
end

function Camera:apply_matrix()
    return vec:new(
        vec:new(1, 0, 0, 0),
        vec:new(0, 1, 0, 0),
        vec:new(0, 0, 1, 0),
        vec:new(-self.position.x, -self.position.y, -self.position.z, 1)
    ) * vec:new(
        vec:new(1, 0, 0, 0),
        vec:new(0, math.cos(self.angle.x), math.sin(self.angle.x), 0),
        vec:new(0, -math.sin(self.angle.x), math.cos(self.angle.x), 0),
        vec:new(0, 0, 0, 1)
    ) * vec:new(
        vec:new(math.cos(self.angle.y), 0, -math.sin(self.angle.y), 0),
        vec:new(0, 1, 0, 0),
        vec:new(math.sin(self.angle.y), 0, math.cos(self.angle.y), 0),
        vec:new(0, 0, 0, 1)
    ) * vec:new(
        vec:new(math.cos(self.angle.z), math.sin(self.angle.z), 0, 0),
        vec:new(-math.sin(self.angle.z), math.cos(self.angle.z), 0, 0),
        vec:new(0, 0, 1, 0),
        vec:new(0, 0, 0, 1)
    )
end

function Camera:transform_point(points)
    local new_points = points * self:apply_matrix()
    new_points = new_points * self.projection_matrix
    return new_points
end

return Camera