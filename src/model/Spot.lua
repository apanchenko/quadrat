local obj       = require 'src.core.obj'
local Vec       = require 'src.core.vec'
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local typ       = require 'src.core.typ'
local Config    = require 'src.model.Config'
local Piece     = require 'src.model.Piece'

local Spot = obj:extend('Spot')

-- flags
local pit      = 1
local low      = 4
local high     = 16
local peak     = 17

-- create empty cell
function Spot:new(x, y, space)
  return obj.new(self,
  {
    space = space, -- duplicate
    pos = Vec(x, y), -- duplicate
    jade = false, -- store
  })
end

--
function Spot:__tostring()
  return 'spot'.. tostring(self.pos)
end

-- create a new piece on this spot
function Spot:spawn_piece(color)
  ass.nul(self.piece)
  self.piece = Piece:new(self.space, color)
  self.piece:set_pos(self.pos)
  self.space:notify('spawn_piece', color, self.pos) -- notify
end

-- move piece from another spot to this
function Spot:move_piece(from)
  ass.is(from, Spot, 'from')
  -- kill target piece
  if self.piece then
    self.piece.die()
    self.space:notify('remove_piece', self.pos) -- notify
  end
  -- change piece position
  from.piece:move_before(from, self)
  self.piece = from.piece
  self.piece:move(from, self)
  from.piece = nil
  self.piece:move_after(from, self)
  -- consume jade
  if self.jade then
    self.jade = false 
    self.space:notify('remove_jade', self.pos) -- notify
    self.piece:add_ability()
  end
end

-- take chance to spawn a new jade if can
function Spot:spawn_jade()
  ass.is(self, Spot)
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
  self.space:notify('spawn_jade', self.pos) -- notify that a new jade set
end

-- take chance to spawn a new jade if can
function Spot:set_jade()
  self.jade = true
  self.space.on_change:call('spawn_jade', self.pos) -- notify that a new jade set
end

-- take chance to spawn a new jade if can
function Spot:remove_jade()
  ass.is(self, Spot)
  if self.jade then -- already used by jade
    self.jade = false
    self.space.on_change:call('remove_jade', self.pos) -- notify that a new jade set
    end
end

-- MODULE ---------------------------------------------------------------------
ass.wrap(Spot, ':new', typ.num, typ.num, 'Space')
ass.wrap(Spot, ':spawn_piece', 'playerid')
ass.wrap(Spot, ':move_piece', Spot)
ass.wrap(Spot, ':spawn_jade')

log:wrap(Spot, 'spawn_piece', 'move_piece')

return Spot