require("UI.button")

Header = {}
Header.__index = Header

function Header:create(x, y, width, height, group_buttons)
    local header = {}
    setmetatable(header, Header)
    header.x = x
    header.y = y
    header.width = width
    header.height = height
    header.group_buttons = group_buttons
    header.isHovered = false
    header.isClicked = false
    header.isShown = true
    return header
end

function Header:render(x, y)
    if x and y then
        self.x = x
        self.y = y
    end
    if not self.isShown then
        return
    end
    love.graphics.setColor(0.5, 0.5, 0.5, 1)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1, 1)
    self.group_buttons:render(self.x, self.y)
end

function Header:update(dt, x, y)
    if x and y then
        self.x = x
        self.y = y
    end
    self.group_buttons:update(dt, self.x, self.y)
end


HeaderTextButton = {}
HeaderTextButton.__index = Header

function HeaderTextButton:create(x, y, width, height, texts, callback)
    local button = {}
    local all_button = GroupButtons:create()
    for i, text in ipairs(texts) do
        local b_witdth = #texts*50
        local button = TextButton:create(0, 0, b_witdth, height, text, function ()
            callback(i)
        end)
        all_button:append(button)
    end
    setmetatable(button, Header)
    button = Header:create(x, y, width, height, all_button)
    return button
end