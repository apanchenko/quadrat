local composer      = require "composer"
local space         = require 'src.model.space'
local playerid      = require 'src.model.playerid'
local cfg           = require 'src.model.cfg'
local log           = require 'src.core.log'
local ass           = require 'src.core.ass'
local typ           = require 'src.core.typ'
local env           = require 'src.core.env'
local agent         = require 'src.model.agent.package'

return function()
  env.space = space:new(cfg.board.cols, cfg.board.rows, 1)
  env.player_white = agent:get('random'):new(env, playerid.white)
  env.player_black = agent:get('random'):new(env, playerid.black)

  composer.gotoScene('src.scenes.battle', {effect = 'fade', time = 600, params = {env=env}})
end