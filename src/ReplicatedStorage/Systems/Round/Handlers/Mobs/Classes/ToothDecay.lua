local Classes = script.Parent
local Types = require(Classes.Types)
local AttackingMob = require(Classes.AttackingMob)

local toothDecayModel = Instance.new("Model")

local ToothDecay = setmetatable({}, { __index = AttackingMob })
ToothDecay.__index = ToothDecay

export type ToothDecayType = Types.AttackingMobType

local TOOTH_DECAY_DATA: Types.BaseMobDataType = {
    model = toothDecayModel,
    hp = 10,
    configuration = {
        damage = 10,
        evadeChance = 10,
        attackDistance = 10,
    }
}

function ToothDecay.New() : ToothDecayType
    return setmetatable(AttackingMob.new(TOOTH_DECAY_DATA), ToothDecay)
end

return ToothDecay