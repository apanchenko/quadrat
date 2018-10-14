local _         = require 'src.core.underscore'
local vec       = require "src.core.vec"
local Player    = require "src.Player"
local Abilities = require "src.battle.PieceAbilities"
local Color     = require 'src.battle.Color'
local cfg       = require 'src.Config'
local lay       = require 'src.core.lay'
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'

-------------------------------------------------------------------------------
local Piece = 
{
  typename = "Piece"
}
Piece.__index = Piece

--[[-----------------------------------------------------------------------------
Arguments:
  color      - color for the piece

Variables:
  group      - display group for all piece content
  color      - is red or black
  img        - image, piece view
  i, j       - int number, position on board
  abilities  - abilities gathered
  powers     - array of activated abilities
  isSelected - one piece may be selected only
  isFocus    - is event drag started

Methods:
  puton(board, pos)
  move_to(pos)
  add_ability()
  select()
  deselect()
-----------------------------------------------------------------------------]]--
function Piece.new(color)
  Color.ass(color)
  local depth = log:trace("Piece.new"):enter()
    local self = setmetatable({}, Piece)
    self.view = display.newGroup()
    self.view:addEventListener("touch", self)
    self:set_color(color)
    self.scale = 1
    self.abilities = Abilities.new(self)
    self.powers = {}
    self.isSelected = false
    self.isFocus = false
  log:exit(depth)
  return self
end
-------------------------------------------------------------------------------
function Piece:__tostring() 
  local s = "piece["
  if self.color ~= nil then
    s = s.. Color.string(self.color)
  end
  if self.pos then
    s = s.. " ".. tostring(self.pos)
  end
  if self.powers then
    for k in pairs(self.powers) do
      s = s.. " ".. k
    end
  end
  return s.. "]"
end
-------------------------------------------------------------------------------
function Piece:set_color(color)
  local depth = log:trace(self, ":set_color ", Color.string(color)):enter()
    Color.ass(color)

    -- nothing to change
    if color ~= self.clolor then
      -- save color
      self.color = color

      -- change image
      if self.img then
        self.img:removeSelf()
      end
      cfg.cell.order = 1
      self.img = lay.image(self, cfg.cell, "src/battle/piece_"..Color.string(self.color)..".png")
      cfg.cell.order = nil
    end

  log:exit(depth)
end
-------------------------------------------------------------------------------
function Piece:die()
  self.view:removeSelf()
  self.view = nil
  self.img:removeSelf()
  self.img = nil
  self.abilities = nil
  self.powers = nil
  self.board = nil
end



-------------------------------------------------------------------------------
-- MOVE------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- insert piece into group, with scale for dragging
function Piece:puton(board, pos)
  board.view:insert(self.view)
  self.board = board
  self:move(nil, pos)
end
-------------------------------------------------------------------------------
function Piece:can_move(to)
  for _, power in pairs(self.powers) do
    if power:can_move(self.pos, to) then
      return true
    end
  end

  local vec = self.pos - to -- movement vector
  return (vec.x == 0 or vec.y == 0) and vec:length2() == 1
end
-------------------------------------------------------------------------------
-- if can be jumed by opponent piece
function Piece:is_jump_protected()
  for _, p in pairs(self.powers) do
    log:trace("  ", p.typename, " ", p.is_jump_protected)
    if p.is_jump_protected then
      log:trace(p.typename, ":jp true")
      return true
    end
  end
  log:trace(self, ":jp false")
  return false

end
-------------------------------------------------------------------------------
function Piece:move_before(cell_from, cell_to)
  _.each(self.powers, function(p) p:move_before(cell_from, cell_to) end)
end
-------------------------------------------------------------------------------
function Piece:move(cell_from, cell_to)
  local depth = log:trace(self, ":move to ", cell_to):enter()
    if cell_from then
      assert(cell_from.piece == self)
      cell_from:leave()           -- get piece at from position
    end

    cell_to:receive(self)                    -- cell that actor is going to move to

    self.pos = cell_to.pos

    for _, power in pairs(self.powers) do
      if power:move(vec) then
        log:exit(depth)
        return true
      end
    end

    self:update_group_pos()
  log:exit(depth)
end
-------------------------------------------------------------------------------
function Piece:move_after(cell_from, cell_to)
  local depth = log:trace(self, ":move_after"):enter()
    for name, power in pairs(self.powers) do
      power:move_after(self, self.board, cell_from, cell_to)
    end
  log:exit(depth)
