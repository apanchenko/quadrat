local Jade = require("src.Pos")
local Config = require("src.Config")

Jade = {}
Jade.__index = Jade
setmetatable(Jade, {__call = function(cls, ...) return cls.new(...) end})
function Jade:__tostring() return "jade" end

-------------------------------------------------------------------------------
function Jade.new(group)
  local self = setmetatable({}, Jade)
  self.img = display.newImageRect(group, "src/jade.png", Config.cell_size.x, Config.cell_size.y)
  self.img.anchorX = 0
  self.img.anchorY = 0
  return self
end

-------------------------------------------------------------------------------
function Jade:die()
  self.img:removeSelf()
  self.img = nil
end

return Jade