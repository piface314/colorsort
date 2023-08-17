local class = require "class"
local Color = require "src.color"

---@class Array
local Array = class()

---@param n number array size
function Array:new(n)
    self.n = n
    self.items = {}
    self.name = nil
    self.value = nil
end

---@diagnostic disable-next-line: undefined-field
local index = Array.__index
function Array:__index(i)
    if not i then
        return rawget(self, "value")
    end
    if type(i) == "number" then
        return rawget(self, "items")[i]
    end
    return index[i]
end

function Array:__newindex(i, v)
    if not i then
        rawset(self, "value", v)
    elseif type(i) == "number" then
        rawget(self, "items")[i] = v
        if i >= rawget(self, "n") then
            rawset(self, "n", i + 1)
        end
    else
        rawset(self, i, v)
    end
end

function Array:setName(name)
    self.name = name
    return self
end

function Array:setItems(items)
    items = items or {}
    for i = 0, #self - 1 do
        self[i] = items[i]
    end
    return self
end

return Array