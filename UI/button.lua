TextButton = {}
TextButton.__index = TextButton

function TextButton:create(x, y, w, h, text, callback)
    local button = {}
    setmetatable(button, TextButton)
    button.x = x
    button.y = y
    button.w = w
    button.h = h
    button.text = text
    button.callback = callback
    button.isHovered = false
    button.isClicked = false
    return button
end

function TextButton:render()
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    local center_text_x = self.w / 2
    local center_text_y = self.h / 2
    love.graphics.print(self.text, self.x + center_text_x - self.text:len() * 3.3, self.y + center_text_y - 8)

    if self.isHovered then
        love.graphics.setColor(255, 255, 255, 100)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    end

    if self.isClicked then
        love.graphics.setColor(0, 255, 0, 100)
        love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)
    end

    love.graphics.setColor(255, 255, 255)
end

function TextButton:update(dt)
    local mx, my = love.mouse.getPosition()
    if mx > self.x and mx < self.x + self.w and my > self.y and my < self.y + self.h then
        self.isHovered = true
        if love.mouse.isDown(1) then
            self.isClicked = true
            self:mousepressed()
        else
            self.isClicked = false
        end
    else
        self.isHovered = false
        self.isClicked = false
    end
end

function TextButton:mousepressed()
    if self.isClicked then
        self.callback()
    end
end

BackgroudButton = {}
BackgroudButton.__index = BackgroudButton

function BackgroudButton:create(x, y, normal_texture, clicked_texture, hover_texture, callback)
    local button = {}
    setmetatable(button, BackgroudButton)
    button.x = x
    button.y = y
    button.normal_texture = normal_texture
    button.clicked_texture = clicked_texture
    button.hover_texture = hover_texture
    button.callback = callback
    button.isHovered = false
    button.isClicked = false
    return button
end

function BackgroudButton:render()
    if self.isClicked then
        love.graphics.draw(self.clicked_texture, self.x, self.y)
    elseif self.isHovered then
        love.graphics.draw(self.hover_texture, self.x, self.y)
    else
        love.graphics.draw(self.normal_texture, self.x, self.y)
    end
end

function BackgroudButton:update(dt)
    local mx, my = love.mouse.getPosition()
    if mx > self.x and mx < self.x + self.normal_texture:getWidth() and my > self.y and my < self.y + self.normal_texture:getHeight() then
        self.isHovered = true
        if love.mouse.isDown(1) then
            self.isClicked = true
            self:mousepressed()
        else
            self.isClicked = false
        end
    else
        self.isHovered = false
        self.isClicked = false
    end
end

function BackgroudButton:mousepressed()
    if self.isClicked then
        self.callback()
    end
end

BackgroudTextButton = {}
BackgroudTextButton.__index = BackgroudTextButton

function BackgroudTextButton:create(x, y, width, height, normal_texture, hover_texture, clicked_texture, text, callback)
    local button = {}
    setmetatable(button, BackgroudTextButton)
    button.x = x
    button.y = y
    button.width = width
    button.height = height
    button.normal_texture = normal_texture
    button.clicked_texture = clicked_texture
    button.hover_texture = hover_texture
    button.text = text
    button.callback = callback
    button.isHovered = false
    button.isClicked = false
    return button
end

function BackgroudTextButton:render()
    if self.isClicked then
        local scale_x = self.width / self.clicked_texture:getWidth()
        local scale_y = self.height / self.clicked_texture:getHeight()
        love.graphics.draw(self.clicked_texture, self.x, self.y, 0, scale_x, scale_y)
    elseif self.isHovered then
        local scale_x = self.width / self.hover_texture:getWidth()
        local scale_y = self.height / self.hover_texture:getHeight()
        love.graphics.draw(self.hover_texture, self.x, self.y, 0, scale_x, scale_y)
    else
        local scale_x = self.width / self.normal_texture:getWidth()
        local scale_y = self.height / self.normal_texture:getHeight()
        love.graphics.draw(self.normal_texture, self.x, self.y, 0, scale_x, scale_y)
    end

    local center_text_x = self.width / 2
    local center_text_y = self.height / 2
    love.graphics.print(self.text, self.x + center_text_x - self.text:len() * 3.3, self.y + center_text_y - 8)
end

function BackgroudTextButton:update(dt)
    local mx, my = love.mouse.getPosition()
    if mx > self.x and mx < self.x + self.width and my > self.y and my < self.y + self.height then
        self.isHovered = true
        if love.mouse.isDown(1) then
            self.isClicked = true
            self:mousepressed()
        else
            self.isClicked = false
        end
    else
        self.isHovered = false
        self.isClicked = false
    end
end

function BackgroudTextButton:mousepressed()
    if self.isClicked then
        self.callback()
    end
end

GroupButtons = {}
GroupButtons.__index = GroupButtons

function GroupButtons:create()
    local group = {}
    setmetatable(group, GroupButtons)
    group.buttons = {}
    return group
end

function GroupButtons:append(button)
    table.insert(self.buttons, button)
end

function GroupButtons:render()
    for i, button in ipairs(self.buttons) do
        button:render()
    end
end

function GroupButtons:update(dt)
    for i, button in ipairs(self.buttons) do
        button:update(dt)
    end
end