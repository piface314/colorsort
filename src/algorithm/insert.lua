local InsertSort = {
    id = "insert",
    label = "Insert Sort"
}

local function run(array, channel)
    local n = array.n
    local a = array.items
    channel:push { type = "malloc", name = "aux" }
    for i = 1, n - 1 do
        local aux = a[i]
        channel:push { type = "move", i = i, dst = "aux" }
        local j = i - 1
        while j >= 0 do
            channel:push { type = "compare", i = j, op = ">", dst = "aux" }
            if a[j] > aux then
                a[j + 1] = a[j]
                channel:push { type = "move", i = j, j = j + 1 }
            else
                break
            end
            j = j - 1
        end
        a[j + 1] = aux
        channel:push { type = "move", j = j + 1, src = "aux" }
    end
end

local thread, array, channel = ...
if thread == true then
    run(array, channel)
end

return InsertSort
