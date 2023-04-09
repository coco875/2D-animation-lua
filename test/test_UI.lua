require("geometrie.bones_nodes")
require("UI.sliders")
require("UI.contextMenu")
require("UI.windows")
require("UI.buttons")
require("UI.select")
require("UI.header")
require("UI.box")
require("UI.image")

local windows = Window:create(100, 100, 200, 200, "Test", {
    HeaderTextButton:create(10, 30, 180, 20, {"Test", "text"}, function(i) print(i) end),
    Slider:create(10, 30, 180, 20, 20, "x"),
    Box:create(10, 60, 180, 100, {
        TextButton:create(0, 0, 170, 70, "Test1", function() print("Test1") end),
        Image:create(0, 0, "button_c.bmp"),
    }),
    TextButton:create(10, 180, 180, 20, "Test6", function() print("Test6") end),
})

local menu_create_obj = {}

local bone_windows = WindowObject:create(300, 100, 200, 200, "Bones", all_bones)
local node_windows = WindowObject:create(100, 300, 200, 200, "Nodes", all_nodes)

menu_create_obj = ContextMenu:create(love.mouse.getX(), love.mouse.getY(), 100, 100, {
    {text = "Create node", callback = function()
        Node:create(love.mouse.getX(), love.mouse.getY(), {1, 0, 0, 1})
        menu_create_obj.isShown = false
    end},

    {text = "Create bone", callback = function()
        print("Load")
        Bone:create(love.mouse.getX(), love.mouse.getY(), {0, 1, 0, 1})
        menu_create_obj.isShown = false
    end},

    {text = "Quit", callback = function()
        love.event.quit()
    end}
})

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

function draw()
    menu_buttons:render()
    mouse_menu:render()
    sub_menu:render()
    render_bones()
    render_nodes()
    render_windows()
    menu_create_obj:render()
end

function update(dt)
    menu_buttons:update(dt)
    sub_menu:update(dt)
    if love.mouse.isDown(2) then
        mouse_menu.x = love.mouse.getX()
        mouse_menu.y = love.mouse.getY()
        mouse_menu.isShown = true
    end
    mouse_menu:update(dt)
    update_windows(dt)
    menu_create_obj:update(dt)
    if love.mouse.isDown(2) then
        menu_create_obj.x = love.mouse.getX()
        menu_create_obj.y = love.mouse.getY()
        menu_create_obj.isShown = true
    end
    update_select(dt)
    update_nodes(dt)
    update_bones(dt)
end