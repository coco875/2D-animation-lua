require("UI.windows")
require("UI.buttons")

img = love.graphics.newImage("assets/button_c.bmp")

local windows = Window:create(100, 100, 200, 200, "Test", {
    TextButton:create(0, 0, 100, 20, "Test", function() print("Test") end),
})

function love.draw()
    render_windows()
end

function love.update(dt)
    update_windows(dt)
    update_select(dt)
end