local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Types = require(ReplicatedStorage.Types)

local GlobalTimer = script.Parent
local Events = GlobalTimer.Events
local event = Events.Event
local eventActions = require(event.Actions)
local _connections: { RBXScriptConnection } = {}
local _tasks: { [string]: Types.TaskType } = {}

local function addTaskToTimer(taskName: string, _task: Types.TaskType)
    _tasks[taskName] = _task
end

local function removeTaskFromTimer(taskName: string)
    if _tasks[taskName] then
        _tasks[taskName] = nil
    end
end

local function eventConnect(action: string, ...: any)
    local actions = {
        [eventActions.addTaskToTimer] = addTaskToTimer,
        [eventActions.removeTaskFromTimer] = removeTaskFromTimer,
    }

    if actions[action] then
        actions[action](...)
    end
end

local function onRenderStepped(deltaTime: number)
    for taskName, _ in _tasks do
        if _tasks[taskName].DeltaTime then
            _tasks[taskName].DeltaTime += deltaTime
        else
            _tasks[taskName].Action()
        end

        if _tasks[taskName].Interval then
            if _tasks[taskName].DeltaTime >= _tasks[taskName].Interval then
                _tasks[taskName].DeltaTime = 0
                _tasks[taskName].Action()
            end
        end

        if _tasks[taskName].Duration then
            if _tasks[taskName].Duration > 0 then
                _tasks[taskName].Duration -= 1
            else
                _tasks[taskName] = nil
            end
        end
    end 
end

local function initialize()
    table.insert(
        _connections,
        event.Event:Connect(eventConnect)
    )

    table.insert(
        _connections,
        RunService.RenderStepped:Connect(onRenderStepped)
    )

end

return {
    initialize = initialize,
}