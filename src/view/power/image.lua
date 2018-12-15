local object      = require 'src.core.object'
local types       = require 'src.core.types'
local ass         = require 'src.core.ass'
local log         = require 'src.core.log'
local cfg         = require 'src.Config'

local image = object:extend('view.power.image')

-- create image with initial one count
function image:create(stone, name, count)
  ass.eq(count, 1)
  local t = setmetatable({}, self)
  self.__index = self
  self.image = lay.image(stone, cfg.cell, 'src/view/power/'..name..'.png')
  return t
end

--
function image:set_count(count)
  ass.eq(count, 0)
  self.image:removeSelf()
end


--MODULE-----------------------------------------------------------------------
ass.wrap(image, ':create', 'Stone', types.str, types.num)
ass.wrap(image, ':set_count', types.num)

log:wrap(image, 'create', 'set_count')

return image