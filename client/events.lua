RegisterNetEvent('JLRP-Framework:teleport')
AddEventHandler('JLRP-Framework:teleport', function(coords)
	Framework.Game.Teleport(Framework.PlayerData.ped, coords)
end)

RegisterNetEvent('JLRP-Framework:setJob')
AddEventHandler('JLRP-Framework:setJob', function(job)
	if Config.EnableHud then
		local gradeLabel = job.grade_label ~= job.label and job.grade_label or ''
		if gradeLabel ~= '' then gradeLabel = ' - '..gradeLabel end
		Framework.UI.HUD.UpdateElement('job', {
			job_label = job.label,
			grade_label = gradeLabel
		})
	end
	Framework.SetPlayerData('job', job)
end)

RegisterNetEvent('JLRP-Framework:setGang')
AddEventHandler('JLRP-Framework:setGang', function(gang)
	if Config.EnableHud then
		local gradeLabel = gang.grade_label ~= gang.label and gang.grade_label or ''
		if gradeLabel ~= '' then gradeLabel = ' - '..gradeLabel end
		Framework.UI.HUD.UpdateElement('gang', {
			gang_label = gang.label,
			grade_label = gradeLabel
		})
	end
	Framework.SetPlayerData('gang', gang)
end)

RegisterNetEvent('JLRP-Framework:setAccountMoney')
AddEventHandler('JLRP-Framework:setAccountMoney', function(account)
	for k, v in ipairs(Framework.PlayerData.accounts) do
		if v.name == account.name then
			Framework.PlayerData.accounts[k] = account
			break
		end
	end

	Framework.SetPlayerData('accounts', Framework.PlayerData.accounts)

	if Config.EnableHud then
		Framework.UI.HUD.UpdateElement('account_' .. account.name, {
			money = Framework.Math.GroupDigits(account.money)
		})
	end
end)

RegisterNetEvent('JLRP-Framework:onPlayerLogout')
AddEventHandler('JLRP-Framework:onPlayerLogout', function()
	Framework.PlayerLoaded = false
	if Config.EnableHud then Framework.UI.HUD.Reset() end
end)

RegisterNetEvent('JLRP-Framework:setMaxWeight')
AddEventHandler('JLRP-Framework:setMaxWeight', function(newMaxWeight) Framework.PlayerData.maxWeight = newMaxWeight end)

RegisterNetEvent('JLRP-Framework:progressBar')
AddEventHandler('JLRP-Framework:progressBar', function(message, length, options)
	Framework.ProgressBar(message, length, options)
end)

RegisterNetEvent('JLRP-Framework:showNotification')
AddEventHandler('JLRP-Framework:showNotification', function(message, type, length)
	Framework.ShowNotification(message, type, length)
end)

