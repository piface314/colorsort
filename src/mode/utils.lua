local DrawModeUtils = {}

function DrawModeUtils.highlights(inst)
    if not inst or inst.type == "swap" then return {} end
    local highlights = {}
    local src, dst = inst.src or "_", inst.dst or "_"
    highlights[src], highlights[dst] = highlights[src] or {}, highlights[dst] or {}
    highlights[src][inst.i or "_"], highlights[dst][inst.j or "_"] = true, true
    return highlights
end

return DrawModeUtils