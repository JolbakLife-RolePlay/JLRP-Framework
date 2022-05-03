function Framework.Player.Login(source, citizenid, newData)
    if source and source ~= '' then
        if citizenid then
            local identifier = Framework.Functions.GetIdentifier(source)
            local PlayerData = MySQL.Sync.prepare('SELECT * FROM users where citizenid = ?', { citizenid })
            if PlayerData and identifier == PlayerData.identifier then
                PlayerData.accounts = json.decode(PlayerData.accounts)
                PlayerData.position = json.decode(PlayerData.position)               
                PlayerData.charinfo = json.decode(PlayerData.charinfo)
                PlayerData.metadata = json.decode(PlayerData.metadata)         
                PlayerData.skin = json.decode(PlayerData.skin)         
                PlayerData.job = json.decode(PlayerData.job)
                if PlayerData.gang then
                    PlayerData.gang = json.decode(PlayerData.gang)
                else
                    PlayerData.gang = {}
                end
                Framework.Player.CheckPlayerData(source, PlayerData)
            else
                Framework.Functions.Kick(source, 'You Have Been Kicked For Exploitation', nil, nil)
                --TODO Add Anticheat?!
            end
        else
            Framework.Player.CheckPlayerData(source, newData)
        end
        return true
    else
        Framework.ShowError(GetCurrentResourceName(), 'Error At Framework.Player.Login() - NO SOURCE GIVEN!')
        return false
    end
end

