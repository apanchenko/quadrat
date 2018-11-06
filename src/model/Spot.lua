local Vec       = require 'src.core.Vec'
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local Config    = require 'src.model.Config'
local Piece     = require 'src.model.Piece'

local Spot = setmetatable({}, { __tostring = function() return 'Spot' end })
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
  self._space = space -- duplicate
  self._pos = Vec(x, y) -- duplicate
  self._jade = false -- store
  return self
end

-- getters
function Spot:pos() return self._pos end
function Spot:piece() return self._piece end

--
function Spot:__tostring()
  return 'spot'.. tostring(self._pos)
end

-- create a new piece on this spot
function Spot:spawn_piece(color)
  ass.is(self, Spot)
  ass.nul(self._piece)
  self._piece = Piece.new(self._space, color, self._pos)
  self._space.on_change:call('spawn_piece', color, self._pos) -- notify
end

-- move piece from another spot to this
function Spot:move_piece(from)
  ass.is(from, Spot, 'from')
  -- kill piece
  if self._piece then
    self._piece.die()
    self._space.on_change:call('remove_piece', self._pos) -- notify
  end

  -- change piece position
  self._piece = from._piece
  self._piece:set_pos(self._pos)
  from._piece = nil

  -- consume jade
  if self._jade then
    self._jade = false 
    self._space.on_change:call('remove_jade', self._pos) -- notify
    self._piece:add_ability()
  end
  self._space.on_change:call('move_piece', self._pos, from._pos) -- notify
end

-- take chance to spawn a new jade if can
function Spot:spawn_jade()
  ass.is(self, Spot)
  if self._jade then -- already used by jade
    return
  end
  if self._piece then
    return
  end
  if math.random() > Config.jade.probability then
    return
  end
  self._jade = true
  self._space.on_change:call('spawn_jade', self._pos) -- notify that a new jade set
end


log:wrap(Spot, 'spawn_piece', 'move_piece')

return Spot