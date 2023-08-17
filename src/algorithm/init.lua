
local names = {
    "bubble",
    "select",
    "insert",
    "shell",
    "quick",
    "heap",
    "merge",
    "radix-lsd"
}

local algorithms = {}
for _, name in pairs(names) do
    algorithms[name] = require("src.algorithm." .. name)
end

return algorithms