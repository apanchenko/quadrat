local count       = require 'src.view.power.count'
local image       = require 'src.view.power.image'

local powers = {}

powers["Multiply"] = count
powers["MoveDiagonal"] = image
powers["jumpproof"] = image
powers["sphere"] = image

return powers