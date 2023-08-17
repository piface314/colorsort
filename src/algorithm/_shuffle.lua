local function run(array, channel)
    math.randomseed(os.time())
    local n = array.n
    local a = array.items
    for i = n - 1, 1, -1 do
        local j = math.random(0, i)
        a[i], a[j] = a[j], a[i]
        channel:push({ type = "swap", i = i, j = j })
    end
end

local thread, array, channel = ...
if thread == true then
    run(array, channel)
end
