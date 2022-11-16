ContextMenu = {}
ContextMenu.__index = ContextMenu

function ContextMenu:create(x, y, width, height, items)
    local menu = {}
    setmetatable(menu, ContextMenu)
    menu.x = x
    menu.y = y
    menu.width = width
    menu.height = height
    menu.items = items
    menu.isShown = false
    for i, item in ipairs(menu.items) do
        item.isHovered = false
        item.isClicked = false
    end
    return menu
end

function ContextMenu:render()
    if not self.isShown then
        return
    end
    love.graphics.setColor(0.1, 0.1, 0.1, 0.8)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    for i, item in ipairs(self.items) do
        love.graphics.print(item["text"], self.x + 5, self.y + 5 + (i - 1) * 20)
        if item.isHovered then
            love.graphics.setColor(1, 1, 1, 0.1)
            love.graphics.rectangle("fill", self.x, self.y + (i - 1) * 20, self.width, 20)
        end
        if item.isClicked then
            love.graphics.setColor(0, 1, 0, 0.1)
            love.graphics.rectangle("fill", self.x, self.y + (i - 1) * 20, self.width, 20)
        end
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function ContextMenu:update(dt)
    if not self.isShown then
        return
    end
    local mx, my = love.mouse.getPosition()
    for i, item in ipairs(self.items) do
        if mx > self.x and mx < self.x + self.width and my > self.y + 5 + (i - 1) * 20 and my < self.y + 5 + i * 20 then
            item.isHovered = true
            if mousepressed() then
                item.isClicked = true
                item["callback"]()
            else
                item.isClicked = false
            end
        else
            item.isHovered = false
            item.isClicked = false
        end
    end
    if mousepressed() then
        if mx < self.x or mx > self.x + self.width or my < self.y or my > self.y + self.height then
            self.isShown = false
        end
    end
end