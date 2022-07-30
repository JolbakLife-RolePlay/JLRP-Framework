RegisterNetEvent('JLRP-Framework:teleport')
AddEventHandler('JLRP-Framework:teleport', function(coords)
	Framework.Game.Teleport(Framework.PlayerData.ped, coords)
end)

RegisterNetEvent('JLRP-Framework:setGroup')
AddEventHandler('JLRP-Framework:setGroup', function(group)
	Framework.SetPlayerData('group', group)
end)

RegisterNetEvent('JLRP-Framework:adminDuty')
AddEventHandler('JLRP-Framework:adminDuty', function(newState)
	Framework.SetPlayerData('adminduty', newState)
	Framework.SetPlayerData('admin_duty', newState)
	Framework.SetPlayerData('admin', newState)
	Framework.SetPlayerData('adminDuty', newState)
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
AddEventHandler('JLRP-Framework:showNotification', function(message, type, length, extra)
	Framework.ShowNotification(message, type, length, extra)
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
			Framework.SetPlayerData('group', Framework.PlayerData.group)
			TriggerEvent('JLRP-Framework:adminDuty', false)
			Framework.SetPlayerData('job', Framework.PlayerData.job)
			Framework.SetPlayerData('gang', Framework.PlayerData.gang)
			Framework.SetPlayerData('accounts', Framework.PlayerData.accounts)
			Framework.SetPlayerData('metadata', Framework.PlayerData.metadata)

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
			local accountTpl = '<div>{{money}}&nbsp;<img src="images/accounts/' .. v.name .. '.png" style="vertical-align:middle;"/></div>'
			local index = v.name == "money" and 0 or v.name == "black_money" and 1 or v.name == "bank" and 2
			Framework.UI.HUD.RegisterElement('account_' .. v.name, index, 0, accountTpl, {money = Framework.Math.GroupDigits(v.money)})
		end

		-- job
		local jobTpl = '<div>{{job_label}}{{grade_label}}&nbsp;<img src="images/job.png" style="vertical-align:middle;"/></div>'

		local jobGradeLabel = Framework.PlayerData.job.grade_label ~= Framework.PlayerData.job.label and Framework.PlayerData.job.grade_label or ''
		if jobGradeLabel ~= '' then jobGradeLabel = ' - '..jobGradeLabel end

		Framework.UI.HUD.RegisterElement('job', #Framework.PlayerData.accounts, 0, jobTpl, {
			job_label = Framework.PlayerData.job.label,
			grade_label = jobGradeLabel
		})

		-- gang
		local gangTpl = '<div>{{gang_label}}{{grade_label}}&nbsp;<img src="images/gang.png" style="vertical-align:middle;"/></div>'

		local gangFradeLabel = Framework.PlayerData.gang.grade_label ~= Framework.PlayerData.gang.label and Framework.PlayerData.gang.grade_label or ''
		if gangFradeLabel ~= '' then gangFradeLabel = ' - '..gangFradeLabel end

		Framework.UI.HUD.RegisterElement('gang', #Framework.PlayerData.accounts + 1, 0, gangTpl, {
			gang_label = Framework.PlayerData.gang.label,
			grade_label = gangFradeLabel
		})
	end
	StartServerSyncLoops()
end)

AddEventHandler('playerSpawned', onPlayerSpawn)
AddEventHandler('JLRP-Framework:onPlayerSpawn', function()
	if Framework.PlayerLoaded then
		Framework.SetPlayerData('ped', PlayerPedId())
		Framework.SetPlayerData('isdead', false)
		Framework.SetPlayerData('is_dead', false)
		Framework.SetPlayerData('dead', false)
	end
end)

AddEventHandler('JLRP-Framework:onPlayerDeath', function()
	Framework.SetPlayerData('ped', PlayerPedId())
	Framework.SetPlayerData('isdead', true)
	Framework.SetPlayerData('is_dead', true)
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
				local vehicle = GetVehiclePedIsIn(Framework.PlayerData.ped)
				if vehicle ~= 0 then
					Framework.Game.DeleteVehicle(vehicle)
				end
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
				Framework.ShowNotification('~g~Successfully Teleported!', "success")
			else
				-- If we can't find the coords, set the coords to the old ones.
				-- We don't unpack them before since they aren't in a loop and only called once.
				SetPedCoordsKeepVehicle(ped, oldCoords['x'], oldCoords['y'], oldCoords['z'] - 1.0)
				Framework.ShowNotification('~o~You got teleported back to your previous position!', "error")
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

RegisterNetEvent("JLRP-Framework:onMetadataChange")
AddEventHandler("JLRP-Framework:onMetadataChange", function(newMetadata)
	Framework.SetPlayerData('metadata', newMetadata)
end)

RegisterNetEvent("JLRP-Framework:deleteVehicle")
AddEventHandler("JLRP-Framework:deleteVehicle", function()
	local vehicle = GetVehiclePedIsIn(Framework.PlayerData.ped)
	if vehicle ~= 0 then
		Framework.Game.DeleteVehicle(vehicle)
	end
end)

local currentlyShowing3D = {}
RegisterNetEvent("JLRP-Framework:show3D")
AddEventHandler("JLRP-Framework:show3D", function(senderId, message, duration, distance, size, font, r, g, b, a)
	if senderId and senderId ~= 0 then
		if currentlyShowing3D[senderId] == nil then
			CreateThread(function()
				local tempSenderId = senderId
				currentlyShowing3D[senderId] = { message = message, duration = (duration ~= nil and duration or 10000) + GetGameTimer(), distance = distance ~= nil and distance or 30.0, size = size, font = font, r = r, g = g, b = b, a = a }
				local sender = GetPlayerFromServerId(tempSenderId)
				while currentlyShowing3D[tempSenderId] and currentlyShowing3D[tempSenderId].duration >= GetGameTimer() do
					local targetPed = GetPlayerPed(sender)
					if targetPed and (GetPlayerServerId(targetPed) == tempSenderId or GetPlayerServerId(targetPed) == GetPlayerServerId(PlayerPedId())) then
						local tCoords = GetPedBoneCoords(targetPed, 31086)
						if tCoords and #(GetEntityCoords(Framework.PlayerData.ped) - tCoords) <= currentlyShowing3D[tempSenderId].distance then
							if HasEntityClearLosToEntity(Framework.PlayerData.ped, targetPed, 13) then
								Framework.Game.Utils.DrawText3D(vec(tCoords.x, tCoords.y, tCoords.z + 0.4), currentlyShowing3D[tempSenderId].message, currentlyShowing3D[tempSenderId].size, currentlyShowing3D[tempSenderId].font, currentlyShowing3D[tempSenderId].r, currentlyShowing3D[tempSenderId].g, currentlyShowing3D[tempSenderId].b, currentlyShowing3D[tempSenderId].a)
							end
						else
							Wait(500)
						end
					else
						Wait(500)
					end
					Wait(0)
				end
				currentlyShowing3D[tempSenderId] = nil
			end)
		else
			currentlyShowing3D[senderId] = { message = message, duration = (duration ~= nil and duration or 10000) + GetGameTimer(), distance = distance ~= nil and distance or 30.0, size = size, font = font, r = r, g = g, b = b, a = a }
		end
	end
end)

RegisterNetEvent("JLRP-Framework:updateStatus")
AddEventHandler("JLRP-Framework:updateStatus", function(newHunger, newThirst, newStress, newDrunk)
	
end)