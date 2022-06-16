function Framework.GetPlayerFromId(source)
    return Core.Players[tonumber(source)]	
end

function Framework.GetPlayerFromIdentifier(identifier)
	for _, v in pairs(Core.Players) do
		if v.identifier == identifier then
			return v
		end
	end
end

function Framework.GetPlayerFromCitizenId(citizenid)
	for _, v in pairs(Core.Players) do
		if v.citizenid == citizenid then
			return v
		end
	end
end

function Framework.GetIdentifier(source, idtype)
    idtype = idtype or 'license'
    for _, v in pairs(GetPlayerIdentifiers(source)) do
        if string.find(v, idtype) then
            return v
        end
    end
    return nil
end

function Framework.IsPlayerBanned(source)
    local identifier = Framework.GetIdentifier(source)
    local result = MySQL.Sync.fetchSingle('SELECT * FROM bans WHERE identifier = ?', { identifier })
    if not result then return false end
    if os.time() < result.expire then
        local timeTable = os.date('*t', tonumber(result.expire))
        return true, 'You have been banned from the server:\n' .. result.reason .. '\nYour ban expires ' .. timeTable.day .. '/' .. timeTable.month .. '/' .. timeTable.year .. ' ' .. timeTable.hour .. ':' .. timeTable.min .. '\n'
    else
        MySQL.Async.execute('DELETE FROM bans WHERE identifier = ?', { identifier })
    end
    return false
end

function Framework.IsLicenseInUse(identifier)
    if Framework.GetPlayerFromIdentifier(identifier) then return true end
    return false
end

function Framework.IsWhitelisted(source)
    if not Config.Server.Whitelist then return true end
    if Framework.HasPermission(source, Config.Server.WhitelistPermission) then return true end
    return false
end

function Framework.HasPermission(source, permission)
    if IsPlayerAceAllowed(source, permission) then return true end
    return false
end

function Framework.Kick(source, reason, setKickReason, deferrals)
    reason = '\n' .. reason .. '\n🔸 Check our Discord for further information: ' .. Config.Server.Discord
    if setKickReason then
        setKickReason(reason)
    end
    CreateThread(function()
        if deferrals then
            deferrals.update(reason)
            Wait(2500)
        end
        if source then
            DropPlayer(source, reason)
        end
        for i = 0, 4 do
            while true do
                if source then
                    if GetPlayerPing(source) >= 0 then
                        break
                    end
                    Wait(100)
                    CreateThread(function()
                        DropPlayer(source, reason)
                    end)
                end
            end
            Wait(5000)
        end
    end)
end

function Core.IsPlayerAdmin(source)
	if IsPlayerAceAllowed(source, 'command') or GetConvar('sv_lan', '') == 'true' and true or false then
		return true
	end
	
	local xPlayer = Framework.GetPlayerFromId(source)
	if xPlayer then
		for i, rank in pairs(Config.Server.AdminGroups) do
			if xPlayer.group == rank then
				return true
			end
		end
	end

	return false
end

function Framework.DoesJobExist(job, grade)
	grade = tostring(grade)

	if job and grade then
		if Framework.Jobs[job] and Framework.Jobs[job].grades[grade] then
			return true
		end
	end

	return false
end

function Framework.DoesGangExist(gang, grade)
	grade = tostring(grade)

	if gang and grade then
		if Framework.Gangs[gang] and Framework.Gangs[gang].grades[grade] then
			return true
		end
	end

	return false
end

