item_selected = false
item_select = {}

local last_pos = {x = love.mouse.getX(), y = love.mouse.getY()}

function update_select(dt)
    if item_selected then
        if love.mouse.isDown(1) then
            item_select.x = item_select.x + (love.mouse.getX() - last_pos.x)
            item_select.y = item_select.y + (love.mouse.getY() - last_pos.y)
        else
            item_selected = false
            item_select.isClicked = false
        end
    end
    last_pos = {x = love.mouse.getX(), y = love.mouse.getY()}
end