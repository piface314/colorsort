local DrawModeUtils = require "src.mode.utils"
local Color = require "src.color"

local BandMode = {}

---@param array Array
---@param x number
---@param y number
---@param w number
---@param h number
local function drawArray(array, x, y, w, h, highs, refN)
    local n = array.n
    local wb = w / n
    for i = 0, n - 1 do
        local color = highs and highs[i] and Color.WHITE or Color.valueToRGB(array[i], refN)
        love.graphics.setColor(color)
        love.graphics.rectangle("fill", x + i * wb, y, wb, h)
    end
end

function BandMode.draw(data, x, y, w, h, instruction)
    local mainH = h / 3
    local mainY = y + h / 2 - mainH / 2
    local highs = DrawModeUtils.highlights(instruction)
    drawArray(data.array, x, mainY, w, mainH, highs._, data.array.n)

    local auxH = mainH / 6
    local gap = 10
    if #data.auxNames > 0 then
        local auxW = w / #data.auxNames
        local auxY = mainY + mainH + gap
        for i, name in ipairs(data.auxNames) do
            local xi = x + (i - 1) * auxW
            drawArray(data.aux[name], xi, auxY, auxW, auxH, highs[name], data.array.n)
            love.graphics.setColor(1, 1, 1)
            love.graphics.printf(name, xi + gap, auxY + auxH + gap, auxW - gap * 2, "center")
        end
    end

    local nVars = #data.varNames
    local varH = auxH * 2
    local varsW = varH * nVars + (gap * nVars - 1)
    local varX = x + w / 2 - varsW / 2
    local varY = mainY - gap - varH
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

return BandMode
