local arr         = require 'src.lua-cor.arr'
local vec         = require 'src.lua-cor.vec'
local lay         = require 'src.lua-cor.lay'
local ass         = require 'src.lua-cor.ass'
local log         = require 'src.lua-cor.log'
local map         = require 'src.lua-cor.map'
local obj         = require 'src.lua-cor.obj'
local typ         = require 'src.lua-cor.typ'
local wrp         = require 'src.lua-cor.wrp'
local Abilities   = require 'src.view.stoneAbilities'
local power_image = require 'src.view.power.image'
local cfg         = require 'src.cfg'
local powers      = require 'src.view.power.powers'

local stone = obj:extend('stone')

--INIT-------------------------------------------------------------------------
function stone:new(env, pid)
  self = obj.new(self,
  {
    env = env,
    view = display.newGroup(),
    scale = 1,
    powers = {},
    isSelected = false,
    is_drag = false
  })
  self._abilities = Abilities:new(self)
  self:set_color(pid)
  return self
end
--
function stone:__tostring() 
  local s = "stone["
  if self._pos then
    s = s.. self._pos.x.. ','.. self._pos.y.. ','
  end
  if self.pid ~= nil then
    s = s.. tostring(self.pid)
  end
  if self.powers then
    for k in pairs(self.powers) do
      s = s.. " ".. k
    end
  end
  return s.. "]"
end
--
function stone:set_color(pid)
  -- nothing to change
  if pid ~= self.pid then
    self.pid = pid

    -- change image
    if self.img then
      self.img:removeSelf()
    end
    cfg.view.cell.path = "src/view/stone_"..tostring(self.pid)..".png"
    self.img = lay.image(self, cfg.view.cell)
  end
end
--
function stone:get_pid()
  return self.pid
end

-- insert stone into group, with scale for dragging
function stone:puton(board)
  ass.isname(board, 'board')
  lay.render(board, self, {vx=0, vy=0})
  self.board = board
end

-- remove stone from board
function stone:putoff()
  ass(self.board)
  self.view:removeSelf()
  self.view = nil
  self.img:removeSelf()
  self.img = nil
  self._abilities = nil
  self.powers = nil
  self.board = nil
end

-- POSITION -------------------------------------------------------------------
-- set stone position
function stone:set_pos(pos)
  if pos ~= nil then
    ass.is(pos, vec)
  end
  self:update_group_pos(pos)
end
--
function stone:pos()
  return self._pos
end

-- ABILITY --------------------------------------------------------------------
function stone:set_ability(id, count)
  self._abilities:set_count(id, count)
end


-- POWER ----------------------------------------------------------------------
function stone:add_power(id, result_count)
  local power = self.powers[id]
  if power == nil then
    self.powers[id] = powers[id]:new(self.env, self, id, result_count)
  else
    self.powers[id] = power:set_count(result_count)
  end
end

-- TOUCH-----------------------------------------------------------------------
-- touch listener function
function stone:touch(event)
  -- do not touch opponent stones
  if self.env.space:who_move() ~= self.pid then
    log:trace('not my move')
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

    if self.env.space:can_move(self._pos, proj) then
      self:create_project(proj)
    else
      self:remove_project()
    end
    return true
  end

  if event.phase == "ended" or event.phase == "cancelled" then
    self:set_drag(nil)
    if self.proj then
      self.env.space:move(self._pos, self.proj)
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
  vec.copy(shift, self.view)
  return proj;
end

-- to be called from board
function stone:select()
  assert(self.isSelected == false)
  self.isSelected = true                    -- set selected
  self:update_group_pos(self._pos)                  -- adjust group position
  self._abilities:show()
end

-- to be called from board
function stone:deselect()
  if self.isSelected then
    log:trace(self, ":deselect"):enter()
      self.isSelected = false                   -- set not selected
      self:update_group_pos(self._pos)                  -- adgjust group position
      self._abilities:hide()
    log:exit()
  end
end
--
function stone:create_project(proj)
  if not self.project then
    cfg.view.cell.path = "src/view/stone_"..tostring(self.pid).."_project.png"
    self.project = lay.image(self.board, cfg.view.cell)
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
  display.getCurrentStage():setFocus(self.view, eventId)
  self.is_drag = (eventId ~= nil)
  if self.is_drag then
    --lay.render(self.board, self, {x=self.view.x, y=self.view.y})
    self.view:toFront()
  end
end

--
function stone:update_group_pos(pos)
  -- remove from board
  if pos == nil then
    self._pos = nil
    self.view.x = 0
    self.view.y = 0
    return
  end

  -- calculate new view position
  local view_pos = pos * cfg.view.cell.size
  if self.isSelected then
    view_pos.y = view_pos.y - 10
  end

  if self._pos then
    log:info('animate to view position', view_pos)
    lay.to(self, view_pos, cfg.view.stone.move)
  else
    log:info('instant set view position', view_pos)
    view_pos:to(self.view)
  end
  self._pos = pos
end

--
function stone:wrap()
  local event = {'event', typ.tab, map.tostring}

  wrp.wrap_tbl_trc(stone, 'new',          {'env'}, {'pid', 'playerid'})
  wrp.wrap_sub_trc(stone, 'select')
  wrp.wrap_sub_inf(stone, 'deselect')
  wrp.wrap_sub_trc(stone, 'set_color',    {'playerid'})
  wrp.wrap_sub_inf(stone, 'get_pid')
  wrp.wrap_sub_trc(stone, 'puton',        {'board'})
  wrp.wrap_sub_trc(stone, 'putoff')
  wrp.wrap_sub_trc(stone, 'pos')
  wrp.wrap_sub_trc(stone, 'set_ability',  {'id', typ.str}, {'count', typ.num})
  wrp.wrap_sub_trc(stone, 'add_power',    {'id', typ.str}, {'result_count', typ.num})
  wrp.wrap_sub_inf(stone, 'touch',        event)
  wrp.wrap_sub_inf(stone, 'touch_began',  event)
  wrp.wrap_sub_inf(stone, 'touch_moved',  event)
end

return stone