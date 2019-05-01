local log   = require 'src.core.log'
local typ   = require 'src.core.typ'
local ass   = require 'src.core.ass'
local arr   = require 'src.core.impl.arr'


-- wrap
local wrp = {}

-- wrap function t.fn_name
-- @param arg_info - array of argument descriptions {name, type, tstr}
-- @param t_name - name of t
-- @param static - is function fn static (called via .)
function wrp.fn(t, fn_name, arg_infos, opts)
  opts = opts or {}
  local t_name = opts.name or tostring(t)
  local log_fn = opts.log or log.trace

  local call = 'wrp.fn('..t_name..', '..fn_name..')'
  local depth = log:info(call):enter()

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
    info.type = info.type or (function(type) -- use anonymous function to get rid of elses
      if typ.is_simple(type) then
        return type
      end
      if typ.str.is(type) then
        return typ.metaname(type)
      end
      return typ.meta(type)
    end)(info[2])
    ass.tab(info.type)
    ass.str(info.type.name)
    ass.fun(info.type.is)

    -- third is tostring function
    info.tostring = info[3] or tostring 
    ass.fun(info.tostring)
  end

    -- original function
  local fn = t[fn_name]
  ass.fun(fn, call..' - no such function')

  -- 
  local function arguments(call, args)
    local merged = args
    ass.eq(#arg_infos, #args, call..' expected '..#arg_infos..' arguments, found '..#args..' - ['..arr.tostring(args)..']')
    if #args == 0 then
      return ''
    end    

    local function merge(arg, info)
      local argstr = info.tostring(arg)
      ass(info.type.is(arg), call..' '..info.name..'='..argstr..' is not '..info.type.name)
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
    local type_fn = t_name..'.'..fn_name
    t[fn_name] = function(...)
      local depth = log_fn(log, type_fn..'('..arguments(type_fn, {...})..')'):enter()
      local result = fn(...)
      log:exit(depth)
      if result then -- log function output
        log_fn(log, fn_name..' ->', result)
      end      
      return result
    end
  else
    local type_fn = t_name..':'..fn_name
    t[fn_name] = function(...)
      local args = {...}
      local self = table.remove(args, 1)
      ass(typ.meta(t).is(self), 'self is not '..t_name..' in '..type_fn)
      local call = tostring(self)..':['..t_name..']'..fn_name
      local depth = log_fn(log, call..'('..arguments(call, args)..')'):enter()

      -- check self state before call
      local fn_before = self[fn_name .. '_before']
      if fn_before then
        fn_before(...)
      end

      -- call original function
      local result = fn(...)

      -- check self state and result after call
      local fn_after = self[fn_name .. '_after']
      if fn_after then
        fn_after(...)
      end

      -- log result
      log:exit(depth)
      if result then -- log function output
        log_fn(log, fn_name..' ->', result)
      end

      return result
    end
  end
  log:exit(depth)
end

return wrp