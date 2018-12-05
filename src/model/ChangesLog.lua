local Piece     = require 'src.model.Piece'
local Color     = require 'src.model.Color'
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local Vec       = require 'src.core.vec'

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
  ass.is(color, Color)
  log:trace(self, ':move ', color)
end

--
function ChangesLog:spawn_jade(pos)
  ass.is(pos, Vec)
  log:trace(self, ':spawn_jade ', pos)
end

--
function ChangesLog:spawn_piece(color, pos)
  ass.is(pos, Vec, 'pos')
  log:trace(self, ':spawn_piece ', color, ' ', pos)
end

--
function ChangesLog:move_piece(to, from)
  ass.is(to, Vec)
  ass.is(from, Vec)
  log:trace(self, ':move_piece ', from, ' -> ', to)
end


return ChangesLog