local Piece     = require 'src.model.Piece'
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local Vec       = require 'src.core.Vec'

local ChangesLog = {}
ChangesLog.typename = 'ChangesLog'
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
function ChangesLog:on_move()
  log:trace(self, ':on_move')
end

--
function ChangesLog:spawn_jade(pos)
  ass.is(pos, Vec)
  log:trace(self, ':spawn_jade ', pos)
end

--
function ChangesLog:spawn_piece(piece)
  ass.is(piece, Piece, 'piece')
  log:trace(self, ':spawn_piece ', piece)
end

--
function ChangesLog:move_piece(to, from)
  ass.is(to, 'Spot')
  ass.is(from, 'Spot')
  log:trace(self, ':move_piece ', from, ' -> ', to)
end


return ChangesLog