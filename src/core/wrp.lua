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
    info.type = (function(v) -- use anonymous function to get rid of elses
      if typ(v) then
        return v
      end
      if typ.str(v) then
        return typ.metaname(v)
      end
      if typ.tab(v) then
        return typ.meta(v)
      end
      if v == nil then
        return typ.metaname(info.name)
      end
      error(call.. ' - invalid type declaration '.. tostring(v))
    end)(info[2])
    ass(typ(info.type))

    log:info('arg '.. info.name.. ' of '.. tostring(info.type))

    -- third is tostring function
    info.tostring = info[3] or tostring 
    ass.fun(info.tostring)
  end

    -- original function
  local fn = t[fn_name]
  ass.fun(fn, call..' - no such function')

  -- 
  local function arguments(call, args)
    ass.eq(#arg_infos, #args, call..' expected '..#arg_infos..' arguments, found '..#args..' - ['..arr.tostring(args)..']')
    local res = ''
    for i = 1, #args do
      local arg = args[i]
      local info = arg_infos[i]
      local argstr = info.tostring(arg)
      local argtype = '['..type(arg)..']'
      --log:info(call.. ' check arg '.. tostring(i).. ': '.. info.name..'='..argstr.. ' is of '.. tostring(info.type))
      ass(info.type(arg), call..' '..info.name..'='..argstr..' is not of '.. tostring(info.type))
      if #res > 0 then
        res = res..', '
      end
      res = res.. info.name.. '='.. argstr
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
      ass(typ.is(self, t), 'self is not '..t_name..' in '..type_fn)
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

function wrp.info(t, fn, ...)
  wrp.fn(t, fn, {...}, {log = log.info})
end

return wrp