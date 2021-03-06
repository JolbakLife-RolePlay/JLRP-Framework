function Core.Player.Login(source, identifier)
    if source and source ~= '' then
		local PlayerData = MySQL.Sync.prepare(QUERIES.LOAD_PLAYER, { identifier })
		if PlayerData then
			if not Framework.String.IsNull(PlayerData.citizenid) then
				PlayerData.accounts = json.decode(PlayerData.accounts)
				PlayerData.inventory = json.decode(PlayerData.inventory)
				PlayerData.position = json.decode(PlayerData.position)
				PlayerData.metadata = json.decode(PlayerData.metadata)
				PlayerData.skin = json.decode(PlayerData.skin)
				PlayerData.job = json.decode(PlayerData.job)
				PlayerData.gang = json.decode(PlayerData.gang)
				Core.Player.CheckPlayerData(source, PlayerData, false)
				return true
			end			
		end
		Core.Player.CheckPlayerData(source, {}, true)
		return true
    else
        Framework.ShowError(GetCurrentResourceName(), 'Error At Core.Player.Login() - NO SOURCE GIVEN!')
        return false
    end
end

function Core.Player.CheckPlayerData(source, PlayerData, isNew)
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
			if Framework.HasPermission(source, rank) then			
				defaultGroup = rank
				print(('[^2ADMIN SYSTEM^0] Player ^5%s ^0Has been granted %s permissions via ^5Ace Perms.^7'):format(source, defaultGroup))
				break
			end		
		end
	end
    PlayerData.group = PlayerData.group or defaultGroup
    
    -- job
    local job, jobObject, jobGradeObject = PlayerData.job or {}, nil, nil
    if Framework.DoesJobExist(job.name, job.grade) then
		jobObject, jobGradeObject = Framework.Jobs[job.name], Framework.Jobs[job.name].grades[tostring(job.grade)]
	else
		if not isNew then
			print(('[^3WARNING^7] Ignoring invalid job for %s [job: %s, grade: %s]'):format(identifier, job.name, job.grade))
		end		
		job.name, job.grade = 'unemployed', '0'
		jobObject, jobGradeObject = Framework.Jobs[job.name], Framework.Jobs[job.name].grades[tostring(job.grade)]
	end
    PlayerData.job = PlayerData.job or {}
	PlayerData.job.id = jobObject.id
	PlayerData.job.name = jobObject.name
	PlayerData.job.label = jobObject.label
	PlayerData.job.grade = tonumber(job.grade)
	PlayerData.job.grade_name = jobGradeObject.name
	PlayerData.job.grade_label = jobGradeObject.label
	PlayerData.job.grade_salary = jobGradeObject.salary
	PlayerData.job.is_boss = jobGradeObject.is_boss
    PlayerData.job.onDuty = Config.ForceJobDefaultDutyAtLogin == true and Config.DefaultDuty or PlayerData.job.onDuty or false
	PlayerData.job.skin_male = json.decode(jobGradeObject.skin_male) or {}
	PlayerData.job.skin_female = json.decode(jobGradeObject.skin_female) or {}

    -- gang
    local gang, gangObject, gangGradeObject = PlayerData.gang or {}, nil, nil
    if Framework.DoesGangExist(gang.name, gang.grade) then
		gangObject, gangGradeObject = Framework.Gangs[gang.name], Framework.Gangs[gang.name].grades[tostring(gang.grade)]
	else
		if not isNew then
			print(('[^3WARNING^7] Ignoring invalid gang for %s [gang: %s, grade: %s]'):format(identifier, gang.name, gang.grade))
		end			
		gang.name, gang.grade = 'nogang', '0'
		gangObject, gangGradeObject = Framework.Gangs[gang.name], Framework.Gangs[gang.name].grades[tostring(gang.grade)]
	end
    PlayerData.gang = PlayerData.gang or {}
    PlayerData.gang.id = gangObject.id
    PlayerData.gang.name = gangObject.name
    PlayerData.gang.label = gangObject.label
    PlayerData.gang.grade = tonumber(gang.grade)
    PlayerData.gang.grade_name = gangGradeObject.name
    PlayerData.gang.grade_label = gangGradeObject.label
    PlayerData.gang.grade_salary = gangGradeObject.salary
	PlayerData.gang.is_boss = gangGradeObject.is_boss
    PlayerData.gang.skin_male = json.decode(gangGradeObject.skin_male) or {}
    PlayerData.gang.skin_female = json.decode(gangGradeObject.skin_female) or {}

    -- accounts
	if isNew then
		PlayerData.accounts = {}
		for account, money in pairs(Config.Accounts.StartingMoney) do
			PlayerData.accounts[account] = money
		end
	end

    local foundAccounts = {}
    if PlayerData.accounts and PlayerData.accounts ~= '' then
        local accounts = PlayerData.accounts
        
        for account, money in pairs(accounts) do
            foundAccounts[account] = money
        end
    end
    PlayerData.accounts = {}
    for account, label in pairs(Config.Accounts.MoneyTypes) do
		table.insert(PlayerData.accounts, {
			name = account,
			money = foundAccounts[account] or Config.Accounts.StartingMoney[account] or 0,
			label = label
		})
	end

    -- inventory 
    local foundItems = {}
    if PlayerData.inventory and PlayerData.inventory ~= '' then
		PlayerData.inventory = PlayerData.inventory
	else 
		PlayerData.inventory = {}
	end

    -- loadout
    -- handling loadout is moved to inventory

    -- position
    PlayerData.position = PlayerData.position or Config.DefaultSpawn

    -- firstname
    PlayerData.firstname = PlayerData.firstname or ""
    
    --lastname
    PlayerData.lastname = PlayerData.lastname or ""

    -- dateofbirth
    PlayerData.dateofbirth = PlayerData.dateofbirth or ""

    -- sex
    PlayerData.sex = PlayerData.sex or ""

    -- height
    PlayerData.height = PlayerData.height or ""

    -- metadata
    PlayerData.metadata = PlayerData.metadata or {}
    PlayerData.metadata['hunger'] = PlayerData.metadata['hunger'] or 100
    PlayerData.metadata['thirst'] = PlayerData.metadata['thirst'] or 100
    PlayerData.metadata['stress'] = PlayerData.metadata['stress'] or 0
	PlayerData.metadata['drunk'] = PlayerData.metadata['drunk'] or 0
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
    PlayerData.skin = PlayerData.skin or {}

	-- phone_number
	if PlayerData.phone_number and PlayerData.phone_number == '' then
		if Config.NPWD then
			PlayerData.phone_number = Core.GeneratePhoneNumber(PlayerData.citizenid)
		end
	end

    -- is_dead
    --PlayerData.is_dead = PlayerData.is_dead or 0
	PlayerData.is_dead = PlayerData.is_dead or false

    local xPlayer = Core.Player.CreatePlayer(PlayerData)
    --Core.Players[source] = xPlayer -- using in server-side 'JLRP-Framework:playerLoaded'

    if PlayerData.firstname and PlayerData.firstname ~= '' then
        xPlayer.setFirstname(PlayerData.firstname)
        xPlayer.setLastname(PlayerData.lastname)
		if PlayerData.dateofbirth then
            xPlayer.setDateofbirth(PlayerData.dateofbirth)
        end
		if PlayerData.sex then
            xPlayer.setSex(PlayerData.sex)
        end
		if PlayerData.height then
            xPlayer.setHeight(PlayerData.height)
        end
	end

	xPlayer.set('phoneNumber', PlayerData.phone_number)

    TriggerEvent('JLRP-Framework:playerLoaded', source, xPlayer, isNew)

	xPlayer.triggerEvent('JLRP-Framework:playerLoaded', {
		accounts = xPlayer.getAccounts(),
		coords = xPlayer.getPosition(),
		identifier = xPlayer.getIdentifier(),
		inventory = xPlayer.getInventory(),
		job = xPlayer.getJob(),
        gang = xPlayer.getGang(),
		maxWeight = xPlayer.getMaxWeight(),
		money = xPlayer.getMoney(),
        metadata = xPlayer.getMetadata(),
		group = xPlayer.getGroup(),
		admin = xPlayer.adminDuty(),
		dead = false
	}, isNew, PlayerData.skin)

    OX_INVENTORY:setPlayerInventory(xPlayer, PlayerData.inventory)

    if isNew then
        MySQL.Async.insert(QUERIES.NEW_PLAYER, { PlayerData.citizenid, PlayerData.identifier, PlayerData.name, PlayerData.group, json.encode(PlayerData.job), json.encode(PlayerData.gang), json.encode(PlayerData.accounts), json.encode(PlayerData.position), json.encode(PlayerData.metadata) })
		if Config.Accounts.StartingMoney.money then 
			xPlayer.setAccountMoney('money', Config.Accounts.StartingMoney.money)
		end
    end

	xPlayer.triggerEvent('JLRP-Framework:registerSuggestions', Core.RegisteredCommands)
    print(('[^2INFO^0] Player ^5"%s" ^0has connected to the server. ID: ^5%s^7'):format(xPlayer.getName(), source))
