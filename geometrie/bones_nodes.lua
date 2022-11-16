require("utils.tableManip")
require("UI.select")
require("UI.button")

all_bones = {}

Bone = {}
Bone.__index = Bone

function Bone:create(x, y, color)
    local bone = {}
    setmetatable(bone, Bone)
    bone.name = "Bone"..tostring(#all_bones)
    bone.node1 = Node:create(x+50, y, color)
    bone.node2 = Node:create(x-50, y, color)
    bone.color = color
    bone.isHovered = false
    bone.isClicked = false
    bone.isShown = true
    bone.x = x
    bone.y = y
    bone.old_x = x
    bone.old_y = y
    table.insert(all_bones, bone)
    return bone
end

function Bone:render()
    if not self.isShown then
        return
    end
    love.graphics.setColor(self.color)
    love.graphics.line(self.node1.x, self.node1.y, self.node2.x, self.node2.y)
    love.graphics.setColor(1, 1, 1, 1)
end

function Bone:update(dt)
    self.node1.isShown = self.isShown
    self.node2.isShown = self.isShown

    if self.x ~= self.old_x or self.y ~= self.old_y then
        self.node1.x = self.node1.x + (self.x - self.old_x)
        self.node1.y = self.node1.y + (self.y - self.old_y)
        self.node2.x = self.node2.x + (self.x - self.old_x)
        self.node2.y = self.node2.y + (self.y - self.old_y)
        self.old_x = self.x
        self.old_y = self.y
    end
    local mx, my = love.mouse.getPosition()
    local x1, y1, x2, y2 = self.node1.x, self.node1.y, self.node2.x, self.node2.y
    local d = math.abs((y2 - y1) * mx - (x2 - x1) * my + x2 * y1 - y2 * x1) / math.sqrt((y2 - y1) ^ 2 + (x2 - x1) ^ 2)
    if d < 10 and mx > math.min(x1, x2)-10 and mx < math.max(x1, x2)+10 and my > math.min(y1, y2)-10 and my < math.max(y1, y2)+10 then
        self.isHovered = true
        if mousepressed() then
            print("clicked")
            self.isClicked = true
            item_select = self
            item_selected = true
        else
            self.isClicked = false
        end
    else
        self.isHovered = false
        self.isClicked = false
    end
end

function render_bones()
    for i, bone in ipairs(all_bones) do
        bone:render()
    end
end

function update_bones(dt)
    for i, bone in ipairs(all_bones) do
        bone:update(dt)
    end
end

all_nodes = {}

Node = {}
Node.__index = Node

function Node:create(x, y, color)
    local node = {}
    setmetatable(node, Node)
    node.name = "Node"..tostring(#all_nodes)
    node.x = x
    node.y = y
    node.color = color
    node.isHovered = false
    node.isClicked = false
    node.isShown = true
    node.bones = {}
    table.insert(all_nodes, node)
    return node
end

function Node:render()
    if not self.isShown then
        return
    end
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.x, self.y, 10)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle("line", self.x, self.y, 10)
    if self.isHovered then
        love.graphics.setColor(0.5, 0.5, 0.5, 0.4)
        love.graphics.circle("fill", self.x, self.y, 10)
    end
    if self.isClicked then
        love.graphics.setColor(1, 1, 1, 0.4)
        love.graphics.circle("fill", self.x, self.y, 10)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function Node:update(dt)
    local mx, my = love.mouse.getPosition()
    if mx > self.x - 10 and mx < self.x + 10 and my > self.y - 10 and my < self.y + 10 then
        self.isHovered = true
        if mousepressed() then
            print("node clicked")
            self.isClicked = true
            item_select = self
            item_selected = true
        end
    else
        self.isHovered = false
    end
end

function Node:addBone(bone)
    table.insert(self.bones, bone)
end

function Node:removeBone(bone)
    for i, b in ipairs(self.bones) do
        if b == bone then
            table.remove(self.bones, i)
        end
    end
end

function Node:remove()
    for i, b in ipairs(self.bones) do
        b:remove()
    end
    for i, n in ipairs(all_nodes) do
        if n == self then
            table.remove(all_nodes, i)
        end
    end
end

function render_nodes()
    for i, node in ipairs(all_nodes) do
        node:render()
    end
end

function update_nodes(dt)
    for i, node in ipairs(all_nodes) do
        node:update(dt)
    end
end