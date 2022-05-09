function onPlayerConnecting(name, setKickReason, deferrals)
    local src = source
    local license = Framework.GetIdentifier(src)
    deferrals.defer()

    -- Mandatory wait
    Wait(0)

    if Config.Server.Closed then
        if not IsPlayerAceAllowed(src, 'frameworkadmin.join') then
            deferrals.done(Config.Server.ClosedReason)
        end
    end

    deferrals.update(_Locale('checking_ban', name))

    -- Mandatory wait
    Wait(2500)

	deferrals.update(_Locale('checking_whitelisted', name))

    local isBanned, Reason = Framework.IsPlayerBanned(src)
    local isLicenseAlreadyInUse = Framework.IsLicenseInUse(license)
    local isWhitelist, whitelisted = Config.Server.Whitelist, Framework.IsWhitelisted(src)

    Wait(2500)

	deferrals.update(_Locale('join_server', name, Config.Server.Name))

    if not license then
	  deferrals.done(_Locale('no_valid_license'))
    elseif isBanned then
        deferrals.done(Reason)
    elseif isLicenseAlreadyInUse and Config.Server.CheckDuplicateLicense then
		deferrals.done(_Locale('duplicate_license'))
    elseif isWhitelist and not whitelisted then 
		deferrals.done(_Locale('not_whitelisted'))
    else
        RemoveCommmandPermissionForPlayer(src)
        deferrals.done()
        if Config.Server.UseConnectQueue then
            Wait(1000)
            TriggerEvent('connectqueue:playerConnect', name, setKickReason, deferrals)
        end
    end
end

AddEventHandler('playerConnecting', onPlayerConnecting) -- Default FiveM Event

function RemoveCommmandPermissionForPlayer(source)
	local identifiers = GetPlayerIdentifiers(source)
    for i in ipairs(identifiers) do
        ExecuteCommand(('remove_ace identifier.%s command allow'):format(identifiers[i]))
		ExecuteCommand(('add_ace identifier.%s command deny'):format(identifiers[i]))
    end
end

if Config.MultiCharacter then
	--[[Would not be implemented for now]]
else
	RegisterNetEvent('Framework:onPlayerJoined')
	AddEventHandler('Framework:onPlayerJoined', function()
		while not next(Framework.Jobs) do Wait(50) end
		if not Core.Players[source] then
			onPlayerJoined(source)
		end
	end)
end

function onPlayerJoined(source)
	local identifier = Framework.GetIdentifier(source)
	if identifier then
		if Framework.IsLicenseInUse(identifier) then
            Framework.Kick(source, _Locale('duplicate_license'), nil, nil)
        else
            Core.Player.Login(source, identifier)
		end
	else
        Framework.Kick(source, _Locale('no_valid_license'), nil, nil)
	end
end

RegisterNetEvent('Framework:updateCoords')
AddEventHandler('Framework:updateCoords', function(coords, src)
    local _source = src or source
	local xPlayer = Framework.GetPlayerFromId(_source)
	if xPlayer then
		xPlayer.updatePosition(coords)
	end
end)

RegisterNetEvent('Framework:setJob')
AddEventHandler('Framework:setJob', function(source, newJob, lastJob)
    
end)

RegisterNetEvent('Framework:setGang')
AddEventHandler('Framework:setGang', function(source, newGang, lastGang)
    
end)

RegisterNetEvent('Framework:onAddInventoryItem')
AddEventHandler('Framework:onAddInventoryItem', function(source, itemName, itemCount)
    
end)

RegisterNetEvent('Framework:onRemoveInventoryItem')
AddEventHandler('Framework:onRemoveInventoryItem', function(source, itemName, itemCount)
    
end)

