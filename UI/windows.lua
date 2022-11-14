require("UI.button")
require("UI.select")

Window = {}
Window.__index = Window

function Window:create(x, y, width, height, title, buttons)
    local window = {}
    setmetatable(window, Window)
    window.x = x
    window.y = y
    window.width = width
    window.height = height
    window.title = title
    window.buttons = buttons
    window.isShown = true
    return window
end

function Window:render()
    if self.isShown then
        love.graphics.setColor(0.2, 0.2, 0.2, 1)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
        love.graphics.setColor(0.8, 0.8, 0.8, 1)
        love.graphics.rectangle("fill", self.x, self.y, self.width, 20)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print(self.title, self.x + 5, self.y + 5)
        for i, button in ipairs(self.buttons) do
            button:render(self.x, self.y)
        end
    end
end

function Window:update(dt)
    if self.isShown then
        for i, button in ipairs(self.buttons) do
            button:update(dt, self.x, self.y)
        end

        if love.mouse.isDown(1) and not item_selected then
            local mx, my = love.mouse.getPosition()
            if mx > self.x and mx < self.x + self.width and my > self.y and my < self.y + 20 then
                item_select = self
                item_selected = true 
            end
        end
    end
end