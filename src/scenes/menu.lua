local widget    = require 'widget'
local composer  = require 'composer'
local log       = require 'src.core.log'
local lay       = require 'src.core.lay'
local app_cfg   = require 'src.cfg'
local cfg       = require 'src.model.cfg'
local solo      = require 'src.scenes.solo'
local exit      = require 'src.scenes.exit'

local menu = composer.newScene()
local platform = system.getInfo('platform')

local options = {effect = 'fade', time = 600}

-------------------------------------------------------------------------------
-- create new button
local function new_button(id, label, onPress)
  return widget.newButton {
    x = display.contentCenterX,
    y = 0,
    id = id,
    label = label,
    onPress = function(event) onPress() return true end,
    emboss = false,
    font = native.systemFont,
    fontSize = 17,
    shape = 'roundedRect',
    width = 250,
    height = 32,
    cornerRadius = 9,
    fillColor = {default = {0.6, 0.7, 0.8, 1}, over = {0.6, 0.7, 0.8, 0.8}},
    labelColor = {default = {1.0, 1.0, 1.0, 1}, over = {1.0, 1.0, 1.0, 1.0}},
    strokeColor = {default = {1.0, 0.4, 0.0, 1}, over = {0.8, 0.8, 1.0, 1.0}},
    strokeWidth = 0
  }
end

-------------------------------------------------------------------------------
function menu:create(event)
  print('menu:new')
  lay.image(self.view, cfg.battle.bg)

  local buttons = display.newGroup()

  buttons:insert(new_button('lobby', 'Play', function() composer.gotoScene('src.scenes.lobby', options) end))
  buttons:insert(new_button('battle', 'Solo', solo))

  if (platform ~= 'ios' and platform ~= 'tvos') then
    buttons:insert(new_button('exit', 'Exit', exit))
  end

  lay.column(buttons, 5)

  -- draw version
  lay.text(self, {text=app_cfg.version, vx=0, vy=90})

  lay.render(self, buttons, {vx=0, vy=15})
end

-------------------------------------------------------------------------------
function menu:show(event)
  print('menu:show')
  local sceneGroup = self.view
  local phase = event.phase

  if (phase == 'will') then
    -- Code here runs when the menu is still off screen (but is about to come on screen)
  elseif (phase == 'did') then
  -- Code here runs when the menu is entirely on screen
  end
end

-------------------------------------------------------------------------------
function menu:hide(event)
  local sceneGroup = self.view
  local phase = event.phase

  if (phase == 'will') then
    -- Code here runs when the menu is on screen (but is about to go off screen)
  elseif (phase == 'did') then
  -- Code here runs immediately after the menu goes entirely off screen
  end
end

-------------------------------------------------------------------------------
function menu:destroy(event)
  print('menu:destroy')
end

menu:addEventListener('create', menu)
menu:addEventListener('show', menu)
menu:addEventListener('hide', menu)
menu:addEventListener('destroy', menu)

return menu
