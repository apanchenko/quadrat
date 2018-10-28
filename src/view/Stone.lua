local _         = require 'src.core.underscore'
local Vec       = require 'src.core.Vec'
local Player    = require 'src.Player'
local Abilities = require 'src.view.PieceAbilities'
local Color     = require 'src.model.Color'
local cfg       = require 'src.Config'
local lay       = require 'src.core.lay'
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local map       = require 'src.core.map'

local Stone = { typename = "Stone" }
Stone.__index = Stone

--INIT-------------------------------------------------------------------------
function Stone.new(color)
  local depth = log:trace("Stone.new"):enter()
    Color.ass(color)
    local self = setmetatable({}, Stone)
    self.view = display.newGroup()
    self.view:addEventListener("touch", self)
    self:set_color(color)
    self.scale = 1
    --self.abilities = Abilities.new(self)
    self.powers = {}
    self.isSelected = false
    self.isFocus = false
  log:exit(depth)
  return self
end
--
function Stone:__tostring() 
  local s = "Stone["
  if self.color ~= nil then
    s = s.. Color.string(self.color)
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
  local depth = log:trace(self, ":set_color ", Color.string(color)):enter()
    Color.ass(color)

    -- nothing to change
    if color ~= self.clolor then
      self.color = color

      -- change image
      if self.img then
        self.img:removeSelf()
      end
      cfg.cell.order = 1
      self.img = lay.image(self, cfg.cell, "src/view/stone_"..Color.string(self.color)..".png")
      cfg.cell.order = nil
    end
  log:exit(depth)
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
  self.abilities = nil
  self.powers = nil
  self.board = nil
end

-- set stone position
function Stone:set_pos(pos)
  if pos ~= nil then
    ass.is(pos, Vec)
  end
  self._pos = pos
end

-- ABILITY --------------------------------------------------------------------
function Stone:add_ability()
  --self.abilities:add(self.env)

  -- add ability mark
  if self.able == nil then
    cfg.cell.order = 1
    self.able = lay.image(self, cfg.cell, "src/battle/ability_".. Color.string(self.color).. ".png")
    cfg.cell.order = nil
  end
end
--
function Stone:use_ability(ability)
  local depth = log:trace(self, ":use_ability ", ability):enter()
    self:add_power(ability)                   -- increase power
    self.board:select(nil)                  -- remove selection if was selected

    -- remove ability mark
    if self.abilities:is_empty() then
      log:trace("remove able")
      self.able:removeSelf()
      self.able = nil
    end
  log:exit(depth)
end
--
function Stone:add_power(ability)
  local name = tostring(ability)
  local depth = log:trace(self, ":add_power ", name):enter()
    local p = self.powers[name]
    if p then
      p:increase()
    else
      self.powers[name] = ability:create_power():apply(self)
    end
  log:exit(depth)
end
--
function Stone:remove_power(name)
  local depth = log:trace(self, ":remove_power ", name):enter()
    local p = self.powers[name]
    if p then
      if not p:decrease() then
        self.powers[name] = nil
      end
    end
  log:exit(depth)
end

-- SELECTION-------------------------------------------------------------------
-- to be called from Board. Use self.board:select instead
function Stone:select()
  local depth = log:trace(self, ":select"):enter()
    assert(self.isSelected == false)
    self.isSelected = true                    -- set selected
    self:update_group_pos()                  -- adjust group position
    --self.abilities:show(self.env)           -- show abilities list
  log:exit(depth)
end
-- to be called from Board. Use self.board:select instead
function Stone:deselect()
  if self.isSelected then
    local depth = log:trace(self, ":deselect"):enter()
      self.isSelected = false                   -- set not selected
      self:update_group_pos()                  -- adgjust group position
      --self.abilities:hide()
    log:exit(depth)
  end
end

-- PRIVATE---------------------------------------------------------------------
-- touch listener function
function Stone:touch(event)
  -- do not touch opponent stones
  if self.board.model:who_move() ~= self.color then
    return true
  end
  -- take stone
  if event.phase == "began" then
    self:touch_began(event)
    return true
  end

  if not self.isFocus then
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
    self:set_focus(nil)
    if self.proj then
      self.board.model:move(self._pos, self.proj)
      self.board:select(nil)              -- deselect any
    else
      Vec.copy(self._pos * cfg.cell.size, self.view) -- return to original position
      if self.isSelected then
        self.board:select(nil)            -- remove selection if was selected
      else
        self.board:select(self)           -- select this Stone
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
  self:set_focus(event.id)
end
--
function Stone:touch_moved(event)
  local start = Vec(event.xStart, event.yStart)
  local shift = (Vec.from(event) - start) / Vec(self.board.view.xScale) + (self._pos * cfg.cell.size)
  local proj = (shift / cfg.cell.size):round()
  Vec.copy(shift, self.view)
  return proj;
end
--
function Stone:create_project(proj)
  if not self.project then
    local path = "src/view/stone_"..Color.string(self.color).."_project.png"
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
-------------------------------------------------------------------------------
function Stone:set_focus(eventId)
  --log:trace(self, ":set_focus")
  display.getCurrentStage():setFocus(self.view, eventId)
  self.isFocus = (eventId ~= nil)

  if self.isFocus then
    self.board.hover:insert(self.view)
  else
    self.board.view:insert(self.view)
  end

end
-------------------------------------------------------------------------------
function Stone:update_group_pos()
  local pos = self._pos * cfg.cell.size
  if self.isSelected then
    pos.y = pos.y - 10
  end
  Vec.copy(pos, self.view)
end

return Stone