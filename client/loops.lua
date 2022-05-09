function StartServerSyncLoops()
	if not Config.OxInventory then
		-- keep track of ammo
		CreateThread(
			function()
				local currentWeapon = {Ammo = 0}
				while Framework.PlayerLoaded do
					local sleep = 300
					if GetSelectedPedWeapon(Framework.PlayerData.ped) ~= -1569615261 then
						sleep = 0
						local _, weaponHash = GetCurrentPedWeapon(Framework.PlayerData.ped, true)
						local weapon = Framework.GetWeaponFromHash(weaponHash)
						if weapon then
							local ammoCount = GetAmmoInPedWeapon(Framework.PlayerData.ped, weaponHash)
							if weapon.name ~= currentWeapon.name then
								currentWeapon.Ammo = ammoCount
								currentWeapon.name = weapon.name
							else
								if ammoCount ~= currentWeapon.Ammo then
									currentWeapon.Ammo = ammoCount
									TriggerServerEvent("Framework:updateWeaponAmmo", weapon.name, ammoCount)
								end
							end
						end
					end
					Wait(sleep)
				end
			end
		)
	end

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
