type MapType = Folder & {
    Spawner: Part,
    MobSpawners: Folder & { Part },
    ToothProblemPoints: Folder & { Part },
    Saliva: Part,
}

local Instances = {
    Map = nil :: MapType,
}

return Instances