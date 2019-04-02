local widget    = require 'widget'
local composer  = require 'composer'
local log       = require 'src.core.log'
local lay       = require 'src.core.lay'
local cfg       = require 'src.cfg'
local battle    = require 'src.scenes.battle'
local lobby     = require 'src.scenes.lobby'

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
    onPress = onPress,
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
  lay.image(self.view, cfg.view.battle.bg)

  local buttons = display.newGroup()

  buttons:insert(new_button('lobby', 'Play', lobby.goto_lobby))
  buttons:insert(new_button('battle', 'Solo', battle.goto_solo))
  buttons:insert(new_button('robots', 'Robots Arena', battle.goto_robots))

  if (platform ~= 'ios' and platform ~= 'tvos') then
    buttons:insert(new_button('exit', 'Exit', function() native.requestExit() end))
  end

  lay.column(buttons, 5)

  -- draw version
  lay.text(self, {text = cfg.version, vx=0, vy=90})

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
