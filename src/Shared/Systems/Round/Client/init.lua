local RoundSystem = script.Parent
local Events = RoundSystem.Events

local remote = Events.Remote
local remoteActions = require(remote.Actions)


local function initialize()
    
end

return {
    initialize = initialize,
}