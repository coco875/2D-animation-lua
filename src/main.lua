local Love3D = require("Love3D")
local vec = require("vector.vec")
local Object3D = Love3D.Object3D
local Camera = Love3D.Camera
local Shape = Love3D.Shape

local camera = Camera:new()
local object = Object3D:new()
local shape = Shape:new()

local axis = vec:new(
    vec:new(0, 0, 0, 1),
    vec:new(1, 0, 0, 1),
    vec:new(0, 1, 0, 1),
    vec:new(0, 0, 1, 1)
)
axis = axis * vec:new(
    vec:new(100, 0, 0, 0),
    vec:new(0, 100, 0, 0),
    vec:new(0, 0, 100, 0),
    vec:new(0, 0, 0, 1)
)

function love.load()
    object:translate(-0.5, -0.5, -0.5)
    object:scale(100)
    shape:scale(100)
    love.window.setMode(800, 600, {resizable=true})
    camera:caclulate_projection()
end

function love.draw()
    -- object:draw(camera)
    shape:draw(camera)
    local points = axis
    points = camera:transform_point(points)
    love.graphics.setColor(1, 0, 0)
    love.graphics.line(points[0].x, points[0].y, points[1].x, points[1].y)
    love.graphics.setColor(0, 1, 0)
    love.graphics.line(points[0].x, points[0].y, points[2].x, points[2].y)
    love.graphics.setColor(0, 0, 1)
    love.graphics.line(points[0].x, points[0].y, points[3].x, points[3].y)
end

function love.update(dt)
    camera:control()
    camera:caclulate_projection()
end