local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GlobalTypes = require(ReplicatedStorage.Types)

local GlobalTimer = ReplicatedStorage.GlobalTimer
local globalTimerEvent = GlobalTimer.Events.Event
local globalTimerEventActions = require(globalTimerEvent.Actions)

local Utility = ReplicatedStorage.Utility

local Constants = require(ReplicatedStorage.Constants)
local getMagnitude = require(Utility.getMagnitude)

local MobsHandler = script.Parent.Parent
local Types = require(MobsHandler.Types)

local BaseMobClass = {}
BaseMobClass.__index = BaseMobClass

type AnimationListType = {
    attack: number | AnimationTrack,
    die: number | AnimationTrack,
}

type ConfigurationType = {
    evadeChance: number?,
    attackDistance: number?,
}

function BaseMobClass.New(mobData: Types.MobData)
    local self = {
        -- TODO: возможно потом не подгружать модель в начале, а вытаскиваь из ассетов чтобы было легче респавнить
        model = mobData.model,
        hp = mobData.hp,
        -- TODO: возможно поместить в таблицу
        stats = nil :: Folder & { Target: ObjectValue },
        configuration = {
            attackDistance = 0,
            spellDistance = 0,
            evadeChance = 0,
        } :: ConfigurationType,
        animations = {
            attack = 0,
            die = 0,
        } :: AnimationListType,
        boosts = {} :: { [string]: number },
        effects = {} :: { [string]: number },
    }
    return setmetatable(self, BaseMobClass)
end

BaseMobClass.Initialize = function(self: BaseMobClassType, spawnPosition: Part)
    self:LoadAnimation()
    self.model = self.model:Clone()
    self.model.Parent = spawnPosition
    -- TODO: так как далее размеры у мобов будут разные вытаскивать хуманоида и после hipHeight 
    self.model:PivotTo(spawnPosition.CFrame * CFrame.new(0, 5, 0))

    -- start thread

    local function mobAction()
        self:Act()
    end

    local mobTask: GlobalTypes.TaskType = {
        Action = mobAction,
    }

    globalTimerEvent:Fire(globalTimerEventActions.addTaskToTimer, "", mobTask)
end

BaseMobClass.FindTarget = function(self: BaseMobClassType, enemyUnits: { Model }) -- or { classes }
    if not self.stats.Target.Value then
        for _, enemy in enemyUnits do
            if self.configuration.targetDistance < getMagnitude(enemy:GetPivot().Position, self.model:GetPivot().Position) then
                self.stats.Target.Value = enemy
                break
            end
        end
    end
end

BaseMobClass.CheckAlive = function(self: BaseMobClassType)
    local humanoid = self.model:FindFirstChildOfClass("Humanoid")
    return (humanoid.Health > 0)
end

BaseMobClass.CanAct = function(self: BaseMobClassType)

    for _, effect in Constants.EFFECT_KEYS do
        if self.effects[effect] then
            return false
        end
    end

    return true
end

BaseMobClass.Attack = function(self: BaseMobClassType, callback: () -> ())
    local enemy = self.stats.Target.Value :: Model
    local function _attack()
        self.animations.attack:Play()
        -- task.wait(self.animations.attack.Length)
        -- local magicInstance = self.configuration.magicInstance:Clone()
        -- local distance = getMagnitude(enemy:GetPivot().Position, self.model:GetPivot().Position)
        -- local tweenTime = distance / self.configuration.magicSpeed
        -- local tweenInfo = TweenInfo.new(tweenTime)
        -- magicInstance.Parent = self.model
        -- local tween = TweenService:Create(magicInstance, tweenInfo, {CFrame = enemy:GetPivot()})
        -- tween:Play()
        callback()
    end

    if enemy then
        local targetMagnitude = getMagnitude(enemy:GetPivot().Position, self.model:GetPivot().Position)
        if targetMagnitude < self.configuration.attackDistance then
            _attack()
        end
    end

    print(self.name, "Attack")
end

BaseMobClass.LoadAnimation = function(self: BaseMobClassType)
    local humanoid = self.model.Humanoid
    local animator = humanoid:FindFirstChildOfClass("Animator")
    for animName, animationId in self.animations do
        local animation = Instance.new("Animation")
        animation.AnimationId = animationId
        self.animations[animName] = animator:LoadAnimation(animation)
    end
end

BaseMobClass.Died = function(self: BaseMobClassType)
    -- maybe make revive ability for died units like a shaman
    globalTimerEvent:Fire(globalTimerEventActions.removeTaskFromTimer, "")
end

BaseMobClass.Act = function(self: BaseMobClassType, callback: () -> ())
    if not self:CanAct() then
        return
    end

    if not self:CheckAlive() then
        self:Died()
        return
    end

    callback()
end

export type BaseMobClassType = typeof(BaseMobClass.New())

return BaseMobClass