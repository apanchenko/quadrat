local log       = require 'src.core.log'
local obj       = require 'src.core.obj'
local typ       = require 'src.core.typ'
local ass       = require 'src.core.ass'
local map       = require 'src.core.map'

local photon    = require 'plugin.photon'
local Client    = photon.loadbalancing.LoadBalancingClient
local Constants = photon.loadbalancing.constants
local tableutil = photon.common.util.tableutil
local Logger    = photon.common.Logger

local EVENT_CODE = 101
local MAX_SENDCOUNT = 5

local net = obj:extend('net')

-- constructor
function net:new()
  self = obj.new(self,
  {
    serverAddress = "ns.exitgames.com:5058",
    appId = "a5aaee83-7690-404e-b43c-d7c2de4646fe",
    appVersion = "1.0",
  })
  local client = Client.new(self.serverAddress, self.appId, self.appVersion)
  client.logger:setLevel(Logger.Level.WARN)

  function client:onOperationResponse(errCode, errMsg, code, content)
    local log_content_prefix = '\n'.. string.rep('  ', log.depth + 1).. '| '
    local log_depth = log:trace('client:onOperationResponse('..
      'errCode='.. tostring(errCode).. ', '..
      'errMsg='.. tostring(errMsg).. ', '..
      'code='.. tostring(code).. ', '..
      'content='.. map.tostring(content, log_content_prefix).. ')'):enter()

    if errCode ~= 0 then
      if code == Constants.OperationCode.JoinRandomGame then  -- master random room fail - try create
        log:trace("createRoom")
        self:createRoom("helloworld")
      else
        log:error(errCode, errMsg)
      end
    end

    log:exit(log_depth)
  end

  function client:onStateChange(state)
    local log_depth = log:trace('client:onStateChange', Client.StateToName(state)):enter()
    if state == Client.State.JoinedLobby then
        log:trace('joinRandomRoom')
        self:joinRandomRoom()
    end
    log:exit(log_depth)
  end

  function client:onError(code, msg)
    --[[
    Ok No Error.
    MasterError General Master server peer error.
    MasterConnectFailed Master server connection error.
    MasterConnectClosed Disconnected from Master server.
    MasterTimeout Disconnected from Master server for timeout.
    MasterEncryptionEstablishError Master server encryption establishing failed.
    MasterAuthenticationFailed Master server authentication failed.
    GameError General Game server peer error.
    GameConnectFailed Game server connection error.
    GameConnectClosed Disconnected from Game server.
    GameTimeout Disconnected from Game server for timeout.
    GameEncryptionEstablishError Game server encryption establishing failed.
    GameAuthenticationFailed Game server authentication failed.
    NameServerError General NameServer peer error.
    NameServerConnectFailed NameServer connection error.
    NameServerConnectClosed Disconnected from NameServer.
    NameServerTimeout Disconnected from NameServer for timeout.
    NameServerEncryptionEstablishError NameServer encryption establishing failed.
    NameServerAuthenticationFailed NameServer authentication failed.
    --]]
    self.logger:error(code, msg)
    self.last_error = msg;
  end

  function client:onEvent(code, content, actorNr)
    self.logger:debug("on event", code, tableutil.toStringReq(content))
    if code == EVENT_CODE then
        client.mReceiveCount = client.mReceiveCount + 1
        client.mLastReceiveEvent = content[2]
        if client.mReceiveCount == MAX_SENDCOUNT then
            self.mState = "Data Received"    
            client:disconnect();
        end
    end
  end

  client.mState = "Init"
  client.mLastSentEvent = ""
  client.mSendCount = 0
  client.mReceiveCount = 0
  client.mLastReceiveEvent= ""
  client.mRunning = true

  function client:update()
    self:sendData()
    self:service()
  end

  function client:sendData()
    if self:isJoinedToRoom() and self.mSendCount < MAX_SENDCOUNT then
        self.mState = "Data Sending"    
        local data = {}
        self.mLastSentEvent = "e" .. self.mSendCount
        data[2] = self.mLastSentEvent
        data[3] = string.rep("x", 160)
        self:raiseEvent(EVENT_CODE, data, { receivers = Constants.ReceiverGroup.All } ) 
        self.mSendCount = self.mSendCount + 1
        if self.mSendCount >= MAX_SENDCOUNT then
            self.mState = "Data Sent"
        end
    end
  end

  function client:getStateString()
    local res = Client.StateToName(self.state)..
      "\n\nevents: ".. self.mState..
      "\nsent "..self.mLastSentEvent..", total: "..self.mSendCount..
      "\nreceived "..self.mLastReceiveEvent..", total: "..self.mReceiveCount
      if self.last_error then
        res = res.. "\n\n".. self.last_error
      end
    return res
  end

  local prevStr = ""
  function client:timer(event)
    local str = nil
    if self.mRunning then
        self:update()
    else
        timer.cancel(event.source)
        self.mState = "Stopped"
    end

    str = client:getStateString()
    if prevStr ~= str then
        prevStr = str
        print("\n\n")
        print(str)
    end
  end

  self.client = client
  ass(client:connectToRegionMaster("EU"))

  timer.performWithDelay(200, client, 0)
  return self
end

--
log:wrap(net, 'new')

return net