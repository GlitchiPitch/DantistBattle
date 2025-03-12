local Mobs = script.Parent
local BaseMob = require(Mobs.TestBaseMobClass)

local TartarClass = setmetatable({}, { __index = BaseMob }) -- Inherit from Parent
TartarClass.__index = TartarClass

function TartarClass.new(name, age)
	local self = setmetatable(BaseMob.new(name), TartarClass) -- Call Parent's constructor
	self.age = age or 0
	return self
end

TartarClass.bebe = function()
end

-- Testing
local childInstance = TartarClass.new("Alice", 10)
childInstance:bibi() -- Calls bibi() from Parent, but bebe() from Child
