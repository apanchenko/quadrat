local Pos = require("src.Pos")
local Player = require("src.Player")

-------------------------------------------------------------------------------
local Piece = {}
Piece.__index = Piece
setmetatable(Piece, {__call = function(cls, ...) return cls.new(...) end})

-------------------------------------------------------------------------------
-- group - display group
-- color - is red or black
-- img   - image, piece view
-- scale - number
-- i, j  - int number, position on board
function Piece.new(color)
  local self = setmetatable({}, Piece)
  self.group = display.newGroup()
  self.color = color
  self.img = Piece._new_image(self.group, "src/piece_"..Player.tostring(self.color)..".png")
  self.scale = 1
  self.group:addEventListener("touch", self)
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
  if self.board.color ~= self.color then
    return true
  end
  
  if event.phase == "began" then
    self:_set_focus(event.id)
    self.mark = Pos.from(self.group)

  elseif self.isFocus then
    
    if event.phase == "moved" then
      local start = Pos(event.xStart, event.yStart)
      local shift = (Pos.from(event) - start) / self.board.scale + self.mark
      local proj = (shift / Cell.size):round()
      Pos.copy(shift, self.group)

      if self.board:can_move(self.pos, proj) then
        self:_create_project()
        self.proj = proj
        Pos.copy(proj * Cell.size, self.project)
      else
        self:_remove_project()
        self.proj = nil
      end
    
    elseif event.phase == "ended" or event.phase == "cancelled" then
      self:_set_focus(nil)
      self:_remove_project()
      if self.proj then
        self.board:move(self.pos, self.proj)
        self.proj = nil
      else
        Pos.copy(self.pos * Cell.size, self.group) -- return to original position
      end
    end
  end

  return true
end

-------------------------------------------------------------------------------
-- insert piece into group, with scale for dragging
function Piece:puton(board, pos)
  board.group:insert(self.group)
  self.board = board
  self:move(pos)
end

-------------------------------------------------------------------------------
function Piece:move(to)
  self.pos = to
  Pos.copy(to * Cell.size, self.group)
end

-------------------------------------------------------------------------------
function Piece:_create_project()
  if not self.project then
    self.project = Piece._new_image(self.board.group, "src/piece_"..Player.tostring(self.color).."_project.png")
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
function Piece._new_image(group, name)
  local img = display.newImageRect(group, name, 64, 64)
  img.anchorX = 0
  img.anchorY = 0
  return img
end

-------------------------------------------------------------------------------
function Piece:_set_focus(eventId)
  display.getCurrentStage():setFocus(self.group, eventId)
  self.isFocus = (eventId ~= nil)
end

return Piece