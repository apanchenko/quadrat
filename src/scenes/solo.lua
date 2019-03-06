local composer      = require "composer"
local space         = require 'src.model.space'
local playerid      = require 'src.model.playerid'
local cfg           = require 'src.model.cfg'
local log           = require 'src.core.log'
local ass           = require 'src.core.ass'
local typ           = require 'src.core.typ'
local env           = require 'src.core.env'
local players       = require 'src.model.players.players'

return function()
  env.space = space:new(cfg.board.cols, cfg.board.rows, 1)
  env.player_white = players:get('user'):new(env, playerid.white)
  env.player_black = players:get('random'):new(env, playerid.black)

  composer.gotoScene('src.scenes.battle', {effect = 'fade', time = 600, params = env})
end