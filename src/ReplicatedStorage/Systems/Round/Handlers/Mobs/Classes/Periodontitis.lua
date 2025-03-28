local Classes = script.Parent
local AttackingMob = require(Classes.AttackingMob)
local Types = require(Classes.Types)

local Periodontitis = setmetatable({}, { __index = AttackingMob })
Periodontitis.__index = Periodontitis

Periodontitis.New = function()
	local PERIODONTITIS_DATA: Types.BaseMobDataType = {
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

	return setmetatable(AttackingMob.new(PERIODONTITIS_DATA), Periodontitis)
end

return Periodontitis

