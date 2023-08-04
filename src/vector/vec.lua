utils = require("vector.utils")
same_vector_type = utils.same_vector_type
print_table = utils.print_table

local name = "xyzwabcdefghijklmnopqrstuv"

local vec = {}
function vec.__index(t, k)
    if type(k) == "number" then
        return t[name:sub(k + 1, k + 1)]
    elseif type(k) == "table" then
        local result = t[k[1]]
        for i = 2, #k do
            result = result[k[i]]
        end
        return result
    else
        return vec[k]
    end
end

function vec.__newindex(t, k, v)
    if type(k) == "number" then
        t[name:sub(k + 1, k + 1)] = v
    elseif type(k) == "table" then
        local result = t[k[1]]
        for i = 2, #k-1 do
            result = result[k[i]]
        end
        result[k[k.size]] = v
    else
        rawset(t, k, v)
    end
    
end

vec.__name = "vec"
vec.type = "vec"

-- in reality is vec/matrix type

function vec:new(...)
    local self = setmetatable({}, vec)
    local t = {...}
    self.size = #t
    if #t == 1 and type(t[1]) == "table" then
        if t[1].type ~= "vec" then
            t = t[1]
            self.size = #t
        else
            self.size = t[1].size
            for i = 0, self.size-1 do
                self[i] = t[1][i]
            end
            return self
        end
    end
    for i = 1, #t do
        if type(t[i]) == "table" then
            self[i-1] = vec:new(t[i])
        else
            self[i-1] = t[i] or 0
        end
    end
    return self
end

function vec:__pairs(t)
    local i = 0
    return function()
        if i <= self.size then
            return i, self[name:sub(i + 1, i + 1)]
        end
        i = i + 1
    end
end

function vec:__ipairs(t)
    local i = 0
    return function()
        if i <= self.size then
            return i, self[i]
        end
        i = i + 1
    end
end

function vec:__concat(other)
    if type(other) == "string" then
        return tostring(self) .. other
    end
    assert(same_vector_type(self, other), "Cannot concatenate two vectors of different types")
    local new = {}
    for i = 0, self.size do
        new[i] = self[i]
    end
    for i = 0, other.size do
        new[i + self.size] = other[i]
    end
    return vec:new(new)
end

-- display the vector as a string
function vec:__tostring()
    if type(self[0]) == "table" then
        local str = {}
        for i = 0, self.size-1 do
            str[i] = "  "..tostring(self[i])
        end
        return string.format("vec(\n%s\n)", table.concat(str, ",\n", 0, self.size-1))
    end
    local t_concat = ""
    for i = 0, self.size-1 do
        t_concat = t_concat .. tostring(self[i]) .. ", "
    end
    return string.format("vec(%s)", t_concat)
end

-- add two vectors
function vec:__add(other)
    local vector = vec:new(self)
    if type(other) == "number" then
        for i = 0, self.size-1 do
            vector[i] = self[i] + other
        end
        vector.size = self.size
        return vector
    else
        assert(same_vector_type(self, other), "Cannot add two vectors of different types")
        for i = 0, self.size-1 do
            vector[i] = self[i] + other[i]
        end
    end
    vector.size = self.size
    return vector
end

-- subtract two vectors
function vec:__sub(other)
    local vector = vec:new(self)
    if type(other) == "number" then
        for i = 0, self.size-1 do
            vector[i] = self[i] - other
        end
    else
        assert(same_vector_type(self, other), "Cannot subtract two vectors of different types")
        for i = 0, self.size-1 do
            vector[i] = self[i] - other[i]
        end
    end
    vector.size = self.size
    return vector
end

-- multiply two vectors
function vec:multiple(other)
    local vector = vec:new(self)
    if type(other) == "number" then
        for i = 0, self.size-1 do
            vector[i] = self[i] * other
        end
    else
        assert(same_vector_type(self, other), "Cannot multiply two vectors of different types")
        for i = 0, self.size-1 do
            vector[i] = self[i] * other[i]
        end
    end
    vector.size = self.size
    return vector
end

-- matrix multiplication of two vectors (with the symbol %)
function vec:__mul(other)
    local vector = vec:new()
    -- handle if the second dimmentions is a int
    if type(other[0]) == "number" then
        for i = 0, #self-1 do
            vector[i] = 0
            for j = 0, #other-1 do
                vector[i] = vector[i] + self[i][j] * other[j]
            end
        end
        vector.size = other.size
        return vector
    elseif type(self[0]) == "number" then
        for i = 0, #other-1 do
            vector[i] = 0
            for j = 0, #self-1 do
                vector[i] = vector[i] + self[j] * other[j][i]
            end
        end
        vector.size = self.size
        return vector
    end
    for i = 0, self.size-1 do
        vector[i] = vec:new()
        vector[i].size = other[0].size
        for j = 0, other[0].size-1 do
            vector[i][j] = 0
            for k = 0, other.size-1 do
                vector[i][j] = vector[i][j] + self[i][k] * other[k][j]
            end
        end
    end
    vector.size = self.size
    return vector
end

function vec:__len()
    return self.size
end

-- divide two vectors
function vec:__div(other)
    local vector = vec:new(self)
    if type(other) == "number" then
        for i = 0, self.size-1 do
            vector[i] = self[i] / other
        end
    else
        assert(same_vector_type(self, other), "Cannot divide two vectors of different types")
        for i = 0, self.size-1 do
            vector[i] = self[i] / other[i]
        end
    end
    vector.size = self.size
    return vector
end

-- check if two vectors are equal
function vec:__eq(other)
    assert(same_vector_type(self, other), "Cannot compare two vectors of different types")
    for i = 0, self.size-1 do
        if self[i] ~= other[i] then
            return false
        end
    end
    return true
end

-- negate a vector
function vec:__unm()
    local vector = vec:new(self)
    for i = 0, self.size-1 do
        vector[i] = -self[i]
    end
    vector.size = self.size
    return vector
end

return vec