local BASE = (...):match('(.-)[^%.]+$')

local function isType(val, typ)
    return type(val) == typ
        or (type(val) == "userdata" and val.typeOf and val:typeOf(typ))
end

local itemsXY = {
    u = function(i, o, s, x, y, d) return x, y - o * (i * d + d) + s end,
    d = function(i, o, s, x, y, d) return x, y + o * (i * d) + s end,
    l = function(i, o, s, x, y, d) return x - o * (i * d + d) + s, y end,
    r = function(i, o, s, x, y, d) return x + o * (i * d) + s, y end
}

local function intersects(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1 + w1 >= x2 and x2 + w2 >= x1 and y1 + h1 >= y2 and y2 + h2 >= y1
end

return function(core, items, state, ...)
    local opt, x, y, w, h = core.getOptionsAndSize(...)
    assert(opt.id, "Drop needs an ID")

    opt.font = opt.font or love.graphics.getFont()
    if not state.open then
        opt.state = 'normal'
        return {}
    end
    opt.state = core:registerHitbox(opt.id, x, y, w, h)

    local dir = opt.dir or 'd'
    local dm, dx, wi, hi, m, sx, sy
    local n = #items > 0 and #items or 1
    if dir == 'u' or dir == 'd' then
        dm = opt.size or h / n
        dx = w
        wi, hi, m = dx, dm, h
        sx, sy = x, dir == 'u' and y - h or y
    else
        dm = opt.size or w / n
        dx = h
        wi, hi, m = dm, dx, w
        sx, sy = dir == 'l' and x - w or x, y
    end


    state.scroll = state.scroll or 0
    if core:mouseInRect(sx, sy, w, h) then
        local scroll = state.scroll + (core.wheel_dy or 0) * 3
        local scrollSpace = math.max(n * dm - m, 0)
        if scroll < 0 then
            state.scroll = 0
        elseif scroll > scrollSpace then
            state.scroll = scrollSpace
        else
            state.scroll = scroll
        end
    elseif love.mouse.isDown(1) then
        state.open = false
    end
    core:registerDraw(function()
        love.graphics.setScissor()
    end)

    local selected = false
    local function onClick(i, value)
        state.open = false
        state.index = i
        state.value = value
        selected = true
    end
    for i, item in ipairs(items) do
        local xi, yi = itemsXY[dir](i - 1, state.open and 1 or 0, state.scroll, x, y, dm)
        if intersects(sx, sy, w, h, xi, yi, wi, hi) then
            local buttonID = opt.id .. '-' .. i
            if isType(item, 'string') then
                if core:Button(item, { id = buttonID, align = opt.align, cornerRadius = 0 }, xi, yi, wi, hi).hit then
                    onClick(i, item)
                end
            elseif isType(item, 'table') then
                if item.icon then
                    if core:IconButton(item.icon, item.quad, { id = buttonID, cornerRadius = 0 }, xi, yi, wi, hi).hit then
                        onClick(i, item.value)
                    end
                else
                    if core:Button(item.label, { id = buttonID, align = opt.align, cornerRadius = 0 }, xi, yi, wi, hi).hit then
                        onClick(i, item.value)
                    end
                end
            end
        end
    end
    core:registerDraw(function()
        love.graphics.setScissor(sx, sy, w, h)
    end)

    return {
        id = opt.id,
        hit = core:mouseReleasedOn(opt.id),
        hovered = core:isHovered(opt.id),
        entered = core:isHovered(opt.id) and not core:wasHovered(opt.id),
        left = not core:isHovered(opt.id) and core:wasHovered(opt.id),
        selected = selected
    }
end
