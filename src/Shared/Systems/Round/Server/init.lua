local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedStorage.Types)

local RoundSystem = script.Parent
local Events = RoundSystem.Events

local event = Events.Event
local eventActions = require(event.Actions)

local remote = Events.Remote
local remoteActions = require(remote.Actions)

local function startGame(team: Types.TeamType)
    
end

local function eventConnect(action: string, ...: any)
    local actions = {
        [eventActions.startGame] = startGame,
    }

    if actions[action] then
        actions[action](...)
    end
end

local function initialize()
    event.Event:Connect(eventConnect)
end

return {
    initialize = initialize,
}