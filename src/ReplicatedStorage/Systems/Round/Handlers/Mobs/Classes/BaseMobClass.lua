local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Utility = ReplicatedStorage.Utility

local Constants = require(ReplicatedStorage.Constants)
local getMagnitude = require(Utility.getMagnitude)

local BaseMobClass = {}
BaseMobClass.__index = BaseMobClass


function BaseMobClass.New(name: string, model: Model, hp: number)
    local self = {}
    self.model = model
    self.hp = hp

    self.name = name
    self.stats = Instance.new("Folder") :: Folder & { Target: ObjectValue }
    self.configuration = {
        targetDistance = 0,
        spellDistance = 0,
        evadeChance = 0,
        magicInstance = 0,
        magicSpeed = 0,
    }
    self.animations = {
        attack = 0,
        die = 0,
    } :: { 
        attack: number | AnimationTrack,
        die: number | AnimationTrack,
    }
    self.boosts = {} :: { [string]: number }
    self.effects = {} :: { [string]: number }

    return setmetatable(self, BaseMobClass)
end

BaseMobClass.Initialize = function(self: BaseMobClassType)
    self:LoadAnimation()
end


BaseMobClass.CheckValidAct = function(self: BaseMobClassType)
    for _, effect in Constants.EFFECT_KEYS do
        if self.effects[effect] then
            return false
        end
    end

    return true
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

BaseMobClass.CanAct = function(self: BaseMobClassType)
    local humanoid = self.model:FindFirstChildOfClass("Humanoid")
    return (humanoid.Health > 0)
end

BaseMobClass.Attack = function(self: BaseMobClassType)
    local enemy = self.stats.Target.Value :: Model
    local function spellMagic()
        self.animations.attack:Play()
        -- task.wait(self.animations.attack.Length)
        local magicInstance = self.configuration.magicInstance:Clone()
        local distance = getMagnitude(enemy:GetPivot().Position, self.model:GetPivot().Position)
        local tweenTime = distance / self.configuration.magicSpeed
        local tweenInfo = TweenInfo.new(tweenTime)
        magicInstance.Parent = self.model
        local tween = TweenService:Create(magicInstance, tweenInfo, {CFrame = enemy:GetPivot()})
        tween:Play()
        
    end

    if enemy then
        if self.configuration.spellDistance < getMagnitude(enemy:GetPivot().Position, self.model:GetPivot().Position) then
            spellMagic()
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
end

BaseMobClass.Act = function(self: BaseMobClassType)
    if not self:CanAct() then
        return
    end
end

export type BaseMobClassType = typeof(BaseMobClass.New())

return BaseMobClass