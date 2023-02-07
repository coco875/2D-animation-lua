require("UI.sliders")

Box = {}
Box.__index = Box

function Box:create(x, y, width, height, items)
    local box = {}
    setmetatable(box, Box)
    box.x = x
    box.y = y
    box.width = width
    box.height = height
    box.slider_y = Slider:create(width-20, 0, 20, height-20, 20, "y", true)
    box.slider_x = Slider:create(0, height-20, width-20, 20, 20, "x", true)
    box.items = items
    box.canvas = love.graphics.newCanvas(width-20, height-20)
    box.max_x = 0
    box.max_y = 0
    for i, item in ipairs(box.items) do
        if item.x + item.width > box.max_x then
            box.max_x = item.x + item.width
        end
        if item.y + item.height > box.max_y then
            box.max_y = item.y + item.height
        end
    end
    if box.max_x < box.canvas:getWidth() then
        box.max_x = box.width
    end
    if box.max_y < box.canvas:getHeight() then
        box.max_y = box.height
    end
    return box
end

function Box:render(x,y)
    love.graphics.setColor(0.8,0.8,0.8)
    love.graphics.rectangle("fill", self.x + x, self.y + y, self.width, self.height)
    love.graphics.setCanvas(self.canvas)
        love.graphics.clear()
        local x_, y_ = (-self.slider_x.percent) * (self.max_x - self.canvas:getWidth()), (-self.slider_y.percent) * (self.max_y - self.canvas:getHeight())
        for i, item in ipairs(self.items) do
            item:render(x_,y_)
        end
    love.graphics.setCanvas()
    love.graphics.draw(self.canvas, self.x + x, self.y + y)
    self.slider_y:render(self.x + x, self.y + y)
    self.slider_x:render(self.x + x, self.y + y)
end

function Box:update(dt, x, y)
    self.slider_y:update(dt, self.x + x, self.y + y)
    self.slider_x:update(dt, self.x + x, self.y + y)
end