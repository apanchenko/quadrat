local Pos     = require "src.core.Pos"
local Player  = require "src.Player"
local AbilityDiagonal = require "src.battle.AbilityDiagonal"
local lib     = require "src.core.lib"
local cfg     = require "src.Config"

-------------------------------------------------------------------------------
local Piece = {}
Piece.__index = Piece
setmetatable(Piece, {__call = function(cls, ...) return cls.new(...) end})

--[[
group     - display group for all piece content
color     - is red or black
img       - image, piece view
i, j      - int number, position on board
abilities - array of abilities gathered
selected  - one piece may be selected only
--]]
function Piece.new(color)
  local self = setmetatable({}, Piece)
  self.group = display.newGroup()
  self.group:addEventListener("touch", self)
  self.color = color
  self.img = lib.image(self.group, "src/battle/piece_"..Player.tostring(self.color)..".png", {w=cfg.cell_size.x})
  self.scale = 1
  self.abilities = {}
  self.selected = false
  self.isFocus = false
  return self
end

-------------------------------------------------------------------------------
function Piece:die()
  self.group:removeSelf()
  self.group = nil
  self.img:removeSelf()
  self.img = nil
end

-------------------------------------------------------------------------------
function Piece:__tostring() 
  return "piece["..tostring(self.pos)..","..Player.tostring(self.color).."]"
end

-------------------------------------------------------------------------------
-- touch listener function
function Piece:touch(event)
  if self.board:is_color(self.color) == false then
    return true
  end
  
  if event.phase == "began" then
    if self.selected == false then
      self.board:select(nil)                -- deselect another piece
    end
    self:_set_focus(event.id)
    self.mark = Pos.from(self.group)

  elseif self.isFocus then

    if event.phase == "moved" then
      local start = Pos(event.xStart, event.yStart)
      local shift = (Pos.from(event) - start) / self.board.scale + self.mark
      local proj = (shift / cfg.cell_size):round()
      Pos.copy(shift, self.group)

      if self.board:can_move(self.pos, proj) then
        self:_create_project()
        self.proj = proj
        Pos.copy(proj * cfg.cell_size, self.project)
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
        Pos.copy(self.pos * cfg.cell_size, self.group) -- return to original position
        if self.selected then
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
-- insert piece into group, with scale for dragging
function Piece:puton(board, pos)
  assert(board, "board is nil")
  assert(board.move, "board.move is nil")
  assert(board.select, "board.select is nil")
  board.group:insert(self.group)
  self.board = board
  self:move(pos)
end

-------------------------------------------------------------------------------
function Piece:move(to)
  self.pos = to
  self:_update_group_pos()
end

-------------------------------------------------------------------------------
function Piece:add_ability()
  local ability = AbilityDiagonal(self.group)
  table.insert(self.abilities, ability)
end

-------------------------------------------------------------------------------
-- SELECTION-------------------------------------------------------------------
-------------------------------------------------------------------------------
function Piece:select()
  assert(self.selected == false)
  self.selected = true                      -- set selected
  self:_update_group_pos()                  -- adjust group position
end
-------------------------------------------------------------------------------
function Piece:deselect()
  assert(self.selected == true)
  self.selected = false                     -- set not selected
  self:_update_group_pos()                  -- adgjust group position
end

-------------------------------------------------------------------------------
-- PRIVATE---------------------------------------------------------------------
-------------------------------------------------------------------------------
function Piece:_create_project()
  if not self.project then
    local path = "src/battle/piece_"..Player.tostring(self.color).."_project.png"
    self.project = lib.image(self.board.group, path, {w=cfg.cell_size.x})
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
  local pos = self.pos * cfg.cell_size
  if self.selected then
    pos.y = pos.y - 10
  end
  Pos.copy(pos, self.group)
end

return Piece