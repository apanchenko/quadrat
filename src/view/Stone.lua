local _           = require 'src.core.underscore'
local Vec         = require 'src.core.vec'
local lay         = require 'src.core.lay'
local ass         = require 'src.core.ass'
local log         = require 'src.core.log'
local map         = require 'src.core.map'
local Class       = require 'src.core.Class'
local types       = require 'src.core.types'
local Powers      = require 'src.model.power.Powers'
local Color       = require 'src.model.Color'
local Abilities   = require 'src.view.StoneAbilities'
local power_image = require 'src.view.power.image'
local cfg         = require 'src.Config'
local Player      = require 'src.Player'

local Stone = Class.Create 'Stone'

--INIT-------------------------------------------------------------------------
function Stone.New(color, model)
  local depth = log:trace("Stone.new"):enter()
    local self = setmetatable({}, Stone)
    self._model = model
    self.view = display.newGroup()
    self.view:addEventListener("touch", self)
    self:set_color(color)
    self.scale = 1
    self._abilities = Abilities.New(self, model)
    self.powers = {}
    self.isSelected = false
    self.is_drag = false
  log:exit(depth)
  return self
end
--
function Stone:__tostring() 
  local s = "stone["
  if self._color ~= nil then
    s = s.. tostring(self._color)
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
function Stone:set_color(color)
  -- nothing to change
  if color ~= self._clolor then
    self._color = color

    -- change image
    if self.img then
      self.img:removeSelf()
    end
    cfg.cell.order = 1
    self.img = lay.image(self, cfg.cell, "src/view/stone_"..tostring(self._color)..".png")
    cfg.cell.order = nil
  end
end
--
function Stone:color()
  return self._color
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
  if self.powers[name] == nil then
    self.powers[name] = power_image:create(self, name)
    --lay.image(self, cfg.cell, 'src/view/powers/'..name..'.png')
    --self.text = lay.text(piece, {text=tostring(self.count + 1), fontSize=22})
  else
--    local Power = Powers.Find(name)
--    ass.table(Power)
--    if Power.Stackable then
--    end
  end
end
--
function Stone:remove_power(name)
  local p = self.powers[name]
  if p then
    self.powers[name] = p:decrease()
  end
end

-- TOUCH-----------------------------------------------------------------------
-- touch listener function
function Stone:touch(event)
  -- do not touch opponent stones
  if self.board.model:who_move() ~= self._color then
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
    local path = "src/view/stone_"..tostring(self._color).."_project.png"
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
ass.wrap(Stone, ':set_color', Color)
ass.wrap(Stone, ':color')
ass.wrap(Stone, ':puton', 'Board', Vec)
ass.wrap(Stone, ':putoff')
ass.wrap(Stone, ':select')
ass.wrap(Stone, ':deselect')
ass.wrap(Stone, ':pos')
--ass.wrap(Stone, 'set_pos', Vec)
ass.wrap(Stone, ':add_ability', types.str)
ass.wrap(Stone, ':remove_ability', types.str)
ass.wrap(Stone, ':add_power', types.str, types.num)

log:wrap(Stone, 'select', 'add_ability', 'remove_ability', 'add_power', 'set_color')
--]]
return Stone