local MergeSort = {
    id = "merge",
    label = "Merge Sort"
}

local function run(array, channel)
    local n = array.n
    local a = array.items

    local aux = {}
    channel:push { type = "malloc", name = "aux", n = n }

    local function mergesort(l, r)
        if l + 1 >= r then return end

        local m = math.floor((l + r) / 2)

        mergesort(l, m)
        mergesort(m, r)

        local i, j, k = l, m, 0

        while i < m and j < r do
            channel:push { type = "compare", i = i, op = "<", j = j }
            if a[i] < a[j] then
                aux[k] = a[i]
                channel:push { type = "move", i = i, j = k, dst = "aux" }
                i = i + 1
            else
                aux[k] = a[j]
                channel:push { type = "move", i = j, j = k, dst = "aux" }
                j = j + 1
            end
            k = k + 1
        end
        while i < m do
            aux[k] = a[i]
            channel:push { type = "move", i = i, j = k, dst = "aux" }
            i, k  = i + 1, k + 1
        end
        while j < r do
            aux[k] = a[j]
            channel:push { type = "move", i = j, j = k, dst = "aux" }
            j, k = j + 1, k + 1
        end
        for k = 0, r - l - 1 do
            a[l+k] = aux[k]
            channel:push { type = "move", i = k, j = l + k, src = "aux" }
        end
    end
    mergesort(0, n)
end

local thread, array, channel = ...
if thread == true then
    run(array, channel)
end

return MergeSort
