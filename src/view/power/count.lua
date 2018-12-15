local object      = require 'src.core.object'
local types       = require 'src.core.types'
local ass         = require 'src.core.ass'
local log         = require 'src.core.log'
local cfg         = require 'src.Config'

-- power draws a counter ------------------------------------------------------
local count = object:extend('view.power.count')

-- create image with initial one count
function count:create(stone, name, count)
  local t = setmetatable({}, self)
  self.__index = self
  self.count = count
  self.text = lay.text(stone, {text=tostring(count), fontSize=22})
  return t
end

--
function count:set_count(count)
  if count > 0 then
    self.count = count
    self.text.text = tostring(count)
    return self
  end

  self.text:removeSelf()
end


--MODULE-----------------------------------------------------------------------
ass.wrap(count, ':create', 'Stone', types.str, types.num)
ass.wrap(count, ':set_count', types.num)

log:wrap(count, 'create', 'set_count')

return count