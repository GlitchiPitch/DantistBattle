local MobsHandler = script.Parent.Parent
local Types = require(MobsHandler.Types)

type AnimationListType = {
    attack: number | AnimationTrack,
    die: number | AnimationTrack,
}

type ConfigurationType = {
    evadeChance: number?,
    attackDistance: number?,
}

local BaseMob = {}
BaseMob.__index = BaseMob

function BaseMob.new(mobData: Types.MobData)
    local self = {
        -- TODO: возможно потом не подгружать модель в начале, а вытаскиваь из ассетов чтобы было легче респавнить
        model = mobData.model,
        hp = mobData.hp,
        -- TODO: возможно поместить в таблицу
        stats = nil :: Folder & { Target: ObjectValue },
        configuration = {
            attackDistance = 0,
            spellDistance = 0,
            evadeChance = 0,
        } :: ConfigurationType,
        animations = {
            attack = 0,
            die = 0,
        } :: AnimationListType,
        boosts = {} :: { [string]: number },
        effects = {} :: { [string]: number },
    }

	return setmetatable(self, BaseMob)
end

BaseMob.Initialize = function(self)

end

BaseMob.bibi = function(self)
	print("Parent's bibi() method called")
	self:bebe()  -- Calls bebe() (will use Child's version if overridden)
end

BaseMob.bebe = function()
	print("Parent's bebe() method called")
end

-- Child Class inheriting from Parent
