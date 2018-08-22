local cfg = require "src.Config"
local lib = require "src.core.lib"

Jade = {}
Jade.__index = Jade
setmetatable(Jade, {__call = function(cls, ...) return cls.new(...) end})
function Jade:__tostring() return "jade" end

-------------------------------------------------------------------------------
function Jade.new(group)
  local self = setmetatable({}, Jade)
  self.img = lib.image(group, cfg.jade)
  return self
end

-------------------------------------------------------------------------------
function Jade:die()
  self.img:removeSelf()
  self.img = nil
end

return Jade