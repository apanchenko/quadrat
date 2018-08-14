local Pos = require("src.core.Pos")
local cfg = require("src.Config")
local lib = require("src.lib")

AbilityDiagonal =
{
}
AbilityDiagonal.__index = AbilityDiagonal
setmetatable(AbilityDiagonal, {__call = function(cls, ...) return cls.new(...) end})
function AbilityDiagonal:__tostring() return "ability_diagonal" end

-------------------------------------------------------------------------------
function AbilityDiagonal.new(group)
  local self = setmetatable({}, AbilityDiagonal)
  self.img = lib.image(group, "src/battle/ability_diagonal.png", {w=cfg.cell_size.x})
  return self
end


return AbilityDiagonal