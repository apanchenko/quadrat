local Vec   = require 'src.core.vec'
local lay   = require 'src.core.lay'
local ass   = require 'src.core.ass'
local cfg   = require 'src.Config'
local Class  = require 'src.core.Class'

-------------------------------------------------------------------------------
local MoveDiagonal = Class.Create('MoveDiagonal',
{
  is_areal = false,
  Stackable = false
})
--
function MoveDiagonal.New(Zone)
  ass.nul(Zone)
  return setmetatable({}, MoveDiagonal)
end
--
function MoveDiagonal:__tostring()
  return "move diagonal"
end

-------------------------------------------------------------------------------
function MoveDiagonal:apply(piece)
  self._piece = piece
  return self
end
--
function MoveDiagonal:increase()
  -- do nothing here
end
--
function MoveDiagonal:decrease()
  return self
end

-- MOVE------------------------------------------------------------------------
function MoveDiagonal:can_move(from, to)
  ass.is(from, Vec)
  ass.is(to, Vec)

  local diff = from - to
  return (diff.x==1 or diff.x==-1) and (diff.y==1 or diff.y==-1)
end
--
function MoveDiagonal:move_before(cell_from, cell_to)
end
--
function MoveDiagonal:move(vec)
end
--
function MoveDiagonal:move_after(piece, board, cell_from, cell_to)
end


return MoveDiagonal