local log   = require 'src.core.log'
local typ   = require 'src.core.typ'
local ass   = require 'src.core.ass'


-- wrap
local wrp = {}

-- duplicate arr.tostring
local function arr_tostring(t)
  if #t == 0 then
    return ''
  end
  local res = tostring(t[1])
  for i = 2, #t do
    res = res.. ', '.. tostring(t[i])
  end
  return res
end

-- wrap function t.fn_name
-- @param arg_info - array of argument descriptions {name, type, tstr}
-- @param t_name - name of t
-- @param static - is function fn static (called via .)
function wrp.fn(t, fn_name, arg_infos, t_name, static)
  t_name = t_name or tostring(t)
  local call = 'wrp.fn('..t_name..', '..fn_name..')'

  ass.tab(t, 'first arg is not a table in '.. call)
  ass.str(fn_name, 'fn_name is not a string in '.. call)

  -- prepare arg_infos array
  arg_infos = arg_infos or {}
  for i = 1, #arg_infos do
    local info = arg_infos[i]

    info.name = info[1] -- first is name of the argument
    ass.str(info.name)

    info.type = (function(type)-- second typ.child
      if typ.is_simple(type) then
        return type
      end
      if typ.str.is(type) then
        return typ.metaname(type)
      end
      return typ.meta(type)
    end)(info[2] or info.name)
    ass.tab(info.type)
    ass.str(info.type.name)
    ass.fun(info.type.is)

    info.tostring = info[3] or tostring -- third is tostring function
    ass.fun(info.tostring)
  end

    -- original function
  local fn = t[fn_name]
  ass.fun(fn, 'no such function in '.. call)

  -- 
  local function arguments(call, args)
    local merged = args
    ass.eq(#arg_infos, #args, fn_name..' expected '..#arg_infos..' arguments, found '..#args..' in '..call)
    for i = 1, #args do
      local arg = args[i]
      local info = arg_infos[i];
      local argstr = info.tostring(arg)
      ass(info.type.is(arg), info.name..'='..argstr..' is not '..info.type.name.." in "..call)
      merged[i] = info.name.. '='.. argstr
    end
    return arr_tostring(merged)
  end

  -- define a new function
  if static then
    t[fn_name] = function(...)
      local call = t_name..'.'..fn_name
      local depth = log:trace(call..'('..arguments(call, {...})..')'):enter()
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