local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Systems = ReplicatedStorage.Systems

local Types = require(ReplicatedStorage.Types)
local RoundSystem = Systems.Round
local roundSystemEvent = RoundSystem.Events.Event
local roundSystemEventActions = require(roundSystemEvent.Actions)

local TeamSystem = script.Parent
local Events = TeamSystem.Events

local event = Events.Event
local eventActions = require(event.Actions)

local _connections: { RBXScriptConnection } = {}

--[[
    функция что будет получать всех уже готовых игроков
    и сделать отдельную функцию которая будет собирать к примеру по кнопкам, или плитам игроков и потом отправлять в функцию выше
]]

local function teamReady(team: Types.TeamType)
    roundSystemEvent:Fire(roundSystemEventActions.startGame, team)
end

local function eventConnect(action: string, ...: any)
    local actions = {
        [eventActions.teamReady] = teamReady,
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

return {
    initialize = initialize,
}