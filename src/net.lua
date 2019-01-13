local log       = require 'src.core.log'
local obj       = require 'src.core.obj'
local typ       = require 'src.core.typ'
local ass       = require 'src.core.ass'
local map       = require 'src.core.map'
local arr       = require 'src.core.arr'

local photon    = require 'plugin.photon'
local Client    = photon.loadbalancing.LoadBalancingClient
local const     = photon.loadbalancing.constants
local EVENT_CODE = 101
local MAX_SENDCOUNT = 5

local net = obj:extend('net')

-- net constructor
function net:new(on_join_room)
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

  client.logger:setLevel(photon.common.Logger.Level.WARN)
  client.sent_count = 0
  client.receive_count = 0

  function client:onRoomList(rooms) -- {roomName: loadbalancing.RoomInfo}
    if map.any(rooms, function(room) return room.isOpen end) then
      log:trace('join random room')
      self:joinRandomRoom()
    else
      local name = tostring(math.random(10000, 99999))
      log:trace('create room '.. name)
      self:createRoom(name)
    end
  end

  function client:onStateChange(state)
    if state == Client.State.JoinedLobby then
      --log:trace('joinRandomRoom')
      --self:joinRandomRoom()
      local name = tostring(math.random(10000, 99999))
      --log:trace('create room '.. name)
      --self:createRoom(name)
    end
  end

  function client:onJoinRoom(createdByMe)
    log:trace('room name '.. self:myRoom().name)
  end

  function client:onOperationResponse(errCode, errMsg, code, content)
--[[  if errCode ~= 0 then
      if code == const.OperationCode.JoinRandomGame then  -- master random room fail - try create
        log:trace("createRoom")
        self:createRoom("helloworld")
      else
        log:error(errCode, errMsg)
      end
    end --]]
  end

  function client:onError(code, msg)
    local log_depth = log:trace('net:onError('..
      'code='.. map.key(Client.PeerErrorCode, code)..', '..
      'msg='..msg..')'):enter()
    self.last_error = msg;
    log:exit(log_depth)
  end

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

  this.client = client
  ass(client:connectToRegionMaster("EU"))
  log:wrap_fn(client, 'onRoomList', {
    {name='rooms', tostring=function(v) return arr.tostring(map.keys(v)) end}}, 'client')
  log:wrap_fn(client, 'onJoinRoom', {{name='createdByMe'}}, 'client')
  log:wrap_fn(client, 'onStateChange', {{name='state', tostring=Client.StateToName}}, 'client')
  log:wrap_fn(client, 'onOperationResponse', {
    {name='errCode'},
    {name='errMsg'},
    {name='code', tostring=function (code) return map.key(const.OperationCode, code) end},
    {name='content', tostring=map.tostring}}, 'client')
  log:wrap_fn(client, 'onEvent', {
    {name='code'},
    {name='content', tostring=map.tostring},
    {name='actor'}}, 'client')

  -- start running
  function client:timer(event)
    if self.mRunning then
      --self:sendData()
      self:service()
    else
      timer.cancel(event.source)
    end
  end  
  client.mRunning = true
  timer.performWithDelay(200, client, 0)

  return this
end

--
log:wrap(net, 'new')

function net.test()
  print('test net..')
end

return net