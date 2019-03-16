local log       = require 'src.core.log'
local obj       = require 'src.core.obj'
local typ       = require 'src.core.typ'
local ass       = require 'src.core.ass'
local map       = require 'src.core.map'
local arr       = require 'src.core.arr'
local wrp       = require 'src.core.wrp'

local photon    = require 'plugin.photon'
local Client    = photon.loadbalancing.LoadBalancingClient
local const     = photon.loadbalancing.constants
local EVENT_CODE = 101
local MAX_SENDCOUNT = 5

local net = obj:extend('net')

-- net constructor
function net:new()
  this = obj.new(self,
  {
    serverAddress = "ns.exitgames.com:5058",
    appId         = "a5aaee83-7690-404e-b43c-d7c2de4646fe",
    appVersion    = "0.0.1",
  })

  -- create photon client
  local client = Client.new(this.serverAddress, this.appId, this.appVersion,
  {
    initRoom = function(client, room)
      function room:onPropertiesChange(changedCustomProps, byClient) 
        if not byClient then
          --client.game:updateStateFromProps(changedCustomProps)
        end
      end
      return room
    end,

    initActor = function(client, actor)
      return actor
    end
  })

  -- callback on error
  function client:onError(code, msg)
    if this.on_error then
      this.on_error()
    end
  end
  wrp.fn(client, 'onError', {
    {'code', typ.num, function(code) return map.key(Client.PeerErrorCode, code) end},
    {'msg', typ.str}}, 'client')

  -- react to state change
  function client:onStateChange(state)
  end    
  wrp.fn(client, 'onStateChange', {{'state', typ.num, Client.StateToName}}, 'client')

  function client:onOperationResponse(errCode, errMsg, code, content)
  end
  wrp.fn(client, 'onOperationResponse', {
    {'errCode', typ.num},
    {'errMsg', typ.str},
    {'code', typ.num, function(code) return map.key(const.OperationCode, code) end},
    {'content', typ.tab, map.tostring}}, 'client')

  client.logger:setLevel(photon.common.Logger.Level.WARN)
  client.sent_count = 0
  client.receive_count = 0
 
  this.client = client
  return this
end

-- find worthy opponent
function net:find_opponent(on_opponent, on_error)
  self.on_error = on_error
  local client = self.client

  function client:onRoomList(rooms) -- {roomName: loadbalancing.RoomInfo}
    if map.any(rooms, function(room) return room.isOpen end) then
      log:trace('join random room')
      self:joinRandomRoom()
    else
      local room_name = tostring(math.random(10000, 99999))
      log:trace('create room '.. room_name)
      self:createRoom(room_name)
    end
  end

  function client:onJoinRoom(createdByMe)
    local room = self:myRoom()
    local room_name = room.name
    log:trace('room name '..room_name)

    -- i am second, can play here
    if room.playerCount == 2 then
      local room_id = tonumber(room_name)
      on_opponent(room_id, createdByMe)
    end
  end

  function client:onActorJoin(actor)
    local room = self:myRoom()
    if room.playerCount == 2 then
      local room_id = tonumber(room.name)
      on_opponent(room_id, createdByMe)
    end
  end
  wrp.fn(client, 'onActorJoin', {
    {'actor', typ.tab, function(actor) return tostring(actor.actorNr) end}}, 'client')

  function client:sendData()
    if self:isJoinedToRoom() and self.sent_count < MAX_SENDCOUNT then
      local data = {}
      data[2] = "e" .. self.sent_count
      data[3] = string.rep("x", 160)
      self:raiseEvent(EVENT_CODE, data, { receivers = const.ReceiverGroup.All } ) 
      self.sent_count = self.sent_count + 1
    end
  end

  function client:onEvent(code, content, actorNr)
    if code == EVENT_CODE then
      self.receive_count = self.receive_count + 1
      if self.receive_count == MAX_SENDCOUNT then
        self:disconnect();
      end
    end
  end

  ass(client:connectToRegionMaster("EU"))

  wrp.fn(client, 'onRoomList', {
    {'rooms', typ.tab, function(v) return arr.tostring(map.keys(v)) end}}, 'client')
  wrp.fn(client, 'onJoinRoom', {{'createdByMe', typ.boo}}, 'client')
  wrp.fn(client, 'onEvent', {
    {'code', typ.num},
    {'content', typ.tab, map.tostring},
    {'actor', typ.tab}}, 'client')


  -- start running
  function client:timer(event)
    if self.is_running then
      --self:sendData()
      self:service()
    else
      timer.cancel(event.source)
    end
  end
  client.is_running = true
  timer.performWithDelay(200, client, 0)
end

-- MODULE ---------------------------------------------------------------------
-- wrap functions
function net.wrap()
  wrp.fn(net, 'new')
end

function net.test()
  print('test net..')
end

return net