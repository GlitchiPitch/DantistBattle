local Classes = script.Parent
local AttackingMob = require(Classes.AttackingMob)
local Types = require(Classes.Types)

local Pulpitus = setmetatable({}, { __index = AttackingMob })
Pulpitus.__index = Pulpitus

Pulpitus.New = function()

	local PULPITUS_DATA: Types.BaseMobDataType = {
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

	return setmetatable(AttackingMob.new(PULPITUS_DATA), Pulpitus)
end

return Pulpitus

