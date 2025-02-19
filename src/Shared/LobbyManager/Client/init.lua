local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Constants = require(ReplicatedStorage.Constants)

local function initialize()
    for _, capsule in CollectionService:GetTagged(Constants.CAPSULE_TAG) do
        
    end
end

return {
    initialize = initialize,
}