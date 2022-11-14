require("UI/button")
require("UI/contextMenu")

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

local sub_menu = ContextMenu:create(love.mouse.getX(), love.mouse.getY(), 100, 100, {{
    text = "Test",
    callback = function()
        print("Test")
    end
}})

local mouse_menu = ContextMenu:create(love.mouse.getX(), love.mouse.getY(), 100, 100, {
    {text = "New", callback = function()
        print("New")
    end},
    {text = "Load", callback = function()
        sub_menu.isShown = true
        sub_menu.x = love.mouse.getX()
        sub_menu.y = love.mouse.getY()
    end},
    {text = "Quit", callback = function()
        love.event.quit()
    end}
})

function love.draw()
    menu_buttons:render()
    mouse_menu:render()
    sub_menu:render()
end

function love.update(dt)
    menu_buttons:update(dt)
    sub_menu:update(dt)
    if love.mouse.isDown(2) then
        mouse_menu.x = love.mouse.getX()
        mouse_menu.y = love.mouse.getY()
        mouse_menu.isShown = true
    end
    mouse_menu:update(dt)
end