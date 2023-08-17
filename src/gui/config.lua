local suit = require "lib.suit"
local tween = require "lib.tween"
local Color = require "src.color"


local ConfigGUI = {}
ConfigGUI.input = {}

function ConfigGUI:load()
    self.gui = suit.new()
    self.position = { x = 0 }
    self.configs = {}
end

function ConfigGUI:toggle(open)
    self.isOpen = open
    local target = open and 1 or 0
    self.animation = tween.new(0.5, self.position, { x = target }, "outCubic")
end

function ConfigGUI:loadConfigs(configs)
    self.configs = configs or {}
    self.state = {}
    for _, config in ipairs(configs) do
        local state = {}
        for k, v in pairs(config) do state[k] = v end
        self.state[config.id] = state
    end
end

function ConfigGUI:update(dt, state, onEvent, variables)
    if self.animation then self.animation:update(dt) end
    local configs = self.configs
    local wd, ht = love.graphics.getDimensions()
    local w, h = math.min(wd / 4, 400), ht - (variables.menuTotalHeight or 0)
    self.w, self.h, self.pad = w, h, 10
    self.rowH = 20

    if next(configs) == nil or self.position.x <= 0 then return end

    local layout = self.gui.layout
    layout:reset((self.position.x - 1) * w + self.pad, self.pad, self.pad)
    layout:push(layout:row(0, 0))
    self.gui:Label("Settings", layout:col(w*3/4 - self.pad*2, self.rowH))
    self.gui:Button("OK", layout:col(w/4 - self.pad*2, self.rowH))
    layout:pop()
    for _, config in ipairs(configs) do
        layout:push(layout:row(0, 0))
        self.input[config.type](self, config)
        layout:pop()
    end
end

function ConfigGUI.input.int(self, args)
    local layout = self.gui.layout
    local state = self.state[args.id]
    self.gui:Label(args.label, layout:col(self.w / 4 - self.pad * 2, self.rowH))
    self.gui:Slider(state, layout:col(self.w / 2 - self.pad * 2, self.rowH))
    self.gui:Label(tostring(state.value), { align = "right" }, layout:col(self.w / 4 - self.pad * 2, self.rowH))
end

function ConfigGUI:draw(variables)
    if self.position.x <= 0 then return end
    local w, h = self.w, self.h
    local x0 = (self.position.x - 1) * w
    local xf = x0 + w
    love.graphics.setColor(0, 0, 0, 0.5)
    love.graphics.rectangle("fill", x0, 0, w, h)
    love.graphics.setLineWidth(variables.menuLine)
    love.graphics.setColor(Color.WHITE)
    love.graphics.line(xf, 0, xf, h)
    self.gui:draw()
    if next(self.configs) == nil then
        love.graphics.setColor(Color.WHITE)
        love.graphics.printf("No settings.", x0, h / 2, w, "center")
    end
end

return ConfigGUI
