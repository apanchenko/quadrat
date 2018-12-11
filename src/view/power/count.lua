local object      = require 'src.core.object'
local types       = require 'src.core.types'
local ass         = require 'src.core.ass'
local log         = require 'src.core.log'
local cfg         = require 'src.Config'

-- power draws a counter ------------------------------------------------------
local count = object:extend('view.power.count')

function count:__tostring()
  return 'account '..self.balance
end

-- create image with initial one count
function count:create(stone, name)
  local t = setmetatable({}, self)
  self.__index = self
  self.count = 2
  self.text = lay.text(stone, {text=tostring(self.count + 1), fontSize=22})
  return t
end

--
function count:decrease()
  self.text:removeSelf()
  return nil
end


--MODULE-----------------------------------------------------------------------
ass.wrap(count, ':create', 'Stone', types.str)
ass.wrap(count, ':decrease')

log:wrap(count, 'create', 'decrease')

return count