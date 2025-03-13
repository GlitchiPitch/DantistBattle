local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Utility = ReplicatedStorage.Utility
local getMagnitude = require(Utility.getMagnitude)

local Mobs = script.Parent
local Types = require(Mobs.Parent.Types)
local BaseMob = require(Mobs.BaseMobClass)

local AttackingMob = setmetatable({}, { __index = BaseMob })
AttackingMob.__index = AttackingMob

export type AttackingMobType = BaseMob.BaseMobType & {
    FindTarget: (enemyUnits: { Model }) -> (),
    Attack: () -> (),
}

function AttackingMob.New(mobData: Types.MobData) : AttackingMobType
    return setmetatable(BaseMob.new(mobData), AttackingMob)
end

-- at the future make a multi target feature
AttackingMob.FindTarget = function(self: AttackingMobType, enemyUnits: { Model }) -- or { classes }
    for _, enemy in enemyUnits do
        if self.configuration.targetDistance < getMagnitude(enemy:GetPivot().Position, self.model:GetPivot().Position) then
            table.insert(self.cache.targets, enemy)
            break
        end
    end
end

AttackingMob.Attack = function(self: AttackingMobType)
    local enemy = self.cache.targets[1] :: BaseMob.BaseMobType

    local function _doDamage()
        local humanoid = enemy.model:FindFirstChildOfClass("Humanoid")
        enemy.hp -= self.configuration.damage
        humanoid.Health = enemy.hp
    end

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
        _doDamage()
    end

    if enemy then
        local targetMagnitude = getMagnitude(enemy.model:GetPivot().Position, self.model:GetPivot().Position)
        if targetMagnitude < self.configuration.attackDistance then
            _attack()
        else
            self:Move()
        end
    end

    print(self.name, "Attack")
end

-- export type AttackingMobType = typeof()

return AttackingMob