end



-------------------------------------------------------------------------------
-- SELECTION-------------------------------------------------------------------
-------------------------------------------------------------------------------
-- to be called from Board. Use self.board:select instead
function Piece:select()
  local depth = log:trace(self, ":select"):enter()
    assert(self.isSelected == false)
    self.isSelected = true                    -- set selected
    self:update_group_pos()                  -- adjust group position
    self.abilities:show(self.env)           -- show abilities list
  log:exit(depth)
end
-------------------------------------------------------------------------------
-- to be called from Board. Use self.board:select instead
function Piece:deselect()
  if self.isSelected then
    local depth = log:trace(self, ":deselect"):enter()
      self.isSelected = false                   -- set not selected
      self:update_group_pos()                  -- adgjust group position
      self.abilities:hide()
    log:exit(depth)
  end
end



-------------------------------------------------------------------------------
-- ABILITY --------------------------------------------------------------------
-------------------------------------------------------------------------------
function Piece:add_ability()
  self.abilities:add(self.env)

  -- add ability mark
  if self.able == nil then
    cfg.cell.order = 1
    self.able = lay.image(self, cfg.cell, "src/battle/ability_".. Color.string(self.color).. ".png")
    cfg.cell.order = nil
  end
end
-------------------------------------------------------------------------------
function Piece:use_ability(ability)
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
-------------------------------------------------------------------------------
function Piece:add_power(ability)
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
-------------------------------------------------------------------------------
function Piece:remove_power(name)
  local depth = log:trace(self, ":remove_power ", name):enter()
    local p = self.powers[name]
    if p then
      if not p:decrease() then
        self.powers[name] = nil
      end
    end
  log:exit(depth)
end


-------------------------------------------------------------------------------
-- PRIVATE---------------------------------------------------------------------
-------------------------------------------------------------------------------
-- touch listener function
function Piece:touch(event)
  --self.env.log:trace(self, ":touch phase ", event.phase)
  if self.board:is_color(self.color) == false then
    return true
  end
  
  if event.phase == "began" then
    if self.isSelected == false then
      self.board:select(nil)                -- deselect another piece
    end
    self:set_focus(event.id)
    self.mark = vec.from(self.view)

  elseif self.isFocus then

    if event.phase == "moved" then
      local start = vec(event.xStart, event.yStart)
      local shift = (vec.from(event) - start) / vec(self.board.view.xScale) + self.mark
      local proj = (shift / cfg.cell.size):round()
      vec.copy(shift, self.view)

      if self.board:can_move(self.pos, proj) then
        self:create_project()
        self.proj = proj
        vec.copy(proj * cfg.cell.size, self.project)
      else
        self:remove_project()
        self.proj = nil
      end

    elseif event.phase == "ended" or event.phase == "cancelled" then
      self:set_focus(nil)
      self:remove_project()
      if self.proj then
        self.board:player_move(self.pos, self.proj)
        self.board:select(nil)              -- deselect any
        self.proj = nil
      else
        vec.copy(self.pos * cfg.cell.size, self.view) -- return to original position
        if self.isSelected then
          self.board:select(nil)            -- remove selection if was selected
        else
          self.board:select(self)           -- select this piece
        end
      end
    end
  end

  return true
end
-------------------------------------------------------------------------------
function Piece:create_project()
  if not self.project then
    local path = "src/battle/piece_"..Color.string(self.color).."_project.png"
    self.project = lay.image(self.board, cfg.cell, path)
    vec.copy(self.view, self.project)
  end
end
-------------------------------------------------------------------------------
function Piece:remove_project()
  if self.project then
    self.project:removeSelf()
    self.project = nil
  end
end
-------------------------------------------------------------------------------
function Piece:set_focus(eventId)
  log:trace(self, ":set_focus")
  display.getCurrentStage():setFocus(self.view, eventId)
  self.isFocus = (eventId ~= nil)

  if self.isFocus then
    self.board.hover:insert(self.view)
  else
    self.board.view:insert(self.view)
  end

end
-------------------------------------------------------------------------------
function Piece:update_group_pos()
  local pos = self.pos * cfg.cell.size
  if self.isSelected then
    pos.y = pos.y - 10
  end
  vec.copy(pos, self.view)
end

return Piece