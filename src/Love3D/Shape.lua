local Object3D = require("Love3D.Object3D")
local vec = require("vector.vec")

local Shape = Object3D:new()

Shape.__index = Shape

function Shape:new(points, curve_link, faces, color)
    local self = setmetatable({}, Shape)
    local l = {}
    if points then
        self.points = vec:new(points)
    else
        local lines = {}
        local points = {}
        local l = {}
        -- hemisphere x
        for i = 1,10 do
            local angle = (i-1)/9*math.pi
            local x = math.cos(angle)
            local y = math.sin(angle)
            -- table.insert(points, {x, y, 0, 1})
            table.insert(l, #points-1)
        end
        -- table.insert(lines, l)
        -- hemisphere -x
        l = {}
        for i = 1,10 do
            local angle = (i-1)/9*math.pi
            local x = math.cos(angle)
            local y = math.sin(angle)
            -- table.insert(points, {x, -y, 0, 1})
            table.insert(l, #points-1)
        end
        -- table.insert(lines, l)
        -- hemisphere y
        l = {}
        for i = 1,10 do
            local angle = (i-1)/9*math.pi
            print(angle, i)
            local x = math.cos(angle)
            local y = math.sin(angle)
            table.insert(points, {x, 0, y, 1})
            table.insert(l, #points-1)
        end
        table.insert(lines, l)
        -- hemisphere -y
        -- l = {}
        -- for i = 1,9 do
        --     local x = math.cos(i/9*math.pi)
        --     local y = math.sin(i/9*math.pi)
        --     table.insert(points, {-x, 0, y, 1})
        --     table.insert(l, #points)
        -- end
        -- table.insert(lines, l)
        -- -- hemisphere z
        -- l = {}
        -- for i = 1,9 do
        --     local x = math.cos(i/9*math.pi)
        --     local y = math.sin(i/9*math.pi)
        --     table.insert(points, {0, x, y, 1})
        --     table.insert(l, #points)
        -- end
        -- table.insert(lines, l)
        -- -- hemisphere -z
        -- l = {}
        -- for i = 1,9 do
        --     local x = math.cos(i/9*math.pi)
        --     local y = math.sin(i/9*math.pi)
        --     table.insert(points, {0, x, -y, 1})
        --     table.insert(l, #points)
        -- end
        -- table.insert(lines, l)
        self.points = vec:new(points)
        self.lines = lines
    end
    self.lines = curve_link or self.lines
    self.face = faces or {
        {1,2},
        {3,4},
        {5,6}
    }
    self.color = color or {1,1,1,1}
    self.position = vec:new(0, 0, 0, 1)
    self.rotation = vec:new(0, 0, 0)
    self.size3d = vec:new(1, 1, 1)
    self.children = {}
    self.parent = nil
    return self
end

local bez = love.math.newBezierCurve(0,0, 0,0, 0,0, 0,0)

local tension = 0
local continuity = 0
local bias = 0

function Kochanek_Bartels(t, c, b,
    p0x, p0y, p1x, p1y, p2x, p2y, p3x, p3y)
  local P0x = p1x
  local P0y = p1y
  local P1x = p1x + (  (1-t)*(1+b)*(1+c) * (p1x - p0x)
                     + (1-t)*(1-b)*(1-c) * (p2x - p1x) ) / 6
  local P1y = p1y + (  (1-t)*(1+b)*(1+c) * (p1y - p0y)
                     + (1-t)*(1-b)*(1-c) * (p2y - p1y) ) / 6
  local P2x = p2x - (  (1-t)*(1+b)*(1-c) * (p2x - p1x)
                     + (1-t)*(1-b)*(1+c) * (p3x - p2x) ) / 6
  local P2y = p2y - (  (1-t)*(1+b)*(1-c) * (p2y - p1y)
                     + (1-t)*(1-b)*(1+c) * (p3y - p2y) ) / 6
  local P3x = p2x
  local P3y = p2y
  bez:setControlPoint(1, P0x, P0y)
  bez:setControlPoint(2, P1x, P1y)
  bez:setControlPoint(3, P2x, P2y)
  bez:setControlPoint(4, P3x, P3y)
  love.graphics.line(bez:render())
end

function lagrange(points, t)
    local n = #points
    local sum = vec:new(0, 0)
    for i = 1, n do
        local p = points[i]
        local l = 1
        for j = 1, n do
            if i ~= j then
                l = l * (t - points[j].x) / (points[i].x - points[j].x)
            end
        end
        sum = sum + vec:new(p.x, p.y):multiple(l)
    end
    return sum
end

function custom_curv(dot)
    -- Draw the curve
    local len = #dot
    local npoints = len / 2
    if npoints >= 3 then
        -- do first segment by repeating first point
        Kochanek_Bartels(tension, continuity, bias,
        dot[1], dot[2], dot[1], dot[2],
        dot[3], dot[4], dot[5], dot[6])
        -- do middle segments
        for i = 2, npoints - 2 do
            local base = i * 2 - 1
            Kochanek_Bartels(tension, continuity, bias,
            dot[base - 2], dot[base - 1],
            dot[base], dot[base + 1],
            dot[base + 2], dot[base + 3],
            dot[base + 4], dot[base + 5])
        end
        -- do last segment by repeating last point
        Kochanek_Bartels(tension, continuity, bias,
        dot[len - 5], dot[len - 4], dot[len - 3], dot[len - 2],
        dot[len - 1], dot[len], dot[len - 1], dot[len])
    elseif npoints == 2 then
        -- just draw a line between the points
        love.graphics.line(dot)
    end
end

function findcenter(p1, p2, p3)
    local x1 = p1.x
    local y1 = p1.y
    local x2 = p2.x
    local y2 = p2.y
    local x3 = p3.x
    local y3 = p3.y

    local x12 = x1 - x2
    local x13 = x1 - x3

    local y12 = y1 - y2
    local y13 = y1 - y3

    local y31 = y3 - y1
    local y21 = y2 - y1

    local x31 = x3 - x1
    local x21 = x2 - x1

    local sx13 = x1^2 - x3^2
    local sy13 = y1^2 - y3^2

    local sx21 = x2^2 - x1^2
    local sy21 = y2^2 - y1^2

    local f = ((sx13) * (x12)
            + (sy13) * (x12)
            + (sx21) * (x13)
            + (sy21) * (x13))
            / (2 * ((y31) * (x12) - (y21) * (x13)))

    local g = ((sx13) * (y12)
            + (sy13) * (y12)
            + (sx21) * (y13)
            + (sy21) * (y13))
            / (2 * ((x31) * (y12) - (x21) * (y13)))

    local c = -(x1^2) - (y1^2) - 2 * g * x1 - 2 * f * y1

    local h = -g
    local k = -f

    local sqr_of_r = h^2 + k^2 - c

    local r = math.sqrt(sqr_of_r)

    return {x = h, y = k, r = r}
end

function get_angle(p1, p2)
    local px1, px2, py1, py2 = p1.x, p2.x, p1.y, p2.y
    local angle = math.atan2(py2 - py1, px2 - px1)
    return angle
end

function arc_line(x,y,r, angle_start, angle_end, segments)
    lines = {}
    local angle_range = angle_end - angle_start
    angle_range = angle_range%math.pi*2
    local angle_step = angle_range / segments
    for i = 0, segments do
        local angle = angle_start + angle_step * i
        local px = x + r * math.cos(angle)
        local py = y + r * math.sin(angle)
        table.insert(lines, px)
        table.insert(lines, py)
    end
    return lines
end

function round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function Shape:draw(camera)
    local points = self:apply_matrix()
    points = camera:transform_point(points)
    -- set color
    love.graphics.setColor(self.color)
    local line = self.lines
    for i = 1, #line do
        local curve = line[i]
        local p = curve
        local dot = {}
        for j = 1, #p do
            local point = points[p[j]]
            table.insert(dot, point.x)
            table.insert(dot, point.y)
        end
        custom_curv(dot)
        if curve.type == "curve" then
            local p = curve.points
            local dot = {}
            for j = 1, #p do
                local point = points[p[j]]
                table.insert(dot, point.x)
                table.insert(dot, point.y)
            end
            custom_curv(dot)
        elseif curve.type == "arc" then
            local center = findcenter(points[curve.points[1]], points[curve.points[2]], points[curve.points[3]])
            local start = points[curve.points[1]]
            local endp = points[curve.points[3]]
            local angle_start = get_angle(center,start)
            local angle_end = get_angle(center, endp)
            local angle_mid = get_angle(center, points[curve.points[2]])
            angle_mid = angle_end + angle_start - angle_mid
            print(round(angle_mid,4), round(angle_end,4), round(angle_start,4))
            if (math.abs(angle_mid) > math.pi/2) then
                angle_start = angle_start + math.pi*2
            end
            l = arc_line(center.x, center.y, center.r, angle_start, angle_end, 20)
            love.graphics.line(l)
        end
    end

    for i = 0, points.size-1 do
        local p = points[i]
        love.graphics.circle("fill", p.x, p.y, 5)
    end
end

return Shape