local vec         = require('src.lua-cor.vec')
local lay         = require('src.lua-cor.lay')
local ass         = require('src.lua-cor.ass')
local log         = require('src.lua-cor.log').get('view')
local map         = require('src.lua-cor.map')
local obj         = require('src.lua-cor.obj')
local com         = require('src.lua-cor.com')
local powers      = require('src.view.power.powers')
local layout      = require('src.view.stone.layout')
local cfg         = require('src.cfg')

local stone = obj:extend('stone')

-- private
local _abilities = {}
local _ability_view = {}
local _view = {}
local _battle_view = {}
local _asset = {}
local _move_pid = {} -- moving side

-- private
local update_aura = function(self)
  if self:is_abilities_empty() then
    self[_view].hide('aura_white')
    self[_view].hide('aura_black')
  else
    self[_view].show('aura_'..tostring(self:get_pid()))
  end
end

-- private
local active_changed = function(self)
  local pid = self:get_pid()
  local my_active_view = 'active_'..tostring(pid)
  if pid == self[_move_pid] then
    self[_view].show(my_active_view)
  else
    self[_view].hide(my_active_view)
  end
end

-- private
local update_pid = function(self, pid)
  self[_view].show(tostring(pid))
  update_aura(self)
  active_changed(self)
end

-- private
local update_group_pos = function(self, pos)
  -- remove from board
  if pos == nil then
    self._pos = nil
    self[_view].x = 0
    self[_view].y = 0
    return
  end

  -- calculate new view position
  local view_pos = pos * cfg.view.cell.size
  if self.isSelected then
    view_pos.y = view_pos.y - 10
  end

  if self._pos then
    log.info('animate to view position', view_pos)
    lay.to(self[_view], view_pos, cfg.view.stone.move)
  else
    log.info('instant set view position', view_pos)
    view_pos:to(self[_view])
  end
  self._pos = pos
end

--INIT-------------------------------------------------------------------------
function stone:new(asset)
  self = obj.new(self, com())
  self[_view] = self.com_add(layout.new_group())
  self.scale = 1
  self.powers = {}
  self.isSelected = false
  self.is_drag = false

  self[_view].show('stone')
  self[_abilities] = {}
  self[_asset] = asset
  self[_asset]:get_space():listen_set_move(self, true)

  update_pid(self, asset:get_pid())
  return self
end

function stone:view()
  return self[_view]
end

-- remove stone from board
function stone:putoff()
  ass(self.board)
  map.invoke_self(self.powers, 'destroy')
  self[_asset]:get_space():listen_set_move(self, false)
  self[_asset] = nil
  self[_view]:removeSelf()
  self[_view] = nil
  self[_abilities] = nil
  self.powers = nil
  self.board = nil
  self.com_destroy()
end

-- public 
function stone:get_pid()
  return self[_asset]:get_pid()
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
  self[_asset]:set_controller(controller)
  update_pid(self, controller:get_pid())
  self:deselect()
end

--
function stone:get_piece()
  return self[_asset]
end

-- insert stone into group, with scale for dragging
function stone:puton(board, battle_view)
  ass.isname(board, 'board')
  lay.insert(board.view, self[_view], {vx=0, vy=0, z=50})
  self.board = board
  self[_battle_view] = battle_view
end

-- space event
function stone:set_move(pid)
  self[_move_pid] = pid
  active_changed(self)
end

-- POSITION -------------------------------------------------------------------
-- set stone position
function stone:set_pos(pos)
  if pos ~= nil then
    ass.is(pos, vec)
  end
  update_group_pos(self, pos)
end

--
function stone:pos()
  return self._pos
end

-- ABILITY --------------------------------------------------------------------

-- show on board
function stone:show_abilities()
  ass.nul(self[_ability_view])                 -- check is hidden now
  self[_ability_view] = display.newGroup()

  for name, count in pairs(self[_abilities]) do     -- create new button
    local opts = cfg.view.abilities.button
    opts.id = name
    opts.label = name
    if count > 1 then
      opts.label = opts.label.. ' '.. count
    end
    opts.onRelease = function(event)
      self[_asset]:use_jade(event.target.id)
      return true
    end
    --log.trace(opts.label)
    lay.new_button(self[_ability_view], opts)
  end
  lay.rows(self[_ability_view], cfg.view.abilities.rows)
  lay.insert(self[_battle_view], self[_ability_view], cfg.view.abilities)
end

-- hide from board when piece deselected
function stone:hide_abilities()
  if self[_ability_view] then -- check shown
    self[_ability_view]:removeSelf()
    self[_ability_view] = nil
  end
end

-- set ability count 
function stone:set_ability(id, count)
  ass.ge(count, 0)

  if count == 0 then
    self[_abilities][id] = nil
  else
    self[_abilities][id] = count
  end

  update_aura(self)

  local reshow = self[_ability_view] ~= nil
  if reshow then
    self:hide_abilities()
  end

  if not self:is_abilities_empty() then
    if reshow then
      self:show_abilities()
    end
  end
end
function stone:set_ability_wrap_after(id, count)
end

-- return true if empty
function stone:is_abilities_empty()
  return map.count(self[_abilities]) == 0
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
  self[_view]:addEventListener('touch', self)
end

function stone:deactivate_touch()
  self[_view]:removeEventListener('touch', self)
end

-- touch listener function
function stone:touch(event)
  local piece = self[_asset]
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
      self:create_project(proj)
    else
      self:remove_project()
    end
    return true
  end

  if event.phase == "ended" or event.phase == "cancelled" then
    self:set_drag(nil)
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
    self:remove_project()
  end

  return true
end

--
function stone:touch_began(event)
  if self.isSelected == false then
    self.board:select(nil)                -- deselect another stone
  end
  self:set_drag(event.id)
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
  vec.copy(shift, self[_view])
  return proj;
end

-- to be called from board
function stone:select()
  assert(self.isSelected == false)
  self.isSelected = true                    -- set selected
  update_group_pos(self, self._pos)          -- adjust group position
  self:show_abilities()
end

-- to be called from board
function stone:deselect()
  if self.isSelected then
    local indent = log.trace(self, ":deselect")
    indent.enter()
      self.isSelected = false                   -- set not selected
      update_group_pos(self, self._pos)          -- adgjust group position
      self:hide_abilities()
    indent.exit()
  end
end

--
function stone:create_project(proj)
  if not self.project then
    cfg.view.cell.path = "images/board/project_"..tostring(self:get_pid())..".png"
    self.project = lay.new_image(self.board.view, cfg.view.cell)
  end
  self.proj = proj
  vec.copy(proj * cfg.view.cell.size, self.project)
end

--
function stone:remove_project()
  if self.project then
    self.project:removeSelf()
    self.project = nil
  end
  self.proj = nil
end

--
function stone:set_drag(eventId)
  display.getCurrentStage():setFocus(self[_view], eventId)
  self.is_drag = (eventId ~= nil)
  if self.is_drag then
    --lay.render(self.board, self, {x=self.view.x, y=self.view.y})
    self[_view]:toFront()
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
  wrp.fn(log.trace, stone,  'pos',            ex)
  wrp.fn(log.trace, stone,  'set_ability',    ex, typ.str, typ.num)
  wrp.fn(log.trace, stone,  'add_power',      ex, typ.str, typ.num)
  wrp.fn(log.info,  stone,  'touch',          ex, event)
  wrp.fn(log.trace, stone,  'touch_began',    ex, event)
  wrp.fn(log.info,  stone,  'touch_moved',    ex, event)
  wrp.fn(log.info,  stone,  'is_abilities_empty', ex)
end

return stone