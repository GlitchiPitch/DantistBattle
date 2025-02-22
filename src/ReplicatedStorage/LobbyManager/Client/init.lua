local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Types = require(ReplicatedStorage.Types)
local Constants = require(ReplicatedStorage.Constants)
local Configuration = require(ReplicatedStorage.Configuration)

local LobbyManager = script.Parent
local Instances = require(LobbyManager.Instances)

local remote = LobbyManager.Events.Remote
local remoteActions = require(remote.Actions)

local player = Players.LocalPlayer
local capsuleGui = player.PlayerGui:WaitForChild("CapsuleGui")
local capsuleFrameTemplate = capsuleGui.Roles.CapsuleFrameTemplate

local _inspectPrompts: {
	[Instance]: {
		Shown: RBXScriptConnection,
		Hidden: RBXScriptConnection,
	},
} = {}

local function createCapsuleFrame(capsule: Model, capsuleRole: string): typeof(capsuleFrameTemplate)
	local capsuleData = Configuration[capsuleRole]
	local capsuleFrame = capsuleFrameTemplate:Clone() :: typeof(capsuleFrameTemplate)

	local function onClick()
		capsuleFrame.Button.TextButton.Interactable = false
		remote:FireServer(remoteActions.getRole, capsule)
		task.wait(1)
		capsuleFrame.Button.TextButton.Interactable = true
	end

	local function onMouseEnter() end
	local function onMouseLeave() end

	capsuleFrame.Parent = capsuleGui.Roles
	capsuleFrame.Title.TextLabel.Text = capsuleData.PromptText
	capsuleFrame.Button.TextButton.MouseButton1Click:Connect(onClick)
	capsuleFrame.Button.TextButton.MouseEnter:Connect(onMouseEnter)
	capsuleFrame.Button.TextButton.MouseLeave:Connect(onMouseLeave)

	return capsuleFrame
end

local function CustomPrompt(capsule: Model, capsuleRole: string): (ProximityPrompt, typeof(capsuleFrameTemplate))
	local _prompt = Instance.new("ProximityPrompt")
	local _customPrompt = createCapsuleFrame(capsule, capsuleRole)
	_prompt.Style = Enum.ProximityPromptStyle.Custom
	return _prompt, _customPrompt
end

local function onCapsuleAdded(capsule: Model & { PrimartPart: Part & { PromptAttachment: Attachment } })
	local promptAttachment = capsule.PrimartPart.PromptAttachment
	local capsuleRole = capsule:GetAttribute(Constants.CAPSULE_ROLE_ATTRIBUTE) :: string
	local prompt, customPrompt = CustomPrompt(capsule, capsuleRole)

	local function onPromptShown()
		customPrompt.Visible = true
	end

	local function onPromptHidden()
		customPrompt.Visible = false
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

local function getRole(state: boolean)
	capsuleGui.WaitingFrame.Visible = state
	if state then
		
	end
end

local function remoteConnect(action: string, ...: any)
	local actions = {
		[remoteActions.getRole] = getRole,
		[remoteActions.removeRole] = getRole,
	}
	
end

local function initialize()
	for _, capsule in CollectionService:GetTagged(Constants.CAPSULE_TAG) do
		onCapsuleAdded(capsule)
	end

	CollectionService:GetInstanceAddedSignal(Constants.CAPSULE_TAG):Connect(onCapsuleAdded)
	CollectionService:GetInstanceRemovedSignal(Constants.CAPSULE_TAG):Connect(onCapsuleRemoved)

	remote.OnClientEvent:Connect(remoteConnect)
end

return {
	initialize = initialize,
}
