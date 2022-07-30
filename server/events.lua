function onPlayerConnecting(name, setKickReason, deferrals)
    local src = source
    local license = Framework.GetIdentifier(src)
    deferrals.defer()

    -- Mandatory wait
    Wait(0)

    if Config.Server.Closed then
        if not IsPlayerAceAllowed(src, 'join') then
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
	RegisterNetEvent('JLRP-Framework:onPlayerJoined')
	AddEventHandler('JLRP-Framework:onPlayerJoined', function()
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

RegisterNetEvent('JLRP-Framework:updateCoords')
AddEventHandler('JLRP-Framework:updateCoords', function(coords, src)
    local _source = src or source
	local xPlayer = Framework.GetPlayerFromId(_source)
	if xPlayer then
		xPlayer.updatePosition(coords)
	end
end)

RegisterNetEvent('JLRP-Framework:setGroup')
AddEventHandler('JLRP-Framework:setGroup', function(source, newGroup, lastGroup)
    
end)

RegisterNetEvent('JLRP-Framework:adminDuty')
AddEventHandler('JLRP-Framework:adminDuty', function(source, newState)
    
end)

RegisterNetEvent('JLRP-Framework:setJob')
AddEventHandler('JLRP-Framework:setJob', function(source, newJob, lastJob)
    
end)

RegisterNetEvent('JLRP-Framework:setGang')
AddEventHandler('JLRP-Framework:setGang', function(source, newGang, lastGang)
    
end)

RegisterNetEvent('JLRP-Framework:onAddInventoryItem')
AddEventHandler('JLRP-Framework:onAddInventoryItem', function(source, itemName, itemCount)
    
end)

RegisterNetEvent('JLRP-Framework:onRemoveInventoryItem')
AddEventHandler('JLRP-Framework:onRemoveInventoryItem', function(source, itemName, itemCount)
    
end)

RegisterNetEvent('JLRP-Framework:setDuty')
AddEventHandler('JLRP-Framework:setDuty', function(bool)
    local xPlayer = Framework.GetPlayerFromId(source)
    if xPlayer.getJob().onDuty == bool then return end
    
    if bool then
        xPlayer.setDuty(true)
        xPlayer.triggerEvent('JLRP-Framework:showNotification', _Locale('started_duty'))
    else
        xPlayer.setDuty(false)
        xPlayer.triggerEvent('JLRP-Framework:showNotification', _Locale('stopped_duty'))
    end
    TriggerClientEvent('JLRP-Framework:setJob', xPlayer.source, xPlayer.getJob())
end)

RegisterNetEvent('JLRP-Framework:playerLoaded')
AddEventHandler('JLRP-Framework:playerLoaded', function(source, xPlayer, isNew)
    Core.Players[source] = xPlayer
end)

AddEventHandler('playerDropped', function(reason)
	local _source = source
	local xPlayer = Framework.GetPlayerFromId(_source)

	if xPlayer then
		TriggerEvent('JLRP-Framework:playerDropped', _source, reason)

		Core.SavePlayer(xPlayer, function()
			Core.Players[_source] = nil
		end)
	end
end)

RegisterNetEvent('JLRP-Framework:playerDropped')
AddEventHandler('JLRP-Framework:playerDropped', function(source, reason)
    
end)

RegisterNetEvent('JLRP-Framework:triggerServerCallback')
AddEventHandler('JLRP-Framework:triggerServerCallback', function(name, requestId, ...)
	local _source = source

	Framework.TriggerServerCallback(name, requestId, _source, function(...)
		TriggerClientEvent('JLRP-Framework:serverCallback', _source, requestId, ...)
	end, ...)
end)

RegisterNetEvent('JLRP-Framework:onPlayerSpawn')
AddEventHandler('JLRP-Framework:onPlayerSpawn', function()
	local _source = source
    local xPlayer = Framework.GetPlayerFromId(_source)
    if xPlayer then
        --[[
        if xPlayer.getMetadata('dead') then
            MySQL.update(QUERIES.MODIFY_DEATH, { false, xPlayer.citizenid })
            xPlayer.setMetadata('isdead', false, false)
            xPlayer.setMetadata('is_dead', false, false)
            xPlayer.metadata['isDead'] = false -- we use this method because xPlayer.setMetadata(key, val, sync) translates the key to lowercase
            xPlayer.setMetadata('dead', false, false)
        end
        ]]
        MySQL.update(QUERIES.MODIFY_DEATH, { false, xPlayer.citizenid })
        xPlayer.setMetadata('isdead', false, false)
        xPlayer.setMetadata('is_dead', false, false)
        xPlayer.metadata['isDead'] = false -- we use this method because xPlayer.setMetadata(key, val, sync) translates the key to lowercase
        xPlayer.setMetadata('dead', false, false)

        xPlayer.setMetadata('hunger', 50)
        xPlayer.setMetadata('thirst', 50)
        xPlayer.setMetadata('stress', 0)
        xPlayer.setMetadata('drunk', 0)

        xPlayer.syncMetadata()
        xPlayer.triggerEvent('JLRP-Framework:updateStatus', xPlayer.getMetadata('hunger'), xPlayer.getMetadata('thirst'), xPlayer.getMetadata('stress'), xPlayer.getMetadata('drunk'))
    end
end)

RegisterNetEvent('JLRP-Framework:onPlayerDeath')
AddEventHandler('JLRP-Framework:onPlayerDeath', function(xPlayer, isNew)
    --print(data.victimCoords)
    --print(data.killedByPlayer)
    --print(data.deathCause)
    local _source = source
    local xPlayer = Framework.GetPlayerFromId(_source)
    if xPlayer then
        MySQL.update(QUERIES.MODIFY_DEATH, { true, xPlayer.citizenid })
        xPlayer.setMetadata('isdead', true, false)
        xPlayer.setMetadata('is_dead', true, false)
        xPlayer.metadata['isDead'] = true -- we use this method because xPlayer.setMetadata(key, val, sync) translates the key to lowercase
        xPlayer.setMetadata('dead', true, true)
    end
end)

RegisterNetEvent("JLRP-Framework:onMetadataChange")
AddEventHandler("JLRP-Framework:onMetadataChange", function(source, newMetadata)
    
end)

-- Non-Chat Command Calling
RegisterNetEvent('JLRP-Framework:callCommand', function(command, args)
    local src = source
    if not Core.RegisteredCommands[command] then return end
    local xPlayer = Framework.GetPlayerFromId(src)
    if not xPlayer then return end
    local hasPerm = Framework.HasPermission(src, "command."..command)
	print("JLRP-Framework:callCommand => "..tostring(hasPerm).." - "..command)
    if hasPerm then
        if Core.RegisteredCommands[command].suggestion.arguments and #Core.RegisteredCommands[command].suggestion.arguments ~= 0 and not args[#Core.RegisteredCommands[command].suggestion.arguments] then
			xPlayer.showNotification(_U("commanderror_missing_args"), 'error')
        else
            Core.RegisteredCommands[command].cb(src, args)
        end
    else
		xPlayer.showNotification(_U("command_adminduty_not_authorized"), 'error')
    end
end)

-- hunger
RegisterNetEvent('JLRP-Framework:addHunger', function(amount)
    local src = source
    local xPlayer = Framework.GetPlayerFromId(src)
    if xPlayer then
        local newValue = xPlayer.getMetadata('hunger') + (amount ~= nil and amount or Config.Player.HungerRate)
        
        if newValue > 100 then
            newValue = 100
        elseif newValue < 0 then
            newValue = 0
        end
        xPlayer.setMetadata('hunger', newValue, true)
        xPlayer.triggerEvent('JLRP-Framework:updateStatus', newValue, nil, nil, nil)
    end
end)

RegisterNetEvent('JLRP-Framework:removeHunger', function(amount)
    local src = source
    local xPlayer = Framework.GetPlayerFromId(src)
    if xPlayer then
        local newValue = xPlayer.getMetadata('hunger') - (amount ~= nil and amount or Config.Player.HungerRate)
        
        if newValue > 100 then
            newValue = 100
        elseif newValue < 0 then
            newValue = 0
        end
        xPlayer.setMetadata('hunger', newValue, true)
        xPlayer.triggerEvent('JLRP-Framework:updateStatus', newValue, nil, nil, nil)
    end
end)

-- thirst
RegisterNetEvent('JLRP-Framework:addThirst', function(amount)
    local src = source
    local xPlayer = Framework.GetPlayerFromId(src)
    if xPlayer then
        local newValue = xPlayer.getMetadata('thirst') + (amount ~= nil and amount or Config.Player.ThirstRate)
        
        if newValue > 100 then
            newValue = 100
        elseif newValue < 0 then
            newValue = 0
        end
        xPlayer.setMetadata('thirst', newValue, true)
        xPlayer.triggerEvent('JLRP-Framework:updateStatus', nil, newValue, nil, nil)
    end
end)

RegisterNetEvent('JLRP-Framework:removeThirst', function(amount)
    local src = source
    local xPlayer = Framework.GetPlayerFromId(src)
    if xPlayer then
        local newValue = xPlayer.getMetadata('thirst') - (amount ~= nil and amount or Config.Player.ThirstRate)
        
        if newValue > 100 then
            newValue = 100
        elseif newValue < 0 then
            newValue = 0
        end
        xPlayer.setMetadata('thirst', newValue, true)
        xPlayer.triggerEvent('JLRP-Framework:updateStatus', nil, newValue, nil, nil)
    end
end)

-- stress
RegisterNetEvent('JLRP-Framework:addStress', function(amount)
    local src = source
    local xPlayer = Framework.GetPlayerFromId(src)
    if xPlayer then
        local newValue = xPlayer.getMetadata('stress') + (amount ~= nil and amount or Config.Player.StressRate)
        
        if newValue > 100 then
            newValue = 100
        elseif newValue < 0 then
            newValue = 0
        end
        xPlayer.setMetadata('stress', newValue, true)
        xPlayer.triggerEvent('JLRP-Framework:updateStatus', nil, nil, newValue, nil)
    end
end)

RegisterNetEvent('JLRP-Framework:removeStress', function(amount)
    local src = source
    local xPlayer = Framework.GetPlayerFromId(src)
    if xPlayer then
        local newValue = xPlayer.getMetadata('stress') - (amount ~= nil and amount or Config.Player.StressRate)
        
        if newValue > 100 then
            newValue = 100
        elseif newValue < 0 then
            newValue = 0
        end
        xPlayer.setMetadata('stress', newValue, true)
        xPlayer.triggerEvent('JLRP-Framework:updateStatus', nil, nil, newValue, nil)
    end
end)

-- drunk
RegisterNetEvent('JLRP-Framework:addDrunk', function(amount)
    local src = source
    local xPlayer = Framework.GetPlayerFromId(src)
    if xPlayer then
        local newValue = xPlayer.getMetadata('drunk') + (amount ~= nil and amount or Config.Player.DrunkRate)
        
        if newValue > 100 then
            newValue = 100
        elseif newValue < 0 then
            newValue = 0
        end
        xPlayer.setMetadata('drunk', newValue, true)
        xPlayer.triggerEvent('JLRP-Framework:updateStatus', nil, nil, nil, newValue)
    end
end)

RegisterNetEvent('JLRP-Framework:removeDrunk', function(amount)
    local src = source
    local xPlayer = Framework.GetPlayerFromId(src)
    if xPlayer then
        local newValue = xPlayer.getMetadata('drunk') - (amount ~= nil and amount or Config.Player.DrunkRate)
        
        if newValue > 100 then
            newValue = 100
        elseif newValue < 0 then
            newValue = 0
        end
        xPlayer.setMetadata('drunk', newValue, true)
        xPlayer.triggerEvent('JLRP-Framework:updateStatus', nil, nil, nil, newValue)
    end
end)

AddEventHandler('txAdmin:events:scheduledRestart', function(eventData)
	if eventData.secondsRemaining == 60 then
		CreateThread(function()
			Wait(50000)
			Core.SavePlayers()
		end)
	end
end)
