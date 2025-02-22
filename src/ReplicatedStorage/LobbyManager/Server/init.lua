local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Configuration = require(ReplicatedStorage.Configuration)
local Constants = require(ReplicatedStorage.Constants)
local Types = require(ReplicatedStorage.Types)

local LobbyManager = script.Parent
local Instances = require(LobbyManager.Instances)

local remote = LobbyManager.Events.Remote
local remoteActions = require(remote.Actions)

local _inspectCapsules: { [Instance]: Player } = {}

local function removeRole(player: Player, capsule: Types.CapsuleType)
    if _inspectCapsules[capsule] then
        _inspectCapsules[capsule] = nil
        remote:FireClient(player, remoteActions.getRole, capsule, false)
    end
end

local function getInspectCapsules() : number
    local i = 0
    for _, _ in _inspectCapsules do i += 1 end
    return i
end

local function giveRole(player: Player, capsule: Types.CapsuleType)
    if not _inspectCapsules[capsule] then
        player.Character:PivotTo(capsule.Primary.CharacterAttachment.WorldCFrame)
        _inspectCapsules[capsule] = player
        remote:FireClient(player, remoteActions.getRole, capsule, true)

        if getInspectCapsules() == #Instances.Lobby.Capsules then
            -- start
            print("start")
        else
            print("asd")
        end
    end
    -- setup player to capsule
    -- open waiting frame
end

local function remoteConnect(player: Player, action: string, ...: any)
    local actions = {
        [remoteActions.getRole] = giveRole,
        [remoteActions.removeRole] = removeRole,
    }

    if actions[action] then
        actions[action](player, ...)
    end
end

local function initialize()
    remote.OnServerEvent:Connect(remoteConnect)
end

return {
    initialize = initialize,
}