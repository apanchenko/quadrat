local obj       = require 'src.core.obj'
local Vec       = require 'src.core.vec'
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local typ       = require 'src.core.typ'
local wrp       = require 'src.core.wrp'
local cfg       = require 'src.model.cfg'
local piece     = require 'src.model.piece'
local jade      = require 'src.model.jade'

local spot = obj:extend('spot')

-- flags
local pit      = 1
local low      = 4
local high     = 16
local peak     = 17

-- create empty cell
function spot:new(x, y, space)
  return obj.new(self,
  {
    space = space, -- duplicate
    pos = Vec(x, y), -- duplicate
    jade = nil, -- store
  })
end

--
function spot:__tostring()
  local res = 'spot{'.. self.pos.x.. ",".. self.pos.y
  if self.jade then
    res = res .. ',jade'
  end
  return res.. '}'
end


-- PIECE ----------------------------------------------------------------------

-- create a new piece on this spot
function spot:spawn_piece(color)
  ass.nul(self.piece)
  self.piece = piece:new(self.space, color)
  self.piece:set_pos(self.pos)
  self.space:notify('spawn_piece', color, self.pos) -- notify
end

-- move piece from another spot to this
function spot:move_piece(from)
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
  local jade = self.jade
  if jade then
    self.jade = nil 
    self.space:notify('remove_jade', self.pos) -- notify
    self.piece:add_jade(jade)
  end
end


-- JADE -----------------------------------------------------------------------

-- take chance to spawn a new jade if can
function spot:spawn_jade()
  ass.is(self, spot)
  if self.jade then -- already used by jade
    return
  end
  if self.piece then
    return
  end
  if math.random() > cfg.jade.probability then
    return
  end
  self.jade = jade:new()
  self.space:notify('spawn_jade', self.pos) -- notify that a new jade set
end

-- take chance to spawn a new jade if can
function spot:set_jade()
  self.jade = jade:new()
  self.space:notify('spawn_jade', self.pos) -- notify that a new jade set
end

-- take chance to spawn a new jade if can
function spot:remove_jade()
  ass.is(self, spot)
  if self.jade then -- already used by jade
    self.jade = nil
    self.space.on_change:call('remove_jade', self.pos) -- notify that a new jade set
    end
end

-- MODULE ---------------------------------------------------------------------
wrp.fn(spot, 'new', {{'x', typ.num}, {'y', typ.num}, {'space'}})
wrp.fn(spot, 'spawn_piece', {{'playerid'}})
wrp.fn(spot, 'move_piece', {{'from', spot}})
wrp.fn(spot, 'spawn_jade', {}, {log = log.info})

return spot