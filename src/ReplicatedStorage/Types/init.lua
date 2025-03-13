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

export type CapsuleType = Model & {
    Primary: Part & { PromptAttachment: Attachment, CharacterAttachment: Attachment },
    Variables: Folder & { CapsuleCheckerFrame: ObjectValue },
}

export type MapType = Folder & {
	Interact: Folder & {
        -- players spawn
		SpawnLocations: Folder & { Part },

		MobSpawners: Folder & { Part },
		Mobs: Folder & {
			Tartar: Folder & { Model },
			ToothDecay: Folder & { Model },
		},
		Tooths: Folder & { Part },
		Saliva: Part,
	},
}

return {}