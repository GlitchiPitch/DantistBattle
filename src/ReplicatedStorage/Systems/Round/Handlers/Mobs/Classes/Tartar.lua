local Mobs = script.Parent
local AttackingMob = require(Mobs.AttackingMob)
local Types = require(Mobs.Parent.Types)

local Tartar = setmetatable({}, { __index = AttackingMob })
Tartar.__index = Tartar

export type TartarType = AttackingMob.AttackingMobType

local TARTAR_DATA: Types.MobData = {
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

function Tartar.New() : TartarType
	return setmetatable(AttackingMob.new(TARTAR_DATA), Tartar)
end

return Tartar

