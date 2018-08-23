local Pos = require "src.core.Pos"
local lib = require "src.core.lib"
local cfg = require "src.Config"

PowerMoveDiagonal = {}
PowerMoveDiagonal.__index = PowerMoveDiagonal
setmetatable(PowerMoveDiagonal, {__call = function(cls, ...) return cls.new(...) end})
function PowerMoveDiagonal:__tostring() return "power_diagonal" end

-------------------------------------------------------------------------------
function PowerMoveDiagonal.new(group)
  local self = setmetatable({}, PowerMoveDiagonal)
  self.img = lib.image(group, cfg.cell, "src/battle/power_diagonal.png")
  return self
end


-------------------------------------------------------------------------------
-- POSITION--------------------------------------------------------------------
-------------------------------------------------------------------------------
function PowerMoveDiagonal:can_move(vec)
  print("PowerMoveDiagonal:can_move vec "..tostring(vec))
  return (vec.x==1 or vec.x==-1) and (vec.y==1 or vec.y==-1)
end


return PowerMoveDiagonal