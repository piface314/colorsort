local RadixSortLSD = {
    id = "radix-lsd",
    label = "Radix Sort (LSD)",
    config = {
        { id = "base", label = "Base", type = "int", min = 2, max = 10, value = 4, step = 1 },
    }
}

local function run(array, channel, config)
    local n = array.n
    local a = array.items

    local b = config.base or 4
    local max = -math.huge
    channel:push { type = "malloc", name = "max", value = a[0] }

    local digits = {}
    for i = 0, b - 1 do
        digits[i] = { n = 0 }
        channel:push { type = "malloc", name = "digit" .. i, n = 0 }
    end

    for i = 1, n - 1 do
        channel:push { type = "compare", i = i, op = ">", dst = "max" }
        if a[i] > max then
            max = a[i]
            channel:push { type = "move", i = i, dst = "max" }
        end
    end

    local step = 1
    while max >= step do
        for i = 0, n - 1 do
            local d = math.floor(a[i] / step) % b
            local digit = digits[d]
            digit[digit.n] = a[i]
            channel:push { type = "move", i = i, j = digit.n, dst = "digit" .. d }
            digit.n = digit.n + 1
        end
        local i = 0
        for d = 0, b - 1 do
            local digit = digits[d]
            for j = 0, digit.n - 1 do
                a[i] = digit[j]
                channel:push { type = "move", i = j, src = "digit" .. d, j = i }
                i = i + 1
            end
            digit.n = 0
        end
        step = step * b
    end
end

local thread, array, channel, config = ...
if thread == true then
    run(array, channel, config or {})
end

return RadixSortLSD
