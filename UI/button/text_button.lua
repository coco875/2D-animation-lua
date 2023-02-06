TextButton = {}
TextButton.__index = TextButton

function TextButton:create(x, y, w, h, text, callback)
    local button = {}
    setmetatable(button, TextButton)
    button.x = x
    button.y = y
    button.width = w
    button.height = h
    button.text = text
    button.callback = callback
    button.isHovered = false
    button.isClicked = false
    return button
end

function TextButton:render(x, y)
    local old = {}
    if x and y then
        old = {self.x, self.y}
        self.x = self.x + x
        self.y = self.y + y
    end
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    local center_text_x = self.width / 2
    local center_text_y = self.height / 2
    love.graphics.print(self.text, self.x + center_text_x - self.text:len() * 3.3, self.y + center_text_y - 8)

    if self.isHovered then
        love.graphics.setColor(255, 255, 255, 100)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    end

    if self.isClicked then
        love.graphics.setColor(0, 255, 0, 100)
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    end

    love.graphics.setColor(255, 255, 255)

    if x and y then
        self.x = old[1]
        self.y = old[2]
    end
end

function TextButton:update(dt, x, y)
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

function TextButton:mousepressed()
    if self.isClicked then
        self.callback()
    end
end

