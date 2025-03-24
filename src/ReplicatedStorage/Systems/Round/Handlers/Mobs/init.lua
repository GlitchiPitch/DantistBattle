local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GlobalUtility = ReplicatedStorage.Utility
local clearConnections = require(GlobalUtility.clearConnections)

local Handlers = script.Parent
local RoundSystem = Handlers.Parent

local Variables = RoundSystem.Variables
local Instances = require(RoundSystem.Instances)

local event = RoundSystem.Events.Event
local eventActions = require(event.Actions)

local Classes = script.Classes
local Tartar = require(Classes.Tartar)
local ToothDecay = require(Classes.ToothDecay)

local Mobas = {
	[1] = ToothDecay,
	[2] = Tartar,
}

local MOB_COUNT = 10
local _connections: { [string]: RBXScriptConnection } = {}
local _connectionKeys = {
	eventConnect = "eventConnect",
	onCurrentWaveChanged = "onCurrentWaveChanged",
}

local function clearMobs() 
	for _, v: Part in Instances.Map.Interact.MobSpawners:GetChildren() do
		v:ClearAllChildren()
	end
end

local function spawnMobs()
	local currentMob = Mobas[Variables.CurrentWave.Value]
	local _mobSpawners = Instances.Map.Interact.MobSpawners:GetChildren()
	-- TODO: at the future add difficult
	for _ = 1, MOB_COUNT do
		local _mob = currentMob.New()
		local _mobSpawner = _mobSpawners[math.random(#_mobSpawners)] :: Part
		_mob:Initialize(_mobSpawner)
	end
end

local function startRound()

	local function onCurrentWaveChanged(value: number)
		if value == 0 then return end
		spawnMobs()
	end

	_connections[_connectionKeys.onCurrentWaveChanged] = Variables.CurrentWave.Changed:Connect(onCurrentWaveChanged)
end

local function finishRound()

	clearMobs()
	clearConnections(_connections, function(connectIndex: string)
		return connectIndex ~= _connectionKeys.eventConnect
	end)
end

local function eventConnect(action: string, ...: any)
	local actions = {
		[eventActions.startRound] = startRound,
		[eventActions.finishRound] = finishRound,
	}

	if actions[action] then
		actions[action](...)
	end
end

local function initialize()
	_connections[_connectionKeys.eventConnect] = event.Event:Connect(eventConnect)
end

return { initialize = initialize }
