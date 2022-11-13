require("UI/button")

local quit_image_n = love.graphics.newImage("assets/quit_n.bmp")
local quit_image_h = love.graphics.newImage("assets/quit_h.bmp")
local quit_image_c = love.graphics.newImage("assets/quit_c.bmp")

local texture_button_n = love.graphics.newImage("assets/button_n.bmp")
local texture_button_h = love.graphics.newImage("assets/button_h.bmp")
local texture_button_c = love.graphics.newImage("assets/button_c.bmp")

local new_button = TextButton:create(100, 100, 100, 100, "Test Button", function()
    print("Test Button Clicked!")
end)

local load_button = BackgroudTextButton:create(100, 200, 100, 100, texture_button_n, texture_button_h, texture_button_c, "Load", function()
    print("Load Button Clicked!")
end)

local quit = BackgroudButton:create(100, 300, quit_image_n, quit_image_c, quit_image_h, function()
    love.event.quit()
end)

local menu_buttons = GroupButtons:create()
menu_buttons:append(new_button)
menu_buttons:append(load_button)
menu_buttons:append(quit)

function love.draw()
    menu_buttons:render()
end

function love.update(dt)
    menu_buttons:update(dt)
end