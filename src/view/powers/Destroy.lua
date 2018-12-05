local vec       = require 'src.core.vec'
local lay       = require 'src.core.lay'
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local Class     = require 'src.core.Class'
local cfg       = require 'src.Config'
local Color     = require 'src.model.Color'

local Destroy = Class.Create 'Destroy'

function Destroy.New(stone, count)
  local self = setmetatable({}, Destroy)
  self.image = lay.image(stone, cfg.cell, 'src/view/powers/'..tostring(Destroy)..'.png')
  return self
end

-- MODULE ---------------------------------------------------------------------
ass.wrap(Destroy, 'New', 'Stone', Type.Num)

--log:wrap(Destroy, 'apply')

return Destroy