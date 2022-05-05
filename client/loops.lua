function StartServerSyncLoops()
	CreateThread(function()
		local previousCoords = vector3(Framework.PlayerData.coords.x, Framework.PlayerData.coords.y, Framework.PlayerData.coords.z)

		--while Framework.PlayerLoaded do
		while true do
			local playerPed = PlayerPedId()
			if Framework.PlayerData.ped ~= playerPed then Framework.SetPlayerData('ped', playerPed) end

			if DoesEntityExist(Framework.PlayerData.ped) then
				local playerCoords = GetEntityCoords(Framework.PlayerData.ped)
				local distance = #(playerCoords - previousCoords)

				if distance > 1 then
					previousCoords = playerCoords
					local playerHeading = Framework.Math.Round(GetEntityHeading(Framework.PlayerData.ped), 1)
					local formattedCoords = {x = Framework.Math.Round(playerCoords.x, 1), y = Framework.Math.Round(playerCoords.y, 1), z = Framework.Math.Round(playerCoords.z, 1), heading = playerHeading}
					--TriggerServerEvent('Framework:updateCoords', formattedCoords)
				end
			end
			Wait(2000)
		end
	end)
end
