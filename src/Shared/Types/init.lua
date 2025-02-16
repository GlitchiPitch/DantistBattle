export type RoleType = "Dantist" | "Heavy"

export type TaskType = { 
    DeltaTime: number?,
    Duration: number?,
    Interval: number?,
    Action: () -> (),
}

export type TeamType = {
    Dantist: Player,
    Heavy: Player,
}

return {}