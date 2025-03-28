local GlobalTypes = require(script.Parent.GlobalTypes)

export type BaseMobType = {
    model: Model,
    hp: number,
    id: string,
    configuration: GlobalTypes.ConfigurationType,
    animations: GlobalTypes.AnimationListType,
    cache: {
        targets: { BaseMobType }, -- { classes }
        boosts: { [string]: number },
        effects: { [string]: number },        
    },

    Initialize: (spawnPoint: Part) -> (),
    LoadAnimation: () -> (),
    Move: () -> (),
    CheckAlive: () -> (),
    CanAct: () -> boolean,
    Act: () -> (),
    UpdateCache: () -> (),
    Destroy: () -> (),
}

export type AttackingMobType = BaseMobType & {
    FindTarget: (enemyUnits: { BaseMobType }) -> (),
    Attack: () -> (),
    CheckValidTarget: () -> boolean,
}

return {}