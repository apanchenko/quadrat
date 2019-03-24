local obj       = require 'src.core.obj'
local arr       = require 'src.core.arr'
local vec       = require 'src.core.vec'
local map       = require 'src.core.map'
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local typ       = require 'src.core.typ'
local wrp       = require 'src.core.wrp'
local cfg       = require 'src.model.cfg'
local cnt       = require 'src.core.cnt'
local piece     = require 'src.model.piece'
local jade      = require 'src.model.jade'

local spot = obj:extend('spot')

-- interface
function piece.wrap()
  local otps  = {log = log.info}
  local x     = {'x', typ.num}
  local y     = {'y', typ.num}
  local space = {'space'}
  local pid   = {'playerid'}
  local piece = {'piece'}
  local from  = {'from', spot}
  local comp  = {'comp'}
  local stash = {'stash', typ.tab}

  -- spot
  wrp.fn(spot, 'new',           { x,   y,  space  })

  -- piece
  wrp.fn(spot, 'can_set_piece', {                 }, opts)
  wrp.fn(spot, 'spawn_piece',   { pid             }) -- create a new piece
  wrp.fn(spot, 'move_piece',    { from            })
  wrp.fn(spot, 'stash_piece',   { stash           }) -- put piece into special hidden place for a short time
  wrp.fn(spot, 'unstash_piece', { stash           }) -- get piece from a stash

  -- jades
  wrp.fn(spot, 'spawn_jade',    {                 }, opts)
  wrp.fn(spot, 'set_jade',      {                 }, opts)
  wrp.fn(spot, 'remove_jade',   {                 }, opts)

  -- component
  wrp.fn(spot, 'add_comp',      { comp            }, opts)
end



-- create empty cell
function spot:new(x, y, space)
  return obj.new(self,
  {
    space = space, -- duplicate
    pos = vec(x, y), -- duplicate
    jade = nil, -- store
    comps = {} -- container for powers
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

-- return true if cell is able to receive (spawn or move) piece
function spot:can_set_piece()
  return map.all(self.comps, function(comp) return comp:can_set_piece() end)
end

-- create a new piece on this spot
function spot:spawn_piece(color)
  ass.nul(self.piece)
  self.piece = piece:new(self.space, color)
  self.piece:set_pos(self.pos)
  self.space:yell('spawn_piece', color, self.pos) -- notify
end

-- move piece from another spot to this
function spot:move_piece(from)
  -- kill target piece
  if self.piece then
    self.piece.die()
    self.space:yell('remove_piece', self.pos) -- notify
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
    self.space:yell('remove_jade', self.pos) -- notify
    self.piece:add_jade(jade)
  end
end

-- put piece into special hidden place for a short time
-- caller is responsible for stash
-- stash is a FILO stack
function spot:stash_piece_before()
  ass(self.piece)
end
function spot:stash_piece(stash)
  local piece = self.piece
  self.piece = nil
  piece:set_pos(nil)
  arr.push(stash, piece)
  self.space:yell('stash_piece', self.pos) -- notify
end
function spot:stash_piece_after()
  ass(self.piece == nil)
end

-- get piece from stash
-- caller is responsible for stash
-- stash is a FILO stack
function spot:unstash_piece_before()
  ass.nul(self.piece)
  ass(self:can_set_piece())
  ass.nul(self.jade)
end
function spot:unstash_piece(stash)
  self.piece = arr.pop(stash)
  self.piece:set_pos(self.pos)
  self.space:yell('unstash_piece', self.pos) -- notify
end
function spot:unstash_piece_after()
  ass(self.piece)
end


-- JADE -----------------------------------------------------------------------

-- take chance to spawn a new jade if can
function spot:spawn_jade()
  ass.is(self, spot)
  -- already used by jade
  if self.jade then
    return
  end
  -- already used by piece
  if self.piece then
    return
  end
  -- something prevents
  if not map.all(self.comps, function(comp) return comp:can_set_jade() end) then
    return
  end
  if math.random() > cfg.jade.probability then
    return
  end
  self.jade = jade:new()
  self.space:yell('spawn_jade', self.pos) -- notify that a new jade set
end

-- take chance to spawn a new jade if can
function spot:set_jade()
  self.jade = jade:new()
  self.space:yell('spawn_jade', self.pos) -- notify that a new jade set
end

-- take chance to spawn a new jade if can
function spot:remove_jade()
  ass.is(self, spot)
  if self.jade then -- already used by jade
    self.jade = nil
    self.space.on_change:call('remove_jade', self.pos) -- notify that a new jade set
    end
end

-- COMPONENTS -----------------------------------------------------------------
--
function spot:add_comp(comp)
  local count = cnt.push(self.comps, comp)
  self.space:yell('add_spot_comp', self.pos, comp.id, count) -- notify
end

-- MODULE ---------------------------------------------------------------------
return spot