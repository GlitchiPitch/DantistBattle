local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Utility = ReplicatedStorage.Utility
local getMagnitude = require(Utility.getMagnitude)

local Mobs = script.Parent
local Types = require(Mobs.Parent.Types)
local BaseMob = require(Mobs.BaseMobClass)

local AttackingMob = setmetatable({}, { __index = BaseMob })
AttackingMob.__index = AttackingMob

function AttackingMob.New(mobData: Types.MobData)
    return setmetatable(BaseMob.new(mobData), AttackingMob)
end

AttackingMob.FindTarget = function(self, enemyUnits: { Model }) -- or { classes }
    for _, enemy in enemyUnits do
        if self.configuration.targetDistance < getMagnitude(enemy:GetPivot().Position, self.model:GetPivot().Position) then
            self.stats.Target.Value = enemy
            break
        end
    end
end

AttackingMob.Attack = function(self)
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
    end

    if enemy then
        local targetMagnitude = getMagnitude(enemy:GetPivot().Position, self.model:GetPivot().Position)
        if targetMagnitude < self.configuration.attackDistance then
            _attack()
        end
    end

    print(self.name, "Attack")
end

-- export type AttackingMobType = typeof()

return AttackingMob