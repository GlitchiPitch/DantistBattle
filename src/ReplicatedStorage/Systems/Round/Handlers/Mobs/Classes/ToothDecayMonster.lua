local Mobs = script.Parent
local Types = require(Mobs.Parent.Types)
local BaseMobClass = require(Mobs.BaseMobClass)

local toothDecayModel = Instance.new("Model")

local ToothDecayMonster = {}
ToothDecayMonster.__index = ToothDecayMonster

local toothDecayMobData: Types.MobData = {
    model = toothDecayModel,
    hp = 10,
    configuration = {
        damage = 10,
        evadeChance = 10,
        attackDistance = 10,
    }
}

function ToothDecayMonster.new()
    local super = BaseMobClass.New(toothDecayMobData)
    -- super:Initialize()

    local self = super
    return setmetatable(self, ToothDecayMonster)
end

-- ToothDecayMonster.Initialize = function(self: ToothDecayMonsterType)
    
-- end

export type ToothDecayMonsterType = typeof(ToothDecayMonster.new())

return ToothDecayMonster