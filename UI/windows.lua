require("UI.buttons")
require("UI.select")
require("UI.box")
require("UI.windows_calc")

local all_windows = {}

Window = {}
Window.__index = Window

function Window:create(x, y, width, height, title, items)
    local window = {}
    setmetatable(window, Window)
    window.x = x
    window.y = y
    window.width = width
    window.height = height
    window.title = title
    window.isShown = true
    window.canClose = true
    window.canMove = true
    window.box = Box:create(0, 20, width, height-20, items)
    all_windows[#all_windows+1] = window
    return window
end

function Window:render()
    if not self.isShown then
        return
    end

    love.graphics.setColor(0.9, 0.9, 0.9, 1)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    love.graphics.setColor(0.8, 0.8, 0.8, 1)
    love.graphics.rectangle("fill", self.x, self.y, self.width, 20)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(self.title, self.x + 5, self.y + 5)
    
    self.box:render(self.x, self.y)

    -- close button
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.rectangle("fill", self.x + self.width - 20, self.y, 20, 20)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print("X", self.x + self.width - 15, self.y + 5)
end

function Window:update(dt)
    if not self.isShown then
        return
    end

    self.box:update(dt, self.x, self.y)

    if not mousepressed() then
        return
    end

    local mx, my = love.mouse.getPosition()

    if inside_box(mx, my, {self.x + self.width - 20, self.y, 20, 20}) and self.canClose then
        self.isShown = false
    
    elseif inside_box(mx, my, {self.x, self.y, self.width, 20}) and self.canMove then
        item_select = self
        item_selected = true

        local id = 0
        for i, window in ipairs(all_windows) do
            if window == self then
                id = i
            end
        end
        table.remove(all_windows, id)
        all_windows[#all_windows+1] = self
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
    all_windows[#all_windows+1] = window
    return window
end

function WindowObject:render()
    if not self.isShown then
        return
    end
    
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
                local id = 0
                for i, window in ipairs(all_windows) do
                    if window == self then
                        id = i
                    end
                end
                table.remove(all_windows, id)
                all_windows[#all_windows+1] = self
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

function render_windows()
    for i, window in ipairs(all_windows) do
        window:render()
    end
end

function update_windows(dt)
    for i, window in ipairs(all_windows) do
        all_windows[#all_windows-i+1]:update(dt)
    end
end