RegisterNetEvent('Framework:setDuty')
AddEventHandler('Framework:setDuty', function(bool)
    local xPlayer = Framework.GetPlayerFromId(source)
    if xPlayer.job.onDuty == bool then return end
    
    if bool then
        xPlayer.setDuty(true)
        xPlayer.triggerEvent('Framework:showNotification', _Locale('started_duty'))
    else
        xPlayer.setDuty(false)
        xPlayer.triggerEvent('Framework:showNotification', _Locale('stopped_duty'))
    end
    TriggerClientEvent('Framework:setJob', xPlayer.source, xPlayer.job)
end)

RegisterNetEvent('Framework:playerLoaded')
AddEventHandler('Framework:playerLoaded', function(source, xPlayer, isNew)
    Core.Players[source] = xPlayer
end)

AddEventHandler('playerDropped', function(reason)
	local _source = source
	local xPlayer = Framework.GetPlayerFromId(_source)

	if xPlayer then
		TriggerEvent('Framework:playerDropped', _source, reason)

		Core.SavePlayer(xPlayer, function()
			Core.Players[_source] = nil
		end)
	end
end)

RegisterNetEvent('Framework:playerDropped')
AddEventHandler('Framework:playerDropped', function(source, reason)
    
end)

RegisterServerEvent('Framework:triggerServerCallback')
AddEventHandler('Framework:triggerServerCallback', function(name, requestId, ...)
	local _source = source

	Framework.TriggerServerCallback(name, requestId, _source, function(...)
		TriggerClientEvent('Framework:serverCallback', _source, requestId, ...)
	end, ...)
end)

