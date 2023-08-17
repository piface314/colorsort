local BASE = (...):match('(.-)[^%.]+$')

local function isType(val, typ)
    return type(val) == "userdata" and val.typeOf and val:typeOf(typ)
end

return function(core, img, quad, ...)
    local opt, x, y, w, h = core.getOptionsAndSize(...)
    opt.id = opt.id or quad or img
    opt.font = opt.font or love.graphics.getFont()

    local image = assert(img, "No image for icon button")

    w = w or image:getWidth() + 4
    h = h or image:getHeight() + 4

    opt.state = core:registerHitbox(opt.id, x, y, w, h)
    assert(isType(image, "Image"), "icon image is not a love.graphics.Image")
    assert(not quad or isType(quad, "Quad"), "icon quad is not a love.graphics.Quad")
    core:registerDraw(opt.draw or core.theme.IconButton, image, quad, opt, x, y, w, h)

    return {
        id = opt.id,
        hit = core:mouseReleasedOn(opt.id),
        hovered = core:isHovered(opt.id),
        entered = core:isHovered(opt.id) and not core:wasHovered(opt.id),
        left = not core:isHovered(opt.id) and core:wasHovered(opt.id)
    }
end
