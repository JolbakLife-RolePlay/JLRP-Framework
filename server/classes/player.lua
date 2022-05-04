function Framework.Player.Login(source, citizenid, newData)
    if source and source ~= '' then
        if citizenid then
            local identifier = Framework.GetIdentifier(source)
            --local PlayerData = MySQL.Sync.prepare('SELECT * FROM users where citizenid = ?', { citizenid })
            local PlayerData = MySQL.prepare.await(QUERIES.LOAD_PLAYER, { citizenid })
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
                PlayerData.position = json.decode(PlayerData.position)
                Framework.Player.CheckPlayerData(source, PlayerData)
            else
                Framework.Kick(source, 'You Have Been Kicked For Exploitation', nil, nil)
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

	local foundAccounts, foundItems = {}, {}

    PlayerData = PlayerData or {}
    -- source
    PlayerData.source = source
    -- citizenid
    PlayerData.citizenid = PlayerData.citizenid or Framework.Player.CreateCitizenId()
    -- identifier
    PlayerData.identifier = PlayerData.identifier or Framework.GetIdentifier(source)
    -- name
    PlayerData.name = PlayerData.name or GetPlayerName(source)

    -- group
    local defaultGroup = 'user'
	if Core.IsPlayerAdmin(source) then
		for i, rank in pairs(Config.Server.Permissions) do
			if IsPlayerAceAllowed(source, rank) then			
				defaultGroup = rank
				print(('[^2ADMIN SYSTEM^0] Player ^5%s ^0Has been granted %s permissions via ^5Ace Perms.^7'):format(source, defaultGroup))
				break
			end		
		end
	end
    PlayerData.group = PlayerData.group or defaultGroup
    
    -- job
    local job, jobObject, jobGradeObject = json.decode(PlayerData.job) or {}, nil, nil
    if Framework.DoesJobExist(job.name, job.grade) then
		jobObject, jobGradeObject = Framework.Jobs[job.name], Framework.Jobs[job.name].grades[job.grade]
	else
		print(('[^3WARNING^7] Ignoring invalid job for %s [job: %s, grade: %s]'):format(identifier, job.name, job.grade))
		job.name, job.grade = 'unemployed', '0'
		jobObject, jobGradeObject = Framework.Jobs[job.name], Framework.Jobs[job.name].grades[job.grade]
	end
    PlayerData.job = {}
	PlayerData.job.id = jobObject.id
	PlayerData.job.name = jobObject.name
	PlayerData.job.label = jobObject.label
	PlayerData.job.grade = tonumber(job.grade)
	PlayerData.job.grade_name = jobGradeObject.name
	PlayerData.job.grade_label = jobGradeObject.label
	PlayerData.job.grade_salary = jobGradeObject.salary
    PlayerData.job.onDuty = Config.ForceJobDefaultDutyAtLogin and Config.DefaultDuty or PlayerData.job.onDuty or false
	PlayerData.job.skin_male = json.decode(jobGradeObject.skin_male) or {}
	PlayerData.job.skin_female = json.decode(jobGradeObject.skin_female) or {}
	--if jobGradeObject.skin_male then PlayerData.job.skin_male = json.decode(jobGradeObject.skin_male) end
	--if jobGradeObject.skin_female then PlayerData.job.skin_female = json.decode(jobGradeObject.skin_female) end

    -- gang
    local gang, gangObject, gangGradeObject = json.decode(PlayerData.gang) or {}, nil, nil
    if Framework.DoesJobExist(gang.name, gang.grade) then
		gangObject, jobGradeObject = Framework.Jobs[gang.name], Framework.Jobs[gang.name].grades[gang.grade]
	else
		print(('[^3WARNING^7] Ignoring invalid gang for %s [gang: %s, grade: %s]'):format(identifier, gang.name, gang.grade))
		gang.name, gang.grade = 'nogang', '0'
		gangObject, gradeObject = Framework.Jobs[gang.name], Framework.Jobs[gang.name].grades[gang.grade]
	end
    PlayerData.gang = {}
	PlayerData.gang.id = gangObject.id
	PlayerData.gang.name = gangObject.name
	PlayerData.gang.label = gangObject.label
	PlayerData.gang.grade = tonumber(gang.grade)
	PlayerData.gang.grade_name = gangGradeObject.name
	PlayerData.gang.grade_label = gangGradeObject.label
	PlayerData.gang.grade_salary = gangGradeObject.salary
	PlayerData.gang.skin_male = json.decode(gangGradeObject.skin_male) or {}
	PlayerData.gang.skin_female = json.decode(gangGradeObject.skin_female) or {}
    --if gangGradeObject.skin_male then PlayerData.job.skin_male = json.decode(gangGradeObject.skin_male) end
	--if gangGradeObject.skin_female then PlayerData.job.skin_female = json.decode(gangGradeObject.skin_female) end

    -- accounts
    if PlayerData.accounts then
		local accounts = json.decode(result.accounts)

		for account, money in pairs(accounts) do
			foundAccounts[account] = money
		end
    end
    PlayerData.accounts = {}
    for account, label in pairs(Config.Accounts.MoneyTypes) do
		table.insert(PlayerData.accounts, {
			name = account,
			amount = foundAccounts[account] or Config.Accounts.MoneyTypes[account] or 0
		})
	end

    -- Other
    PlayerData.position = PlayerData.position or Config.DefaultSpawn
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

function Framework.Player.CreateAccountNumber()
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