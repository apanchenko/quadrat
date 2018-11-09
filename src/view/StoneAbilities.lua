local _         = require 'src.core.underscore'
local widget    = require "widget"
local vec       = require "src.core.Vec"
local Ability   = require "src.battle.powers.Ability"
local Color     = require 'src.model.Color'
local cfg       = require 'src.Config'
local lay       = require 'src.core.lay'
local Ass       = require 'src.core.Ass'
local log       = require 'src.core.log'
local Type      = require 'src.core.Type'

local StoneAbilities = Type.Create('StoneAbilities')

-- A set of abilities a piece have.
function StoneAbilities.New(stone, model)
  Ass.Is(stone, 'Stone')
  Ass.Is(model, 'Space')
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
-- add ability
function StoneAbilities:add(name)
  local count = self._list[name]
  if count == nil then
    self._list[name] = 1
  else
    self._list[name] = count + 1
  end
  -- add ability mark
  if self._mark == nil then
    self._mark = lay.image(self._stone, cfg.cell, "src/battle/ability_"..tostring(self._stone:color())..".png")
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
      self:use(event.target.id)
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
  assert(self._view)                        -- check shown
  self._view:removeSelf()
  self._view = nil
end

-- use instant ability or create power
function StoneAbilities:use(name)
  if self:is_empty() and self._mark then
    self._mark:removeSelf()
    self._mark = nil
  end
  self._model:use(self._stone:pos(), name)
end


--MODEULE----------------------------------------------------------------------
Ass.Wrap(StoneAbilities, 'add', 'string')
Ass.Wrap(StoneAbilities, 'is_empty')
Ass.Wrap(StoneAbilities, 'show')
Ass.Wrap(StoneAbilities, 'hide')
Ass.Wrap(StoneAbilities, 'use', 'string')

log:wrap(StoneAbilities, 'add', 'show', 'hide', 'use')

return StoneAbilities