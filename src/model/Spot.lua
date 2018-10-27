local Vec       = require 'src.core.Vec'
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local Config    = require 'src.model.Config'
local Piece     = require 'src.model.Piece'

local Spot = {}
Spot.typename = 'Spot'
Spot.__index = Spot

-- flags
local pit      = 1
local low      = 4
local high     = 16
local peak     = 17

-- create empty cell
function Spot.new(x, y, space)
  ass.number(x)
  ass.number(y)
  ass.is(space, 'Space')
  local self = setmetatable({}, Spot)
  self.space = space -- duplicate
  self.pos = Vec(x, y) -- duplicate
  self.jade = false -- store
  return self
end

--
function Spot:__tostring()
  return 'spot['.. tostring(self.pos).. ']'
end

-- create a new piece on this spot
function Spot:spawn_piece(color)
  local depth = log:trace(self, ':spawn_piece'):enter()
    ass.is(self, Spot)
    ass.nul(self.piece)
    self.piece = Piece.new(color, self.pos)
    self.space.on_change:call('spawn_piece', self.piece) -- notify
  log:exit(depth)
end

-- move piece from another spot to this
function Spot:move_piece(from)
  local depth = log:trace(self, ':move_piece'):enter()
    ass.is(from, Spot, 'from')
    self.jade = false -- consume jade
    if self.piece then
      self.piece.die() -- kill piece
    end
    self.piece = from.piece
    self.piece.pos = self.pos
    from.piece = nil
    self.space.on_change:call('move_piece', self, from) -- notify
  log:exit(depth)
end

--
function Spot:has_jade()
  ass.is(self, Spot)
  return self.jade
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
  local depth = log:trace(self, ':spawn_jade'):enter()
  self.jade = true
  self.space.on_change:call('spawn_jade', self.pos) -- notify that a new jade set
  log:exit(depth)
end

return Spot