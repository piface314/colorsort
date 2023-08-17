local function isTypeOf(t, o)
    if type(o) ~= 'table' then return false end
    local class = getmetatable(o)
    return class == t or (class and t:isTypeOf(class))
end

local function constructor(c, ...)
    local o = setmetatable({}, c)
    if c.new then c.new(o, ...) end
    return o
end

---@class Object
local Object = { isTypeOf = isTypeOf }

local function class(super)
    local c = {}
    c.__index = c
    c.isTypeOf = isTypeOf
    super = super or Object
    super.__call = constructor
    return setmetatable(c, super)
end

return class
