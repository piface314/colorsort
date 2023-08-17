local Sound = require "src.sound"
local Array = require "src.array"


local Instructions = {}

---@param data table
---@param ref string
local function selectArray(data, ref)
    if not ref then return data.array end
    return data.aux[ref]
end

function Instructions.malloc(data, args)
    local name, n = args.name, args.n
    data.aux[name] = Array(n):setName(name)
    table.insert(data[n and "auxNames" or "varNames"], name)
    if args.value then
        data.aux[name][nil] = args.value
    end
end

function Instructions.swap(data, args)
    local i, j = args.i, args.j
    local src, dst = selectArray(data, args.src), selectArray(data, args.dst)
    if src.name == nil then
        Sound.play(src[i], data.array.n)
    elseif dst.name == nil then
        Sound.play(dst[j], data.array.n)
    end
    src[i], dst[j] = dst[j], src[i]
    local a = i and ("%s[%d]"):format(src.name or "array", i) or src.name
    local b = j and ("%s[%d]"):format(dst.name or "array", j) or dst.name
    return ("%s <-> %s"):format(a, b)
end

function Instructions.compare(data, args)
    local i, j = args.i, args.j
    local src, dst = selectArray(data, args.src), selectArray(data, args.dst)
    Sound.play(src[i], data.array.n)
    local a = i and ("%s[%d]"):format(src.name or "array", i) or src.name
    local b = j and ("%s[%d]"):format(dst.name or "array", j) or dst.name
    return ("%s %s %s ?"):format(a, args.op, b)
end

function Instructions.move(data, args)
    local i, j = args.i, args.j
    local src, dst = selectArray(data, args.src), selectArray(data, args.dst)
    Sound.play(src[i], data.array.n)
    dst[j] = src[i]
    local a = i and ("%s[%d]"):format(src.name or "array", i) or src.name
    local b = j and ("%s[%d]"):format(dst.name or "array", j) or dst.name
    return ("%s <- %s"):format(b, a)
end

return Instructions