end

function Core.Player.CreateCitizenId()
    local UniqueFound = false
    local CitizenId = nil
    while not UniqueFound do
        CitizenId = tostring(Framework.String.Random(3) .. Framework.Integer.Random(5)):upper()
        local result = MySQL.Sync.prepare(QUERIES.CREATE_CITIZENID, { CitizenId })
        if result == 0 then
            UniqueFound = true
        end
        Wait(0)
    end
    return CitizenId
end

function Core.Player.CreateFingerId()
    local UniqueFound = false
    local FingerId = nil
    while not UniqueFound do
        FingerId = tostring(Framework.String.Random(2) .. Framework.Integer.Random(3) .. Framework.String.Random(1) .. Framework.Integer.Random(2) .. Framework.String.Random(3) .. Framework.Integer.Random(4))
        local query = '%' .. FingerId .. '%'
        local result = MySQL.Sync.prepare(QUERIES.CREATE_FINGERID, { query })
        if result == 0 then
            UniqueFound = true
        end
        Wait(0)
    end
    return FingerId
end

local Inventory

AddEventHandler('ox_inventory:loadInventory', function(module)
	Inventory = module
end)

function Core.Player.CreatePlayer(PlayerData)
    local self = {}
    self.PlayerData = PlayerData
    self.source = PlayerData.source
	self.playerId = self.source -- for compatibility with esx
    self.citizenid = PlayerData.citizenid
    self.identifier = PlayerData.identifier
    self.name = PlayerData.name
    self.rpname = PlayerData.firstname .. ' ' .. PlayerData.lastname
    self.group = PlayerData.group
	self.adminduty = false
    self.job = PlayerData.job
    self.gang = PlayerData.gang
    self.accounts = PlayerData.accounts
    self.inventory = PlayerData.inventory or {}
	self.position = PlayerData.position
    self.coords = self.position -- for compatibility with esx
	self.firstname = PlayerData.firstname
	self.lastname = PlayerData.lastname
    self.dateofbirth = PlayerData.dateofbirth
    self.sex = PlayerData.sex
    self.height = PlayerData.height
    self.metadata = PlayerData.metadata
    self.skin = PlayerData.skin
    self.is_dead = PlayerData.is_dead
    
	self.variables = {}
	self.weight = PlayerData.weight
	self.maxWeight = Config.Player.MaxWeight

	if Config.MultiCharacter then 
        --[[would not be implemeneted for now]]
    else 
        self.license = self.identifier
    end

    --ExecuteCommand(('add_principal identifier.%s group.%s'):format(self.license, self.group))
    ExecuteCommand(('add_principal player.%s group.%s'):format(self.source, self.group))
	ExecuteCommand(('add_principal player.%s group.%s'):format(self.source, self.job.name))
	local identifiers = GetPlayerIdentifiers(self.source)
	for i in ipairs(identifiers) do
		ExecuteCommand(('add_principal identifier.%s group.%s'):format(identifiers[i], self.group))
	end

    function self.triggerEvent(eventName, ...)
		TriggerClientEvent(eventName, self.source, ...)
	end

    -- citizenid
    function self.getCitizenid()
		return self.citizenid
	end

    -- identifier
    function self.getIdentifier()
		return self.identifier
	end

    -- group
    function self.setGroup(newGroup)
		local lastGroup = self.group
		
        if self.group ~= newGroup then
			local identifiers = GetPlayerIdentifiers(self.source)
			print(('[^2ADMIN SYSTEM^0] Player ^5%s ^0Has been removed %s permissions.^7'):format(self.source, self.group))
			ExecuteCommand(('remove_principal player.%s group.%s'):format(self.source, self.group))	
			for i in ipairs(identifiers) do
				ExecuteCommand(('remove_principal identifier.%s group.%s'):format(identifiers[i], self.group))
			end
			self.group = newGroup
			print(('[^2ADMIN SYSTEM^0] Player ^5%s ^0Has been given %s permissions.^7'):format(self.source, self.group))
			ExecuteCommand(('add_principal player.%s group.%s'):format(self.source, self.group))
			for i in ipairs(identifiers) do
				ExecuteCommand(('add_principal identifier.%s group.%s'):format(identifiers[i], self.group))
			end
			
			self.adminDuty(false)
			TriggerEvent('JLRP-Framework:setGroup', self.source, self.group, lastGroup)
			self.triggerEvent('JLRP-Framework:setGroup', self.group)
		end
	end

	function self.getGroup()
		return self.group
	end
	
	function self.adminDuty(state)
		if state == nil then
			return self.adminduty
		else
			self.adminduty = state
			TriggerEvent('JLRP-Framework:adminDuty', self.source, self.adminduty)
			self.triggerEvent('JLRP-Framework:adminDuty', self.adminduty)
		end
	end
	

    -- job
    function self.setJob(job, grade)
		grade = tostring(grade)
		local lastJob = json.decode(json.encode(self.job))

		if Framework.DoesJobExist(job, grade) then
			local jobObject, gradeObject = Framework.Jobs[job], Framework.Jobs[job].grades[grade]

			self.job.id    = jobObject.id
			self.job.name  = jobObject.name
			self.job.label = jobObject.label

			self.job.grade        = tonumber(grade)
			self.job.grade_name   = gradeObject.name
			self.job.grade_label  = gradeObject.label
			self.job.grade_salary = gradeObject.salary
			self.job.is_boss = gradeObject.is_boss
            self.job.onDuty = Config.DefaultDuty

			if gradeObject.skin_male then
				self.job.skin_male = json.decode(gradeObject.skin_male)
			else
				self.job.skin_male = {}
			end

			if gradeObject.skin_female then
				self.job.skin_female = json.decode(gradeObject.skin_female)
			else
				self.job.skin_female = {}
			end

			TriggerEvent('JLRP-Framework:setJob', self.source, self.job, lastJob)
			self.triggerEvent('JLRP-Framework:setJob', self.job)
		else
			print(('[JLRP-Framework] [^3WARNING^7] Ignoring invalid .setJob() usage for "%s"'):format(self.name))
		end
	end

    function self.getJob()
		return self.job
	end

    function self.setDuty(bool)
        self.job.onDuty = bool
        self.triggerEvent('JLRP-Framework:setJob', self.job)
    end

    function self.getDuty()
        return self.job.onDuty
    end

    -- gang
    function self.setGang(gang, grade)
		grade = tostring(grade)
		local lastGang = json.decode(json.encode(self.gang))

		if Framework.DoesGangExist(gang, grade) then
			local gangObject, gradeObject = Framework.Gangs[gang], Framework.Gangs[gang].grades[grade]

			self.gang.id    = gangObject.id
			self.gang.name  = gangObject.name
			self.gang.label = gangObject.label

			self.gang.grade        = tonumber(grade)
			self.gang.grade_name   = gradeObject.name
			self.gang.grade_label  = gradeObject.label
			self.gang.grade_salary = gradeObject.salary
			self.gang.is_boss = gradeObject.is_boss

			if gradeObject.skin_male then
				self.gang.skin_male = json.decode(gradeObject.skin_male)
			else
				self.gang.skin_male = {}
			end

			if gradeObject.skin_female then
				self.gang.skin_female = json.decode(gradeObject.skin_female)
			else
				self.gang.skin_female = {}
			end

			TriggerEvent('JLRP-Framework:setGang', self.source, self.gang, lastGang)
			self.triggerEvent('JLRP-Framework:setGang', self.gang)
		else
			print(('[JLRP-Framework] [^3WARNING^7] Ignoring invalid .setGang() usage for "%s"'):format(self.name))
		end
	end

    function self.getGang()
		return self.gang
	end

    -- accounts
    function self.getAccounts(minimal)
		if minimal then
			local minimalAccounts = {}

			for _, v in ipairs(self.accounts) do
				minimalAccounts[v.name] = v.money
			end

			return minimalAccounts
		else
			return self.accounts
		end
	end

	function self.getAccount(account)
		for k,v in ipairs(self.accounts) do
			if v.name == account then
				return v
			end
		end
	end

    function self.setAccountMoney(accountName, money)
		if money >= 0 then
			local account = self.getAccount(accountName)

			if account then
				local newMoney = Framework.Math.Round(money)
				account.money = newMoney

				self.triggerEvent('JLRP-Framework:setAccountMoney', account)

				if Inventory.accounts[accountName] then
					Inventory.SetItem(self.source, accountName, money)
				end
			end
		end
	end

	function self.addAccountMoney(accountName, money)
		if money > 0 then
			local account = self.getAccount(accountName)

			if account then
				local newMoney = account.money + Framework.Math.Round(money)
				account.money = newMoney

				self.triggerEvent('JLRP-Framework:setAccountMoney', account)

				if Inventory.accounts[accountName] then
					Inventory.AddItem(self.source, accountName, money)
				end
			end
		end
	end

	function self.removeAccountMoney(accountName, money)
		if money > 0 then
			local account = self.getAccount(accountName)

			if account then
				local newMoney = account.money - Framework.Math.Round(money)
				account.money = newMoney

				self.triggerEvent('JLRP-Framework:setAccountMoney', account)

				if Inventory.accounts[accountName] then
					Inventory.RemoveItem(self.source, accountName, money)
				end
			end
		end
	end

    function self.setMoney(money)
		money = Framework.Math.Round(money)
		self.setAccountMoney('money', money)
	end

    function self.getMoney()
		return self.getAccount('money').money
	end

	function self.addMoney(money)
		money = Framework.Math.Round(money)
		self.addAccountMoney('money', money)
	end

	function self.removeMoney(money)
		money = Framework.Math.Round(money)
		self.removeAccountMoney('money', money)
	end

    -- inventory
	function self.getInventory(minimal)
		if minimal then
			local minimalInventory = {}

			for k, v in pairs(self.inventory) do
				if v.count and v.count > 0 then
					local metadata = v.metadata

					if v.metadata and next(v.metadata) == nil then
						metadata = nil
					end

					minimalInventory[#minimalInventory+1] = {
						name = v.name,
						count = v.count,
						slot = k,
						metadata = metadata
					}
				end
			end

			return minimalInventory
		end

		return self.inventory
	end

    function self.getInventoryItem(name, metadata)
		return Inventory.GetItem(self.source, name, metadata)
	end

	function self.addInventoryItem(name, count, metadata, slot)
		return Inventory.AddItem(self.source, name, count or 1, metadata, slot)
	end

	function self.removeInventoryItem(name, count, metadata, slot)
		return Inventory.RemoveItem(self.source, name, count or 1, metadata, slot)
	end

	function self.setInventoryItem(name, count, metadata)
		return Inventory.SetItem(self.source, name, count, metadata)
	end

	function self.getWeight()
		return self.weight
	end

	function self.getMaxWeight()
		return self.maxWeight
	end

	function self.canCarryItem(name, count, metadata)
		return Inventory.CanCarryItem(self.source, name, count, metadata)
	end

	function self.canSwapItem(firstItem, firstItemCount, testItem, testItemCount)
		return Inventory.CanSwapItem(self.source, firstItem, firstItemCount, testItem, testItemCount)
	end

	function self.setMaxWeight(newWeight)
		return Inventory.Set(self.source, 'maxWeight', newWeight)
	end

    function self.hasItem(item, metadata) -- for compatibility with esx
		return Inventory.GetItem(self.source, item, metadata)
	end

    -- loadout
	-- handling loadout is moved to inventory

    -- position
    function self.updatePosition(coords)
		self.position = {x = Framework.Math.Round(coords.x, 1), y = Framework.Math.Round(coords.y, 1), z = Framework.Math.Round(coords.z, 1), heading = Framework.Math.Round(coords.heading or 0.0, 1)}
        self.coords = self.position
	end

    function self.updateCoords(coords) -- for compatibility with esx
		self.updatePosition(coords)
	end

    function self.setPosition(coords)
		self.updatePosition(coords)
		self.triggerEvent('JLRP-Framework:teleport', coords)
	end

    function self.setCoords(coords) -- for compatibility with esx
		self.setPosition(coords)
	end

    function self.getPosition(vector)
		if vector then
			return vector3(self.position.x, self.position.y, self.position.z)
		else
			return self.position
		end
	end

    function self.getCoords(vector) -- for compatibility with esx
		return self.getPosition(vector)
	end

    -- firstname
    function self.setFirstname(newName)
		self.firstname = newName
		self.set('firstName', newName) -- for compatibility with esx
        self.rpname = self.getFirstname() .. ' ' .. self.getLastname()
	end

    function self.getFirstname()
		return self.firstname
	end

    -- lastname
    function self.setLastname(newName)
		self.lastname = newName
		self.set('lastName', newName) -- for compatibility with esx
        self.rpname = self.getFirstname() .. ' ' .. self.getLastname()
	end

    function self.getLastname()
		return self.lastname
	end

    -- name
    function self.setName(newName)
		self.name = newName
	end

    function self.getName()
		return self.name
	end

    -- rpname
    function self.getRPname()
		return self.rpname
	end

    -- dateofbirth
    function self.setDateofbirth(newValue)
		self.dateofbirth = newValue
		self.set('dateofbirth', newValue) -- for compatibility with esx
	end

    function self.getDateofbirth()
        return self.dateofbirth
	end

    -- sex
    function self.setSex(newValue)
		self.sex = newValue
		self.set('sex', newValue) -- for compatibility with esx
	end

    function self.getSex()
        return self.sex
	end

    -- height
    function self.setHeight(newValue)
		self.height = newValue
		self.set('height', newValue) -- for compatibility with esx
	end

    function self.getHeight()
        return self.height
	end

    -- metadata
    function self.setMetadata(meta, value, syncWithClient)
        if not meta then return end
		meta = meta:lower()
		self.metadata[meta] = value
		if syncWithClient then
			self.syncMetadata()
		end
	end

    function self.getMetadata(k)
		if k then return self.metadata[k] end
        return self.metadata
	end

	function self.syncMetadata()
		TriggerEvent('JLRP-Framework:onMetadataChange', self.source, self.metadata)
		self.triggerEvent('JLRP-Framework:onMetadataChange', self.metadata)
	end

    -- variables
    function self.set(k, v)
		self.variables[k] = v
	end

	function self.get(k)
		return self.variables[k]
	end

    -- kick
    function self.kick(reason)
		Framework.Kick(self.source, reason, nil, nil)
	end

    -- notification
    function self.showNotification(msg, type, length)
		self.triggerEvent('JLRP-Framework:showNotification', msg, type, length)
	end

    -- advanced notification
    function self.showAdvancedNotification(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
		self.triggerEvent('JLRP-Framework:showAdvancedNotification', sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
	end

    -- help notification
	function self.showHelpNotification(msg, thisFrame, beep, duration)
		self.triggerEvent('JLRP-Framework:showHelpNotification', msg, thisFrame, beep, duration)
	end

    -- progress bar
    function self.progressBar(message, length, options)
		self.triggerEvent('JLRP-Framework:progressBar', message, length, options)
	end


    function self.syncInventory(weight, maxWeight, items, money)
		self.weight, self.maxWeight = weight, maxWeight
		self.inventory = items

		if money then
			for k, v in pairs(money) do
				local account = self.getAccount(k)
				if Framework.Math.Round(account.money) ~= v then
					account.money = v
					self.triggerEvent('JLRP-Framework:setAccountMoney', account)
				end
			end
		end
	end

	return self

end