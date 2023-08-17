local HeapSort = {
    id = "heap",
    label = "Heap Sort"
}

local function run(array, channel)
    local n = array.n
    local a = array.items

    local i = math.floor(n / 2)
    local aux, parent, child
    channel:push { type = "malloc", name = "aux" }

    while true do
        if i > 0 then
            i = i - 1
            aux = a[i]
            channel:push { type = "move", i = i, dst = "aux" }
        else
            n = n - 1
            if n <= 0 then break end
            aux = a[n]
            channel:push { type = "move", i = n, dst = "aux" }
            a[n] = a[0]
            channel:push { type = "move", i = 0, j = n }
        end
        parent, child = i, 2 * i + 1
        while child < n do
            if child + 1 < n and channel:push { type = "compare", i = child + 1, op = ">", j = child }
                and a[child + 1] > a[child] then
                child = child + 1
            end
            channel:push { type = "compare", i = child, op = ">", dst = "aux" }
            if a[child] > aux then
                a[parent] = a[child]
                channel:push { type = "move", i = child, j = parent }
                parent = child
                child = 2 * parent + 1
            else
                break
            end
        end
        a[parent] = aux
        channel:push { type = "move", src = "aux", j = parent }
    end
end

local thread, array, channel = ...
if thread == true then
    run(array, channel)
end

return HeapSort
