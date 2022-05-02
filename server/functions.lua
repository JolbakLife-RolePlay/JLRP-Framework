function Framework.Functions.GetPlayerFromId(source)
    if type(source) ~= "number" then
        source = tonumber(source)
    end
	return Framework.Players[source]
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
            if string.match(v, 'license:') then
                local identifier = string.gsub(v, 'license:', '')
                return identifier
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
    local license = Framework.Functions.GetIdentifier(source)
    local result = MySQL.Sync.fetchSingle('SELECT * FROM bans WHERE license = ?', { license })
    if not result then return false end
    if os.time() < result.expire then
        local timeTable = os.date('*t', tonumber(result.expire))
        return true, 'You have been banned from the server:\n' .. result.reason .. '\nYour ban expires ' .. timeTable.day .. '/' .. timeTable.month .. '/' .. timeTable.year .. ' ' .. timeTable.hour .. ':' .. timeTable.min .. '\n'
    else
        MySQL.Async.execute('DELETE FROM bans WHERE id = ?', { result.id })
    end
    return false
end

function Framework.Functions.IsLicenseInUse(identifier)
    if Framework.GetPlayerFromIdentifier(identifier) then return true end
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