if not Config.OxInventory then
	RegisterNetEvent('Framework:updateWeaponAmmo')
	AddEventHandler('Framework:updateWeaponAmmo', function(weaponName, ammoCount)
		local xPlayer = Framework.GetPlayerFromId(source)

		if xPlayer then
			xPlayer.updateWeaponAmmo(weaponName, ammoCount)
		end
	end)

	RegisterNetEvent('Framework:giveInventoryItem')
	AddEventHandler('Framework:giveInventoryItem', function(target, type, itemName, itemCount)
		local playerId = source
		local sourceXPlayer = Framework.GetPlayerFromId(playerId)
		local targetXPlayer = Framework.GetPlayerFromId(target)
        local distance = #(GetEntityCoords(GetPlayerPed(playerId)) - GetEntityCoords(GetPlayerPed(target)))
        if not sourceXPlayer then return end
        if not targetXPlayer then Framework.Kick(playerId, "Cheating: " ..  GetPlayerName(playerId), nil, nil) return end
        if distance > Config.DistanceGive then Framework.Kick(playerId, "Cheating: " ..  GetPlayerName(playerId), nil, nil) return end


		if type == 'item_standard' then
			local sourceItem = sourceXPlayer.getInventoryItem(itemName)

			if itemCount > 0 and sourceItem.count >= itemCount then
				if targetXPlayer.canCarryItem(itemName, itemCount) then
					sourceXPlayer.removeInventoryItem(itemName, itemCount)
					targetXPlayer.addInventoryItem   (itemName, itemCount)

					sourceXPlayer.showNotification(_Locale('gave_item', itemCount, sourceItem.label, targetXPlayer.name))
					targetXPlayer.showNotification(_Locale('received_item', itemCount, sourceItem.label, sourceXPlayer.name))
				else
					sourceXPlayer.showNotification(_Locale('ex_inv_lim', targetXPlayer.name))
				end
			else
				sourceXPlayer.showNotification(_Locale('imp_invalid_quantity'))
			end
		elseif type == 'item_account' then
			if itemCount > 0 and sourceXPlayer.getAccount(itemName).money >= itemCount then
				sourceXPlayer.removeAccountMoney(itemName, itemCount)
				targetXPlayer.addAccountMoney   (itemName, itemCount)

				sourceXPlayer.showNotification(_Locale('gave_account_money', Framework.Math.GroupDigits(itemCount), Config.Accounts[itemName], targetXPlayer.name))
				targetXPlayer.showNotification(_Locale('received_account_money', Framework.Math.GroupDigits(itemCount), Config.Accounts[itemName], sourceXPlayer.name))
			else
				sourceXPlayer.showNotification(_Locale('imp_invalid_amount'))
			end
		elseif type == 'item_weapon' then
			if sourceXPlayer.hasWeapon(itemName) then
				local weaponLabel = Framework.GetWeaponLabel(itemName)
				if not targetXPlayer.hasWeapon(itemName) then
					local _, weapon = sourceXPlayer.getWeapon(itemName)
					local _, weaponObject = Framework.GetWeapon(itemName)
					itemCount = weapon.ammo
					local weaponComponents = Framework.Table.Clone(weapon.components)
					local weaponTint = weapon.tintIndex
					if weaponTint then
                        targetXPlayer.setWeaponTint(itemName, weaponTint)
					end
					if weaponComponents then
                        for k, v in pairs(weaponComponents) do
                            targetXPlayer.addWeaponComponent(itemName, v)
                        end
					end
					sourceXPlayer.removeWeapon(itemName)
					targetXPlayer.addWeapon(itemName, itemCount)

					if weaponObject.ammo and itemCount > 0 then
						local ammoLabel = weaponObject.ammo.label
						sourceXPlayer.showNotification(_Locale('gave_weapon_withammo', weaponLabel, itemCount, ammoLabel, targetXPlayer.name))
						targetXPlayer.showNotification(_Locale('received_weapon_withammo', weaponLabel, itemCount, ammoLabel, sourceXPlayer.name))
					else
						sourceXPlayer.showNotification(_Locale('gave_weapon', weaponLabel, targetXPlayer.name))
						targetXPlayer.showNotification(_Locale('received_weapon', weaponLabel, sourceXPlayer.name))
					end
				else
					sourceXPlayer.showNotification(_Locale('gave_weapon_hasalready', targetXPlayer.name, weaponLabel))
					targetXPlayer.showNotification(_Locale('received_weapon_hasalready', sourceXPlayer.name, weaponLabel))
				end
			end
		elseif type == 'item_ammo' then
			if sourceXPlayer.hasWeapon(itemName) then
				local weaponNum, weapon = sourceXPlayer.getWeapon(itemName)

				if targetXPlayer.hasWeapon(itemName) then
					local _, weaponObject = Framework.GetWeapon(itemName)

					if weaponObject.ammo then
						local ammoLabel = weaponObject.ammo.label

						if weapon.ammo >= itemCount then
							sourceXPlayer.removeWeaponAmmo(itemName, itemCount)
							targetXPlayer.addWeaponAmmo(itemName, itemCount)

							sourceXPlayer.showNotification(_Locale('gave_weapon_ammo', itemCount, ammoLabel, weapon.label, targetXPlayer.name))
							targetXPlayer.showNotification(_Locale('received_weapon_ammo', itemCount, ammoLabel, weapon.label, sourceXPlayer.name))
						end
					end
				else
					sourceXPlayer.showNotification(_Locale('gave_weapon_noweapon', targetXPlayer.name))
					targetXPlayer.showNotification(_Locale('received_weapon_noweapon', sourceXPlayer.name, weapon.label))
				end
			end
		end
	end)

	RegisterNetEvent('Framework:removeInventoryItem')
	AddEventHandler('Framework:removeInventoryItem', function(type, itemName, itemCount)
		local playerId = source
		local xPlayer = Framework.GetPlayerFromId(source)

		if type == 'item_standard' then
			if itemCount == nil or itemCount < 1 then
				xPlayer.showNotification(_Locale('imp_invalid_quantity'))
			else
				local xItem = xPlayer.getInventoryItem(itemName)

				if (itemCount > xItem.count or xItem.count < 1) then
					xPlayer.showNotification(_Locale('imp_invalid_quantity'))
				else
					xPlayer.removeInventoryItem(itemName, itemCount)
					local pickupLabel = ('~y~%s~s~ [~b~%s~s~]'):format(xItem.label, itemCount)
					Framework.CreatePickup('item_standard', itemName, itemCount, pickupLabel, playerId)
					xPlayer.showNotification(_Locale('threw_standard', itemCount, xItem.label))
				end
			end
		elseif type == 'item_account' then
			if itemCount == nil or itemCount < 1 then
				xPlayer.showNotification(_Locale('imp_invalid_amount'))
			else
				local account = xPlayer.getAccount(itemName)

				if (itemCount > account.money or account.money < 1) then
					xPlayer.showNotification(_Locale('imp_invalid_amount'))
				else
					xPlayer.removeAccountMoney(itemName, itemCount)
					local pickupLabel = ('~y~%s~s~ [~g~%s~s~]'):format(account.label, _Locale('locale_currency', Framework.Math.GroupDigits(itemCount)))
					Framework.CreatePickup('item_account', itemName, itemCount, pickupLabel, playerId)
					xPlayer.showNotification(_Locale('threw_account', Framework.Math.GroupDigits(itemCount), string.lower(account.label)))
				end
			end
		elseif type == 'item_weapon' then
			itemName = string.upper(itemName)

			if xPlayer.hasWeapon(itemName) then
				local _, weapon = xPlayer.getWeapon(itemName)
				local _, weaponObject = Framework.GetWeapon(itemName)
				local components, pickupLabel = Framework.Table.Clone(weapon.components)
				xPlayer.removeWeapon(itemName)

				if weaponObject.ammo and weapon.ammo > 0 then
					local ammoLabel = weaponObject.ammo.label
					pickupLabel = ('~y~%s~s~ [~g~%s~s~ %s]'):format(weapon.label, weapon.ammo, ammoLabel)
					xPlayer.showNotification(_Locale('threw_weapon_ammo', weapon.label, weapon.ammo, ammoLabel))
				else
					pickupLabel = ('~y~%s~s~'):format(weapon.label)
					xPlayer.showNotification(_Locale('threw_weapon', weapon.label))
				end

				Framework.CreatePickup('item_weapon', itemName, weapon.ammo, pickupLabel, playerId, components, weapon.tintIndex)
			end
		end
	end)


	RegisterNetEvent('Framework:useItem')
	AddEventHandler('Framework:useItem', function(itemName)
		local xPlayer = Framework.GetPlayerFromId(source)
		local count = xPlayer.getInventoryItem(itemName).count

		if count > 0 then
			Framework.UseItem(source, itemName)
		else
			xPlayer.showNotification(_Locale('act_imp'))
		end
	end)

	RegisterNetEvent('Framework:onPickup')
	AddEventHandler('Framework:onPickup', function(pickupId)
		local pickup, xPlayer, success = Core.Pickups[pickupId], Framework.GetPlayerFromId(source)

		if pickup then
			if pickup.type == 'item_standard' then
				if xPlayer.canCarryItem(pickup.name, pickup.count) then
					xPlayer.addInventoryItem(pickup.name, pickup.count)
					success = true
				else
					xPlayer.showNotification(_Locale('threw_cannot_pickup'))
				end
			elseif pickup.type == 'item_account' then
				success = true
				xPlayer.addAccountMoney(pickup.name, pickup.count)
			elseif pickup.type == 'item_weapon' then
				if xPlayer.hasWeapon(pickup.name) then
					xPlayer.showNotification(_Locale('threw_weapon_already'))
				else
					success = true
					xPlayer.addWeapon(pickup.name, pickup.count)
					xPlayer.setWeaponTint(pickup.name, pickup.tintIndex)

					for k,v in ipairs(pickup.components) do
						xPlayer.addWeaponComponent(pickup.name, v)
					end
				end
			end

			if success then
				Core.Pickups[pickupId] = nil
				TriggerClientEvent('Framework:removePickup', -1, pickupId)
			end
		end
	end)
end
