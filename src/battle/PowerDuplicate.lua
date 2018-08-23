local Pos = require "src.core.Pos"
local lib = require "src.core.lib"
local cfg = require "src.Config"

PowerDuplicate = {}
PowerDuplicate.__index = PowerMoveDiagonal
setmetatable(PowerDuplicate, {__call = function(cls, ...) return cls.new(...) end})
function PowerDuplicate:__tostring() return "power_diagonal" end

-------------------------------------------------------------------------------
function PowerDuplicate.new(group)
  local self = setmetatable({}, PowerMoveDiagonal)
  self.img = lib.image(group, cfg.cell, "src/battle/power_diagonal.png")
  return self
end


-------------------------------------------------------------------------------
-- POSITION--------------------------------------------------------------------
-------------------------------------------------------------------------------
function PowerDuplicate:can_move(vec)
  print("PowerMoveDiagonal:can_move vec "..tostring(vec))
  return (vec.x==1 or vec.x==-1) and (vec.y==1 or vec.y==-1)
end


return PowerDuplicate