local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Configuration = require(ReplicatedStorage.Configuration)
local Constants = require(ReplicatedStorage.Constants)
local Types = require(ReplicatedStorage.Types)

local TeamSystem = ReplicatedStorage.Systems.Team
local teamSystemEvent = TeamSystem.Events.Event
local teamSystemEventActions = require(teamSystemEvent.Actions)

local LobbyManager = script.Parent
local Instances = require(LobbyManager.Instances)

local remote = LobbyManager.Events.Remote
local remoteActions = require(remote.Actions)

local _inspectCapsules: { [Instance]: Player } = {}

local function getOccupiedCapsules() : number
    local i = 0
    for _, _ in _inspectCapsules do i += 1 end
    return i
end

local function prepareTeamForStart() : Types.TeamType
    local team: Types.TeamType = {}
    for capsule, playerInCapusle in _inspectCapsules do
        local role = capsule:GetAttribute(Constants.CAPSULE_ROLE_ATTRIBUTE) :: string
        team[role] = playerInCapusle
    end

    return team
end

local function start()
    -- animate capsules
    local team = prepareTeamForStart()

end

local function checkForStartGame()
    if getOccupiedCapsules() == #Instances.Lobby.Capsules then
        start()
    else
        print("asd")
    end
end

local function removeRole(player: Player, capsule: Types.CapsuleType)
    if _inspectCapsules[capsule] then
        _inspectCapsules[capsule] = nil
        remote:FireClient(player, remoteActions.getRole, capsule, false)
    end
end

local function giveRole(player: Player, capsule: Types.CapsuleType)
    if not _inspectCapsules[capsule] then
        player.Character:PivotTo(capsule.Primary.CharacterAttachment.WorldCFrame)
        _inspectCapsules[capsule] = player
        capsule:SetAttribute(Constants.OCCUPIED_CAPSULE_ATTRIBUTE, true)
        remote:FireClient(player, remoteActions.getRole, capsule)

        checkForStartGame()
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

return { initialize = initialize }