local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedStorage.Types)

local Map: Folder & { 
    Interact: Folder & {
        SpawnLocations: Folder & { Part },
        MonsterSpawners: Folder & { Part },
        Monsters: Folder & { 
            Tartar: Folder & { Model },
            ToothDecay: Folder & { Model },
         },
        Tooths: Folder & { Part },
        Saliva: Part,
    }
 }

local GlobalTimer = ReplicatedStorage.GlobalTimer
local globalTimerEvent = GlobalTimer.Events.Event
local globalTimerEventActions = require(globalTimerEvent.Actions)

local QuestsHandler = script.Parent
local Handlers = QuestsHandler.Parent
local RoundSystem = Handlers.Parent
local RoundSystemVariables = RoundSystem.Variables

local MobsHandler = require(Handlers.Mobs)

local roundSystemEvent = RoundSystem.Events.Event
local roundSystemEventActions = require(roundSystemEvent.Actions)

local _connections: { RBXScriptConnection } = {}
local _connectionKeys = {
    onCurrentWaveChanged = "onCurrentWaveChanged",
    roundSystemEventConnect = "roundSystemEventConnect",
}
local _taskKeys = {
    spawnTartars = "spawnTartars",
    spawnToothDecayMonsters = "spawnToothDecayMonsters",
    spawnSaliva = "spawnSaliva",
}

local function spawnMobs(interval: number, mobFolder: Folder & { Model }, mobClass ) : Types.TaskType
    local function _action()
        local mobCount = #mobFolder:GetChildren()
        if mobCount > 10 then
            return
        end

        local mob = mobClass.new()
        local function __action()
            mob:Act()
            if not mob:CanAct() then
                globalTimerEvent:Fire(globalTimerEventActions.removeTaskFromTimer, mob.name .. mobCount)
            end
        end

        local mobTask: Types.TaskType = {
            Action = __action,
        }
        
        globalTimerEvent:Fire(globalTimerEventActions.addTaskToTimer, mob.name .. mobCount, mobTask)
    end

    local spawnTask: Types.TaskType = {
        DeltaTime = 0,
        Interval = interval,
        Action = _action,
    }
    return spawnTask
end

local function spawnToothDecayMonsters(currentWave: number)
    local toothDecayMobsModels = {
        "ToothDaceyMob",
        "PulpitusMob",
        "ParodontitusMob"
    }

    local spawnToothDecayMonstersTask = spawnMobs(10, Map.Interact.Monsters.ToothDecay, MobsHandler.ToothDecayMonster)
    globalTimerEvent:Fire(globalTimerEventActions.addTaskToTimer, _taskKeys.spawnTartars, spawnToothDecayMonstersTask)
end

local function spawnTartarMonsters()
    local spawnTartarTask = spawnMobs(10, Map.Interact.Monsters.Tartar, MobsHandler.Tartar)
    globalTimerEvent:Fire(globalTimerEventActions.addTaskToTimer, _taskKeys.spawnTartars, spawnTartarTask)
end

local function spawnToothDecay(currentWave: number)
    local toothDecayModels = {
        "ToothDacey",
        "Pulpitus",
        "Parodontitus",
        "FellOut"
    }

    -- get random tooth and spawn
end

local function spawnTartars()
    
end

local function spawnSaliva()
    local function _action()
        Map.Interact.Saliva.Size += Vector3.yAxis
        Map.Interact.Saliva.Position += Vector3.yAxis
    end
    local salivaTask: Types.TaskType = {
        DeltaTime = 0,
        Interval = 20,
        Action = _action,
    }

    globalTimerEvent:Fire(globalTimerEventActions.addTaskToTimer, _taskKeys.spawnSaliva, salivaTask)
    -- and if player touch that part his speed decrease
    -- and if player position will be smaller that top of saliva he deads

end

local function finishRound()
    globalTimerEvent:Fire(globalTimerEventActions.removeTaskFromTimer, _taskKeys.spawnSaliva)
    globalTimerEvent:Fire(globalTimerEventActions.removeTaskFromTimer, _taskKeys.spawnTartars)
    globalTimerEvent:Fire(globalTimerEventActions.removeTaskFromTimer, _taskKeys.spawnToothDecayMonsters)
    _connections[_connectionKeys.onCurrentWaveChanged]:Disconnect()
end

local function startRound()

    local function onCurrentWaveChanged(value: number)
        if value == 0 then return end
        spawnToothDecay()
        spawnTartars()
        spawnSaliva()

        spawnToothDecayMonsters()
        spawnTartarMonsters()
    end

    _connections[_connectionKeys.onCurrentWaveChanged] = RoundSystemVariables.CurrentWave.Changed:Connect(onCurrentWaveChanged)
    -- spawn tooth decay to random tooths
    
    -- start thread for spawning tooth decay monsters
    -- start thread for spawning saliva
    -- start thread for spawning tartar mobs
    -- spawn thread for checking timer how long tooth decay is exist after the over timer pulpitis spawns and more powerful mobs
    -- if players can't fix tooths, there are fell out
end

local function roundSystemEventConnect(action: string, ...: any)
    local actions = {
        [roundSystemEventActions.startRound] = startRound,
        [roundSystemEventActions.finishRound] = finishRound,
    }

    if actions[action] then
        actions[action](...)
    end
end

local function initialize()
    _connections[_connectionKeys.roundSystemEventConnect] = roundSystemEvent.Event:Connect(roundSystemEventConnect)
end

return {
    initialize = initialize,
}