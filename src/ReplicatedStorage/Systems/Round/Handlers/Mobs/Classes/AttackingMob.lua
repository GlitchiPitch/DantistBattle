local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Utility = ReplicatedStorage.Utility
local getMagnitude = require(Utility.getMagnitude)

local Classes = script.Parent
local Types = require(Classes.Types)
local BaseMob = require(Classes.BaseMob)

local AttackingMob = setmetatable({}, { __index = BaseMob })
AttackingMob.__index = AttackingMob

function AttackingMob.New(mobData: Types.BaseMobDataType) : Types.AttackingMobType
    return setmetatable(BaseMob.new(mobData), AttackingMob)
end

-- at the future make a multi target feature
AttackingMob.FindTarget = function(self: Types.AttackingMobType, enemyUnits: { Types.BaseMobType }) -- or { classes }
    for _, enemy in enemyUnits do
        if self.configuration.targetDistance < getMagnitude(enemy:GetPivot().Position, self.model:GetPivot().Position) then
            table.insert(self.cache.targets, enemy)
            break
        end
    end
end

AttackingMob.Attack = function(self: Types.AttackingMobType)
    local enemy = self.cache.targets[1] :: Types.BaseMobType

    local function _doDamage()
        enemy.hp -= self.configuration.damage
        -- local humanoid = enemy.model:FindFirstChildOfClass("Humanoid")
        -- humanoid.Health = enemy.hp
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
    
end

AttackingMob.CheckValidTarget = function(self: Types.AttackingMobType) : boolean
    local target = self.cache.targets[1] :: Types.BaseMobType
    return target.hp > 0
end

AttackingMob.Act = function(self: Types.AttackingMobType)
    if #self.cache.targets == 0 then
        self:FindTarget()
    else
        if self:CheckValidTarget() then
            self:Attack()
        end
    end
end

return AttackingMob