RegisterNetEvent('JLRP-Framework:showAdvancedNotification')
AddEventHandler('JLRP-Framework:showAdvancedNotification', function(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
	Framework.ShowAdvancedNotification(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
end)

RegisterNetEvent('JLRP-Framework:showHelpNotification')
AddEventHandler('JLRP-Framework:showHelpNotification', function(msg, thisFrame, beep, duration)
	Framework.ShowHelpNotification(msg, thisFrame, beep, duration)
end)

RegisterNetEvent('JLRP-Framework:playerLoaded')
AddEventHandler('JLRP-Framework:playerLoaded', function(xPlayer, isNew, skin)
	Framework.PlayerLoaded = true
	Framework.PlayerData = xPlayer

	FreezeEntityPosition(PlayerPedId(), true)

	if Config.MultiCharacter then
		Wait(3000)
	else
		exports.spawnmanager:spawnPlayer({
			x = Framework.PlayerData.coords.x,
			y = Framework.PlayerData.coords.y,
			z = Framework.PlayerData.coords.z + 0.25,
			heading = Framework.PlayerData.coords.heading,
			model = GetHashKey("mp_m_freemode_01"),
			skipFade = false
		}, function()
			TriggerServerEvent('JLRP-Framework:onPlayerSpawn')
			TriggerEvent('JLRP-Framework:onPlayerSpawn')

			if isNew then
				TriggerEvent('skinchanger:loadDefaultModel', skin.sex == 0)
			elseif skin then
				TriggerEvent('skinchanger:loadSkin', skin)
			end

			TriggerEvent('JLRP-Framework:loadingScreenOff')
			
			FreezeEntityPosition(PlayerPedId(), false)
		end)
	end

	while Framework.PlayerData.ped == nil do Wait(20) end

	if Config.Player.PVP then
		SetCanAttackFriendly(Framework.PlayerData.ped, true, false)
		NetworkSetFriendlyFireOption(true)
	end

	if not Config.Player.HealthRegenerator then
		SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
	end

	if Config.EnableHud then
		-- accounts
		for k, v in ipairs(Framework.PlayerData.accounts) do
			local accountTpl = '<div>{{money}}&nbsp;<img src="images/accounts/' .. v.name .. '.png"/></div>'
			local index = v.name == "money" and 0 or v.name == "black_money" and 1 or v.name == "bank" and 2
			Framework.UI.HUD.RegisterElement('account_' .. v.name, index, 0, accountTpl, {money = Framework.Math.GroupDigits(v.money)})
		end

		-- job
		local jobTpl = '<div>{{job_label}}{{grade_label}}&nbsp;<img src="images/job.png"/></div>'

		local jobGradeLabel = Framework.PlayerData.job.grade_label ~= Framework.PlayerData.job.label and Framework.PlayerData.job.grade_label or ''
		if jobGradeLabel ~= '' then jobGradeLabel = ' - '..jobGradeLabel end

		Framework.UI.HUD.RegisterElement('job', #Framework.PlayerData.accounts, 0, jobTpl, {
			job_label = Framework.PlayerData.job.label,
			grade_label = jobGradeLabel
		})

		-- gang
		local gangTpl = '<div>{{gang_label}}{{grade_label}}&nbsp;<img src="images/gang.png"/></div>'

		local gangFradeLabel = Framework.PlayerData.gang.grade_label ~= Framework.PlayerData.gang.label and Framework.PlayerData.gang.grade_label or ''
		if gangFradeLabel ~= '' then gangFradeLabel = ' - '..gangFradeLabel end

		Framework.UI.HUD.RegisterElement('gang', #Framework.PlayerData.accounts + 1, 0, gangTpl, {
			gang_label = Framework.PlayerData.gang.label,
			grade_label = gangFradeLabel
		})
	end
	StartServerSyncLoops()
end)

local function onPlayerSpawn()
	if Framework.PlayerLoaded then
		Framework.SetPlayerData('ped', PlayerPedId())
		Framework.SetPlayerData('dead', false)
	end
end

AddEventHandler('playerSpawned', onPlayerSpawn)
AddEventHandler('JLRP-Framework:onPlayerSpawn', onPlayerSpawn)

AddEventHandler('JLRP-Framework:onPlayerDeath', function()
	Framework.SetPlayerData('ped', PlayerPedId())
	Framework.SetPlayerData('dead', true)
end)

if Config.EnableHud then
	AddEventHandler('JLRP-Framework:loadingScreenOff', function()
		ShutdownLoadingScreen()
		ShutdownLoadingScreenNui()
		Framework.UI.HUD.SetDisplay(1.0)
	end)
end

RegisterNetEvent('JLRP-Framework:serverCallback')
AddEventHandler('JLRP-Framework:serverCallback', function(requestId, ...)
	Core.ServerCallbacks[requestId](...)
	Core.ServerCallbacks[requestId] = nil
end)

RegisterNetEvent('JLRP-Framework:registerSuggestions')
AddEventHandler('JLRP-Framework:registerSuggestions', function(registeredCommands)
	for name, command in pairs(registeredCommands) do
		if command.suggestion then
			TriggerEvent('chat:addSuggestion', ('/%s'):format(name), command.suggestion.help, command.suggestion.arguments)
		end
	end
end)

RegisterNetEvent('JLRP-Framework:spawnVehicle')
AddEventHandler('JLRP-Framework:spawnVehicle', function(vehicle)
	Framework.TriggerServerCallback("JLRP-Framework:isUserAdmin", function(admin)
		if admin then
			local model = type(vehicle) == 'number' and vehicle or GetHashKey(vehicle)

			if IsModelInCdimage(model) then
				local playerCoords, playerHeading = GetEntityCoords(Framework.PlayerData.ped), GetEntityHeading(Framework.PlayerData.ped)

				Framework.Game.SpawnVehicle(model, playerCoords, playerHeading, function(vehicle)
					TaskWarpPedIntoVehicle(Framework.PlayerData.ped, vehicle, -1)
				end)
			else
				Framework.ShowNotification('~o~Invalid vehicle model!')
			end
		end
	end)
end)

