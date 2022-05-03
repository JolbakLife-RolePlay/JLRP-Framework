local QUERIES = {
    NEW_PLAYER = 'INSERT INTO `users` SET `citizenid` = ?, `identifier` = ?, `name` = ?, `group` = ?, `accounts` = ?, `position` = ?, `metadata` = ?',
    --LOAD_PLAYER = 'SELECT `accounts`, `job`, `job_grade`, `group`, `position`, `inventory`, `skin`, `loadout`'
}


local function onPlayerConnecting(name, setKickReason, deferrals)
    local src = source
    local license = Framework.Functions.GetIdentifier(src)
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

    local isBanned, Reason = Framework.Functions.IsPlayerBanned(src)
    local isLicenseAlreadyInUse = Framework.Functions.IsLicenseInUse(license)
    local isWhitelist, whitelisted = Config.Server.Whitelist, Framework.Functions.IsWhitelisted(src)

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

local function RemoveCommmandPermissionForPlayer(source)
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

		if not Framework.Players[source] then
			onPlayerJoined(source)
		end
	end)
end

local function onPlayerJoined(source)
	local identifier = Framework.Functions.GetIdentifier(source)
	if identifier then
		if Framework.Functions.IsLicenseInUse(identifier) then
            Framework.Functions.Kick(source, _Locale('duplicate_license'), nil, nil)
        else
			local result = MySQL.scalar.await('SELECT 1 FROM users WHERE identifier = ?', { identifier })
			if result then
                
			else
				-- Create Player
                --Framework.Player.Login(source, false, {})
                --createPlayer(identifier, source)
                TriggerClientEvent('Framework:onNewPlayerJoined', source)
			end
		end
	else
        Framework.Functions.Kick(source, _Locale('no_valid_license'), nil, nil)
	end
end

function createPlayer(identifier, source, data)
    local accounts = {}

    for moneytype, startamount in pairs(Config.Accounts.MoneyTypes) do
        --accounts[moneytype] = accounts[moneytype] or startamount
        accounts[moneytype] = startamount
    end

    local defaultGroup = 'user'
	if Framework.Functions.IsPlayerAdmin(source) then
		for i, rank in pairs(Config.Server.AdminGroups) do
			if IsPlayerAceAllowed(source, rank) then			
				defaultGroup = rank
				print(('[^2ADMIN SYSTEM^0] Player ^5%s ^0Has been granted %s permissions via ^5Ace Perms.^7'):format(source, defaultGroup))
				break
			end		
		end
	end

    local metadata = {}
    metadata['hunger'] = 100
    metadata['thirst'] = 100
    metadata['stress'] = 0
    metadata['is_dead'] = false
    metadata['armor'] = 0
    metadata['is_handcuffed'] = false
    metadata['injail'] =  0
    metadata['jailtime'] =  0
    metadata['jailitems'] = {}
    metadata['status'] = {}
    metadata['bloodtype'] = Config.Player.Bloodtypes[math.random(1, #Config.Player.Bloodtypes)]
    metadata['callsign'] = 'NO CALLSIGN'
    metadata['fingerprint'] = Framework.Player.CreateFingerId()
    metadata['criminalrecord'] = {
        ['hasRecord'] = false,
        ['date'] = nil
    }
    metadata['licences'] = {
        ['car'] = false,
        ['truck'] = false,
        ['motorcycle'] = false,
        ['business'] = false,
        ['weapon'] = false
    }
    metadata['inside'] = {
        house = nil,
        apartment = {
            apartmentType = nil,
            apartmentId = nil,
        }
    }


	if Config.MultiCharacter then
        --[[Would not be implemented for now]]		
	else
        --'INSERT INTO `users` SET `citizenid` = ?, `identifier` = ?, `name` = ?, `group` = ?, `accounts` = ?, `position` = ?, `metadata` = ?'
		MySQL.prepare(QUERIES.NEW_PLAYER, { Framework.Player.CreateCitizenId(), identifier, GetPlayerName(source), defaultGroup, json.encode(accounts), json.encode(Config.DefaultSpawn), json.encode(Config.metadata) }, function()
			-- LOAD PLAYER
		end)
	end
end