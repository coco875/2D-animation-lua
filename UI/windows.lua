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
    window.canClose = true
    window.canMove = true
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
        -- close button
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.rectangle("fill", self.x + self.width - 20, self.y, 20, 20)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print("X", self.x + self.width - 15, self.y + 5)

    end
end

function Window:update(dt)
    if self.isShown then
        for i, button in ipairs(self.buttons) do
            button:update(dt, self.x, self.y)
        end

        if mousepressed() then
            local mx, my = love.mouse.getPosition()
            if mx > self.x + self.width - 20 and mx < self.x + self.width and my > self.y and my < self.y + 20 and self.canClose then
                self.isShown = false
            elseif mx > self.x and mx < self.x + self.width and my > self.y and my < self.y + 20 and self.canMove then
                item_select = self
                item_selected = true 
            end
        end
    end
end

WindowObject = {}
WindowObject.__index = WindowObject

function WindowObject:create(x, y, width, height, title, liste)
    local window = {}
    setmetatable(window, WindowObject)
    window.x = x
    window.y = y
    window.width = width
    window.height = height
    window.title = title
    window.liste = liste
    window.isShown = true
    window.canClose = true
    window.canMove = true
    window.couldown = 0
    return window
end

function WindowObject:render()
    if self.isShown then
        love.graphics.setColor(0.2, 0.2, 0.2, 1)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
        love.graphics.setColor(0.8, 0.8, 0.8, 1)
        love.graphics.rectangle("fill", self.x, self.y, self.width, 20)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print(self.title, self.x + 5, self.y + 5)
        -- close button
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.rectangle("fill", self.x + self.width - 20, self.y, 20, 20)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print("X", self.x + self.width - 15, self.y + 5)

        for i, object in ipairs(self.liste) do
            love.graphics.setColor(0.8, 0.8, 0.8, 1)
            love.graphics.rectangle("fill", self.x + 5, self.y + 25 + (i - 1) * 20, self.width - 10, 20)
            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.print(object.name, self.x + 10, self.y + 30 + (i - 1) * 20)

            if object.isShown then
                love.graphics.setColor(0, 1, 0, 1)
            else
                love.graphics.setColor(1, 0, 0, 1)
            end
            love.graphics.rectangle("fill", self.x + 5, self.y + 25 + (i - 1) * 20, 10, 20)
        end
    end
end

function WindowObject:update(dt)
    self.couldown = self.couldown - dt

    if self.isShown then
        if mousepressed() then
            local mx, my = love.mouse.getPosition()
            if mx > self.x + self.width - 20 and mx < self.x + self.width and my > self.y and my < self.y + 20 and self.canClose then
                self.isShown = false
            elseif mx > self.x and mx < self.x + self.width and my > self.y and my < self.y + 20 and self.canMove then
                item_select = self
                item_selected = true 
            end

            if mx > self.x + 5 and mx < self.x + self.width - 5 and my > self.y + 25 and my < self.y + self.height - 5 and self.couldown < 0 then
                for i, object in ipairs(self.liste) do
                    if my > self.y + 25 + (i - 1) * 20 and my < self.y + 25 + (i - 1) * 20 + 20 then
                        object.isShown = not object.isShown
                        self.couldown = 0.2
                    end
                end
            end
        end
    end
end