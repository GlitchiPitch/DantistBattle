export type BaseRoleType = {
    Tool: Tool,
    Skin: Folder & { Accessory },
    Stats: Folder & { IntValue },
    PromptText: string,
}

export type DantistType = BaseRoleType

export type SilvaRemoverType = BaseRoleType
export type CleanerType = BaseRoleType


local Dantist: DantistType = {}
local SilvaRemover: SilvaRemoverType = {}
local Cleaner: CleanerType = {}

local Configuration = {
    Dantist = Dantist,
    SilvaRemover = SilvaRemover,
    Cleaner = Cleaner,
}

return Configuration