local ShellSort = {
    id = "shell",
    label = "Shell Sort"
}

local function run(array, channel)
    local n = array.n
    local a = array.items

    local h = 1
    while h < n do
        h = 3 * h + 1
    end

    channel:push { type = "malloc", name = "aux" }

    while h > 1 do
        h = math.floor(h / 3)
        for i = h, n - 1 do
            local aux = a[i]
            channel:push { type = "move", i = i, dst = "aux" }
            local j = i - h
            while j >= 0 do
                channel:push { type = "compare", i = j, op = ">", dst = "aux" }
                if a[j] > aux then
                    a[j + h] = a[j]
                    channel:push { type = "move", i = j, j = j + h }
                else
                    break
                end
                j = j - h
            end
            a[j + h] = aux
            channel:push { type = "move", src = "aux", j = j + h }
        end
    end
end

local thread, array, channel = ...
if thread == true then
    run(array, channel)
end

return ShellSort
