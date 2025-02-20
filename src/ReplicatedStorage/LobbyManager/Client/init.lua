local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Constants = require(ReplicatedStorage.Constants)

local player = Players.LocalPlayer
local capsuleGui = player.PlayerGui:WaitForChild("CapsuleGui")

local _inspectPrompts: { 
    [Instance]: {
        Shown: RBXScriptConnection,
        Hidden: RBXScriptConnection,
    }
} = {}

local function CustomPrompt()
    local _prompt = Instance.new("ProximityPrompt")
    _prompt.Style = Enum.ProximityPromptStyle.Custom
    return _prompt
end

local function onCapsuleAdded(capsule: Model & { PrimartPart: Part & { PromptAttachment: Attachment } })
    local promptAttachment = capsule.PrimartPart.PromptAttachment
    local prompt = CustomPrompt()

    local function onPromptShown()
        
    end

    local function onPromptHidden()
        
    end

    prompt.Parent = promptAttachment

    _inspectPrompts[capsule] = {
        Shown = prompt.PromptShown:Connect(onPromptShown),
        Hidden = prompt.PromptHidden:Connect(onPromptHidden),
    }
end

local function onCapsuleRemoved(capsule)
    if _inspectPrompts[capsule] then
        _inspectPrompts[capsule].Shown:Disconnect()
        _inspectPrompts[capsule].Hidden:Disconnect()
        _inspectPrompts[capsule] = nil
    end
end

local function initialize()
    for _, capsule in CollectionService:GetTagged(Constants.CAPSULE_TAG) do
        onCapsuleAdded(capsule)
    end

    CollectionService:GetInstanceAddedSignal(Constants.CAPSULE_TAG):Connect(onCapsuleAdded)
    CollectionService:GetInstanceRemovedSignal(Constants.CAPSULE_TAG):Connect(onCapsuleRemoved)
end

return {
    initialize = initialize,
}