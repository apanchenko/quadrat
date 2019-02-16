local count       = require 'src.view.power.count'
local image       = require 'src.view.power.image'

local powers = {}

powers['multiply'] = count
powers['movediagonal'] = image
powers['jumpproof'] = image
powers['sphere'] = image
powers['parasite'] = image
powers['parasite_host'] = image

return powers