local function clearConnections(
    _connections: { [string]: RBXScriptConnection } | { RBXScriptConnection },
    filter: (connectIndex: number | string) -> boolean?
)
    for connectIndex, connect in _connections do
		if filter and filter(connectIndex) then
            continue
		end
        connect:Disconnect()
	end
    
end

return clearConnections