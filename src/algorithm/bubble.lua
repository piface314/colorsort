local BubbleSort = {
    id = "bubble",
    label = "Bubble Sort"
}

local function run(array, channel)
    local n = array.n
    local a = array.items
    for i = 0, n - 2 do
        for j = 1, n - i - 1 do
            channel:push { type = "compare", i = j - 1, j = j, op = ">" }
            if a[j - 1] > a[j] then
                a[j - 1], a[j] = a[j], a[j - 1]
                channel:push { type = "swap", i = j - 1, j = j }
            end
        end
    end
end

local thread, array, channel = ...
if thread == true then
    run(array, channel)
end

return BubbleSort
