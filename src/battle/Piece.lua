local Pos       = require "src.core.Pos"
local Player    = require "src.Player"
local Abilities = require "src.battle.Abilities"
local lib       = require "src.core.lib"
local cfg       = require "src.Config"
local PowerMoveDiagonal = require "src.battle.PowerMoveDiagonal"

-------------------------------------------------------------------------------
local Piece = {}
Piece.__index = Piece
setmetatable(Piece, {__call = function(cls, ...) return cls.new(...) end})

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
  local self = setmetatable({}, Piece)
  self.group = display.newGroup()
  self.group:addEventListener("touch", self)
  self.color = color
  self.img = lib.image(self.group, cfg.cell, "src/battle/piece_"..Player.tostring(self.color)..".png")
  self.scale = 1
  self.abilities = Abilities(self)
  self.powers = {}
  self.isSelected = false
  self.isFocus = false
  return self
end

-------------------------------------------------------------------------------
function Piece:get_abilities()
  return self.abilities
end

-------------------------------------------------------------------------------
function Piece:die()
  self.group:removeSelf()
  self.group = nil
  self.img:removeSelf()
  self.img = nil
  self.abilities = nil
  self.powers = nil
  self.board = nil
end

-------------------------------------------------------------------------------
function Piece:__tostring() 
  return "piece["
    ..Player.tostring(self.color)
    .." "..tostring(self.pos)
    ..", powers "..#self.powers
  .."]"
end



-------------------------------------------------------------------------------
-- POSITION--------------------------------------------------------------------
-------------------------------------------------------------------------------
-- insert piece into group, with scale for dragging
function Piece:puton(board, pos)
  assert(board, "board is nil")
  assert(board.move, "board.move is nil")
  assert(board.select, "board.select is nil")
  board.group:insert(self.group)
  self.board = board
  self:move_to(pos)
end
-------------------------------------------------------------------------------
function Piece:move_to(pos)
  assert(pos)
  assert(pos:typename() == "Pos")
  self.pos = pos
  self:_update_group_pos()
end
-------------------------------------------------------------------------------
function Piece:can_move(to)
  print(tostring(self)..":can_move to "..tostring(to))
  local vec = self.pos - to                 -- movement vector

  for _, power in ipairs(self.powers) do
    if power:can_move(vec) then
      return true
    end
  end

  return (vec.x == 0 or vec.y == 0) and vec:length2() == 1
end



-------------------------------------------------------------------------------
-- SELECTION-------------------------------------------------------------------
-------------------------------------------------------------------------------
-- to be called from Board. Use self.board:select instead
function Piece:select()
  assert(self.isSelected == false)
  self.isSelected = true                    -- set selected
  self:_update_group_pos()                  -- adjust group position
  self.abilities:show(self.board.group.parent)           -- show abilities list
end
-------------------------------------------------------------------------------
-- to be called from Board. Use self.board:select instead
function Piece:deselect()
  if self.isSelected then
    self.isSelected = false                   -- set not selected
    self:_update_group_pos()                  -- adgjust group position
    self.abilities:hide()
  end
end



-------------------------------------------------------------------------------
-- ABILITY --------------------------------------------------------------------
-------------------------------------------------------------------------------
function Piece:add_ability()
  self.abilities:add()
end
-------------------------------------------------------------------------------
function Piece:use_ability(name)
  if name == Abilities.MoveDiagonal then
    table.insert(self.powers, PowerMoveDiagonal(self.group))
    self.board:select(nil)                  -- remove selection if was selected
  end

  print(tostring(self)..":use_ability " .. name .. " -> " .. " powers " .. #self.powers)
end



-------------------------------------------------------------------------------
-- PRIVATE---------------------------------------------------------------------
-------------------------------------------------------------------------------
-- touch listener function
function Piece:touch(event)
  if self.board:is_color(self.color) == false then
    return true
  end
  
  if event.phase == "began" then
    if self.isSelected == false then
      self.board:select(nil)                -- deselect another piece
    end
    self:_set_focus(event.id)
    self.mark = Pos.from(self.group)

  elseif self.isFocus then

    if event.phase == "moved" then
      local start = Pos(event.xStart, event.yStart)
      local shift = (Pos.from(event) - start) + self.mark
      local proj = (shift / cfg.cell.size):round()
      Pos.copy(shift, self.group)

      if self.board:can_move(self.pos, proj) then
        self:_create_project()
        self.proj = proj
        Pos.copy(proj * cfg.cell.size, self.project)
      else
        self:_remove_project()
        self.proj = nil
      end

    elseif event.phase == "ended" or event.phase == "cancelled" then
      self:_set_focus(nil)
      self:_remove_project()
      if self.proj then
        self.board:move(self.pos, self.proj)
        self.board:select(nil)              -- deselect any
        self.proj = nil
      else
        Pos.copy(self.pos * cfg.cell.size, self.group) -- return to original position
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
function Piece:_create_project()
  if not self.project then
    local path = "src/battle/piece_"..Player.tostring(self.color).."_project.png"
    self.project = lib.image(self.board.group, cfg.cell, path)
    Pos.copy(self.group, self.project)
  end
end
-------------------------------------------------------------------------------
function Piece:_remove_project()
  if self.project then
    self.project:removeSelf()
    self.project = nil
  end
end
-------------------------------------------------------------------------------
function Piece:_set_focus(eventId)
  display.getCurrentStage():setFocus(self.group, eventId)
  self.isFocus = (eventId ~= nil)
end
-------------------------------------------------------------------------------
function Piece:_update_group_pos()
  local pos = self.pos * cfg.cell.size
  if self.isSelected then
    pos.y = pos.y - 10
  end
  Pos.copy(pos, self.group)
end

return Piece