RegisterNetEvent("JLRP-Framework:tpm")
AddEventHandler("JLRP-Framework:tpm", function()
	local PlayerPedId = PlayerPedId
	local GetEntityCoords = GetEntityCoords
	local GetGroundZFor_3dCoord = GetGroundZFor_3dCoord

	Framework.TriggerServerCallback("JLRP-Framework:isUserAdmin", function(admin)
		if admin then
			local blipMarker = GetFirstBlipInfoId(8)
			if not DoesBlipExist(blipMarker) then
				Framework.ShowNotification('~r~No Waypoint has been set!', true, false, 140)
				return 'marker'
			end
	
			-- Fade screen to hide how clients get teleported.
			DoScreenFadeOut(650)
			while not IsScreenFadedOut() do
				Wait(0)
			end
	
			local ped, coords = PlayerPedId(), GetBlipInfoIdCoord(blipMarker)
			local vehicle = GetVehiclePedIsIn(ped, false)
			local oldCoords = GetEntityCoords(ped)
	
			-- Unpack coords instead of having to unpack them while iterating.
			-- 825.0 seems to be the max a player can reach while 0.0 being the lowest.
			local x, y, groundZ, Z_START = coords['x'], coords['y'], 850.0, 950.0
			local found = false
			if vehicle > 0 then
				FreezeEntityPosition(vehicle, true)
			else
				FreezeEntityPosition(ped, true)
			end
	
			for i = Z_START, 0, -25.0 do
				local z = i
				if (i % 2) ~= 0 then
					z = Z_START - i
				end
				
				NewLoadSceneStart(x, y, z, x, y, z, 50.0, 0)
				local curTime = GetGameTimer()
				while IsNetworkLoadingScene() do
					if GetGameTimer() - curTime > 1000 then
						break
					end
					Wait(0)
				end
				NewLoadSceneStop()
				SetPedCoordsKeepVehicle(ped, x, y, z)
				
				while not HasCollisionLoadedAroundEntity(ped) do
					RequestCollisionAtCoord(x, y, z)
					if GetGameTimer() - curTime > 1000 then
						break
					end
					Wait(0)
				end
				
				-- Get ground coord. As mentioned in the natives, this only works if the client is in render distance.
				found, groundZ = GetGroundZFor_3dCoord(x, y, z, false)
				if found then
					Wait(0)
					SetPedCoordsKeepVehicle(ped, x, y, groundZ)
					break
				end
				Wait(0)
			end
	
			-- Remove black screen once the loop has ended.
			DoScreenFadeIn(650)
			if vehicle > 0 then
					FreezeEntityPosition(vehicle, false)
			else
					FreezeEntityPosition(ped, false)
			end
	
			if found then
				-- If Z coord was found, set coords in found coords.
				SetPedCoordsKeepVehicle(ped, x, y, groundZ)
				Framework.ShowNotification('~g~Successfully Teleported!', true, false, 140)
			else
				-- If we can't find the coords, set the coords to the old ones.
				-- We don't unpack them before since they aren't in a loop and only called once.
				SetPedCoordsKeepVehicle(ped, oldCoords['x'], oldCoords['y'], oldCoords['z'] - 1.0)
				Framework.ShowNotification('~o~You got teleported back to your previous position!', true, false, 140)
			end		
		end
	end)
end)

noclip = false
noclip_pos  = nil
RegisterNetEvent("JLRP-Framework:noclip")
AddEventHandler("JLRP-Framework:noclip", function(input)
	Framework.TriggerServerCallback("JLRP-Framework:isUserAdmin", function(admin)
		if admin then
			local player = PlayerId()

			local msg = "disabled"
			if noclip == false then
				noclip_pos = GetEntityCoords(Framework.PlayerData.ped, false)
			end

			noclip = not noclip

			if noclip then
				msg = "enabled"
			end

			Framework.ShowNotification("Noclip has been " .. msg)
		end
	end)
end)

RegisterNetEvent("JLRP-Framework:killPlayer")
AddEventHandler("JLRP-Framework:killPlayer", function()
  SetEntityHealth(Framework.PlayerData.ped, 0)
end)

RegisterNetEvent("JLRP-Framework:freezePlayer")
AddEventHandler("JLRP-Framework:freezePlayer", function(input)
    local player = PlayerId()
    if input == 'freeze' then
        SetEntityCollision(Framework.PlayerData.ped, false)
        FreezeEntityPosition(Framework.PlayerData.ped, true)
        SetPlayerInvincible(player, true)
    elseif input == 'unfreeze' then
        SetEntityCollision(Framework.PlayerData.ped, true)
	    FreezeEntityPosition(Framework.PlayerData.ped, false)
        SetPlayerInvincible(player, false)
    end
end)