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
  self.img = lib.image(group, cfg.cell, "src/battle/power_diagonal.png")
  return self
end


-------------------------------------------------------------------------------
-- POSITION--------------------------------------------------------------------
-------------------------------------------------------------------------------
function PowerDiagonal:can_move(vec)
  print("PowerDiagonal:can_move vec "..tostring(vec))
  return (vec.x==1 or vec.x==-1) and (vec.y==1 or vec.y==-1)
end


return PowerDiagonal