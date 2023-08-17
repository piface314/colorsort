local SelectSort = {
    id = "select",
    label = "Select Sort"
}

local function run(array, channel)
    local n = array.n
    local a = array.items
    for i = 0, n - 2 do
        local m = 0
        for j = 1, n - i - 1 do
            channel:push { type = "compare", i = j, j = m, op = ">" }
            if a[j] > a[m] then
                m = j
            end
        end
        a[n - i - 1], a[m] = a[m], a[n - i - 1]
        channel:push { type = "swap", i = n - i - 1, j = m }
    end
end

local thread, array, channel = ...
if thread == true then
    run(array, channel)
end

return SelectSort
