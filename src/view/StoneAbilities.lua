local _         = require 'src.core.underscore'
local widget    = require "widget"
local vec       = require "src.core.vec"
local Color     = require 'src.model.Color'
local cfg       = require 'src.Config'
local lay       = require 'src.core.lay'
local ass       = require 'src.core.ass'
local log       = require 'src.core.log'
local Class     = require 'src.core.Class'
local types     = require 'src.core.types'

local StoneAbilities = Class.Create('StoneAbilities')

-- A set of abilities a piece have.
function StoneAbilities.New(stone, model)
  local self = setmetatable({}, StoneAbilities)
  self._list = {} -- list of abilities
  self._stone = stone -- owner
  self._model = model
  self._mark = nil -- image marking that piece have abilities
  return self
end
--
function StoneAbilities:__tostring() 
  return "abilities"
end

-------------------------------------------------------------------------------
-- add ability
function StoneAbilities:add(name)
  local count = self._list[name]
  if count == nil then
    self._list[name] = 1
  else
    self._list[name] = count + 1
  end
  if self._mark == nil then
    self._mark = lay.image(self._stone, cfg.cell, "src/view/ability_"..tostring(self._stone:color())..".png")
  end
end

-- remove ability
function StoneAbilities:remove(name)
  local count = self._list[name]
  if count == 1 then
    self._list[name] = nil
  else
    self._list[name] = count - 1
  end
  local reshow = self._view ~= nil
  if reshow then self:hide() end
  if self:is_empty() then
    self._mark:removeSelf()
    self._mark = nil
  else
    if reshow then self:show() end
  end
end

-- return true if empty
function StoneAbilities:is_empty()
  return _.is_empty(self._list)
end

-- show on board
function StoneAbilities:show()
  assert(self.view == nil)                 -- check is hidden now
  self._view = display.newGroup()

  for name, count in pairs(self._list) do     -- create new button
    local opts = cfg.abilities.button
    opts.id = name
    opts.label = name.. ' '.. count
    opts.onRelease = function(event)
      self._model:use(self._stone:pos(), event.target.id)
      return true
    end
    log:trace(opts.label)
    lay.render(self._view, widget.newButton(opts), {})
  end
  lay.column(self._view)
  lay.render(self._stone.board.battle, self._view, cfg.abilities)
end

-- hide from board when piece deselected
function StoneAbilities:hide()
  if self._view then -- check shown
    self._view:removeSelf()
    self._view = nil
  end
end

--MODEULE----------------------------------------------------------------------
--
ass.wrap(StoneAbilities, ':add', types.str)
ass.wrap(StoneAbilities, ':remove', types.str)
ass.wrap(StoneAbilities, ':is_empty')
ass.wrap(StoneAbilities, ':show')
ass.wrap(StoneAbilities, ':hide')

log:wrap(StoneAbilities, 'add', 'remove', 'show', 'hide')
--]]
return StoneAbilities