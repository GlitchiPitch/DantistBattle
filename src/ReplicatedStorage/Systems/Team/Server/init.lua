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

local Guns = {
    Heavy = Instance.new("Tool"),
}

local Armors = {
    Heavy = Instance.new("HumanoidDescription"),
}

local function giveGuns(player: Player, role: string)
    local gun = Guns[role]
    assert(gun, `armor {role} is not found`)
    gun.Parent = player.Backpack
end

local function giveArmor(player: Player, role: string)
    local armor = Armors[role]
    local humanoid = player.Character:FindFirstAncestorOfClass("Humanoid")
    assert(armor, `armor {role} is not found`)
    humanoid:ApplyDescription(armor)
end

local function equipTeam(team: Types.TeamType)
    for role, player in team do
        giveArmor(player, role)
        giveGuns(player, role)
    end
end

local function teamReady(team: Types.TeamType)
    equipTeam(team)
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