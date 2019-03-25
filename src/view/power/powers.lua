local count       = require 'src.view.power.count'
local image       = require 'src.view.power.image'
local invisible   = require 'src.view.power.invisible'

local powers = {}

powers['Multiply'] = count
powers['Movediagonal'] = image
powers['Jumpproof'] = image
powers['Sphere'] = image
powers['Parasite'] = image
powers['Parasite_host'] = image
powers['Invisible'] = invisible

return powers
