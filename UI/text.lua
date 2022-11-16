Text = {}
Text.__index = Text

function Text:create(x, y, text, font, color)
    local text = {}
    setmetatable(text, Text)
    text.x = x
    text.y = y
    text.text = text
    text.font = font
    text.color = color
    return text
end

function Text:render()
    love.graphics.setColor(self.color)
    love.graphics.setFont(self.font)
    love.graphics.print(self.text, self.x, self.y)
end

function Text:update(dt)
end

TextArea = {}
TextArea.__index = TextArea

function TextArea:create(x, y, width, height, text, font, color)
    local textArea = {}
    setmetatable(textArea, TextArea)
    textArea.x = x
    textArea.y = y
    textArea.width = width
    textArea.height = height
    textArea.text = text
    textArea.font = font
    textArea.color = color
    return textArea
end

function TextArea:render()
    love.graphics.setColor(self.color)
    love.graphics.setFont(self.font)
    love.graphics.printf(self.text, self.x, self.y, self.width, "left")
end

function TextArea:update(dt)
end