Image = {}
Image.__index = Image

function Image:create(x, y,image_name, width, height, transparent)
    local image = {}
    setmetatable(image, Image)
    image.x = x
    image.y = y
    image.image = love.graphics.newImage("assets/" .. image_name)
    if width == nil then
        image.width = image.image:getWidth()
    else
        image.width = width
    end
    if height == nil then
        image.height = image.image:getHeight()
    else
        image.height = height
    end
    image.transparent = false
    if transparent then
        image.transparent = true
    end
    return image
end

function Image:render(x,y)
    love.graphics.setColor(1,1,1)
    if not self.transparent then
        love.graphics.rectangle("fill", self.x + x, self.y + y, self.width, self.height)
    end
    love.graphics.draw(self.image, self.x + x, self.y + y, 0, self.width/self.image:getWidth(), self.height/self.image:getHeight())
end

function Image:update(dt, x, y)
    if item_selected then
        return
    end
end