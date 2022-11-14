require("utils.tableManip")

all_bones = {}

Bone = {}
Bone.__index = Bone

function Bone:create(node1, node2, color)
    local bone = {}
    setmetatable(bone, Bone)
    bone.nodeID1 = node1
    bone.nodeID2 = node2
    bone.color = color
    bone.isHovered = false
    bone.isClicked = false
    all_nodes[node1]:addBone(bone)
    all_nodes[node2]:addBone(bone)
    table.insert(all_bones, bone)
    return bone
end

function Bone:render()
    love.graphics.setColor(self.color)
    love.graphics.line(all_nodes[self.nodeID1].x, all_nodes[self.nodeID1].y, all_nodes[self.nodeID2].x, all_nodes[self.nodeID2].y)
    love.graphics.setColor(1, 1, 1, 1)
end

function Bone:update(dt)
    local mx, my = love.mouse.getPosition()
    local x1, y1, x2, y2 = all_nodes[self.nodeID1].x, all_nodes[self.nodeID1].y, all_nodes[self.nodeID2].x, all_nodes[self.nodeID2].y
    local d = math.abs((y2 - y1) * mx - (x2 - x1) * my + x2 * y1 - y2 * x1) / math.sqrt((y2 - y1) ^ 2 + (x2 - x1) ^ 2)
    if d < 10 then
        self.isHovered = true
        if love.mouse.isDown(1) then
            self.isClicked = true
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

all_nodes = {}

Node = {}
Node.__index = Node

function Node:create(x, y, color)
    local node = {}
    setmetatable(node, Node)
    node.x = x
    node.y = y
    node.color = color
    node.isHovered = false
    node.isClicked = false
    node.bones = {}
    table.insert(all_nodes, node)
    return node
end

function Node:render()
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.x, self.y, 10)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.circle("line", self.x, self.y, 10)
    if self.isHovered then
        love.graphics.setColor(1, 1, 1, 0.1)
        love.graphics.circle("fill", self.x, self.y, 10)
    end
    if self.isClicked then
        love.graphics.setColor(0, 1, 0, 0.1)
        love.graphics.circle("fill", self.x, self.y, 10)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

function Node:update(dt)
    local mx, my = love.mouse.getPosition()
    if mx > self.x - 10 and mx < self.x + 10 and my > self.y - 10 and my < self.y + 10 then
        self.isHovered = true
        if love.mouse.isDown(1) then
            self.isClicked = true
        else
            self.isClicked = false
        end
    else
        self.isHovered = false
        self.isClicked = false
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