local Classes = script.Parent
local AttackingMob = require(Classes.AttackingMob)
local Types = require(Classes.Types)

local Tartar = setmetatable({}, { __index = AttackingMob })
Tartar.__index = Tartar

Tartar.New = function()

	local TARTAR_DATA: Types.BaseMobDataType = {
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

	return setmetatable(AttackingMob.new(TARTAR_DATA), Tartar)
end

return Tartar

