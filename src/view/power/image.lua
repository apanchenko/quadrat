local object      = require 'src.core.object'
local types       = require 'src.core.types'
local ass         = require 'src.core.ass'
local log         = require 'src.core.log'
local cfg         = require 'src.Config'

local image = object:extend('view.power.image')

function image:__tostring()
  return 'account '..self.balance
end

-- create image with initial one count
function image:create(stone, name)
  local t = setmetatable({}, self)
  self.__index = self
  self.image = lay.image(stone, cfg.cell, 'src/view/power/'..name..'.png')
  return t
end

--
function image:decrease()
  self.image:removeSelf()
  return nil
end


--MODULE-----------------------------------------------------------------------
ass.wrap(image, ':create', 'Stone', types.str)
ass.wrap(image, ':decrease')

log:wrap(image, 'create', 'decrease')

return image