function Framework.Player.CheckPlayerData(source, PlayerData)
    PlayerData = PlayerData or {}
    PlayerData.source = source
    PlayerData.citizenid = PlayerData.citizenid or Framework.Player.CreateCitizenId()
    PlayerData.identifier = PlayerData.identifier or Framework.Functions.GetIdentifier(source)
    PlayerData.name = GetPlayerName(source)

    local defaultGroup = 'user'
	if Framework.Functions.IsPlayerAdmin(source) then
		for i, rank in pairs(Config.Server.Permissions) do
			if IsPlayerAceAllowed(source, rank) then			
				defaultGroup = rank
				print(('[^2ADMIN SYSTEM^0] Player ^5%s ^0Has been granted %s permissions via ^5Ace Perms.^7'):format(source, defaultGroup))
				break
			end		
		end
	end
    PlayerData.group = PlayerData.group or defaultGroup

    PlayerData.accounts = PlayerData.accounts or {}
    for moneytype, startamount in pairs(Config.Accounts.MoneyTypes) do
        PlayerData.accounts[moneytype] = PlayerData.accounts[moneytype] or startamount
    end
    -- Charinfo
    PlayerData.charinfo = PlayerData.charinfo or {}
    PlayerData.charinfo.backstory = PlayerData.charinfo.backstory or 'placeholder backstory'
    PlayerData.charinfo.nationality = PlayerData.charinfo.nationality or 'CANADA'
    -- Metadata
    PlayerData.metadata = PlayerData.metadata or {}
    PlayerData.metadata['hunger'] = PlayerData.metadata['hunger'] or 100
    PlayerData.metadata['thirst'] = PlayerData.metadata['thirst'] or 100
    PlayerData.metadata['stress'] = PlayerData.metadata['stress'] or 0
    PlayerData.metadata['isdead'] = PlayerData.metadata['isdead'] or false
    PlayerData.metadata['armor'] = PlayerData.metadata['armor'] or 0
    PlayerData.metadata['ishandcuffed'] = PlayerData.metadata['ishandcuffed'] or false
    PlayerData.metadata['injail'] = PlayerData.metadata['injail'] or 0
    PlayerData.metadata['jailtime'] = PlayerData.metadata['jailitems'] or {}
    PlayerData.metadata['jailitems'] = PlayerData.metadata['jailitems'] or {}
    PlayerData.metadata['status'] = PlayerData.metadata['status'] or {}
    --PlayerData.metadata['commandbinds'] = PlayerData.metadata['commandbinds'] or {}
    PlayerData.metadata['bloodtype'] = PlayerData.metadata['bloodtype'] or Config.Player.Bloodtypes[math.random(1, #Config.Player.Bloodtypes)]
    PlayerData.metadata['callsign'] = PlayerData.metadata['callsign'] or 'NO CALLSIGN'
    PlayerData.metadata['fingerprint'] = PlayerData.metadata['fingerprint'] or Framework.Player.CreateFingerId()
    PlayerData.metadata['criminalrecord'] = PlayerData.metadata['criminalrecord'] or {
        ['hasRecord'] = false,
        ['date'] = nil
    }
    PlayerData.metadata['licences'] = PlayerData.metadata['licences'] or {
        ['car'] = false,
        ['truck'] = false,
        ['motorcycle'] = false,
        ['business'] = false,
        ['weapon'] = false
    }
    PlayerData.metadata['inside'] = PlayerData.metadata['inside'] or {
        house = nil,
        apartment = {
            apartmentType = nil,
            apartmentId = nil,
        }
    }

    -- Job
    if PlayerData.job and PlayerData.job.name and not Framework.Jobs[PlayerData.job.name] then PlayerData.job = nil end
    PlayerData.job = PlayerData.job or {}
    PlayerData.job.name = PlayerData.job.name or 'unemployed'
    PlayerData.job.label = PlayerData.job.label or 'Civilian'
    PlayerData.job.payment = PlayerData.job.payment or 10
    if Config.ForceJobDefaultDutyAtLogin or PlayerData.job.onduty == nil then
        PlayerData.job.onduty = Framework.Shared.Jobs[PlayerData.job.name].defaultDuty
    end
    PlayerData.job.is_boss = PlayerData.job.is_boss or false
    PlayerData.job.grade = PlayerData.job.grade or {}
    PlayerData.job.grade.name = PlayerData.job.grade.name or 'Freelancer'
    PlayerData.job.grade.level = PlayerData.job.grade.level or 0
    -- Gang
    if PlayerData.gang and PlayerData.gang.name and not Framework.Gangs[PlayerData.gang.name] then PlayerData.gang = nil end
    PlayerData.gang = PlayerData.gang or {}
    PlayerData.gang.name = PlayerData.gang.name or 'none'
    PlayerData.gang.label = PlayerData.gang.label or 'No Gang Affiliaton'
    PlayerData.gang.isboss = PlayerData.gang.isboss or false
    PlayerData.gang.grade = PlayerData.gang.grade or {}
    PlayerData.gang.grade.name = PlayerData.gang.grade.name or 'none'
    PlayerData.gang.grade.level = PlayerData.gang.grade.level or 0
    -- Other
    PlayerData.position = PlayerData.position or Config.DefaultSpawn
    --PlayerData = Framework.Player.LoadInventory(PlayerData)
    --Framework.Player.CreatePlayer(PlayerData)
end

function Framework.Player.CreateCitizenId()
    local UniqueFound = false
    local CitizenId = nil
    while not UniqueFound do
        CitizenId = tostring(Framework.Shared.RandomStr(3) .. Framework.Shared.RandomInt(5)):upper()
        local result = MySQL.Sync.prepare('SELECT COUNT(*) as count FROM players WHERE citizenid = ?', { CitizenId })
        if result == 0 then
            UniqueFound = true
        end
    end
    return CitizenId
end

function Framework.Functions.CreateAccountNumber()
    local UniqueFound = false
    local AccountNumber = nil
    while not UniqueFound do
        AccountNumber = 'US0' .. math.random(1, 9) .. 'Framework' .. math.random(1111, 9999) .. math.random(1111, 9999) .. math.random(11, 99)
        local query = '%' .. AccountNumber .. '%'
        local result = MySQL.Sync.prepare('SELECT COUNT(*) as count FROM players WHERE charinfo LIKE ?', { query })
        if result == 0 then
            UniqueFound = true
        end
    end
    return AccountNumber
end

function Framework.Player.CreateFingerId()
    local UniqueFound = false
    local FingerId = nil
    while not UniqueFound do
        FingerId = tostring(Framework.Shared.RandomStr(2) .. Framework.Shared.RandomInt(3) .. Framework.Shared.RandomStr(1) .. Framework.Shared.RandomInt(2) .. Framework.Shared.RandomStr(3) .. Framework.Shared.RandomInt(4))
        local query = '%' .. FingerId .. '%'
        local result = MySQL.Sync.prepare('SELECT COUNT(*) as count FROM `players` WHERE `metadata` LIKE ?', { query })
        if result == 0 then
            UniqueFound = true
        end
    end
    return FingerId
end