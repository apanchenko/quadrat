local Piece     = require 'src.model.Piece'
local Color     = require 'src.model.Color'
local Ass       = require 'src.core.Ass'
local log       = require 'src.core.log'
local Vec       = require 'src.core.Vec'

local ChangesLog = { typename = 'ChangesLog' }
ChangesLog.__index = ChangesLog

--
function ChangesLog.new()
  local self = setmetatable({}, ChangesLog)
  return self
end

--
function ChangesLog:__tostring()
  return 'changes_log'
end

--
function ChangesLog:move(color)
  Ass.Is(color, Color)
  log:trace(self, ':move ', color)
end

--
function ChangesLog:spawn_jade(pos)
  Ass.Is(pos, Vec)
  log:trace(self, ':spawn_jade ', pos)
end

--
function ChangesLog:spawn_piece(color, pos)
  Ass.Is(pos, Vec, 'pos')
  log:trace(self, ':spawn_piece ', color, ' ', pos)
end

--
function ChangesLog:move_piece(to, from)
  Ass.Is(to, Vec)
  Ass.Is(from, Vec)
  log:trace(self, ':move_piece ', from, ' -> ', to)
end


return ChangesLog