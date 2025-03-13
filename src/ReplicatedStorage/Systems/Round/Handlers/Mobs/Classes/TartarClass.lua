local Mobs = script.Parent
local AttackingMob = require(Mobs.AttackingMob)
local Types = require(Mobs.Parent.Types)

local Tartar = setmetatable({}, { __index = AttackingMob })
Tartar.__index = Tartar

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

function Tartar.New()
	return setmetatable(AttackingMob.new(TARTAR_DATA), Tartar)
end

Tartar.Act = function(self: TartarClassType)
    if #self.cache.targets == 0 then
        self:FindTarget()
    else
        self:Attack()
    end
end

export type TartarClassType = typeof(Tartar.New())

return Tartar

