require "lib.slam"
local Sound = {}

local rate      = 44100
local length    = 1 / 48
local tone      = 440.0
local p         = math.floor(rate / tone)
local soundData = love.sound.newSoundData(math.floor(length * rate), rate, 16, 1)
for i = 0, soundData:getSampleCount() - 1 do
    -- soundData:setSample(i, math.sin(2*math.pi*i/p)) --sine wave
    soundData:setSample(i, i % p < p / 2 and 0.05 or -0.05) --square wave
end
local source = love.audio.newSource(soundData)

local on = true

function Sound.play(v, n)
    if on then
        local instance = source:play()
        instance:setPitch(math.max(2 * v / n, 0.01))
    end
end

function Sound.enable(enable)
    on = enable
    if not on then source:stop() end
end

return Sound
