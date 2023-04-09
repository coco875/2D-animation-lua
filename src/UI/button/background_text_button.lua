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

function BackgroudTextButton:render(x, y)
    local old = {}
    if x and y then
        old = {self.x, self.y}
        self.x = self.x + x
        self.y = self.y + y
    end

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

    if x and y then
        self.x = old[1]
        self.y = old[2]
    end
end

function BackgroudTextButton:update(dt, x, y)
    local old = {self.x, self.y}
    if x and y then
        self.x = self.x + x
        self.y = self.y + y
    end

    local mx, my = love.mouse.getPosition()
    if mx > self.x and mx < self.x + self.width and my > self.y and my < self.y + self.height then
        self.isHovered = true
        if mousepressed() then
            self.isClicked = true
            self:mousepressed()
        else
            self.isClicked = false
        end
    else
        self.isHovered = false
        self.isClicked = false
    end

    if x and y then
        self.x = old[1]
        self.y = old[2]
    end
end

function BackgroudTextButton:mousepressed()
    if self.isClicked then
        self.callback()
    end
end

