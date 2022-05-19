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
			local time = 1000
			while true do
				if IsPauseMenuActive() and not isPaused then
					isPaused = true
					Framework.UI.HUD.SetDisplay(0.0)
				elseif not IsPauseMenuActive() and isPaused then
					isPaused = false
					Framework.UI.HUD.SetDisplay(1.0)
				end
				Wait(time)
			end
		end
	)
end

-- SetTimeout
CreateThread(
	function()
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
	end
)

local heading = 0
CreateThread(
	function()
		while true do
			if noclip then
				SetEntityCoordsNoOffset(Framework.PlayerData.ped, noclip_pos.x, noclip_pos.y, noclip_pos.z, 0, 0, 0)
				if IsControlPressed(1, 34) then
					heading = heading + 1.5
					if heading > 360 then
						heading = 0
					end

					SetEntityHeading(Framework.PlayerData.ped, heading)
				end

				if IsControlPressed(1, 9) then
					heading = heading - 1.5
					if heading < 0 then
						heading = 360
					end

					SetEntityHeading(Framework.PlayerData.ped, heading)
				end

				if IsControlPressed(1, 8) then
					noclip_pos = GetOffsetFromEntityInWorldCoords(Framework.PlayerData.ped, 0.0, 1.0, 0.0)
				end

				if IsControlPressed(1, 32) then
					noclip_pos = GetOffsetFromEntityInWorldCoords(Framework.PlayerData.ped, 0.0, -1.0, 0.0)
				end

				if IsControlPressed(1, 27) then
					noclip_pos = GetOffsetFromEntityInWorldCoords(Framework.PlayerData.ped, 0.0, 0.0, 1.0)
				end

				if IsControlPressed(1, 173) then
					noclip_pos = GetOffsetFromEntityInWorldCoords(Framework.PlayerData.ped, 0.0, 0.0, -1.0)
				end
			else
				Wait(2000)
			end
			Wait(0)
		end
	end
)

CreateThread(function()
	local isDead = false

	while true do
		local player = PlayerId()

		if NetworkIsPlayerActive(player) then
			local playerPed = PlayerPedId()

			if IsPedFatallyInjured(playerPed) and not isDead then
				isDead = true

				local killerEntity, deathCause = GetPedSourceOfDeath(playerPed), GetPedCauseOfDeath(playerPed)
				local killerClientId = NetworkGetPlayerIndexFromPed(killerEntity)

				if killerEntity ~= playerPed and killerClientId and NetworkIsPlayerActive(killerClientId) then
					PlayerKilledByPlayer(GetPlayerServerId(killerClientId), killerClientId, deathCause)
				else
					PlayerKilled(deathCause)
				end

			elseif not IsPedFatallyInjured(playerPed) and isDead then
				isDead = false
			else
				Wait(2000)
			end
		end
		Wait(0)
	end
end)

function PlayerKilledByPlayer(killerServerId, killerClientId, deathCause)
	local victimCoords = GetEntityCoords(PlayerPedId())
	local killerCoords = GetEntityCoords(GetPlayerPed(killerClientId))
	local distance = #(victimCoords - killerCoords)

	local data = {
		victimCoords = {x = Framework.Math.Round(victimCoords.x, 1), y = Framework.Math.Round(victimCoords.y, 1), z = Framework.Math.Round(victimCoords.z, 1)},
		killerCoords = {x = Framework.Math.Round(killerCoords.x, 1), y = Framework.Math.Round(killerCoords.y, 1), z = Framework.Math.Round(killerCoords.z, 1)},

		killedByPlayer = true,
		deathCause = deathCause,
		distance = Framework.Math.Round(distance, 1),

		killerServerId = killerServerId,
		killerClientId = killerClientId
	}

	TriggerEvent('JLRP-Framework:onPlayerDeath', data)
	TriggerServerEvent('JLRP-Framework:onPlayerDeath', data)
end

function PlayerKilled(deathCause)
	local playerPed = PlayerPedId()
	local victimCoords = GetEntityCoords(playerPed)

	local data = {
		victimCoords = {x = Framework.Math.Round(victimCoords.x, 1), y = Framework.Math.Round(victimCoords.y, 1), z = Framework.Math.Round(victimCoords.z, 1)},

		killedByPlayer = false,
		deathCause = deathCause
	}

	TriggerEvent('JLRP-Framework:onPlayerDeath', data)
	TriggerServerEvent('JLRP-Framework:onPlayerDeath', data)
end