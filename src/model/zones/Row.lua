local Ass       = require 'src.core.Ass'
local Type      = require 'src.core.Type'
local log       = require 'src.core.log'

local Row = Type.Create('Row')

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
Ass.Wrap(Row, 'filter', 'Vec')

log:wrap(Row, 'filter')

return Row