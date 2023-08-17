local QuickSort = {
    id = "quick",
    label = "QuickSort"
}

local function run(array, channel)
    local n = array.n
    local a = array.items

    channel:push { type = "malloc", name = "pivot" }

    local function quicksort(l, r)
        local i, j, m = l, r, math.floor((l + r) / 2)
        local pivot = a[m]
        channel:push { type = "move", i = m, dst = "pivot" }

        while i <= j do
            while channel:push { type = "compare", i = i, op = "<", dst = "pivot" }
                and a[i] < pivot do
                i = i + 1
            end
            while channel:push { type = "compare", i = j, op = ">", dst = "pivot" }
                and a[j] > pivot do
                j = j - 1
            end
            if i <= j then
                a[i], a[j] = a[j], a[i]
                channel:push { type = "swap", i = i, j = j }
                i = i + 1
                j = j - 1
            end
        end

        if l < j then quicksort(l, j) end
        if i < r then quicksort(i, r) end
    end
    quicksort(0, n - 1)
end

local thread, array, channel = ...
if thread == true then
    run(array, channel)
end

return QuickSort
