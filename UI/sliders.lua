require("UI.select")

Slider = {}
Slider.__index = Slider

function Slider:create(x, y, width, height, slider_lenght, orientation)
    local slider = {}
    setmetatable(slider, Slider)
    slider.x = x
    slider.y = y
    slider.width = width
    slider.height = height
    slider.percent = 0
    slider.slider_lenght = slider_lenght
    slider.orientation = "y"
    if orientation == "y" or orientation == "vertical" then
        slider.orientation = "y"
    end
    if orientation == "x" or orientation == "horizontal" then
        slider.orientation = "x"
    end
    return slider
end

function Slider:render(x,y)
    love.graphics.setColor(0.8,0.8,0.8)
    love.graphics.rectangle("fill", self.x + x, self.y + y, self.width, self.height)

    if self.orientation == "y" then
        love.graphics.setColor(0.3,0.3,0.3)
        love.graphics.rectangle("fill", self.x + x, self.y + y + self.percent * (self.height - self.slider_lenght), self.width, self.slider_lenght)
    end
    if self.orientation == "x" then
        love.graphics.setColor(0.3,0.3,0.3)
        love.graphics.rectangle("fill", self.x + x + self.percent * (self.width - self.slider_lenght), self.y + y, self.slider_lenght, self.height)
    end
end

function Slider:update(dt, x, y)
    if item_selected then
        return
    end

    if self.orientation == "y" then
        if love.mouse.isDown(1) then
            if love.mouse.getX() > self.x + x and love.mouse.getX() < self.x + x + self.width and love.mouse.getY() > self.y + y and love.mouse.getY() < self.y + y + self.height then
                self.percent = (love.mouse.getY() - self.y - y - self.slider_lenght/2) /
                    (self.height - self.slider_lenght)
            end
        end
    end
    if self.orientation == "x" then
        if love.mouse.isDown(1) then
            if love.mouse.getX() > self.x + x and love.mouse.getX() < self.x + x + self.width and love.mouse.getY() > self.y + y and love.mouse.getY() < self.y + y + self.height then
                self.percent = (love.mouse.getX() - self.x - x - self.slider_lenght/2) /
                    (self.width - self.slider_lenght)
            end
        end
    end
end
