local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedStorage.Types)
local Constants = require(ReplicatedStorage.Constants)

local GlobalTimer = ReplicatedStorage.GlobalTimer
local globalTimerEvent = GlobalTimer.Events.Event
local globalTimerEventActions = require(globalTimerEvent.Actions)

local RoundSystem = script.Parent
local Events = RoundSystem.Events
local Handlers = RoundSystem.Handlers
local Variables = RoundSystem.Variables

local PlayerHandler = require(Handlers.Player)
local QuestsHandler = require(Handlers.Quests)

local event = Events.Event
local eventActions = require(event.Actions)

local remote = Events.Remote
local remoteActions = require(remote.Actions)

local _connections: { [string]: RBXScriptConnection } = {}

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

local function increaseWave()
    -- change tooth decay to pulpitus
end

--[[
    1 wave tooth decay
    2 puplitus
    3 paradontitus
    4 tooths fell out
    5 game over
]]

local function reset()
    _connections["onCurrentWaveChanged"]:Disconnect()
    Variables.RoundTimer.Value = 0
    Variables.CurrentWave.Value = 0
end

local function finishRound()
    --[[
        if wave is game over player have decrease money
        every wave increase money to specific value
    ]]
    -- check healthy tooths
    reset()
end

local function updateRound()
    Variables.RoundTimer.Value -= 1
    if Variables.RoundTimer.Value <= 0 then
        print("game over")
        finishRound()
    elseif Variables.RoundTimer.Value % Constants.SUBROUND_TIME == 0 then
        Variables.CurrentWave.Value += 1
    end
end

local function startRound()
    local roundTask: Types.TaskType = {
        DeltaTime = 0,
        Interval = 1,
        Duration = Constants.ROUND_TIME,
        Action = updateRound,
    }

    local function onCurrentWaveChanged(value: number)
        
    end

    Variables.RoundTimer.Value = Constants.ROUND_TIME
    Variables.CurrentWave.Value = 1
    -- for quests handler
    event:Fire(eventActions.startRound)
    globalTimerEvent:Fire(globalTimerEventActions.addTaskToTimer, "ROUND", roundTask)

    _connections["onCurrentWaveChanged"] = Variables.CurrentWave.Changed:Connect(onCurrentWaveChanged)
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
    QuestsHandler.initialize()
    PlayerHandler.initialize()

    _connections["eventConnect"] = event.Event:Connect(eventConnect) 
end

return {
    initialize = initialize,
}