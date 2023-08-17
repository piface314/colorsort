local suit = require "lib.suit"

local MenuGUI = {}

function MenuGUI:load(variables)
    local icons = love.graphics.newImage("res/icons.png")
    self.icons = icons
    self.icon = {}
    self.modes = {}
    self.icon.conf = love.graphics.newQuad(0, 0, 48, 48, icons:getDimensions())
    self.icon.sound_true = love.graphics.newQuad(48, 0, 48, 48, icons:getDimensions())
    self.icon.sound_false = love.graphics.newQuad(96, 0, 48, 48, icons:getDimensions())
    self.icon.mode_bars = love.graphics.newQuad(0, 48, 48, 48, icons:getDimensions())
    self.icon.mode_band = love.graphics.newQuad(48, 48, 48, 48, icons:getDimensions())
    self.icon.mode_ring = love.graphics.newQuad(96, 48, 48, 48, icons:getDimensions())
    self.icon.number = love.graphics.newQuad(0, 96, 48, 48, icons:getDimensions())
    self.icon.delay = love.graphics.newQuad(48, 96, 48, 48, icons:getDimensions())
    self.icon.play = love.graphics.newQuad(96, 96, 48, 48, icons:getDimensions())
    self.icon.pause = love.graphics.newQuad(144, 0, 48, 48, icons:getDimensions())
    self.icon.restart = love.graphics.newQuad(144, 48, 48, 48, icons:getDimensions())

    for i, mode in ipairs{"bars", "band", "ring"} do
        self.modes[i] = { icon = icons, quad = self.icon["mode_" .. mode], value = mode}
    end

    self.gui = suit.new()
end

function MenuGUI:update(dt, state, onEvent, variables)
    local wd, ht = love.graphics.getDimensions()
    local pad, menuH, menuLine, inputW = 4, 36, 1, 200
    local icon, icons = self.icon, self.icons
    local gui = self.gui
    local layout = self.gui.layout:cols {
        min_width = wd, padding = { pad, pad }, pos = { 0, ht - menuH },
        { menuH,   menuH },
        { inputW,  menuH },
        { "fill",  menuH },
        { menuH,   menuH },
        { menuH*3, menuH },
        { menuH,   menuH },
        { menuH*3, menuH },
        { menuH,   menuH },
        { menuH,   menuH },
        { menuH,   menuH },
        { menuH,   menuH }
    }
    variables.padding = pad
    variables.menuHeight = menuH
    variables.menuLine = menuLine
    variables.menuTotalHeight = menuH + pad + menuLine

    if gui:IconButton(icons, icon.conf, { id = "conf" }, layout.cell(1)).hit then
        state.config = not state.config
        onEvent("toggleConfig", state.config)
    end

    local selectedAlg = state.algorithm.index and state.algorithms[state.algorithm.index].label or ""
    if gui:Button(selectedAlg, { id = "algo", align = "left" }, layout.cell(2)).hit then
        state.algorithm.open = not state.algorithm.open
    end
    local x2, y2, w2, h2 = layout.cell(2)
    local algDropOpt = { id = "algosel", align = "left", dir = "u", size = h2 }
    if gui:Drop(state.algorithms, state.algorithm, algDropOpt, x2, y2, w2, h2 * 10).selected then
        onEvent("selectAlgorithm", state.algorithm.value)
    end

    gui:Icon(icons, icon.number, { id = "n" }, layout.cell(4))
    if gui:Input(state.size, { id = "size" }, layout.cell(5)).submitted then
        local v = tonumber(state.size.text) or 100
        v = math.floor(v)
        state.size.value = v
        state.size.text = tostring(v)
        onEvent("changeSize", v)
    end

    gui:Icon(icons, icon.delay, { id = "d" }, layout.cell(6))
    if gui:Input(state.delay, { id = "delay" }, layout.cell(7)).submitted then
        local v = tonumber(state.delay.text) or 0.1
        state.delay.value = v
        state.delay.text = tostring(v)
        onEvent("changeDelay", v)
    end

    local soundIcon = icon["sound_" .. tostring(state.sound)]
    if gui:IconButton(icons, soundIcon, { id = "sound" }, layout.cell(8)).hit then
        state.sound = not state.sound
        onEvent("toggleSound", state.sound)
    end

    if gui:IconButton(icons, icon["mode_" .. state.mode.value], { id = "mode" }, layout.cell(9)).hit then
        state.mode.open = not state.mode.open
    end
    local x9, y9, w9, h9 = layout.cell(9)
    gui:Drop(self.modes, state.mode, { id = "modesel", dir = "u", size = h9 }, x9, y9, w9, h9 * 3)

    local runIcon = state.running and "pause" or "play"
    if gui:IconButton(icons, icon[runIcon], { id = "play" }, layout.cell(10)).hit then
        state.running = not state.running
    end

    if gui:IconButton(icons, icon.restart, { id = "restart" }, layout.cell(11)).hit then
        onEvent("restart")
    end
end

function MenuGUI:draw(variables)
    local wd, ht = love.graphics.getDimensions()
    local menuH, pad = variables.menuHeight, variables.padding
    love.graphics.setColor(1, 1, 1)
    love.graphics.setLineWidth(variables.menuLine)
    love.graphics.line(0, ht - menuH - pad, wd, ht - menuH - pad)
    self.gui:draw()
end

return MenuGUI