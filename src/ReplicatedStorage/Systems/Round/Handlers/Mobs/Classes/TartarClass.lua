local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Utility = ReplicatedStorage.Utility

local getMagnitude = require(Utility.getMagnitude)

local Mobs = script.Parent
local BaseMob = require(Mobs.BaseMobClass)
local Types = require(Mobs.Parent.Types)

local Tartar = setmetatable({}, { __index = BaseMob }) -- Inherit from Parent
Tartar.__index = Tartar

local TARTAR_DATA: Types.MobData = {
	model = Instance.new("Model"),
	hp = 100,
	configuration = {
		evadeChance = 0,
		attackDistance = 5,
		damage = 10,
	},
	animations = {
		attack = 0,
		die = 0,
		move = 0,
	},
	
}

function Tartar.New()
	return setmetatable(BaseMob.new(TARTAR_DATA), Tartar)
end

Tartar.Act = function(self: TartarClassType)
    if #self.cache.targets == 0 then
        self:FindTarget()
    else
        self:Attack()
    end
end

Tartar.FindTarget = function(self, enemyUnits: { Model }) -- or { classes }
    for _, enemy in enemyUnits do
        if self.configuration.targetDistance < getMagnitude(enemy:GetPivot().Position, self.model:GetPivot().Position) then
            self.stats.Target.Value = enemy
            break
        end
    end
end

Tartar.Attack = function(self)
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

export type TartarClassType = typeof(Tartar.New())

return Tartar

