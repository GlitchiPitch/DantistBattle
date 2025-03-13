local Handlers = script.Parent
local RoundSystem = Handlers.Parent

local Variables = RoundSystem.Variables
local Instances = require(RoundSystem.Instances)

local event = RoundSystem.Events.Event
local eventActions = require(event.Actions)

local Classes = script.Classes
local TartarClass = require(Classes.TartarClass)
local ToothDecayMonster = require(Classes.ToothDecayMonster)

local Mobas = {
    [1] = ToothDecayMonster,
    [2] = TartarClass, -- Tartar
}

local MOB_COUNT = 10

local function clearMobs()
    
end

local function spawnMobs()
    local currentMob = Mobas[Variables.CurrentWave.Value]
    local _mobSpawners = Instances.Map.MobSpawners:GetChildren()
    -- TODO: at the future add difficult
    for _ = 1, MOB_COUNT do
        local _mob = currentMob.New()
        local _mobSpawner = _mobSpawners[math.random(#_mobSpawners)] :: Part
        _mob:Initialize(_mobSpawners)
    end
end

local function startRound()
    spawnMobs()
end

local function eventConnect(action: string, ...: any)
    local actions = {
        [eventActions.startRound] = startRound,
    }
    
    if actions[action] then
        actions[action](...)
    end
end

local function initialize()
    event.Event:Connect(eventConnect)
end


return { initialize = initialize }