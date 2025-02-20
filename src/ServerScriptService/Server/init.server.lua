local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Modules = {
    GlobalTimer = ReplicatedStorage.GlobalTimer,
}

local function initialize()
    for _, module in Modules do
        require(module).initialize()
    end
end

initialize()
