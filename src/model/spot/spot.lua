local obj       = require('src.lua-cor.obj')
local vec       = require('src.lua-cor.vec')
local ass       = require 'src.lua-cor.ass'
local log       = require('src.lua-cor.log').get('mode')
local cnt       = require 'src.lua-cor.cnt'
local typ       = require('src.lua-cor.typ')
local piece     = require 'src.model.piece.piece'
local jade      = require 'src.model.jade'
local component = require 'src.model.spot.component.component'

local spot = obj:extend('spot')

-- interface
function spot:wrap()
  local wrp       = require('src.lua-cor.wrp')
  local playerid  = require('src.model.playerid')
  local space     = require('src.model.space.space')
  local ex   = typ.new_ex(spot)

  -- spot
  wrp.fn(log.trace, spot, 'new',           spot, typ.num, typ.num, space)

  -- piece
  wrp.fn(log.info, spot, 'can_set_piece', ex)
  wrp.fn(log.trace, spot, 'spawn_piece', ex,   playerid) -- create a new piece
  wrp.fn(log.trace, spot, 'move_piece', ex,    spot)
  wrp.fn(log.trace, spot, 'stash_piece', ex,   typ.tab) -- put piece into special hidden place for a short time
  wrp.fn(log.trace, spot, 'unstash_piece', ex, typ.tab) -- get piece from a stash

  -- jades
  wrp.fn(log.info, spot, 'spawn_jade', ex)
  wrp.fn(log.info, spot, 'set_jade', ex)
  wrp.fn(log.info, spot, 'remove_jade', ex)

  -- component
  wrp.fn(log.info, spot, 'add_comp', ex,      component)
end



-- create empty cell
function spot:new(x, y, space_model)
  return obj.new(self,
  {
    space = space_model, -- duplicate
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
  spot['stash_'..name..'_wrap_before'] = function(self)
    ass(self[name])
  end

  spot['stash_'..name] = function(self, stash)
    local obj = self[name]
    self[name] = nil
    obj:set_pos(nil)
    stash:push(obj)
    self.space['stash_'..name](self.pos)
  end

  spot['stash_'..name..'_wrap_after'] = function(self)
    ass.nul(self[name])
  end

  -- get 'name' from stash
  spot['unstash_'..name..'_wrap_before'] = function(self)
    ass.nul(self[name])
    ass(self['can_set_'..name](self))
  end

  spot['unstash_'..name] = function(self, stash)
    self[name] = stash:pop()
    self[name]:set_pos(self.pos)
    self.space['unstash_'..name](self.pos)
  end

  spot['unstash_'..name..'_wrap_after'] = function(self)
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
  self.space.spawn_piece(color, self.pos) -- notify
end

-- move piece from another spot to this
function spot:move_piece(from)
  -- kill target piece
  if self.piece then
    from.piece:on_kill(self.piece)
    self.piece:die()
    self.piece = nil
    self.space.remove_piece(self.pos) -- notify
  end
  -- change piece position
  from.piece:move_before(from, self)
  self.piece = from.piece
  from.piece = nil
  self.piece:move(from, self)
  self.piece:move_after(from, self)
  -- consume jade
  if self.jade then
    self.piece:add_jade(self.jade)
    self.jade = nil 
    self.space.remove_jade(self.pos) -- notify
  end
end

-- add stash_piece/unstash_piece functions
support_stash('piece')

-- JADE -----------------------------------------------------------------------
function spot:has_jade()
  if self.jade then
    return true
  end
  return false
end

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
  --if math.random() > cfg.jade.probability then
  --  return
  --end
  self.jade = jade:new()
  self.space.spawn_jade(self.pos) -- notify that a new jade set
end

-- take chance to spawn a new jade if can
function spot:set_jade()
  self.jade = jade:new()
  self.space.spawn_jade(self.pos) -- notify that a new jade set
end

-- Remove and return jade
function spot:remove_jade_wrap_before()
  ass(self.jade)
end
function spot:remove_jade()
  local jade = self.jade
  self.jade = nil
  self.space.remove_jade(self.pos) -- notify that a new jade set
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
  self.space.modify_spot(self.pos, comp.id, count) -- notify
end

-- MODULE ---------------------------------------------------------------------
return spot