require("UI.box")
require("UI.buttons")

local items = Box:create(0, 0, 200, 200, {
    TextButton:create(0, 0, 300, 300, "test", function() end),
})

function love.load()
    love.window.setMode(800, 600)
end

function love.update(dt)
    items:update(dt, 100, 100)
end

function love.draw()
    items:render(100, 100)
end