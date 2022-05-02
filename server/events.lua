if Config.Multichar then
	--[[Would not be implemented for now]]
else
	RegisterNetEvent('Framework:onPlayerJoined')
	AddEventHandler('Framework:onPlayerJoined', function()
		while not next(Framework.Jobs) do Wait(50) end

		if not Framework.Players[source] then
			onPlayerJoined(source)
		end
	end)
end