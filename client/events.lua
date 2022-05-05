RegisterNetEvent('Framework:teleport')
AddEventHandler('Framework:teleport', function(coords)
	Framework.Game.Teleport(Framework.PlayerData.ped, coords)
end)

RegisterNetEvent('Framework:setJob')
AddEventHandler('Framework:setJob', function(Job)
	if Config.EnableHud then
		-- TODO
	end
	Framework.SetPlayerData('job', Job)
end)

RegisterNetEvent('Framework:setGang')
AddEventHandler('Framework:setGang', function(Gang)
	if Config.EnableHud then
		-- TODO
	end
	Framework.SetPlayerData('gang', Gang)
end)

RegisterNetEvent('Framework:setAccountMoney')
AddEventHandler('Framework:setAccountMoney', function(account)
	for k, v in ipairs(Framework.PlayerData.accounts) do
		if v.name == account.name then
			Framework.PlayerData.accounts[k] = account
			break
		end
	end

	Framework.SetPlayerData('accounts', Framework.PlayerData.accounts)

	if Config.EnableHud then
		-- TODO
	end
end)

if not Config.OxInventory then
	RegisterNetEvent('Framework:addInventoryItem')
	AddEventHandler('Framework:addInventoryItem', function(item, count, showNotification)
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

	RegisterNetEvent('Framework:removeInventoryItem')
	AddEventHandler('Framework:removeInventoryItem', function(item, count, showNotification)
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

	RegisterNetEvent('Framework:addWeapon')
	AddEventHandler('Framework:addWeapon', function(weapon, ammo)
		GiveWeaponToPed(Framework.PlayerData.ped, GetHashKey(weapon), ammo, false, false)
	end)

	RegisterNetEvent('Framework:addWeaponComponent')
	AddEventHandler('Framework:addWeaponComponent', function(weapon, weaponComponent)
		local componentHash = Framework.GetWeaponComponent(weapon, weaponComponent).hash
		GiveWeaponComponentToPed(Framework.PlayerData.ped, GetHashKey(weapon), componentHash)
	end)

	RegisterNetEvent('Framework:setWeaponAmmo')
	AddEventHandler('Framework:setWeaponAmmo', function(weapon, weaponAmmo)
		SetPedAmmo(Framework.PlayerData.ped, GetHashKey(weapon), weaponAmmo)
	end)

	RegisterNetEvent('Framework:setWeaponTint')
	AddEventHandler('Framework:setWeaponTint', function(weapon, weaponTintIndex)
		SetPedWeaponTintIndex(Framework.PlayerData.ped, GetHashKey(weapon), weaponTintIndex)
	end)

	RegisterNetEvent('Framework:removeWeapon')
	AddEventHandler('Framework:removeWeapon', function(weapon)
		local playerPed = Framework.PlayerData.ped
		RemoveWeaponFromPed(Framework.PlayerData.ped, GetHashKey(weapon))
		SetPedAmmo(Framework.PlayerData.ped, GetHashKey(weapon), 0)
	end)

	RegisterNetEvent('Framework:removeWeaponComponent')
	AddEventHandler('Framework:removeWeaponComponent', function(weapon, weaponComponent)
		local componentHash = Framework.GetWeaponComponent(weapon, weaponComponent).hash
		RemoveWeaponComponentFromPed(Framework.PlayerData.ped, GetHashKey(weapon), componentHash)
	end)
end

RegisterNetEvent('Framework:setMaxWeight')
AddEventHandler('Framework:setMaxWeight', function(newMaxWeight) Framework.PlayerData.maxWeight = newMaxWeight end)

RegisterNetEvent('Framework:progressBar')
AddEventHandler('Framework:progressBar', function(message, length, options)
	Framework.ProgressBar(message, length, options)
end)

RegisterNetEvent('Framework:showNotification')
AddEventHandler('Framework:showNotification', function(msg)
	Framework.ShowNotification(msg)
end)

RegisterNetEvent('Framework:showAdvancedNotification')
AddEventHandler('Framework:showAdvancedNotification', function(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
	Framework.ShowAdvancedNotification(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
end)

RegisterNetEvent('Framework:showHelpNotification')
AddEventHandler('Framework:showHelpNotification', function(msg, thisFrame, beep, duration)
	Framework.ShowHelpNotification(msg, thisFrame, beep, duration)
end)

RegisterNetEvent('Framework:playerLoaded')
AddEventHandler('Framework:playerLoaded', function(xPlayer, isNew, skin)
	Framework.PlayerLoaded = true
	Framework.PlayerData = xPlayer

	FreezeEntityPosition(PlayerPedId(), true)

	if Config.Multichar then
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
			TriggerServerEvent('Framework:onPlayerSpawn')
			TriggerEvent('Framework:onPlayerSpawn')
			TriggerEvent('Framework:restoreLoadout')

			if isNew then
				TriggerEvent('skinchanger:loadDefaultModel', skin.sex == 0)
			elseif skin then
				TriggerEvent('skinchanger:loadSkin', skin)
			end

			TriggerEvent('Framework:loadingScreenOff')
			ShutdownLoadingScreen()
			ShutdownLoadingScreenNui()
			FreezeEntityPosition(Framework.PlayerData.ped, false)
		end)
	end

	while Framework.PlayerData.ped == nil do Wait(20) end
	-- enable PVP
	if Config.Player.PVP then
		SetCanAttackFriendly(Framework.PlayerData.ped, true, false)
		NetworkSetFriendlyFireOption(true)
	end

	if Config.DisableHealthRegen then
		SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0)
	end

	if Config.EnableHud then
		for k,v in ipairs(Framework.PlayerData.accounts) do
			local accountTpl = '<div><img src="img/accounts/' .. v.name .. '.png"/>&nbsp;{{money}}</div>'
			Framework.UI.HUD.RegisterElement('account_' .. v.name, k, 0, accountTpl, {money = Framework.Math.GroupDigits(v.money)})
		end

		local jobTpl = '<div>{{job_label}}{{grade_label}}</div>'

		local gradeLabel = Framework.PlayerData.job.grade_label ~= Framework.PlayerData.job.label and Framework.PlayerData.job.grade_label or ''
		if gradeLabel ~= '' then gradeLabel = ' - '..gradeLabel end

		Framework.UI.HUD.RegisterElement('job', #Framework.PlayerData.accounts, 0, jobTpl, {
			job_label = Framework.PlayerData.job.label,
			grade_label = gradeLabel
		})
	end
	StartServerSyncLoops()
end)

AddEventHandler('Framework:loadingScreenOff', function()
	Framework.UI.HUD.SetDisplay(1.0)
end)