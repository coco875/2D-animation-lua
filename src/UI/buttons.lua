require("UI.button.text_button")
require("UI.button.background_button")
require("UI.button.background_text_button")

GroupButtons = {}
GroupButtons.__index = GroupButtons

function GroupButtons:create()
    local group = {}
    setmetatable(group, GroupButtons)
    group.buttons = {}
    group.x = 0
    group.y = 0
    return group
end

function GroupButtons:append(button)
    table.insert(self.buttons, button)
end

function GroupButtons:render(x, y)
    x = x or 0
    y = y or 0
    local last_width = 0
    for i, button in ipairs(self.buttons) do
        button:render(last_width+x, y)
        last_width = last_width + button.width
    end
end

function GroupButtons:update(dt, x, y)
    local old = {}
    if x and y then
        old = {self.x, self.y}
        self.x = self.x + x
        self.y = self.y + y
    end

    for i, button in ipairs(self.buttons) do
        button:update(dt, x, y)
    end

    if x and y then
        self.x = old[1]
        self.y = old[2]
    end
end
