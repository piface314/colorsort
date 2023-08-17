local GUI = require "src.gui.init"
local Display = require "src.display"
local Array = require "src.array"
local Sound = require "src.sound"

local algorithms = require "src.algorithm"

local N = 100
local state = {
    size = {text = tostring(N), value = N},
    delay = {text = "0.1", value = 0.1},
    algorithm = {},
    mode = { value = "ring" },
    running = false,
    shuffling = false,
    sound = false,
    config = false,
    data = {
        array = Array(N),
        aux = {},
        auxNames = {},
        varNames = {},
        config = {}
    }
}

local fonts = {}

local function loadAlgorithms()
    local algList = {}
    for id, alg in pairs(algorithms) do
        algList[#algList+1] = {value = id, label = alg.label}
    end
    table.sort(algList, function (a, b) return a.label > b.label end)
    state.algorithms = algList
end

local function loadArray(n)
    ---@type Array
    local array = Array(n or N)
    for i = 0, array.n - 1 do array[i] = i end
    state.data.array = array
end

local function loadFonts()
    fonts.bold = love.graphics.newFont("res/font-bold.ttf", 16)
    fonts.regular = love.graphics.newFont("res/font-regular.ttf", 16)
end

local function setEvents()
    GUI:subscribe("selectAlgorithm", function (alg)
        local algData = alg and algorithms[alg]
        Display.load(state.data, algData)
        GUI:loadConfigs(algData and algData.config or {})
        state.running = true
    end)
    GUI:subscribe("changeSize", function (n)
        local alg = state.algorithm.value
        state.running = false
        loadArray(n)
        Display.load(state.data, alg and algorithms[alg])
        state.running = true
    end)
    GUI:subscribe("restart", function ()
        local alg = state.algorithm.value
        Display.load(state.data, alg and algorithms[alg])
        state.running = true
    end)
    GUI:subscribe("toggleSound", function (on)
        Sound.enable(on)
    end)
end

function love.load()
    loadAlgorithms()
    loadArray()
    loadFonts()
    GUI:load()
    Sound.enable(state.sound)
    setEvents()
    Display.load(state.data, nil)
end

function love.update(dt)
    Display.update(dt, state.running, state.delay.value, state.data)
    GUI:update(dt, state)
end

function love.draw()
    local wd, ht = love.graphics.getDimensions()
    love.graphics.setFont(fonts.bold)
    Display.draw(state.mode.value, state.data, state.running, state.delay.value, 0, 0, wd, ht - GUI.variables.menuTotalHeight)
    GUI:draw()
end

function love.textinput(t)
    GUI:textinput(t)
end

function love.keypressed(key)
    GUI:keypressed(key)
end

function love.wheelmoved(dx, dy)
    GUI:wheelmoved(dx, dy)
end