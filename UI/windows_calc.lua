require("utils.tableManip")

local stack_calc = {}

function set_calc(calc)
    if #stack_calc == 0 then
        love.graphics.setScissor(calc[1], calc[2], calc[3], calc[4])
        stack_calc[#stack_calc+1] = calc
        return
    end
    love.graphics.intersectScissor(calc[1], calc[2], calc[3], calc[4])
    stack_calc[#stack_calc+1] = calc
end

function unset_calc()
    stack_calc[#stack_calc] = nil
    if #stack_calc == 0 then
        love.graphics.setScissor()
        return
    end
    local i = 0
    while stack_calc[i] ~= nil and i <= #stack_calc do
        love.graphics.intersectScissor(stack_calc[i][1], stack_calc[i][2], stack_calc[i][3], stack_calc[i][4])
        i = i + 1
    end
end