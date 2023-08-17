local BandMode = require "src.mode.band"
local BarsMode = require "src.mode.bars"
local RingMode = require "src.mode.ring"

local DrawMode = {
    band = BandMode,
    bars = BarsMode,
    ring = RingMode,
}

return DrawMode