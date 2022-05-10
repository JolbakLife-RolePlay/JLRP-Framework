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

if not Config.OxInventory then
	RegisterNetEvent('JLRP-Framework:addInventoryItem')
	AddEventHandler('JLRP-Framework:addInventoryItem', function(item, count, showNotification)
		for k, v in ipairs(Framework.PlayerData.inventory) do
			if v.name == item then
				Framework.UI.ShowInventoryItemNotification(true, v.label, count - v.count)
				Framework.PlayerData.inventory[k].count = count
				break
			end
		end

		if showNotification then
			Framework.UI.ShowInventoryItemNotification(true, item, count)
		end

		if Framework.UI.Menu.IsOpen('default', 'Framework', 'inventory') then
			Framework.ShowInventory()
		end
	end)

	RegisterNetEvent('JLRP-Framework:removeInventoryItem')
	AddEventHandler('JLRP-Framework:removeInventoryItem', function(item, count, showNotification)
		for k, v in ipairs(Framework.PlayerData.inventory) do
			if v.name == item then
				Framework.UI.ShowInventoryItemNotification(false, v.label, v.count - count)
				Framework.PlayerData.inventory[k].count = count
				break
			end
		end

		if showNotification then
			Framework.UI.ShowInventoryItemNotification(false, item, count)
		end

		if Framework.UI.Menu.IsOpen('default', 'Framework', 'inventory') then
			Framework.ShowInventory()
		end
	end)

	RegisterNetEvent('JLRP-Framework:addWeapon')
	AddEventHandler('JLRP-Framework:addWeapon', function(weapon, ammo)
		GiveWeaponToPed(Framework.PlayerData.ped, GetHashKey(weapon), ammo, false, false)
	end)

	RegisterNetEvent('JLRP-Framework:addWeaponComponent')
	AddEventHandler('JLRP-Framework:addWeaponComponent', function(weapon, weaponComponent)
		local componentHash = Framework.GetWeaponComponent(weapon, weaponComponent).hash
		GiveWeaponComponentToPed(Framework.PlayerData.ped, GetHashKey(weapon), componentHash)
	end)

	RegisterNetEvent('JLRP-Framework:setWeaponAmmo')
	AddEventHandler('JLRP-Framework:setWeaponAmmo', function(weapon, weaponAmmo)
		SetPedAmmo(Framework.PlayerData.ped, GetHashKey(weapon), weaponAmmo)
	end)

	RegisterNetEvent('JLRP-Framework:setWeaponTint')
	AddEventHandler('JLRP-Framework:setWeaponTint', function(weapon, weaponTintIndex)
		SetPedWeaponTintIndex(Framework.PlayerData.ped, GetHashKey(weapon), weaponTintIndex)
	end)

	RegisterNetEvent('JLRP-Framework:removeWeapon')
	AddEventHandler('JLRP-Framework:removeWeapon', function(weapon)
		local playerPed = Framework.PlayerData.ped
		RemoveWeaponFromPed(Framework.PlayerData.ped, GetHashKey(weapon))
		SetPedAmmo(Framework.PlayerData.ped, GetHashKey(weapon), 0)
	end)

	RegisterNetEvent('JLRP-Framework:removeWeaponComponent')
	AddEventHandler('JLRP-Framework:removeWeaponComponent', function(weapon, weaponComponent)
		local componentHash = Framework.GetWeaponComponent(weapon, weaponComponent).hash
		RemoveWeaponComponentFromPed(Framework.PlayerData.ped, GetHashKey(weapon), componentHash)
	end)
end

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
			TriggerEvent('JLRP-Framework:restoreLoadout')

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

