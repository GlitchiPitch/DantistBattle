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

local Instances = require(RoundSystem.Instances)
local PlayerHandler = require(Handlers.Player)
local QuestsHandler = require(Handlers.Quests)
local MobHandler = require(Handlers.Mobs)

local event = Events.Event
local eventActions = require(event.Actions)

-- local remote = Events.Remote
-- local remoteActions = require(remote.Actions)

local _connections: { [string]: RBXScriptConnection } = {}
local _connectionKeys = {
	eventConnect = "eventConnect",
}

local function teleportPlayers(team: Types.TeamType)
	local spawner = Instances.Map.Interact.SpawnLocations:GetChildren()[1] :: Part
	for _, player in team do
		if player.Character then
			player.Character:PivotTo(spawner.CFrame * CFrame.new(0, 5, 0))
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

	Variables.RoundTimer.Value = Constants.ROUND_TIME
	Variables.CurrentWave.Value = 1
	-- for quests handler & mobs handler
	event:Fire(eventActions.startRound)
	globalTimerEvent:Fire(globalTimerEventActions.addTaskToTimer, "ROUND", roundTask)

end

local function startGame(team: Types.TeamType)
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
	MobHandler.initialize()

	_connections[_connectionKeys.eventConnect] = event.Event:Connect(eventConnect)
end

return { initialize = initialize }
