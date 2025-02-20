local Mobs = script.Parent
local BaseMobClass = require(Mobs.BaseMobClass)

local ToothDecayMonster = {}
ToothDecayMonster.__index = ToothDecayMonster

function ToothDecayMonster.new()
    local super = BaseMobClass.New() 
    super:initialize()
    local self = super
    return setmetatable(self, ToothDecayMonster)
end

ToothDecayMonster.initialize = function(self: ToothDecayMonsterType)
    
end

export type ToothDecayMonsterType = typeof(ToothDecayMonster.new())

return ToothDecayMonster