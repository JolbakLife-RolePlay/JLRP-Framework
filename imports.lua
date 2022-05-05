local RESOURCE_NAME = exports['Framework'] -- To Store the metadata of exports
Framework = RESOURCE_NAME:GetFrameworkObjects()

if not IsDuplicityVersion() then -- Only register this event for the client
	AddEventHandler('Framework:setPlayerData', function(key, val, last)
		if GetInvokingResource() == 'Framework' then
			Framework.PlayerData[key] = val
			if OnPlayerData ~= nil then OnPlayerData(key, val, last) end -- The function we can create inside external resources
		end
	end)
end