function Framework.GetPlayers(key, val)
	local xPlayers = {}
	for k, v in pairs(Core.Players) do
		if key then
			if (key == 'job' and v.job.name == val) or (key == 'gang' and v.gang.name == val) or v[key] == val then
				xPlayers[#xPlayers + 1] = v
			end
		else
			xPlayers[#xPlayers + 1] = v
		end
	end
	return xPlayers
end

function Framework.GetExtendedPlayers(key, val) -- for compatibility with esx
	return Framework.GetPlayers(key, val)
end

function Core.SavePlayer(xPlayer, cb)
	MySQL.prepare(QUERIES.SAVE_PLAYER, {
		xPlayer.group,
		json.encode(xPlayer.getJob()),
		json.encode(xPlayer.getGang()),
		json.encode(xPlayer.getAccounts(true)),
		json.encode(xPlayer.getInventory(true)),
		json.encode(xPlayer.getPosition()),
		json.encode(xPlayer.getMetadata()),
		xPlayer.getCitizenid()
	}, function(affectedRows)
		if affectedRows == 1 then
			print(('[^2INFO^7] Saved player ^5"%s^7"'):format(xPlayer.name))
		end
		if cb then cb() end
	end)
end

function Core.SavePlayers(cb)
	local xPlayers = Framework.GetPlayers()
	local count = #xPlayers
	if count > 0 then
		local parameters = {}
		local time = os.time()

		for i=1, count do
			local xPlayer = xPlayers[i]
			parameters[#parameters+1] = {
                xPlayer.group,
                json.encode(xPlayer.getJob()),
				json.encode(xPlayer.getGang()),
				json.encode(xPlayer.getAccounts(true)),
				json.encode(xPlayer.getInventory(true)),			
				json.encode(xPlayer.getPosition()),
				json.encode(xPlayer.getMetadata()),
				xPlayer.getCitizenid()
			}
		end
		MySQL.prepare(QUERIES.SAVE_PLAYER, parameters,
		function(results)
			if results then
				if type(cb) == 'function' then cb() else print(('[^2INFO^7] Saved %s %s over %s ms'):format(count, count > 1 and 'players' or 'player', (os.time() - time) / 1000000)) end
			end
		end)
	end
end

function Framework.Trace(msg)
	print(('[^2TRACE^7] %s^7'):format(msg))
end

function Framework.SetTimeout(msec, cb)
	local id = Core.TimeoutCount + 1

	SetTimeout(msec, function()
		if Core.CancelledTimeouts[id] then
			Core.CancelledTimeouts[id] = nil
		else
			cb()
		end
	end)

	Core.TimeoutCount = id

	return id
end

function Framework.ClearTimeout(id)
	Core.CancelledTimeouts[id] = true
end

function Framework.RegisterCommand(name, group, cb, allowConsole, suggestion)
	if type(name) == 'table' then
		for _, v in ipairs(name) do
			Framework.RegisterCommand(v, group, cb, allowConsole, suggestion)
		end

		return
	end

	if Core.RegisteredCommands[name] then
		print(('[^3WARNING^7] Command ^5"%s" already registered, overriding command'):format(name))

		if Core.RegisteredCommands[name].suggestion then
			TriggerClientEvent('chat:removeSuggestion', -1, ('/%s'):format(name))
		end
	end

	if suggestion then
		if not suggestion.arguments then suggestion.arguments = {} end
		if not suggestion.help then suggestion.help = '' end

		TriggerClientEvent('chat:addSuggestion', -1, ('/%s'):format(name), suggestion.help, suggestion.arguments)
	end

	Core.RegisteredCommands[name] = {group = group, cb = cb, allowConsole = allowConsole, suggestion = suggestion}

	RegisterCommand(name, function(playerId, args, rawCommand)
		local command = Core.RegisteredCommands[name]

		if not command.allowConsole and playerId == 0 then
			print(('[^3WARNING^7] ^5%s'):format(_Locale('commanderror_console')))
		else
			local xPlayer, error = Framework.GetPlayerFromId(playerId), nil

			if command.suggestion then
				if command.suggestion.validate then
					if #args ~= #command.suggestion.arguments then
						error = _Locale('commanderror_argumentmismatch', #args, #command.suggestion.arguments)
					end
				end

				if not error and command.suggestion.arguments then
					local newArgs = {}

					for k, v in ipairs(command.suggestion.arguments) do
						if v.type then
							if v.type == 'number' then
								local newArg = tonumber(args[k])

								if newArg then
									newArgs[v.name] = newArg
								else
									error = _Locale('commanderror_argumentmismatch_number', k)
								end
							elseif v.type == 'player' or v.type == 'playerId' then
								local targetPlayer = tonumber(args[k])

								if args[k] == 'me' then targetPlayer = playerId end

								if targetPlayer then
									local xTargetPlayer = Framework.GetPlayerFromId(targetPlayer)

									if xTargetPlayer then
										if v.type == 'player' then
											newArgs[v.name] = xTargetPlayer
										else
											newArgs[v.name] = targetPlayer
										end
									else
										error = _Locale('commanderror_invalidplayerid')
									end
								else
									error = _Locale('commanderror_argumentmismatch_number', k)
								end
							elseif v.type == 'string' then
								newArgs[v.name] = args[k]
							elseif v.type == 'item' or v.type == 'weapon' then
								if Framework.Items[args[k]] then
									newArgs[v.name] = args[k]
								else
									error = _Locale('commanderror_invaliditem')
								end
							elseif v.type == 'any' then
								newArgs[v.name] = args[k]
							end
						end

						if error then break end
					end

					args = newArgs
				end
			end

			if error then
				if playerId == 0 then
					print(('[^3WARNING^7] %s^7'):format(error))
				else
					xPlayer.showNotification(error)
				end
			else
				cb(xPlayer or false, args, function(msg)
					if playerId == 0 then
						print(('[^3WARNING^7] %s^7'):format(msg))
					else
						xPlayer.showNotification(msg)
					end
				end)
			end
		end
	end, true)

	if type(group) == 'table' then
		for k,v in ipairs(group) do
			ExecuteCommand(('add_ace group.%s command.%s allow'):format(v, name))
		end
	else
		ExecuteCommand(('add_ace group.%s command.%s allow'):format(group, name))
	end
end

function Framework.RegisterServerCallback(name, cb)
	Core.ServerCallbacks[name] = cb
end

function Framework.TriggerServerCallback(name, requestId, source, cb, ...)
	if Core.ServerCallbacks[name] then
		Core.ServerCallbacks[name](source, cb, ...)
	else
		print(('[^3WARNING^7] Server callback ^5"%s"^0 does not exist. ^1Please Check The Server File for Errors!'):format(name))
	end
end

function Framework.RegisterUsableItem(item, cb)
	Core.UsableItemsCallbacks[item] = cb
end

function Framework.GetUsableItems()
	local Usables = {}
	for k in pairs(Core.UsableItemsCallbacks) do
		Usables[k] = true
	end
	return Usables
end

function Framework.UseItem(source, item, data)
	if ESX.Items[item] then
		Core.UsableItemsCallbacks[item](source, item, data)
	else
		print(('[^3WARNING^7] Item ^5"%s"^7 was used but does not exist!'):format(item))
	end
end

function Framework.GetItemLabel(item)
	item = OX_INVENTORY:Items(item)
	if item then return item.label end
end

function Framework.GetJobs()
	return Framework.Jobs
end

function Framework.GetGangs()
	return Framework.Gangs
end

function Framework.RefreshJobs()
	Core.RefreshJobs()
end

function Framework.RefreshGangs()
	Core.RefreshGangs()
end

-- OneSync
local function getNearbyPlayers(source, closest, distance, ignore)
	local result = {}
	local count = 0
	if not distance then distance = 100 end
	if type(source) == 'number' then
		source = GetPlayerPed(source)

		if not source then
			error("Received invalid first argument (source); should be playerId or vector3 coordinates")
		end

		source = GetEntityCoords(GetPlayerPed(source))
	end

	for _, xPlayer in pairs(Core.Players) do
		if not ignore or not ignore[xPlayer.source] then
			local entity = GetPlayerPed(xPlayer.source)
			local coords = GetEntityCoords(entity)

			if not closest then
				local dist = #(source - coords)
				if dist <= distance then
					count = count + 1
					result[count] = {id = xPlayer.source, ped = entity, coords = coords, dist = dist}
				end
			else
				local dist = #(source - coords)
				if dist <= (result.dist or distance) then
					result = {id = xPlayer.source, ped = entity, coords = coords, dist = dist}
				end
			end
		end
	end

	return result
end

local function getNearbyEntities(entities, coords, modelFilter, maxDistance, isPed)
	local nearbyEntities = {}
	coords = type(coords) == 'number' and GetEntityCoords(GetPlayerPed(coords)) or vector3(coords.x, coords.y, coords.z)
	for _, entity in pairs(entities) do
		if not isPed or (isPed and not IsPedAPlayer(entity)) then
			if not modelFilter or modelFilter[GetEntityModel(entity)] then
				local entityCoords = GetEntityCoords(entity)
				if not maxDistance or #(coords - entityCoords) <= maxDistance then
					nearbyEntities[#nearbyEntities+1] = {entity=entity, coords=entityCoords}
				end
			end
		end
	end

	return nearbyEntities
end

local function getClosestEntity(entities, coords, modelFilter, isPed)
	local distance, closestEntity, closestCoords = maxDistance or 100, nil, nil
	coords = type(coords) == 'number' and GetEntityCoords(GetPlayerPed(coords)) or vector3(coords.x, coords.y, coords.z)

	for _, entity in pairs(entities) do
		if not isPed or (isPed and not IsPedAPlayer(entity)) then
			if not modelFilter or modelFilter[GetEntityModel(entity)] then
				local entityCoords = GetEntityCoords(entity)
				local dist = #(coords - entityCoords)
				if dist < distance then
					closestEntity, distance, closestCoords = entity, dist, entityCoords
				end
			end
		end
	end
	return closestEntity, distance, closestCoords
end

function Framework.OneSync.GetPlayersInArea(source, maxDistance, ignore)
	return getNearbyPlayers(source, false, maxDistance, ignore)
end

function Framework.OneSync.GetClosestPlayer(source, maxDistance, ignore)
	return getNearbyPlayers(source, true, maxDistance, ignore)
end

function Framework.OneSync.SpawnVehicle(model, coords, heading, cb)
	model = type(model) == "number" and model or GetHashKey(model)
	coords = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)
	CreateThread(function()
		local entity = Citizen.InvokeNative(`CREATE_AUTOMOBILE`, model, coords.x, coords.y, coords.z, heading)
		while not DoesEntityExist(entity) do Wait(50) end

		for i = -1, 6 do
			ped = GetPedInVehicleSeat(entity, i)
			local popType = GetEntityPopulationType(ped)
			if popType >= 1 or popType <= 5 then
				DeleteEntity(ped)
			end
		end

		cb(entity)
	end)
end

function Framework.OneSync.SpawnObject(model, coords, heading, cb)
	model = type(model) == "number" and model or GetHashKey(model)
	coords = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)
	CreateThread(function()
		local entity = CreateObject(model, coords, true, true)
		while not DoesEntityExist(entity) do Wait(50) end
		if heading then
			SetEntityHeading(entity, heading)
		end
		cb(entity)
	end)
end

function Framework.OneSync.SpawnPed(model, coords, heading, cb)
	model = type(model) == "number" and model or GetHashKey(model)
	coords = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)
	CreateThread(function()
		local entity = CreatePed(0, model, coords.x, coords.y, coords.z, heading, true, true)
		while not DoesEntityExist(entity) do Wait(50) end
		cb(entity)
	end)
end

function Framework.OneSync.GetPedsInArea(coords, maxDistance, modelFilter)
	return getNearbyEntities(GetAllPeds(), coords, modelFilter, maxDistance, true)
end

function Framework.OneSync.GetObjectsInArea(coords, maxDistance, modelFilter)
	return getNearbyEntities(GetAllObjects(), coords, modelFilter, maxDistance)
end

function Framework.OneSync.GetVehiclesInArea(coords, maxDistance, modelFilter)
	return getNearbyEntities(GetAllVehicles(), coords, modelFilter, maxDistance)
end

function Framework.OneSync.GetClosestPed(coords, modelFilter)
	return getClosestEntity(GetAllPeds(), coords, modelFilter, true)
end

function Framework.OneSync.GetClosestObject(coords, modelFilter)
	return getClosestEntity(GetAllObjects(), coords, modelFilter)
end

function Framework.OneSync.GetClosestVehicle(coords, modelFilter)
	return getClosestEntity(GetAllVehicles(), coords, modelFilter)
end

function Framework.OneSync.Delete(entity, cb)
	if DoesEntityExist(entity) then
		DeleteEntity(entity)
		if cb then
			cb(true)
		end
	elseif NetworkGetEntityFromNetworkId(entity) then
		DeleteEntity(NetworkGetEntityFromNetworkId(entity))
		if cb then
			cb(true)
		end
	else
		if cb then
			cb(false)
		end
	end
end

Framework.RegisterServerCallback('JLRP-Framework:Framework.OneSync.SpawnVehicle', function(source, cb, model, coords, heading)
	Framework.OneSync.SpawnVehicle(model, coords, heading, function(vehicle)
		cb(NetworkGetNetworkIdFromEntity(vehicle))
	end)
end)

Framework.RegisterServerCallback('JLRP-Framework:Framework.OneSync.SpawnObject', function(source, cb, model, coords, heading)
	Framework.OneSync.SpawnObject(model, coords, heading, function(object)
		cb(NetworkGetNetworkIdFromEntity(object))
	end)
end)

Framework.RegisterServerCallback('JLRP-Framework:Framework.OneSync.SpawnPed', function(source, cb, model, coords, heading)
	Framework.OneSync.SpawnPed(model, coords, heading, function(ped)
		cb(NetworkGetNetworkIdFromEntity(ped))
	end)
end)

Framework.RegisterServerCallback('JLRP-Framework:Framework.OneSync.Delete', function(source, cb, netID)
	Framework.OneSync.Delete(NetworkGetEntityFromNetworkId(netID), function(response)
		if cb then
			cb(response)
		end
	end)
end)