local vec         = require('src.lua-cor.vec')
local lay         = require('src.lua-cor.lay')
local ass         = require('src.lua-cor.ass')
local log         = require('src.lua-cor.log').get('view')
local map         = require('src.lua-cor.map')
local obj         = require('src.lua-cor.obj')
local com         = require('src.lua-cor.com')
local cfg         = require('src.cfg')
local powers      = require('src.view.power.powers')
local layout      = require('src.view.stone.layout')
local _           = require('src.view.stone.private')

local stone = obj:extend('stone')

--INIT-------------------------------------------------------------------------
function stone:new(asset)
  self = obj.new(self, com())
  self[_.view] = self.com_add(layout.new_group())
  self.scale = 1
  self.powers = {}
  self.isSelected = false
  self.is_drag = false

  self[_.view].show('stone')
  self[_.abilities] = {}
  self[_.asset] = asset
  self[_.asset]:get_space():listen_set_move(self, true)

  _.update_pid(self, asset:get_pid())
  return self
end

function stone:view()
  return self[_.view]
end

-- remove stone from board
function stone:putoff()
  ass(self.board)
  map.invoke_self(self.powers, 'destroy')
  self[_.asset]:get_space():listen_set_move(self, false)
  self[_.asset] = nil
  self[_.view]:removeSelf()
  self[_.view] = nil
  self[_.abilities] = nil
  self.powers = nil
  self.board = nil
  self.com_destroy()
end

-- public 
function stone:get_pid()
  return self[_.asset]:get_pid()
end

--
function stone:__tostring()
  local s = "stone["
  if self._pos then
    s = s.. self._pos.x.. ','.. self._pos.y.. ','
  end
  s = s.. tostring(self:get_pid())
  if self.powers then
    for k in pairs(self.powers) do
      s = s.. " ".. k
    end
  end
  return s.. "]"
end

-- event from board
function stone:set_controller(controller)
  self[_.asset]:set_controller(controller)
  _.update_pid(self, controller:get_pid())
  self:deselect()
end

--
function stone:get_piece()
  return self[_.asset]
end

-- insert stone into group, with scale for dragging
function stone:puton(board, battle_view)
  ass.isname(board, 'board')
  lay.insert(board.view, self[_.view], {vx=0, vy=0, z=50})
  self.board = board
  self[_.battle_view] = battle_view
end

-- space event
function stone:set_move(pid)
  self[_.move_pid] = pid
  _.active_changed(self)
end

-- POSITION -------------------------------------------------------------------
-- set stone position
function stone:set_pos(pos)
  if pos ~= nil then
    ass.is(pos, vec)
  end
  _.update_group_pos(self, pos)
end

-- ABILITY --------------------------------------------------------------------

-- set ability count 
function stone:set_ability(id, count)
  ass.ge(count, 0)

  if count == 0 then
    self[_.abilities][id] = nil
  else
    self[_.abilities][id] = count
  end

  _.update_aura(self)

  local reshow = self[_.ability_view] ~= nil
  if reshow then
    _.hide_abilities(self)
  end

  if not _.is_abilities_empty(self) then
    if reshow then
      _.show_abilities(self)
    end
  end
end

-- POWER ----------------------------------------------------------------------
function stone:add_power(id, result_count)
  local power = self.powers[id]
  if power == nil then
    self.powers[id] = powers[id]:new(self, id, result_count)
  else
    self.powers[id] = power:set_count(result_count)
  end
end

-- TOUCH-----------------------------------------------------------------------
function stone:activate_touch()
  self[_.view]:addEventListener('touch', self)
end

function stone:deactivate_touch()
  self[_.view]:removeEventListener('touch', self)
end

-- touch listener function
function stone:touch(event)
  local piece = self[_.asset]
  local space = piece:get_space()

  -- do not touch opponent stones
  if not space:is_my_move() then
    log.trace(self, 'not my move')
    return true
  end
  -- take stone
  if event.phase == "began" then
    self:touch_began(event)
    return true
  end

  if not self.is_drag then
    return true
  end

  if event.phase == "moved" then
    local proj = self:touch_moved(event)

    if piece:can_move(proj) then
      _.create_project(self, proj)
    else
      _.remove_project(self)
    end
    return true
  end

  if event.phase == "ended" or event.phase == "cancelled" then
    _.set_drag(self, nil)
    if self.proj then
      piece:move(self.proj)
      self.board:select(nil) -- deselect any
    else
      if self.isSelected then
        self.board:select(nil) -- release
      else
        self.board:select(self) -- or select
      end
    end
    _.remove_project(self)
  end

  return true
end

--
function stone:touch_began(event)
  if self.isSelected == false then
    self.board:select(nil)                -- deselect another stone
  end
  _.set_drag(self, event.id)
end

--
function stone:touch_moved(event)
  local start = vec(event.xStart, event.yStart)
  local xScale = self.board.view.xScale
  local shift = vec:from(event)
  shift = shift - start
  shift = shift / vec(xScale, xScale)
  shift = shift + (self._pos * cfg.view.cell.size)
  local proj = (shift / cfg.view.cell.size):round()
  vec.copy(shift, self[_.view])
  return proj;
end

-- to be called from board
function stone:select()
  assert(self.isSelected == false)
  self.isSelected = true                    -- set selected
  _.update_group_pos(self, self._pos)          -- adjust group position
  _.show_abilities(self)
end

-- to be called from board
function stone:deselect()
  if self.isSelected then
    local indent = log.trace(self, ":deselect")
    indent.enter()
      self.isSelected = false                   -- set not selected
      _.update_group_pos(self, self._pos)          -- adgjust group position
      _.hide_abilities(self)
    indent.exit()
  end
end

--
function stone:wrap()
  local typ         = require('src.lua-cor.typ')
  local wrp         = require('src.lua-cor.wrp')
  local asset       = require('src.model.piece.asset')
  local playerid    = require('src.model.playerid')
  local board       = require('src.view.board')

  local event = typ.tab:add_tostr(map.tostring)
  local ex    = typ.new_ex(stone)

  wrp.fn(log.trace, stone,  'new',            stone, asset)
  wrp.fn(log.trace, stone,  'select',         ex)
  wrp.fn(log.info,  stone,  'deselect',       ex)
  wrp.fn(log.trace, stone,  'puton',          ex, board, typ.tab)
  wrp.fn(log.trace, stone,  'putoff',         ex)
  wrp.fn(log.trace, stone,  'set_move',       ex, playerid)
  wrp.fn(log.trace, stone,  'set_ability',    ex, typ.str, typ.num)
  wrp.fn(log.trace, stone,  'add_power',      ex, typ.str, typ.num)
  wrp.fn(log.info,  stone,  'touch',          ex, event)
  wrp.fn(log.trace, stone,  'touch_began',    ex, event)
  wrp.fn(log.info,  stone,  'touch_moved',    ex, event)
end

return stone