local log   = require 'src.core.log'
local typ   = require 'src.core.typ'
local ass   = require 'src.core.ass'
local arr   = require 'src.core.arr'


-- wrap
local wrp = {}

-- prepare argument description for wrp.fn
-- @param name - name of argument
-- @param type - one of core.typ to check type info
-- @param tstr - tostring function for logging
function wrp.arg(name, type, tstr)
  local desc =
  {
    name  = name,
    tstr  = tstr or tostring
  }

  if type == nil or typ.str.is(type) then
    desc.type = typ.metaname(name)
  else
    desc.type = type
  end

  return desc
end

-- wrap function t.fn_name
-- @param arg_info - array of argument descriptions {name, type, tstr} @see wrp.arg
-- @param t_name - name of t
-- @param static - is function fn static (called via .)
function wrp.fn(t, fn_name, arg_info, t_name, static)
  t_name = t_name or tostring(t)
  local call = 'wrp.fn('..t_name..', '..fn_name..')'

  ass.tab(t, 'first arg is not a table in '.. call)
  ass.str(fn_name, 'fn_name is not a string in '.. call)

    -- original function
  local fn = t[fn_name]
  ass.fun(fn, 'no such function in '.. call)

  local function arguments(call, args)
    local merged = args
    if arg_info then
      ass.eq(#arg_info, #args, fn_name..' expected '..#arg_info..' arguments, found '..#args..' in '..call)
      for i = 1, #args do
        local arg = args[i]
        local inf = arg_info[i];
        ass(inf.type.is(arg), inf.name..'='..tostring(arg)..' is not '..inf.type.name.." in "..call)
        merged[i] = inf.name.. '='.. inf.tstr(arg)
      end
    end
    return arr.tostring(merged)
  end

  -- define a new function
  if static then
    t[fn_name] = function(...)
      local call = t_name..'.'..fn_name
      local depth = log:trace(call..'('..arguments(call, arg)..')'):enter()
      local result = fn(...)
      log:exit(depth)
      return result
    end
  else
    t[fn_name] = function(...)
      local args = {...}
      local self = table.remove(args, 1)
      local call = tostring(self)..':'..fn_name
      local depth = log:trace(call..'('..arguments(call, args)..')'):enter()
      local result = fn(...)
      log:exit(depth)
      return result
    end
  end
end

return wrp