local DrawMode = require "src.mode"
local Instructions = require "src.instructions"

local Display = {}

local instructionChannel
local currentInstruction

local SHUFFLE = { id = "_shuffle" }
local currentAlgorithm = nil
local nextAlgorithm = nil

local message = ""

local function startThread(data)
    if currentAlgorithm then
        local thread = love.thread.newThread(("src/algorithm/%s.lua"):format(currentAlgorithm.id))
        thread:start(true, data.array, instructionChannel)
    end
end

local function processInstruction(running, data)
    if not running then return end
    local instruction = instructionChannel:pop()
    if instruction then
        currentInstruction = instruction
        local handler = Instructions[instruction.type]
        if handler then
            message = handler(data, instruction) or ""
        end
    elseif currentAlgorithm then
        currentAlgorithm = nextAlgorithm
        nextAlgorithm = nil
        currentInstruction = nil
        data.aux = {}
        data.auxNames = {}
        data.varNames = {}
        message = ""
        startThread(data)
    end
end

function Display.load(data, algorithm)
    if instructionChannel then instructionChannel:clear() end
    instructionChannel = love.thread.newChannel()
    if algorithm then
        currentAlgorithm = SHUFFLE
        nextAlgorithm = algorithm
        data.aux = {}
        data.auxNames = {}
        data.varNames = {}
    end
    startThread(data)
end

local timer = 0
function Display.update(dt, running, delay, data)
    if currentAlgorithm == SHUFFLE or timer >= delay then
        processInstruction(running, data)
        timer = 0
    else
        timer = timer + dt
    end
end

function Display.draw(mode, data, running, delay, x, y, w, h)
    local drawMode = DrawMode[mode]
    if not drawMode then return end
    drawMode.draw(data, x, y, w, h, currentInstruction)
    local shuffling = currentAlgorithm == SHUFFLE
    if not running or delay >= 1 or shuffling then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(shuffling and "Shuffling..." or message, x + 25, y + 25)
    end
end


return Display