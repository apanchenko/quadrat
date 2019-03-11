local count       = require 'src.view.power.count'
local image       = require 'src.view.power.image'
local invisible   = require 'src.view.power.invisible'

local powers = {}

powers['multiply'] = count
powers['movediagonal'] = image
powers['jumpproof'] = image
powers['sphere'] = image
powers['parasite'] = image
powers['parasite_host'] = image
powers['invisible'] = invisible

return powers
