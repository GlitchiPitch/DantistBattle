
type AnimationType = number | AnimationTrack
export type AnimationListType = { [string]: AnimationType } & {
    attack: AnimationType,
    die: AnimationType,
    move: AnimationType,
}

export type ConfigurationType = {
    evadeChance: number?,
    attackDistance: number?,
    damage: number?,
}

export type MobData = {
    model: Model,
    hp: number,
    animations: AnimationListType,
    configuration: ConfigurationType,
    boosts: { [string]: number },
}

return {}