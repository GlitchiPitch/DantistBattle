local Handlers = script.Parent
local RoundSystem = Handlers.Parent
local event = RoundSystem.Events.Event
local eventActions = require(event.Actions)

local Classes = script.Classes
local TartarClass = require(Classes.TartarClass)
local ToothDecayMonster = require(Classes.ToothDecayMonster)

local function spawnMobs()
    
end

local function startRound()
    
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

local Mobas = {
    Tartar = TartarClass,
    ToothDecayMonster = ToothDecayMonster,
}

return { initialize = initialize }