function Framework.Functions.GetPlayerFromId(source)
    return Framework.Players[tonumber(source)]	
end

function Framework.Functions.GetPlayerFromIdentifier(identifier)
	for _, v in pairs(Framework.Players) do
		if v.identifier == identifier then
			return v
		end
	end
end

function Framework.Functions.GetIdentifier(source, idtype)
    if not idtype or idtype == nil then
        for _, v in ipairs(GetPlayerIdentifiers(source)) do
            if string.find(v, 'license') then
                return v
            end
        end
    else
        for _, v in pairs(GetPlayerIdentifiers(source)) do
            if string.find(v, idtype) then
                return v
            end
        end
        return nil
    end
end

function Framework.Functions.IsPlayerBanned(source)
    local identifier = Framework.Functions.GetIdentifier(source)
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

function Framework.Functions.IsLicenseInUse(identifier)
    if Framework.Functions.GetPlayerFromIdentifier(identifier) then return true end
    return false
end

function Framework.Functions.IsWhitelisted(source)
    if not Config.Server.Whitelist then return true end
    if Framework.Functions.HasPermission(source, Config.Server.WhitelistPermission) then return true end
    return false
end

function Framework.Functions.HasPermission(source, permission)
    if IsPlayerAceAllowed(source, permission) then return true end
    return false
end

function Framework.Functions.Kick(source, reason, setKickReason, deferrals)
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

function Framework.Functions.IsPlayerAdmin(source)
	if IsPlayerAceAllowed(source, 'command') or GetConvar('sv_lan', '') == 'true' and true or false then
		return true
	end
	
	local xPlayer = Framework.Functions.GetPlayerFromId(source)
	if xPlayer then
		for i, rank in pairs(Config.Server.AdminGroups) do
			if xPlayer.group == rank then
				return true
			end
		end
	end

	return false
end