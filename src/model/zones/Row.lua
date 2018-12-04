local Ass       = require 'src.core.Ass'
local Class     = require 'src.core.Class'
local log       = require 'src.core.log'
local vec       = require 'src.core.vec'

local Row = Class.Create('Row')

--
function Row.New(pos)
  local self = setmetatable({}, Row)
  self.pos = pos
  return self
end

--
function Row:filter(pos)
  return pos.y == self.pos.y
end

-- selftest
function Row.Test()
  print('test Row..')

  assert(tostring(Row) == 'Row')
end

-- MODULE ---------------------------------------------------------------------
Ass.Wrap(Row, '.filter', vec)

log:wrap(Row)

return Row