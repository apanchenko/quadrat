local Pos = require "src.core.Pos"
local lib = require "src.core.lib"
local cfg = require "src.Config"

PowerDiagonal = {}
PowerDiagonal.__index = PowerDiagonal
setmetatable(PowerDiagonal, {__call = function(cls, ...) return cls.new(...) end})
function PowerDiagonal:__tostring() return "power_diagonal" end

-------------------------------------------------------------------------------
function PowerDiagonal.new(group)
  local self = setmetatable({}, PowerDiagonal)
  self.img = lib.image(group, "src/battle/power_diagonal.png", {w=cfg.cell.size.x})
  return self
end


return PowerDiagonal