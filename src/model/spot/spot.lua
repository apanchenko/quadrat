local obj       = require 'src.lua-cor.obj'
local arr       = require 'src.lua-cor.arr'
local vec       = require 'src.lua-cor.vec'
local map       = require 'src.lua-cor.map'
local ass       = require 'src.lua-cor.ass'
local log       = require 'src.lua-cor.log'
local typ       = require 'src.lua-cor.typ'
local wrp       = require 'src.lua-cor.wrp'
local cfg       = require 'src.model.cfg'
local cnt       = require 'src.lua-cor.cnt'
local piece     = require 'src.model.piece'
local jade      = require 'src.model.jade'
local component = require 'src.model.spot.component.component'

local spot = obj:extend('spot')

-- interface
function spot:wrap()
  local x     = {'x', typ.num}
  local y     = {'y', typ.num}
  local space = {'space'}
  local pid   = {'playerid'}
  local piece = {'piece'}
  local from  = {'from', spot}
  local comp  = {'comp', component}
  local stash = {'stash', typ.tab}

  -- spot
  wrp.wrap_tbl_trc(spot, 'new',           x,   y,  space)

  -- piece
  wrp.wrap_sub_inf(spot, 'can_set_piece')
  wrp.wrap_sub_trc(spot, 'spawn_piece',   pid) -- create a new piece
  wrp.wrap_sub_trc(spot, 'move_piece',    from)
  wrp.wrap_sub_trc(spot, 'stash_piece',   stash) -- put piece into special hidden place for a short time
  wrp.wrap_sub_trc(spot, 'unstash_piece', stash) -- get piece from a stash

  -- jades
  wrp.wrap_sub_inf(spot, 'spawn_jade')
  wrp.wrap_sub_inf(spot, 'set_jade')
  wrp.wrap_sub_inf(spot, 'remove_jade')

  -- component
  wrp.wrap_sub_inf(spot, 'add_comp',      comp)
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
function spot:remove_jade_wrap_before()
  ass(self.jade)
end
function spot:remove_jade()
  local jade = self.jade
  self.jade = nil
  self.space:yell('remove_jade', self.pos) -- notify that a new jade set
  return jade
end
function spot:remove_jade_wrap_after(jade)
  ass.nul(self.jade)
  ass(typ.isname(jade, 'jade'))
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