local QuestsHandler = script.Parent
local Handlers = QuestsHandler.Parent
local RoundSystem = Handlers.Parent
local roundSystemEvent = RoundSystem.Events.Event
local roundSystemEventActions = require(roundSystemEvent.Actions)

local _connections: { RBXScriptConnection } = {}

local function spawnToothDecay()
    -- get random tooth and spawn
end

local function startRound()
    -- spawn tooth decay to random tooths
    spawnToothDecay()
    -- start thread for spawning tooth decay monsters
    -- start thread for spawning saliva
    -- start thread for spawning tartar mobs
    -- spawn thread for checking timer how long tooth decay is exist after the over timer pulpitis spawns and more powerful mobs
    -- if players can't fix tooths, there are fell out
end

local function roundSystemEventConnect(action: string, ...: any)
    local actions = {
        [roundSystemEventActions.startRound] = startRound,
    }
    if actions[action] then
        actions[action](...)
    end
end

local function initialize()
    table.insert(
        _connections,
        roundSystemEvent.Event:Connect(roundSystemEventConnect)
    )
end

return {
    initialize = initialize,
}