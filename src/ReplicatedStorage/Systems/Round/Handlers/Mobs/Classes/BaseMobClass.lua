local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GlobalTypes = require(ReplicatedStorage.Types)
local Constants = require(ReplicatedStorage.Constants)

local GlobalTimer = ReplicatedStorage.GlobalTimer
local globalTimerEvent = GlobalTimer.Events.Event
local globalTimerEventActions = require(globalTimerEvent.Actions)

local MobsHandler = script.Parent.Parent
local Types = require(MobsHandler.Types)

local BaseMob = {}
BaseMob.__index = BaseMob

export type BaseMobType = {
    model: Model,
    hp: number,
    configuration: Types.ConfigurationType,
    animations: Types.AnimationListType,
    cache: {
        targets: { {} }, -- { classes }
        boosts: { [string]: number },
        effects: { [string]: number },        
    },

    Initialize: (spawnPoint: Part) -> (),
    LoadAnimation: () -> (),
    Move: () -> (),
    CheckAlive: () -> (),
    CanAct: () -> boolean,
    Act: () -> (),
    UpdateCache: () -> (),
}

function BaseMob.new(mobData: Types.MobData) : BaseMobType
    local self = {
        -- TODO: возможно потом не подгружать модель в начале, а вытаскиваь из ассетов чтобы было легче респавнить
        model = mobData.model,
        hp = mobData.hp,
        -- TODO: возможно поместить в таблицу
        configuration = mobData.configuration,
        animations = mobData.animations,
        cache = {
            targets = {} :: { {} }, -- { classes }
            boosts = {} :: { [string]: number },
            effects = {} :: { [string]: number },
        },
    }

	return setmetatable(self, BaseMob)
end

BaseMob.Initialize = function(self, spawnPoint: Part)
    self:LoadAnimation()
    self.model = self.model:Clone()
    self.model.Parent = spawnPoint
    -- TODO: так как далее размеры у мобов будут разные вытаскивать хуманоида и после hipHeight 
    self.model:PivotTo(spawnPoint.CFrame * CFrame.new(0, 5, 0))

    local function _mobAction()
        self:UpdateCache()
        
        if not self:CanAct() then
            return
        end
    
        if not self:CheckAlive() then
            self:Died()
            return
        end

        self:Act()
    end

    local mobTask: GlobalTypes.TaskType = {
        Action = _mobAction,
    }

    globalTimerEvent:Fire(globalTimerEventActions.addTaskToTimer, "", mobTask)
end

BaseMob.LoadAnimation = function(self)
    local humanoid = self.model.Humanoid
    local animator = humanoid:FindFirstChildOfClass("Animator")
    for animName, animationId in self.animations do
        local animation = Instance.new("Animation")
        animation.AnimationId = animationId
        self.animations[animName] = animator:LoadAnimation(animation)
    end
end

-- at the future send to this function targetPosition: Vector3
BaseMob.Move = function(self: BaseMobType)
    local target = self.cache.targets[1] :: BaseMobType
    local targetModel = target.model
    local targetHumanoidRootPart = targetModel:FindFirstChild("HumanoidRootPart") :: Part
    local humanoid = self.model:FindFirstChildOfClass("Humanoid")
    humanoid:MoveTo(targetHumanoidRootPart.Position)
end

-- BaseMob.bibi = function(self)
-- 	print("Parent's bibi() method called")
-- 	self:bebe()  -- Calls bebe() (will use Child's version if overridden)
-- end

-- BaseMob.bebe = function()
-- 	print("Parent's bebe() method called")
-- end


BaseMob.CheckAlive = function(self)
    local humanoid = self.model:FindFirstChildOfClass("Humanoid")
    return (humanoid.Health > 0)
end

-- check what effects that block action player has
BaseMob.CanAct = function(self) : boolean

    for _, effect in Constants.EFFECT_KEYS do
        if self.cache.effects[effect] then
            return false
        end
    end

    return true
end

BaseMob.Act = function(self)
    -- implement this method from child classes
end

-- check temporary items from cache like a boost or effects
BaseMob.UpdateCache = function(self)
    -- or make itearate only effects and boosts not targets
    for cacheItemName, _cache in self.cache do
        for _cacheItemName, v in _cache do
            if v > 0 then
                self.cache[cacheItemName][_cacheItemName] -= 1
            elseif v == 0 then
                self.cache[cacheItemName][_cacheItemName] = nil
            end
        end
    end
end

return BaseMob