export type LobbyType = Folder & {
    Capsules: Folder & { 
        Capsule: Model & { 
            PrimaryPart: Part & { 
                PromptAttachment: Attachment 
            } 
        } 
    }
}

local Instances = {
    Lobby = Instance.new("Folder") :: LobbyType -- Wait for child
}

return Instances