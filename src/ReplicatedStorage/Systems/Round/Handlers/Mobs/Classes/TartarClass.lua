local Mobs = script.Parent
local BaseMobClass = require(Mobs.BaseMobClass)

local TartarClass = {}
TartarClass.__index = TartarClass

function TartarClass.new()
    local super = BaseMobClass.New() 
    local self = super
    return setmetatable(self, TartarClass)
end

TartarClass.Initialize = function(self: TartarClassType, spawnPoint: Part)
    local function _act()
        self:Act()
    end
    self:_Initialize(spawnPoint, _act)
end

TartarClass.Act = function(self: TartarClassType)
    
end

export type TartarClassType = typeof(TartarClass.new())

return TartarClass