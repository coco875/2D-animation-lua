time = 100

Timeline = {}
Timeline.__index = Timeline

function Timeline:create(x, y, w, h, name, callback)
    local self = setmetatable({}, Timeline)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.name = name
    self.callback = callback
    self.isShown = true
    self.isDrag = false
    self.isHover = false
    self.isClick = false
    self.isSelect = false
    self.isSelectDrag = false
    self.isSelectHover = false
    self.isSelectClick = false
end