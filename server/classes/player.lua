function Core.Player.Login(source, citizenid, newData)
    if source and source ~= '' then
        if citizenid then
            local identifier = Framework.GetIdentifier(source)
            --local PlayerData = MySQL.Sync.prepare('SELECT * FROM users where citizenid = ?', { citizenid })
            local PlayerData = MySQL.prepare.await(QUERIES.LOAD_PLAYER, { citizenid })
            if PlayerData and identifier == PlayerData.identifier then
                --[[
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
                ]]
                Core.Player.CheckPlayerData(source, PlayerData)
            else
                Framework.Kick(source, 'You Have Been Kicked For Exploitation', nil, nil)
                --TODO Add Anticheat?!
            end
        else
            Core.Player.CheckPlayerData(source, newData)
        end
        return true
    else
        Framework.ShowError(GetCurrentResourceName(), 'Error At Framework.Player.Login() - NO SOURCE GIVEN!')
        return false
    end
end

function Core.Player.CheckPlayerData(source, PlayerData)
    PlayerData = PlayerData or {}
    -- source
    PlayerData.source = source
    -- citizenid
    PlayerData.citizenid = PlayerData.citizenid or Core.Player.CreateCitizenId()
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
    local foundAccounts = {}
    if PlayerData.accounts and PlayerData.accounts ~= '' then
		local accounts = json.decode(PlayerData.accounts)

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

    -- inventory 
    local foundAccounts, foundItems = {}, {}
    if not Config.OxInventory then
		if PlayerData.inventory and PlayerData.inventory ~= '' then
			local inventory = json.decode(PlayerData.inventory)
            
			for name, count in pairs(inventory) do
				local item = Framework.Items[name]

				if item then
					foundItems[name] = count
				else
					print(('[^3WARNING^7] Ignoring invalid item "%s" for "%s"'):format(name, identifier))
				end
			end
		end
        PlayerData.inventory = {}
		for name, item in pairs(Framework.Items) do
			local count = foundItems[name] or 0
			if count > 0 then PlayerData.weight = PlayerData.weight + (item.weight * count) end

			table.insert(PlayerData.inventory, {
				name = name,
				count = count,
				label = item.label,
				weight = item.weight,
				usable = Core.UsableItemsCallbacks[name] ~= nil,
				--rare = item.rare,
				canRemove = item.canRemove
			})
		end

		table.sort(PlayerData.inventory, function(a, b)
			return a.label < b.label
		end)
	else
		if PlayerData.inventory and PlayerData.inventory ~= '' then
			PlayerData.inventory = json.decode(PlayerData.inventory)
        else 
            PlayerData.inventory = {}
        end
	end

    -- loadout
    if not Config.OxInventory then
		if PlayerData.loadout and PlayerData.loadout ~= '' then
			local loadout = json.decode(PlayerData.loadout)
            PlayerData.loadout = {}
			for name, weapon in pairs(loadout) do
				local label = Framework.GetWeaponLabel(name)

				if label then
					if not weapon.components then weapon.components = {} end
					if not weapon.tintIndex then weapon.tintIndex = 0 end

					table.insert(PlayerData.loadout, {
						name = name,
						ammo = weapon.ammo,
						label = label,
						components = weapon.components,
						tintIndex = weapon.tintIndex
					})
				end
			end
		end
	end

    -- position
    PlayerData.position = PlayerData.position or Config.DefaultSpawn

    -- firstname

    --lastname

    -- dateofbirth

    -- sex

    -- height

    -- charinfo
    PlayerData.charinfo = PlayerData.charinfo or {}
    PlayerData.charinfo.backstory = PlayerData.charinfo.backstory or 'placeholder backstory'
    PlayerData.charinfo.nationality = PlayerData.charinfo.nationality or 'CANADA'

    -- metadata
    PlayerData.metadata = PlayerData.metadata or {}
    PlayerData.metadata['hunger'] = PlayerData.metadata['hunger'] or 100
    PlayerData.metadata['thirst'] = PlayerData.metadata['thirst'] or 100
    PlayerData.metadata['stress'] = PlayerData.metadata['stress'] or 0
    PlayerData.metadata['isdead'] = PlayerData.metadata['isdead'] or false
    PlayerData.metadata['armor'] = PlayerData.metadata['armor'] or 0
    PlayerData.metadata['ishandcuffed'] = PlayerData.metadata['ishandcuffed'] or false
    PlayerData.metadata['injail'] = PlayerData.metadata['injail'] or 0
    PlayerData.metadata['jailtime'] = PlayerData.metadata['jailtime'] or 0
    PlayerData.metadata['jailitems'] = PlayerData.metadata['jailitems'] or {}
    PlayerData.metadata['status'] = PlayerData.metadata['status'] or {}
    PlayerData.metadata['bloodtype'] = PlayerData.metadata['bloodtype'] or Config.Player.Bloodtypes[math.random(1, #Config.Player.Bloodtypes)]
    PlayerData.metadata['callsign'] = PlayerData.metadata['callsign'] or 'NO CALLSIGN'
    PlayerData.metadata['fingerprint'] = PlayerData.metadata['fingerprint'] or Core.Player.CreateFingerId()
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

    -- skin

    -- is_dead
    
end

function Core.Player.CreateCitizenId()
    local UniqueFound = false
    local CitizenId = nil
    while not UniqueFound do
        CitizenId = tostring(Framework.String.Random(3) .. Framework.Integer.Random(5)):upper()
        local result = MySQL.Sync.prepare('SELECT COUNT(*) as count FROM users WHERE citizenid = ?', { CitizenId })
        if result == 0 then
            UniqueFound = true
        end
    end
    return CitizenId
end

function Core.Player.CreateFingerId()
    local UniqueFound = false
    local FingerId = nil
    while not UniqueFound do
        FingerId = tostring(Framework.String.Random(2) .. Framework.Integer.Random(3) .. Framework.String.Random(1) .. Framework.Shared.RandomInt(2) .. Framework.Shared.RandomStr(3) .. Framework.Shared.RandomInt(4))
        local query = '%' .. FingerId .. '%'
        local result = MySQL.Sync.prepare('SELECT COUNT(*) as count FROM `users` WHERE `metadata` LIKE ?', { query })
        if result == 0 then
            UniqueFound = true
        end
    end
    return FingerId
end