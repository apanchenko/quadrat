local Pos = require("src.core.Pos")
local Config = require("src.Config")

AbilityDiagonal =
{
}
AbilityDiagonal.__index = AbilityDiagonal
setmetatable(AbilityDiagonal, {__call = function(cls, ...) return cls.new(...) end})
function AbilityDiagonal:__tostring() return "ability_diagonal" end

-------------------------------------------------------------------------------
function AbilityDiagonal.new(group)
  local self = setmetatable({}, Cell)
  self.img = display.newImageRect(group, "src/battle/ability_diagonal.png", Config.cell_size.x, Config.cell_size.y)
  self.img.anchorX = 0
  self.img.anchorY = 0
  return self
end


return AbilityDiagonal