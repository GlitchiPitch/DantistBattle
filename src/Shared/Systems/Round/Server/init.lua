local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedStorage.Types)

local RoundSystem = script.Parent
local Events = RoundSystem.Events
local Handlers = RoundSystem.Handlers

local PlayerHandler = require(Handlers.Player)
local QuestsHandler = require(Handlers.Quests)

local event = Events.Event
local eventActions = require(event.Actions)

local remote = Events.Remote
local remoteActions = require(remote.Actions)

local _connections: { RBXScriptConnection } = {}

local function equipTeam(team: Types.TeamType)
    for role, player in team do
        event:Fire(eventActions.equipPlayer, player, role)
    end
end

local function teleportPlayers(team: Types.TeamType)
    for _, player in team do
        if player.Character then
            player.Character:PivotTo()
        end
    end
end

local function startRound()
    
end

local function startGame(team: Types.TeamType)
    equipTeam(team)
    teleportPlayers(team)
    startRound()
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
    PlayerHandler.initialize()

    table.insert(
        _connections,
        event.Event:Connect(eventConnect)
    )
end

return {
    initialize = initialize,
}