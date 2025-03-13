local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = {
    GlobalTimer = ReplicatedStorage.GlobalTimer,
    RoundSystem = ReplicatedStorage.Systems.Round,
    TeamSystem = ReplicatedStorage.Systems.Team,
    LobbyManager = ReplicatedStorage.LobbyManager,
}

local function initialize()
    for _, module in Modules do
        require(module).initialize()
    end
end

initialize()
