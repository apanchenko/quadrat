local log   = require 'src.core.log'
local typ   = require 'src.core.typ'
local ass   = require 'src.core.ass'


-- wrap
local wrp = {}

-- wrap function t.fn_name
-- @param arg_info - array of argument descriptions {name, type, tstr}
-- @param t_name - name of t
-- @param static - is function fn static (called via .)
function wrp.fn(t, fn_name, arg_infos, opts)
  opts = opts or {}
  local t_name = opts.name or tostring(t)
  local log_fn = opts.log_fn or log.trace
  local call = 'wrp.fn('..t_name..', '..fn_name..')'

  ass.tab(t, 'first arg is not a table in '.. call)
  ass.str(fn_name, 'fn_name is not a string in '.. call)
  ass.fun(log_fn)

  -- prepare arg_infos array
  arg_infos = arg_infos or {}
  for i = 1, #arg_infos do
    local info = arg_infos[i]

    -- first is name of the argument
    info.name = info[1]
    ass.str(info.name)

    -- second typ.child
    info.type = (function(type) -- use anonymous function to get rid of elses
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

    -- third is tostring function
    info.tostring = info[3] or tostring 
    ass.fun(info.tostring)
  end

    -- original function
  local fn = t[fn_name]
  ass.fun(fn, 'no such function in '.. call)

  -- 
  local function arguments(call, args)
    local merged = args
    ass.eq(#arg_infos, #args, ' expected '..#arg_infos..' arguments, found '..#args..' in '..call)
    if #args == 0 then
      return ''
    end    

    local function merge(arg, info)
      local argstr = info.tostring(arg)
      ass(info.type.is(arg), info.name..'='..argstr..' is not '..info.type.name.." in "..call)
      return info.name.. '='.. argstr
    end

    local res = merge(args[1], arg_infos[1])
    for i = 2, #args do
      res = res.. ', '.. merge(args[i], arg_infos[i])
    end
    return res
  end

  -- define a new function
  if opts.static then
    t[fn_name] = function(...)
      local call = t_name..'.'..fn_name
      local depth = log_fn(log, call..'('..arguments(call, {...})..')'):enter()
      local result = fn(...)
      log:exit(depth)
      return result
    end
  else
    t[fn_name] = function(...)
      local args = {...}
      local self = table.remove(args, 1)
      local call = tostring(self)..':'..fn_name
      local depth = log_fn(log, call..'('..arguments(call, args)..')'):enter()
      local result = fn(...)
      log:exit(depth)
      return result
    end
  end
end

return wrp