local MenuGUI = require "src.gui.menu"
local ConfigGUI = require "src.gui.config"

local GUI = {}

function GUI:load()
    self.instances = {
        menu = MenuGUI,
        config = ConfigGUI
    }
    self.order = { "config", "menu" }
    self.variables = {}
    self.events = {}

    for _, k in ipairs(self.order) do
        self.instances[k]:load(self.variables)
    end
    self:subscribe("toggleConfig", function (open)
        self.instances.config:toggle(open)
    end)
end

function GUI:subscribe(event, f)
    self.events[event] = f
end

function GUI:onEvent(event, ...)
    local ev = self.events[event]
    if ev then ev(...) end
end

function GUI:loadConfigs(configs)
    self.instances.config:loadConfigs(configs)
end

function GUI:update(dt, state)
    local onEvent = function (...) return self:onEvent(...) end
    for _, k in ipairs(self.order) do
        self.instances[k]:update(dt, state, onEvent, self.variables)
    end
end

function GUI:draw()
    for _, k in ipairs(self.order) do
        self.instances[k]:draw(self.variables)
    end
end

function GUI:textinput(t)
    for _, i in pairs(self.instances) do
        i.gui:textinput(t)
    end
end

function GUI:keypressed(key)
    for _, i in pairs(self.instances) do
        i.gui:keypressed(key)
    end
end

function GUI:wheelmoved(dx, dy)
    for _, i in pairs(self.instances) do
        i.gui:wheelmoved(dx, dy)
    end
end

return GUI