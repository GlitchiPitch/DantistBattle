local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Types = require(ReplicatedStorage.Types)

local PlayerHandler = script.Parent
local Handlers = PlayerHandler.Parent
local RoundSystem = Handlers.Parent
local Events = RoundSystem.Events

local event = Events.Event
local eventActions = require(event.Actions)

local _connections: { RBXScriptConnection } = {}

local function giveSkin(player: Player, role: Types.RoleType)
    local roleSkin = Instance.new("HumanoidDescription")
    local humanoid = player.Character:FindFirstAncestorOfClass("Humanoid")
    humanoid:ApplyDescription(roleSkin)
end

local function giveGun(player: Player, role: Types.RoleType)
    local roleGun = Instance.new("Tool")
    roleGun:Clone().Parent = player.Backpack
end

local function setupStats(player: Player, role: Types.RoleType)
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    local roleStats = {
        MaxHealth = 1000,
        WalkSpeed = 20,
        JumpPower = 100,
    }

    humanoid.MaxHealth = roleStats.MaxHealth
    humanoid.Health = roleStats.MaxHealth
    humanoid.WalkSpeed = roleStats.WalkSpeed
    humanoid.JumpPower = roleStats.JumpPower
end

local function equipPlayer(player: Player, role: Types.RoleType)
    setupStats(player, role)
    giveSkin(player, role)
    giveGun(player, role) 
end

local function eventConnect(action: string, ...: any)
    local actions = {
        [eventActions.equipPlayer] = equipPlayer,
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

return  {
    initialize = initialize,
}