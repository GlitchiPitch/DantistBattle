local Mobs = script.Parent
local BaseMobClass = require(Mobs.BaseMobClass)

local TartarClass = {}
TartarClass.__index = TartarClass

function TartarClass.new()
    local super = BaseMobClass.New() 
    super:initialize()
    local self = super
    return setmetatable(self, TartarClass)
end

TartarClass.initialize = function(self: TartarClassType)
    
end

export type TartarClassType = typeof(TartarClass.new())

return TartarClass