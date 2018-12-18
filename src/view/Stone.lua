local arr           = require 'src.core.arr'
local Vec         = require 'src.core.vec'
local lay         = require 'src.core.lay'
local ass         = require 'src.core.ass'
local log         = require 'src.core.log'
local map         = require 'src.core.map'
local Class       = require 'src.core.Class'
local typ       = require 'src.core.typ'
local Abilities   = require 'src.view.StoneAbilities'
local power_image = require 'src.view.power.image'
local cfg         = require 'src.Config'
local Player      = require 'src.Player'
local powers      = require 'src.view.power.powers'

local Stone = Class.Create 'Stone'

--INIT-------------------------------------------------------------------------
function Stone.New(pid, model)
  local self = setmetatable({}, Stone)
  self._model = model
  self.view = display.newGroup()
  self.view:addEventListener("touch", self)
  self:set_color(pid)
  self.scale = 1
  self._abilities = Abilities.New(self, model)
  self.powers = {}
  self.isSelected = false
  self.is_drag = false
  return self
end
--
function Stone:__tostring() 
  local s = "stone["
  if self.pid ~= nil then
    s = s.. tostring(self.pid)
  end
  if self._pos then
    s = s.. " ".. tostring(self._pos)
  end
  if self.powers then
    for k in pairs(self.powers) do
      s = s.. " ".. k
    end
  end
  return s.. "]"
end
--
function Stone:set_color(pid)
  -- nothing to change
  if pid ~= self.pid then
    self.pid = pid

    -- change image
    if self.img then
      self.img:removeSelf()
    end
    cfg.cell.order = 1
    self.img = lay.image(self, cfg.cell, "src/view/stone_"..tostring(self.pid)..".png")
    cfg.cell.order = nil
  end
end
--
function Stone:color()
  return self.pid
end

-- insert Stone into group, with scale for dragging
function Stone:puton(board, pos)
  ass.is(board, 'Board')
  ass.is(pos, Vec)
  board.view:insert(self.view)
  self.board = board
  self._pos = pos
  self:update_group_pos()
end

-- remove Stone from board
function Stone:putoff()
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
function Stone:set_pos(pos)
  if pos ~= nil then
    ass.is(pos, Vec)
  end
  self._pos = pos
  self:update_group_pos()
end
--
function Stone:pos()
  return self._pos
end

-- ABILITY --------------------------------------------------------------------
function Stone:add_ability(name)    self._abilities:add(name) end
function Stone:remove_ability(name) self._abilities:remove(name) end

-- POWER ----------------------------------------------------------------------
function Stone:add_power(name, result_count)
  local power = self.powers[name]
  if power == nil then
    self.powers[name] = powers[name]:create(self, name, result_count)
  else
    self.powers[name] = power:set_count(result_count)
  end
end

-- TOUCH-----------------------------------------------------------------------
-- touch listener function
function Stone:touch(event)
  -- do not touch opponent stones
  if self.board.model:who_move() ~= self.pid then
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

    if self.board.model:can_move(self._pos, proj) then
      self:create_project(proj)
    else
      self:remove_project()
    end
    return true
  end

  if event.phase == "ended" or event.phase == "cancelled" then
    self:set_drag(nil)
    if self.proj then
      self.board.model:move(self._pos, self.proj)
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
function Stone:touch_began(event)
  if self.isSelected == false then
    self.board:select(nil)                -- deselect another Stone
  end
  self:set_drag(event.id)
end
--
function Stone:touch_moved(event)
  local start = Vec(event.xStart, event.yStart)
  local xScale = self.board.view.xScale
  local shift = Vec:from(event)
  shift = shift - start
  shift = shift / Vec(xScale, xScale)
  shift = shift + (self._pos * cfg.cell.size)
  local proj = (shift / cfg.cell.size):round()
  Vec.copy(shift, self.view)
  return proj;
end
-- to be called from Board
function Stone:select()
  assert(self.isSelected == false)
  self.isSelected = true                    -- set selected
  self:update_group_pos()                  -- adjust group position
  self._abilities:show()
end
-- to be called from Board
function Stone:deselect()
  if self.isSelected then
    local depth = log:trace(self, ":deselect"):enter()
      self.isSelected = false                   -- set not selected
      self:update_group_pos()                  -- adgjust group position
      self._abilities:hide()
    log:exit(depth)
  end
end
--
function Stone:create_project(proj)
  if not self.project then
    local path = "src/view/stone_"..tostring(self.pid).."_project.png"
    self.project = lay.image(self.board, cfg.cell, path)
  end
  self.proj = proj
  Vec.copy(proj * cfg.cell.size, self.project)
end
--
function Stone:remove_project()
  if self.project then
    self.project:removeSelf()
    self.project = nil
  end
  self.proj = nil
end
--
function Stone:set_drag(eventId)
  display.getCurrentStage():setFocus(self.view, eventId)
  self.is_drag = (eventId ~= nil)
  if self.is_drag then
    self.board.view:insert(self.view)
  end
end
--
function Stone:update_group_pos()
  if self._pos == nil then
    self.view.x = 0
    self.view.y = 0
    return
  end
  local pos = self._pos * cfg.cell.size
  if self.isSelected then
    pos.y = pos.y - 10
  end
  Vec.copy(pos, self.view)
end

--MODULE-----------------------------------------------------------------------
---[[
ass.wrap(Stone, ':select')
ass.wrap(Stone, ':set_color', 'playerid')
ass.wrap(Stone, ':color')
ass.wrap(Stone, ':puton', 'Board', Vec)
ass.wrap(Stone, ':putoff')
ass.wrap(Stone, ':select')
ass.wrap(Stone, ':deselect')
ass.wrap(Stone, ':pos')
--ass.wrap(Stone, 'set_pos', Vec)
ass.wrap(Stone, ':add_ability', typ.str)
ass.wrap(Stone, ':remove_ability', typ.str)
ass.wrap(Stone, ':add_power', typ.str, typ.num)

log:wrap(Stone, 'select', 'add_ability', 'remove_ability', 'add_power', 'set_color')
--]]
return Stone