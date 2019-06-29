local widget    = require 'widget'
local cfg       = require 'src.cfg'
local lay       = require 'src.lua-cor.lay'
local ass       = require 'src.lua-cor.ass'
local log       = require('src.lua-cor.log').get('view')
local obj       = require 'src.lua-cor.obj'
local typ       = require 'src.lua-cor.typ'
local map       = require 'src.lua-cor.map'
local cor       = require 'src.lua-cor.cor'

local stoneAbilities = obj:extend('stoneAbilities')

-- A set of abilities a piece have.
function stoneAbilities:new(stone)
  local this = obj.new(self, cor.com())
  this._list = {} -- list of abilities
  this._stone = stone -- owner
  return this
end

--
function stoneAbilities:__tostring() 
  return "abilities"
end

-- add ability
function stoneAbilities:set_count(id, count)
  ass.ge(count, 0)

  if count == 0 then
    self._list[id] = nil
  else
    self._list[id] = count
  end

  if count > 0 then
    local pid = self._stone:get_pid()
    self._stone._view.show('ability_'..tostring(pid))
  end

  local reshow = self._view ~= nil

  if reshow then
    self:hide()
  end

  if self:is_empty() then
    self._stone._view.hide('ability_white')
    self._stone._view.hide('ability_black')
  else
    if reshow then
      self:show()
    end
  end
end

-- return true if empty
function stoneAbilities:is_empty()
  return map.count(self._list) == 0
end

-- show on board
function stoneAbilities:show()
  assert(self.view == nil)                 -- check is hidden now
  self._view = display.newGroup()

  for name, count in pairs(self._list) do     -- create new button
    local opts = cfg.view.abilities.button
    opts.id = name
    opts.label = name
    if count > 1 then
      opts.label = opts.label.. ' '.. count
    end
    opts.onRelease = function(event)
      cor.env.space:use(self._stone:pos(), event.target.id)
      return true
    end
    --log.trace(opts.label)
    lay.new_button(self._view, opts)
  end
  --lay.column(self._view, 3)
  lay.rows(self._view, cfg.view.abilities.rows)
  lay.insert(cor.env.battle.view, self._view, cfg.view.abilities)
end

-- hide from board when piece deselected
function stoneAbilities:hide()
  if self._view then -- check shown
    self._view:removeSelf()
    self._view = nil
  end
end

--
function stoneAbilities:wrap()
  local is   = {'stoneAbilities', typ.new_is(stoneAbilities)}
  local ex    = {'exstoneAbilities', typ.new_ex(stoneAbilities)}
  cor.wrp(log.trace, stoneAbilities, 'new',       is, {'stone'})
  cor.wrp(log.trace, stoneAbilities, 'set_count', ex, {'id', typ.str}, {'count', typ.num})
  cor.wrp(log.info, stoneAbilities, 'is_empty', ex)
  cor.wrp(log.trace, stoneAbilities, 'show', ex)
  cor.wrp(log.trace, stoneAbilities, 'hide', ex)
end

--
return stoneAbilities