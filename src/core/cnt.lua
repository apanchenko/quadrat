local ass   = require 'src.core.ass'
local typ   = require 'src.core.typ'
local wrp   = require 'src.core.wrp'
local log   = require 'src.core.log'

-- Map id->object
-- where object have
--   .count     - optional number counts objects with same id
--   .id        - equal ids mean equal objects
--   :copy()    - create a copy of the object
local cnt = {}

-- Test if container has no objects
-- @param t     - container
function cnt.is_empty(t)
  return next(t) == nil
end

-- Add object to container
-- @param t     - container
-- @param obj   - object to add
-- @return      - resulting number of objects in container
function cnt.push(t, obj)
  local my = t[obj.id] -- exisitng object in container
  if my then
    if obj.count then -- if countable
      my.count = my.count + obj.count -- add count
      return my.count
    end
    return 1 -- non-countable, always 1
  end
  t[obj.id] = obj -- add new object to container
  return obj.count or 1
end

-- Try return requested count of objects
-- @param t     - container
-- @param id    - object identifier
-- @param count - number of objects to return
-- @return      - object copy with count
function cnt.pull(t, id, count)
  local my = t[id] -- identify existing object in container
  if my == nil then -- nothing found
    return nil -- so return nothing
  end
  if my.count == nil or my.count <= count then -- non-countable or have few
    t[id] = nil -- wipe out
    return my -- give up all
  end
  my.count = my.count - count -- have enough to left
  local copy = my:copy() -- make a copy to return
  copy.count = count -- return requested count
  return copy
end

-- Completely remove object by id
-- @param t     - container
-- @param id    - object identifier
-- @return      - object removed
function cnt.remove(t, id)
  local my = t[id] -- identify existing object in container
  t[id] = nil -- wipe out
  return my -- give up all
end

-- Get number of objects by id
-- @param t     - container
-- @param id    - object identifier
-- @return      - number of objects in container
function cnt.count(t, id)
  local my = t[id]
  if my == nil then
    return 0
  end
  return my.count or 1
end

-- MODULE ---------------------------------------------------------------------
function cnt.wrap()
  local wrap = function(fn, ...)
    wrp.fn(cnt, fn, {...}, {name='cnt', static=true, log=log.info})
  end
  local t = {'t', typ.tab}
  local id = {'id', typ.any}
  wrap('is_empty', t)
  wrap('push', t, {'obj', typ.tab})
  wrap('pull', t, id, {'count', typ.nat})
  wrap('remove', t, id)
  wrap('count', t, id)
end

--
function cnt.test()
  local t = {}
  ass(cnt.is_empty(t))

  local copy = function(self)
    return {id=self.id, count=self.count, copy=self.copy}
  end

  local res
  res = cnt.push(t, {id='a', copy=copy})
  res = cnt.push(t, {id='a', copy=copy})
  ass.eq(cnt.count(t, 'a'), 1)

  res = cnt.push(t, {id='b', count=2, copy=copy})
  res = cnt.push(t, {id='b', count=3, copy=copy})
  ass.eq(res, 5)

  res = cnt.pull(t, 'b', 4)
  ass.eq(res.count, 4)
  ass.eq(cnt.count(t, 'b'), 1)

  res = cnt.pull(t, 'b', 4)
  ass.eq(res.count, 1)
  ass.eq(cnt.count(t, 'b'), 0)

  res = cnt.pull(t, 'a', 1)
  ass.eq(cnt.count(t, 'a'), 0)
end

return cnt