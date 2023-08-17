local DrawModeUtils = require "src.mode.utils"
local Color = require "src.color"

local BarsMode = {}

---@param array Array
---@param x number
---@param y number
---@param w number
---@param h number
local function drawArray(array, x, y, w, h, highs, refN)
    local n = array.n
    local wb = w / n
    local hmax = h*7/8
    local hmin = h/8
    local hdelta = hmax - hmin
    for i = 0, n - 1 do
        if array[i] then
            local hb = hmin + hdelta * (array[i] / refN)
            local yb = y + h - hb
            local color = highs and highs[i] and Color.WHITE or Color.valueToRGB(array[i], refN)
            love.graphics.setColor(color)
            love.graphics.rectangle("fill", x + i*wb, yb, wb, hb)
        end
    end
end

function BarsMode.draw(data, x, y, w, h, instruction)
    local array = data.array
    local nAuxs = #data.auxNames

    local highs = DrawModeUtils.highlights(instruction)
    if nAuxs == 0 then
        drawArray(array, x, y, w, h, highs._, array.n)
    else
        local auxH = h / 10
        local auxW = w / nAuxs
        local auxY = y + h - auxH
        drawArray(array, x, y, w, h - auxH, highs._, array.n)
        for i, name in ipairs(data.auxNames) do
            local xi = x + (i - 1) * auxW
            drawArray(data.aux[name], xi, auxY, auxW, auxH, highs[name], array.n)
            love.graphics.setColor(Color.WHITE)
            love.graphics.print(name, xi + 10, auxY + 10)
        end
    end

    local gap = 10
    local varH = h / 20
    local varX = x + gap
    local varY = y + 80
    for i, name in ipairs(data.varNames) do
        local xi = varX + (i - 1) * (varH + gap)
        love.graphics.setColor(Color.valueToRGB(data.aux[name][nil], data.array.n))
        love.graphics.rectangle("fill", xi, varY, varH, varH)
        love.graphics.setColor(Color.WHITE)
        love.graphics.setLineWidth(highs[name] and 5 or 1)
        love.graphics.rectangle("line", xi, varY, varH, varH)
        love.graphics.printf(name, xi, varY - gap * 2, varH, "center")
    end
end

return BarsMode