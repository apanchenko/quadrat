local ass = require 'src.core.ass'

local Cell = {}

-- flags
local empty    = 0
local grave    = 1
local low      = 4
local normal   = 8
local high     = 16
local jade     = 32

-- create empty cell
function Cell.create()
  return empty
end

-- is valid
-- todo
function Cell.is_valid(cell)
  if type(cell) ~= 'number' then
    return false
  end
  return true
end

return Cell