
type ConfigurationType = {
    evadeChance: number?,
    attackDistance: number?,
    damage: number?,
}

export type MobData = {
    model: Model,
    hp: number,

    configuration: ConfigurationType,
}

return {}