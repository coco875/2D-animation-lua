require("UI.sliders")
require("UI.windows_calc")

Box = {}
Box.__index = Box

function Box:create(x, y, width, height, items)
    local box = {}
    setmetatable(box, Box)
    box.x = x
    box.y = y
    box.width = width
    box.height = height
    box.slider_y = Slider:create(width-20, 0, 20, height-20, 20, "y")
    box.slider_x = Slider:create(0, height-20, width-20, 20, 20, "x")
    box.items = items
    box.calc = {0, 0, width-20, height-20}
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
    if box.max_x < box.calc[3] then
        box.max_x = box.width
        box.slider_x.isShown = false
    end
    if box.max_y < box.calc[4] then
        box.max_y = box.height
        box.slider_y.isShown = false
    end
    return box
end

function Box:render(x,y)
    -- love.graphics.setColor(0.8,0.8,0.8)
    -- love.graphics.rectangle("fill", self.x + x, self.y + y, self.width, self.height)

    set_calc({self.x + x, self.y + y, self.calc[3], self.calc[4]})
        love.graphics.clear()
        local x_ = (-self.slider_x.percent) * (self.max_x - self.calc[3]) + x + self.x
        local y_ = (-self.slider_y.percent) * (self.max_y - self.calc[4]) + y + self.y
        for i, item in ipairs(self.items) do
            item:render(x_,y_)
        end
    unset_calc()

    self.slider_y:render(self.x + x, self.y + y)
    self.slider_x:render(self.x + x, self.y + y)
end

function Box:update(dt, x, y)
    -- print(self.x+x, self.y+y, self.width, self.height)
    self.slider_y:update(dt, self.x + x, self.y + y)
    self.slider_x:update(dt, self.x + x, self.y + y)

    if not inside_box(love.mouse.getX(), love.mouse.getY(), {self.x + x, self.y + y, self.calc[3], self.calc[4]}) then
        for i, item in ipairs(self.items) do
            item.isHovered = false
            item.isClicked = false
        end
        return
    end

    for i, item in ipairs(self.items) do
        item:update(dt, self.x + x, self.y + y)
    end
end