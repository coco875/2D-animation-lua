item_selected = false
item_select = {}

local last_pos = {x = love.mouse.getX(), y = love.mouse.getY()}

multi_selected = false
multi_select = {}

last_click = love.mouse.isDown(1)

function update_select(dt)
    last_click = love.mouse.isDown(1)
    if item_selected then
        if multi_selected then
            if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
                if love.mouse.isDown(1) then
                    for i, item in ipairs(multi_select) do
                        item.x = item.x + (love.mouse.getX() - last_pos.x)
                        item.y = item.y + (love.mouse.getY() - last_pos.y)
                    end
                end
            else
                multi_selected = false
                for i, item in ipairs(multi_select) do
                    item.isClicked = false
                end
                multi_select = {}
            end
        elseif love.mouse.isDown(1) then
            item_select.x = item_select.x + (love.mouse.getX() - last_pos.x)
            item_select.y = item_select.y + (love.mouse.getY() - last_pos.y)
        else
            item_selected = false
            item_select.isClicked = false
        end
    end
    last_pos = {x = love.mouse.getX(), y = love.mouse.getY()}
end

function mousepressed()
    return love.mouse.isDown(1) and not item_selected and not last_click
end