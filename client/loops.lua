function StartServerSyncLoops()
	CreateThread(
		function()
			local previousCoords =
				vector3(Framework.PlayerData.coords.x, Framework.PlayerData.coords.y, Framework.PlayerData.coords.z)

			while Framework.PlayerLoaded do
				local playerPed = PlayerPedId()
				if Framework.PlayerData.ped ~= playerPed then
					Framework.SetPlayerData("ped", playerPed)
				end

				if DoesEntityExist(Framework.PlayerData.ped) then
					local playerCoords = GetEntityCoords(Framework.PlayerData.ped)
					local distance = #(playerCoords - previousCoords)

					if distance > 1 then
						previousCoords = playerCoords
						local playerHeading = Framework.Math.Round(GetEntityHeading(Framework.PlayerData.ped), 1)
						local formattedCoords = {
							x = Framework.Math.Round(playerCoords.x, 1),
							y = Framework.Math.Round(playerCoords.y, 1),
							z = Framework.Math.Round(playerCoords.z, 1),
							heading = playerHeading
						}
						Framework.SetPlayerData("coords", formattedCoords)
					end
				end
				Wait(2000)
			end
		end
	)
end

if Config.EnableHud then
	CreateThread(
		function()
			local isPaused = false
			local time = 500
			while true do
				Wait(time)

				if IsPauseMenuActive() and not isPaused then
					time = 100
					isPaused = true
					Framework.UI.HUD.SetDisplay(0.0)
				elseif not IsPauseMenuActive() and isPaused then
					time = 100
					isPaused = false
					Framework.UI.HUD.SetDisplay(1.0)
				end
			end
		end
	)
end

-- SetTimeout
CreateThread(function()
	while true do
		local sleep = 100
		if #Core.TimeoutCallbacks > 0 then
			local currTime = GetGameTimer()
			sleep = 0
			for i = 1, #Core.TimeoutCallbacks, 1 do
				if currTime >= Core.TimeoutCallbacks[i].time then
					Core.TimeoutCallbacks[i].cb()
					Core.TimeoutCallbacks[i] = nil
				end
			end
		end
		Wait(sleep)
	end
end)