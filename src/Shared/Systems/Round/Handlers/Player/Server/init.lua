local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedStorage.Types)

local PlayerHandler = script.Parent
local Handlers = PlayerHandler.Parent
local RoundSystem = Handlers.Parent
local Events = RoundSystem.Events

local event = Events.Event
local eventActions = require(event.Actions)

local _connections: { RBXScriptConnection } = {}

local function giveSkin(player: Player, role: Types.RoleType)
    
end

local function giveGun(player: Player, role: Types.RoleType)
    
end

local function equipPlayer(player: Player, role: Types.RoleType)
    giveSkin(player, role)
    giveGun(player, role) 
end

local function eventConnect(action: string, ...: any)
    local actions = {
        [eventActions.equipPlayer] = equipPlayer,
    }

    if actions[action] then
        actions[action](...)
    end
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