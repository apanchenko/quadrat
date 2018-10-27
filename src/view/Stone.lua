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

-------------------------------------------------------------------------------
local Stone = {}
Stone.typename = "Stone"
Stone.__index = Stone

--[[-----------------------------------------------------------------------------
Arguments:
  color      - color for the Stone

Variables:
  group      - display group for all Stone content
  color      - is red or black
  img        - image, Stone view
  i, j       - int number, position on board
  abilities  - abilities gathered
  powers     - array of activated abilities
  isSelected - one Stone may be selected only
  isFocus    - is event drag started

Methods:
  puton(board, pos)
  move_to(pos)
  add_ability()
  select()
  deselect()
-----------------------------------------------------------------------------]]--
function Stone.new(piece)
  local depth = log:trace("Stone.new"):enter()
    ass.is(piece, 'Piece', 'piece')
    local self = setmetatable({}, Stone)
    self.view = display.newGroup()
    self.view:addEventListener("touch", self)
    self:set_color(piece:get_color())
    self.scale = 1
    self.abilities = Abilities.new(self)
    self.powers = {}
    self.isSelected = false
    self.isFocus = false
  log:exit(depth)
  return self
end
-------------------------------------------------------------------------------
function Stone:__tostring() 
  local s = "Stone["
  if self.color ~= nil then
    s = s.. Color.string(self.color)
  end
  if self.cell then
    s = s.. " ".. tostring(self.cell)
  end
  if self.powers then
    for k in pairs(self.powers) do
      s = s.. " ".. k
    end
  end
  return s.. "]"
end
-------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------



-- insert Stone into group, with scale for dragging
function Stone:puton(board, cell)
  ass.is(board, 'Board')
  ass.is(cell, 'Cell')

  board.view:insert(self.view)
  self.board = board
  self:move_middle(nil, cell)

  ass(self.cell == cell)
end

-- remove Stone from board
function Stone:putoff()
  self.view:removeSelf()
  self.view = nil
  self.img:removeSelf()
  self.img = nil
  self.abilities = nil
  self.powers = nil
  self.board = nil
  if self.cell then
    ass(self.cell.Stone == self)
    self.cell.Stone = nil
    self.cell = nil
  end
end

-- get position
function Stone:get_pos()
  return self.cell.pos
end

-------------------------------------------------------------------------------
function Stone:can_move(to_pos)
  ass.is(to_pos, Vec)

  if map.any(self.powers, function(p) return p:can_move(self.cell.pos, to_pos) end) then
    return true
  end

  local vec = self.cell.pos - to_pos -- movement vector
  return (vec.x == 0 or vec.y == 0) and vec:length2() == 1
end

-- if cannot be jumed by opponent Stone
function Stone:is_jump_protected()
  return map.any(self.powers, function(p) return p.is_jump_protected end)
end

-- before Stone moved
function Stone:move_before(cell_from, cell_to)
  map.each(self.powers, function(p) p:move_before(cell_from, cell_to) end)
end
-------------------------------------------------------------------------------
function Stone:move_middle(cell_from, cell_to)
  local depth = log:trace(self, ":move_middle to ", cell_to):enter()
    if cell_from then
      ass(cell_from.Stone == self)
      cell_from:leave()           -- get Stone at from position
    end

    cell_to:receive(self)                    -- cell that actor is going to move to

    self.cell = cell_to

    for name, power in pairs(self.powers) do
      if power:move(vec) then
        log:exit(depth)
        return true
      end
    end

    self:update_group_pos()
  log:exit(depth)
end
-------------------------------------------------------------------------------
function Stone:move_after(cell_from, cell_to)
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
function Stone:select()
  local depth = log:trace(self, ":select"):enter()
    assert(self.isSelected == false)
    self.isSelected = true                    -- set selected
    self:update_group_pos()                  -- adjust group position
    self.abilities:show(self.env)           -- show abilities list
  log:exit(depth)
end
-------------------------------------------------------------------------------
-- to be called from Board. Use self.board:select instead
function Stone:deselect()
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
function Stone:add_ability()
  self.abilities:add(self.env)

  -- add ability mark
  if self.able == nil then
    cfg.cell.order = 1
    self.able = lay.image(self, cfg.cell, "src/battle/ability_".. Color.string(self.color).. ".png")
    cfg.cell.order = nil
  end
end
-------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------
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
-------------------------------------------------------------------------------
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


-------------------------------------------------------------------------------
-- PRIVATE---------------------------------------------------------------------
-------------------------------------------------------------------------------
-- touch listener function
function Stone:touch(event)
  --log:trace(self, ":touch phase ", event.phase)

  if self.board.model:who_move() ~= self.color then
    log:trace("  inactive color")
    return true
  end
  
  if event.phase == "began" then
    if self.isSelected == false then
      self.board:select(nil)                -- deselect another Stone
    end
    self:set_focus(event.id)
    self.mark = Vec.from(self.view)

  elseif self.isFocus then

    if event.phase == "moved" then
      local start = Vec(event.xStart, event.yStart)
      local shift = (Vec.from(event) - start) / Vec(self.board.view.xScale) + self.mark
      local proj = (shift / cfg.cell.size):round()
      Vec.copy(shift, self.view)

      if self.board.model:can_move(self.cell.pos, proj) then
        self:create_project()
        self.proj = proj
        Vec.copy(proj * cfg.cell.size, self.project)
      else
        self:remove_project()
        self.proj = nil
      end

    elseif event.phase == "ended" or event.phase == "cancelled" then
      self:set_focus(nil)
      self:remove_project()
      if self.proj then
        self.board:move(self.cell, self.proj)
        self.board:select(nil)              -- deselect any
        self.proj = nil
      else
        Vec.copy(self.cell.pos * cfg.cell.size, self.view) -- return to original position
        if self.isSelected then
          self.board:select(nil)            -- remove selection if was selected
        else
          self.board:select(self)           -- select this Stone
        end
      end
    end
  end

  return true
end
-------------------------------------------------------------------------------
function Stone:create_project()
  if not self.project then
    local path = "src/view/stone_"..Color.string(self.color).."_project.png"
    self.project = lay.image(self.board, cfg.cell, path)
    Vec.copy(self.view, self.project)
  end
end
-------------------------------------------------------------------------------
function Stone:remove_project()
  if self.project then
    self.project:removeSelf()
    self.project = nil
  end
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
  local pos = self.cell.pos * cfg.cell.size
  if self.isSelected then
    pos.y = pos.y - 10
  end
  Vec.copy(pos, self.view)
end

return Stone