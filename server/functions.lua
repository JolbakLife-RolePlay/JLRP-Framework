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
			if (key == 'job' and v.job.name == val) or v[key] == val then
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
	MySQL.prepare("UPDATE users SET `group` = ?, `job` = ?, `gang` = ?, `accounts` = ?, `inventory` = ?, `position` = ?, `metadata` = ? WHERE `citizenid` = ?", {
		xPlayer.group,
		json.encode(xPlayer.job),
		json.encode(xPlayer.gang),
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
                json.encode(xPlayer.job),
				json.encode(xPlayer.gang),
				json.encode(xPlayer.getAccounts(true)),
				json.encode(xPlayer.getInventory(true)),			
				json.encode(xPlayer.getPosition()),
				json.encode(xPlayer.getMetadata()),
				xPlayer.getCitizenid()
			}
		end
		MySQL.prepare("UPDATE users SET `group` = ?, `job` = ?, `gang` = ?, `accounts` = ?, `inventory` = ?, `position` = ?, `metadata` = ? WHERE `citizenid` = ?", parameters,
		function(results)
			if results then
				if type(cb) == 'function' then cb() else print(('[^2INFO^7] Saved %s %s over %s ms'):format(count, count > 1 and 'players' or 'player', (os.time() - time) / 1000000)) end
			end
		end)
	end
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