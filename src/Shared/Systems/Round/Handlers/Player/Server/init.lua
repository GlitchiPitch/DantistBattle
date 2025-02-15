local PlayerHandler = script.Parent
local Handlers = PlayerHandler.Parent
local RoundSystem = Handlers.Parent
local Events = RoundSystem.Events

local event = Events.Event
local eventActions = require(event.Actions)

local _connections: { RBXScriptConnection } = {}

local function giveSkin()
    
end

local function giveGun()
    
end

local function equipPlayer()
    giveSkin()
    giveGun()    
end

local function eventConnect(action: string, ...: any)
    
end

local function initialize()
    table.insert(
        _connections,
        event.Event:Connect(eventConnect)
    )
end

return  {
    initialize = initialize,
}