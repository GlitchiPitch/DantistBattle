local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Types = require(ReplicatedStorage.Types)
local Constants = require(ReplicatedStorage.Constants)
local Configuration = require(ReplicatedStorage.Configuration)

local LobbyManager = script.Parent
-- local Instances = require(LobbyManager.Instances)

local remote = LobbyManager.Events.Remote
local remoteActions = require(remote.Actions)

local player = Players.LocalPlayer
local capsuleGui = player.PlayerGui:WaitForChild("CapsuleGui")
-- local waitingFrame = capsuleGui.WaitingFrame

local capsuleFrameTemplate = capsuleGui.Roles.CapsuleFrameTemplate

local _inspectPrompts: {
	[Instance]: {
		Shown: RBXScriptConnection,
		Hidden: RBXScriptConnection,
		IsOccupied: RBXScriptConnection,
	},
} = {}

local _connections: { [any]: RBXScriptConnection } = {}
local _connectionKeys: { string } = {}

local function iterateCapculeInstances(callback: (capsule: Model) -> ())
	for _, capsule in CollectionService:GetTagged(Constants.CAPSULE_TAG) do
		callback(capsule)
	end
end

--[[
	спавнить для каждой капсулы в ваитинг фрейме иконку, в чек капсуле окупид атрибут и менял картинку
	

]]



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

local function createCapsuleStatusFrame(capsule: Types.CapsuleType)
	local capsuleChecker = capsuleGui.WaitingFrame.CapsulesChecker.Template:Clone()
	local states = {
		active = 0,
		inactive = 0,
	}
	local function capsuleCheckerOccupiedChecked()
		local isOccupied = capsuleChecker:GetAttribute(Constants.OCCUPIED_CAPSULE_ATTRIBUTE) :: boolean
		capsuleChecker.ImageLabel.Image = "rbxassets://" .. isOccupied and states.active or states.inactive
	end

	capsuleChecker:GetAttributeChangedSignal(Constants.OCCUPIED_CAPSULE_ATTRIBUTE):Connect(capsuleCheckerOccupiedChecked)

	capsuleChecker.Visible = true
	capsuleChecker.Parent = capsuleGui.WaitingFrame.CapsulesChecker
	capsule.Variables.CapsuleCheckerFrame.Value = capsuleChecker
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

	createCapsuleStatusFrame(capsule)

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

local function checkCapsuleOccupied(capsule: Types.CapsuleType)
	local function onCapsuleOccupied()
		local isOccupied = capsule:GetAttribute(Constants.OCCUPIED_CAPSULE_ATTRIBUTE) :: boolean
		local capsuleCheckerFrame = capsule.Variables.CapsuleCheckerFrame.Value :: typeof(capsuleGui.WaitingFrame.CapsulesChecker.Template)
		capsuleCheckerFrame:SetAttribute(Constants.OCCUPIED_CAPSULE_ATTRIBUTE, isOccupied)
	end

	_connections[capsule] = capsule:GetAttributeChangedSignal(Constants.OCCUPIED_CAPSULE_ATTRIBUTE):Connect(onCapsuleOccupied)
end

local function clearConnectionsForCapsules(capsule: Types.CapsuleType)
	if _connections[capsule] then
		_connections[capsule]:Disconnect()
		_connections[capsule] = nil
	end
end

local function getRole() -- capsule, true
	capsuleGui.WaitingFrame.Visible = true
	iterateCapculeInstances(checkCapsuleOccupied)
end

local function removeRole()
	-- при ремуве роли снимать конекты и дропать интерфейс до дефолта
	capsuleGui.WaitingFrame.Visible = false
	iterateCapculeInstances(clearConnectionsForCapsules)
end

local function remoteConnect(action: string, ...: any)
	local actions = {
		[remoteActions.getRole] = getRole,
		[remoteActions.removeRole] = removeRole,
	}

	if actions[action] then
		actions[action](...)
	end
end

local function initialize()
	iterateCapculeInstances(onCapsuleAdded)

	CollectionService:GetInstanceAddedSignal(Constants.CAPSULE_TAG):Connect(onCapsuleAdded)
	CollectionService:GetInstanceRemovedSignal(Constants.CAPSULE_TAG):Connect(onCapsuleRemoved)

	local function onExitClick()
		remote:FireServer(remoteActions.removeRole)
	end

	capsuleGui.WaitingFrame.Exit.TextButton.MouseButton1Click:Connect(onExitClick)
	remote.OnClientEvent:Connect(remoteConnect)
end

return { initialize = initialize }
