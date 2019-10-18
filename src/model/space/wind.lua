local obj = require('src.lua-cor.obj')
local bro = require('src.lua-cor.bro')

-- Wind of changes
-- that blows from real world
-- towards observers
local Wind = obj:extend('Wind')

-------------------------------------------------------------------------------
function Wind:new()
  self = obj.new(self,
  {
    on_set_move      = bro('set_move'), -- delegate
    on_set_ability   = bro('set_ability'), -- delegate
    on_set_color     = bro('set_color'), -- delegate
    on_add_power     = bro('add_power'), -- delegate
    on_remove_power  = bro('remove_power'), -- delegate
    on_spawn_piece   = bro('spawn_piece'), -- delegate
    on_move_piece    = bro('move_piece'), -- delegate
    on_remove_piece  = bro('remove_piece'), -- delegate
    on_stash_piece   = bro('stash_piece'), -- delegate
    on_unstash_piece = bro('unstash_piece'), -- delegate
    on_spawn_jade    = bro('spawn_jade'), -- delegate
    on_remove_jade   = bro('remove_jade'), -- delegate
    on_modify_spot   = bro('modify_spot'), -- delegate
  })
  return self
end

-------------------------------------------------------------------------------
function Wind:listen(listener, name, subscribe)
  self[name]:listen(listener, subscribe)
end

-------------------------------------------------------------------------------
-- wrap functions
function Wind:wrap()
  local typ = require('src.lua-cor.typ')
  local wrp = require('src.lua-cor.wrp')
  local log = require('src.lua-cor.log').get('mode')
  local ex  = typ.new_ex(Wind)
  wrp.fn(log.trace, Wind, 'listen', ex, typ.tab, typ.str, typ.boo)
end

-- return module
return Wind