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

function love.draw()
    render_bones()
    render_nodes()
    render_windows()
    menu_create_obj:render()
end

function love.update(dt)
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
