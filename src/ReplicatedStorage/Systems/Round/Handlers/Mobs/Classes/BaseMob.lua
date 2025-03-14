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
        targets: { BaseMobType }, -- { classes }
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
    Destroy: () -> (),
}

function BaseMob.new(mobData: Types.MobData) : BaseMobType
    local self = {
        -- TODO: возможно потом не подгружать модель в начале, а вытаскиваь из ассетов по имени чтобы было легче респавнить
        model = mobData.model,
        hp = mobData.hp,
        -- TODO: возможно поместить в таблицу
        configuration = mobData.configuration,
        animations = mobData.animations,
        cache = {
            targets = {},
            boosts = {},
            effects = {},
        },
    }

	return setmetatable(self, BaseMob)
end

--[[
    Intitialize run:
    * load animations to humanoid
    * setup the mob to workspace and specific position
    * send main loop of the mob to the global timer
    * and check if mob was died do remove main loop from the global timer
]]
BaseMob.Initialize = function(self: BaseMobType, spawnPoint: Part)
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
            self:Destroy()
            return
        end

        self:Act()
    end

    local mobTask: GlobalTypes.TaskType = {
        Action = _mobAction,
    }

    globalTimerEvent:Fire(globalTimerEventActions.addTaskToTimer, "", mobTask)
end

BaseMob.Act = function(self: BaseMobType)
    -- implement this method from child classes
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
    local targetPosition = target.model:GetPivot().Position
    local humanoid = self.model:FindFirstChildOfClass("Humanoid")
    humanoid:MoveTo(targetPosition)
end

-- BaseMob.bibi = function(self)
-- 	print("Parent's bibi() method called")
-- 	self:bebe()  -- Calls bebe() (will use Child's version if overridden)
-- end

-- BaseMob.bebe = function()
-- 	print("Parent's bebe() method called")
-- end

BaseMob.CheckAlive = function(self: BaseMobType) : boolean
    return self.hp > 0
end

-- check what effects that block action player has
BaseMob.CanAct = function(self: BaseMobType) : boolean

    for _, effect in Constants.EFFECT_KEYS do
        if self.cache.effects[effect] then
            return false
        end
    end

    return true
end

-- check temporary items from cache like a boost or effects
BaseMob.UpdateCache = function(self: BaseMobType)

    local function _iterateCache(cacheName: string, _cache: { [string]: number })
        for cacheItemName, cacheValue in _cache do
            if cacheValue > 0 then
                self.cache[cacheName][cacheItemName] -= 1
            elseif cacheValue <= 0 then
                self.cache[cacheName][cacheItemName] = nil
            end
        end
    end

    _iterateCache("boosts", self.cache.boosts)
    _iterateCache("effects", self.cache.effects)
end

BaseMob.Destroy = function(self: BaseMobType)
    globalTimerEvent:Fire(globalTimerEventActions.removeTaskFromTimer, "")
end

return BaseMob