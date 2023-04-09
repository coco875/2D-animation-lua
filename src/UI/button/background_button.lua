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

function BackgroudButton:render(x, y)
    local old = {}
    if x and y then
        old = {self.x, self.y}
        self.x = self.x + x
        self.y = self.y + y
    end

    if self.isClicked then
        love.graphics.draw(self.clicked_texture, self.x, self.y)
    elseif self.isHovered then
        love.graphics.draw(self.hover_texture, self.x, self.y)
    else
        love.graphics.draw(self.normal_texture, self.x, self.y)
    end

    if x and y then
        self.x = old[1]
        self.y = old[2]
    end
end

function BackgroudButton:update(dt, x, y)
    old = {}
    if x and y then
        old = {self.x, self.y}
        self.x = self.x + x
        self.y = self.y + y
    end

    local mx, my = love.mouse.getPosition()
    if mx > self.x and mx < self.x + self.normal_texture:getWidth() and my > self.y and my < self.y + self.normal_texture:getHeight() then
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

function BackgroudButton:mousepressed()
    if self.isClicked then
        self.callback()
    end
end

