local Color = {}

Color.BLACK = {0, 0, 0}
Color.WHITE = {1, 1, 1}
Color.GRAY = {.1, .1, .1}

local colorCurves = {
    function (x) return {  1,   x,   0} end,
    function (x) return {1-x,   1,   0} end,
    function (x) return {  0,   1,   x} end,
    function (x) return {  0, 1-x,   1} end,
    function (x) return {  x,   0,   1} end,
    function (x) return {  1,   0, 1-x} end,
}
function Color.hueToRGB(h)
    local h6 = h * 6
    local i = math.floor(h6)
    return colorCurves[i%6+1](h6 - i)
end

function Color.valueToRGB(v, n)
    if not v then return Color.GRAY end
    return Color.hueToRGB(v / n)
end

return Color