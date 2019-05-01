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
function spot:wrap()
  local opts  = {log = log.info}
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
    comps = cnt:new() -- container for powers
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

-- Add stash/unstash methods for 'name'
local function support_stash(name)
  -- put 'name' into special hidden place for a short time
  -- caller is responsible for stash
  -- stash is a FILO stack
  spot['stash_'..name..'_before'] = function(self)
    ass(self[name])
  end

  spot['stash_'..name] = function(self, stash)
    local obj = self[name]
    self[name] = nil
    obj:set_pos(nil)
    arr.push(stash, obj)
    self.space:yell('stash_'..name, self.pos) -- notify
  end

  spot['stash_'..name..'_after'] = function(self)
    ass.nul(self[name])
  end

  -- get 'name' from stash
  spot['unstash_'..name..'_before'] = function(self)
    ass.nul(self[name])
    ass(self['can_set_'..name](self))
  end

  spot['unstash_'..name] = function(self, stash)
    self[name] = arr.pop(stash)
    self[name]:set_pos(self.pos)
    self.space:yell('unstash_'..name, self.pos) -- notify
  end

  spot['unstash_'..name..'_after'] = function(self)
    ass(self[name])
  end
end

-- PIECE ----------------------------------------------------------------------

-- return true if cell is able to receive (spawn or move) piece
function spot:can_set_piece()
  return self.comps:all(function(comp) return comp:can_set_piece() end)
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
    self.piece:die()
    self.space:yell('remove_piece', self.pos) -- notify
  end
  -- change piece position
  from.piece:move_before(from, self)
  self.piece = from.piece
  self.piece:move(from, self)
  from.piece = nil
  self.piece:move_after(from, self)
  -- consume jade
  if self.jade then
    self.piece:add_jade(self.jade)
    self.jade = nil 
    self.space:yell('remove_jade', self.pos) -- notify
  end
end

-- add stash_piece/unstash_piece functions
support_stash('piece')

-- JADE -----------------------------------------------------------------------

-- return true if cell is able to receive a jade
function spot:can_set_jade()
  return self.piece == nil
     and self.jade == nil
     and self.comps:all(function(comp) return comp:can_set_jade() end)
end

-- take chance to spawn a new jade if can
function spot:spawn_jade()
  if not self:can_set_jade() then
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

-- Remove and return jade
function spot:remove_jade_before()
  ass(self.jade)
end
function spot:remove_jade()
  local jade = self.jade
  self.jade = nil
  self.space:yell('remove_jade', self.pos) -- notify that a new jade set
  return jade
end
function spot:remove_jade_after(jade)
  ass.nul(self.jade)
  ass(jade)
end

-- add stash_jade/unstash_jade functions
support_stash('jade')

-- COMPONENTS -----------------------------------------------------------------
--
function spot:add_comp(comp)
  local count = self.comps:push(comp)
  self.space:yell('add_spot_comp', self.pos, comp.id, count) -- notify
end

-- MODULE ---------------------------------------------------------------------
return spot