local _         = require 'src.core.underscore'
local vec       = require "src.core.vec"
local Player    = require "src.Player"
local Abilities = require "src.battle.Abilities"
local lay       = require "src.core.lay"
local cfg       = require "src.Config"
local str       = tostring

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
function Piece.new(log, color)
  assert(log)
  assert(log.name() == "log")

  local self = setmetatable({log = log}, Piece)
  self.view = display.newGroup()
  self.view:addEventListener("touch", self)
  self.color = color
  self.img = lay.image(self, cfg.cell, "src/battle/piece_"..Player.tostring(self.color)..".png")
  self.scale = 1
  self.abilities = Abilities.new(log, self)
  self.powers = {}
  self.isSelected = false
  self.isFocus = false

  return self
end


-------------------------------------------------------------------------------
-- TYPE------------------------------------------------------------------------
-------------------------------------------------------------------------------
function Piece:__tostring() 
  local s = "piece[" .. Player.tostring(self.color)
  if self.pos then
    s = s.." "..tostring(self.pos)
  end
  for k in pairs(self.powers) do
		s = s.. " ".. k
	end
  return s.."]"
end

function Piece:typename()
  return "Piece"
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
  assert(board, "board is nil")
  assert(board.move, "board.move is nil")
  assert(board.select, "board.select is nil")
  board.view:insert(self.view)
  self.board = board
  self:move(nil, pos)
end
-------------------------------------------------------------------------------
function Piece:can_move(to)
  --print(tostring(self)..":can_move to "..tostring(to))
  local vec = self.pos - to                 -- movement vector

  for _, power in pairs(self.powers) do
    if power:can_move(vec) then
      return true
    end
  end

  return (vec.x == 0 or vec.y == 0) and vec:length2() == 1
end
-------------------------------------------------------------------------------
function Piece:move_before(cell_from, cell_to)
  _.each(self.powers, function(p) p:move_before(cell_from, cell_to) end)
end
-------------------------------------------------------------------------------
function Piece:move(cell_from, cell_to)
  self.log:enter():trace(self, ":move to ", cell_to)
    if cell_from then
      assert(cell_from.piece == self)
      cell_from:leave()           -- get piece at from position
    end

    cell_to:receive(self)                    -- cell that actor is going to move to

    self.pos = cell_to.pos

    for _, power in ipairs(self.powers) do
      if power:move(vec) then
        return true
      end
    end

    self:_update_group_pos()
  self.log:exit()
end
-------------------------------------------------------------------------------
function Piece:move_after(cell_from, cell_to)
  self.log:enter():trace(self, ":move_after")
    for name, power in pairs(self.powers) do
      power:move_after(self, self.board, cell_from, cell_to)
    end
  self.log:exit()
end



-------------------------------------------------------------------------------
-- SELECTION-------------------------------------------------------------------
-------------------------------------------------------------------------------
-- to be called from Board. Use self.board:select instead
function Piece:select()
  assert(self.isSelected == false)
  self.isSelected = true                    -- set selected
  self:_update_group_pos()                  -- adjust group position
  self.abilities:show(self.board.view.parent)           -- show abilities list
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

  -- add ability mark
  if self.able == nil then
    self.able = lay.image(self, cfg.cell, "src/battle/ability.png")
  end
end
-------------------------------------------------------------------------------
function Piece:use_ability(Power)
  self.log:enter():trace(self, ":use_ability ", Power.name())
    self:add_power(Power)                   -- increase power
    self.board:select(nil)                  -- remove selection if was selected

    -- remove ability mark
    if self.abilities:is_empty() then
      self.able:removeSelf()
      self.able = nil
    end
  self.log:exit()
end
-------------------------------------------------------------------------------
function Piece:add_power(Power)
  self.log:enter():trace(self, ":add_power ", Power.name())
    local name = Power.name()
    local p = self.powers[name]
    if p then
      p:increase()
    else
      self.powers[name] = Power.new(self.log, self.view)
    end
  self.log:exit()
end
-------------------------------------------------------------------------------
function Piece:remove_power(name)
  self.log:enter():trace(self, ":remove_power ", name)
    local p = self.powers[name]
    if p then
      if not p:decrease() then
        self.powers[name] = nil
      end
    end
  self.log:exit()
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
    self.mark = vec.from(self.view)

  elseif self.isFocus then

    if event.phase == "moved" then
      local start = vec(event.xStart, event.yStart)
      local shift = (vec.from(event) - start) / vec(self.board.view.xScale) + self.mark
      local proj = (shift / cfg.cell.size):round()
      vec.copy(shift, self.view)

      if self.board:can_move(self.pos, proj) then
        self:_create_project()
        self.proj = proj
        vec.copy(proj * cfg.cell.size, self.project)
      else
        self:_remove_project()
        self.proj = nil
      end

    elseif event.phase == "ended" or event.phase == "cancelled" then
      self:_set_focus(nil)
      self:_remove_project()
      if self.proj then
        self.board:will_move(self.pos, self.proj)
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
function Piece:_create_project()
  if not self.project then
    local path = "src/battle/piece_"..Player.tostring(self.color).."_project.png"
    self.project = lay.image(self.board, cfg.cell, path)
    vec.copy(self.view, self.project)
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
  display.getCurrentStage():setFocus(self.view, eventId)
  self.isFocus = (eventId ~= nil)
end
-------------------------------------------------------------------------------
function Piece:_update_group_pos()
  local pos = self.pos * cfg.cell.size
  if self.isSelected then
    pos.y = pos.y - 10
  end
  vec.copy(pos, self.view)
end

return Piece