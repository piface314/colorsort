local DrawModeUtils = require "src.mode.utils"
local Color = require "src.color"


local RingMode = {}

---@param array Array
---@param x number
---@param y number
---@param w number
---@param h number
local function drawArray(array, x, y, w, h, highs, arc0, arcF, refN)
    local n = array.n
    local segments = n > 200 and 100 or 10
    local theta = (arcF - arc0) / n
    local ox, oy = x + w / 2, y + h / 2
    local rOut = math.min(w, h) * 0.4
    local rIn = rOut * 2 / 3
    love.graphics.push()
    love.graphics.translate(ox, oy)
    love.graphics.rotate(-math.pi / 2)
    for i = 0, n - 1 do
        local color = highs and highs[i] and Color.WHITE or Color.valueToRGB(array[i], refN)
        love.graphics.setColor(color)
        love.graphics.arc("fill", 0, 0, rOut, arc0 + i * theta, arc0 + (i + 1) * theta, segments)
    end
    love.graphics.pop()
    love.graphics.setColor(Color.BLACK)
    love.graphics.circle("fill", ox, oy, rIn)
    return rIn
end

function RingMode.draw(data, x, y, w, h, instruction)
    local array = data.array
    local highs = DrawModeUtils.highlights(instruction)
    local rIn = drawArray(array, x, y, w, h, highs._, 0, math.pi * 2, array.n)

    if #data.auxNames > 0 then
        local arc = math.pi * 2 / #data.auxNames
        local xa, ya = x + w / 2 - rIn, y + h / 2 - rIn
        local ox, oy = x + w / 2, y + h / 2
        local r
        for i, name in ipairs(data.auxNames) do
            local arc0 = (i - 1) * arc
            local arcF = arc0 + arc
            r = drawArray(data.aux[name], xa, ya, rIn * 2, rIn * 2, highs[name], arc0, arcF, array.n)
        end
        for i, name in ipairs(data.auxNames) do
            local arc0 = (i - 1) * arc
            love.graphics.push()
            love.graphics.setColor(Color.WHITE)
            love.graphics.translate(ox, oy)
            love.graphics.rotate(arc0 + arc / 2)
            local wt = love.graphics.getFont():getWidth(name)
            love.graphics.print(name, -wt / 2, -r + 10)
            love.graphics.pop()
        end
    end

    local nVars = #data.varNames
    local gap = 10
    local varR = h / 20
    local varsH = varR * nVars + (gap * nVars - 1)
    local varX = x + w - gap * 4 - varR
    local varY = y + h / 2 - varsH / 2 + varR
    for i, name in ipairs(data.varNames) do
        local yi = varY + (i - 1) * (varR * 2 + gap)
        love.graphics.setColor(Color.valueToRGB(data.aux[name][nil], data.array.n))
        love.graphics.circle("fill", varX, yi, varR)
        love.graphics.setColor(Color.WHITE)
        love.graphics.setLineWidth(highs[name] and 5 or 1)
        love.graphics.circle("line", varX, yi, varR)
        love.graphics.printf(name, varX - varR, yi - varR - gap * 2, varR * 2, "center")
    end
end

return RingMode
