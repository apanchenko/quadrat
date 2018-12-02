local Class      = require 'src.core.Class'
local Vec       = require 'src.core.Vec'
local Ass       = require 'src.core.Ass'
local log       = require 'src.core.log'
local Config    = require 'src.model.Config'
local Piece     = require 'src.model.Piece'
local Color     = require 'src.model.Color'

local Spot = Class.Create('Spot')

-- flags
local pit      = 1
local low      = 4
local high     = 16
local peak     = 17

-- create empty cell
function Spot.new(x, y, space)
  Ass.Number(x)
  Ass.Number(y)
  Ass.Is(space, 'Space')
  local self = setmetatable({}, Spot)
  self.space = space -- duplicate
  self.pos = Vec(x, y) -- duplicate
  self.jade = false -- store
  return self
end

--
function Spot:__tostring()
  return 'spot'.. tostring(self.pos)
end

-- create a new piece on this spot
function Spot:spawn_piece(color)
  Ass.Nil(self.piece)
  self.piece = Piece.New(self.space, color)
  self.piece:set_pos(self.pos)
  self.space.on_change:call('spawn_piece', color, self.pos) -- notify
end

-- move piece from another spot to this
function Spot:move_piece(from)
  Ass.Is(from, Spot, 'from')
  -- kill target piece
  if self.piece then
    self.piece.die()
    self.space:notify('remove_piece', self.pos) -- notify
  end
  -- change piece position
  self.piece = from.piece
  self.piece:set_pos(self.pos)
  from.piece = nil
  self.space.on_change:call('move_piece', self.pos, from.pos) -- notify
  -- consume jade
  if self.jade then
    self.jade = false 
    self.space.on_change:call('remove_jade', self.pos) -- notify
    self.piece:add_ability()
  end
end

-- take chance to spawn a new jade if can
function Spot:spawn_jade()
  Ass.Is(self, Spot)
  if self.jade then -- already used by jade
    return
  end
  if self.piece then
    return
  end
  if math.random() > Config.jade.probability then
    return
  end
  self.jade = true
  self.space.on_change:call('spawn_jade', self.pos) -- notify that a new jade set
end


-- MODULE ---------------------------------------------------------------------
Ass.Wrap(Spot, 'spawn_piece', Color)
Ass.Wrap(Spot, 'move_piece', Spot)
Ass.Wrap(Spot, 'spawn_jade')

log:wrap(Spot, 'spawn_piece', 'move_piece')

return Spot