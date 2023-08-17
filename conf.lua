function love.conf(t)
    t.title = 'ColorSort'
    t.window.width = 1200
    t.window.height = 900
    t.modules.physics = false
    t.console = true
    t.window.resizable = true
    t.window.fullscreen = false
end

---@diagnostic disable-next-line: lowercase-global
function opairs(t)
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end
    table.sort(keys)
    return coroutine.wrap(function()
        for i, k in ipairs(keys) do
            coroutine.yield(i, k, t[k])
        end
    end)
end
