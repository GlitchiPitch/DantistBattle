local QuestsHandler = script.Parent
local Handlers = QuestsHandler.Parent
local RoundSystem = Handlers.Parent
local roundSystemEvent = RoundSystem.Events.Event
local roundSystemEventActions = require(roundSystemEvent.Actions)

local _connections: { RBXScriptConnection } = {}

local function roundSystemEventConnect(action: string, ...: any)
    local actions = {}
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