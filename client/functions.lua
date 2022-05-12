function Framework.SetTimeout(msec, cb)
	table.insert(
		Core.TimeoutCallbacks,
		{
			time = GetGameTimer() + msec,
			cb = cb
		}
	)
	return #Core.TimeoutCallbacks
end

function Framework.ClearTimeout(i)
	Core.TimeoutCallbacks[i] = nil
end

function Framework.IsPlayerLoaded()
	return Framework.PlayerLoaded
end

function Framework.GetPlayerData()
	return Framework.PlayerData
end

function Framework.SearchInventory(items, count)
	if type(items) == "string" then
		items = {items}
	end

	local returnData = {}
	local itemCount = #items

	for i = 1, itemCount do
		local itemName = items[i]
		returnData[itemName] = count and 0

		for _, item in pairs(Framework.PlayerData.inventory) do
			if item.name == itemName then
				if count then
					returnData[itemName] = returnData[itemName] + item.count
				else
					returnData[itemName] = item
				end
			end
		end
	end

	if next(returnData) then
		return itemCount == 1 and returnData[items[1]] or returnData
	end
end

function Framework.Game.Teleport(entity, coords, cb)
	local vector =
		type(coords) == "vector4" and coords or type(coords) == "vector3" and vector4(coords, 0.0) or
		vec(coords.x, coords.y, coords.z, coords.heading or 0.0)

	if DoesEntityExist(entity) then
		RequestCollisionAtCoord(vector.xyz)
		while not HasCollisionLoadedAroundEntity(entity) do
			Wait(0)
		end

		SetEntityCoords(entity, vector.xyz, false, false, false, false)
		SetEntityHeading(entity, vector.w)
	end

	if cb then
		cb()
	end
end

function Framework.SetPlayerData(key, val)
	local current = Framework.PlayerData[key]
	Framework.PlayerData[key] = val
	if key ~= "inventory" then
		if type(val) == "table" or val ~= current then
			TriggerEvent("JLRP-Framework:setPlayerData", key, val, current)
		end
	end
end

function Framework.Progressbar(message, length, options)
	-- TODO
end

function Framework.ShowNotification(message, type, length)
	if Config.NativeNotify then
		BeginTextCommandThefeedPost("STRING")
		AddTextComponentSubstringPlayerName(message)
		EndTextCommandThefeedPostTicker(0, 1)
	else
		-- TODO
	end
end

function Framework.TextUI(message, type)
	-- TODO
end

function Framework.HideUI()
	-- TODO
end

function Framework.ShowAdvancedNotification(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
	if saveToBrief == nil then
		saveToBrief = true
	end
	AddTextEntry("FrameworkAdvancedNotification", msg)
	BeginTextCommandThefeedPost("FrameworkAdvancedNotification")
	if hudColorIndex then
		ThefeedSetNextPostBackgroundColor(hudColorIndex)
	end
	EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, sender, subject)
	EndTextCommandThefeedPostTicker(flash or false, saveToBrief)
end

function Framework.ShowHelpNotification(msg, thisFrame, beep, duration)
	AddTextEntry("FrameworkHelpNotification", msg)

	if thisFrame then
		DisplayHelpTextThisFrame("FrameworkHelpNotification", false)
	else
		if beep == nil then
			beep = true
		end
		BeginTextCommandDisplayHelp("FrameworkHelpNotification")
		EndTextCommandDisplayHelp(0, false, beep, duration or -1)
	end
end

function Framework.ShowFloatingHelpNotification(msg, coords)
	AddTextEntry("FrameworkFloatingHelpNotification", msg)
	SetFloatingHelpTextWorldPosition(1, coords)
	SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
	BeginTextCommandDisplayHelp("FrameworkFloatingHelpNotification")
	EndTextCommandDisplayHelp(2, false, false, -1)
end

function Framework.TriggerServerCallback(name, cb, ...)
	Core.ServerCallbacks[Core.CurrentRequestId] = cb

	TriggerServerEvent("JLRP-Framework:triggerServerCallback", name, Core.CurrentRequestId, ...)

	if Core.CurrentRequestId < 65535 then
		Core.CurrentRequestId = Core.CurrentRequestId + 1
	else
		Core.CurrentRequestId = 0
	end
end

function Framework.UI.HUD.SetDisplay(opacity)
	SendNUIMessage({
		action  = 'setHUDDisplay',
		opacity = opacity
	})
end

function Framework.UI.HUD.RegisterElement(name, index, priority, html, data)
	local found = false

	for i=1, #Framework.UI.HUD.RegisteredElements, 1 do
		if Framework.UI.HUD.RegisteredElements[i] == name then
			found = true
			break
		end
	end

	if found then
		return
	end

	Framework.UI.HUD.RegisteredElements[#Framework.UI.HUD.RegisteredElements + 1] = name

	SendNUIMessage({
		action    = 'insertHUDElement',
		name      = name,
		index     = index,
		priority  = priority,
		html      = html,
		data      = data
	})

	Framework.UI.HUD.UpdateElement(name, data)
end

function Framework.UI.HUD.RemoveElement(name)
	for i=1, #Framework.UI.HUD.RegisteredElements, 1 do
		if Framework.UI.HUD.RegisteredElements[i] == name then
			table.remove(Framework.UI.HUD.RegisteredElements, i)
			break
		end
	end

	SendNUIMessage({
		action    = 'deleteHUDElement',
		name      = name
	})
end

function Framework.UI.HUD.Reset()
	SendNUIMessage({
		action    = 'resetHUDElements'
	})
	Framework.UI.HUD.RegisteredElements = {}
end

function Framework.UI.HUD.UpdateElement(name, data)
	SendNUIMessage({
		action = 'updateHUDElement',
		name   = name,
		data   = data
	})
end

function Framework.UI.Menu.RegisterType(type, open, close)
	Framework.UI.Menu.RegisteredTypes[type] = {
		open   = open,
		close  = close
	}
end

function Framework.UI.Menu.Open(type, namespace, name, data, submit, cancel, change, close)
	local menu = {}

	menu.type      = type
	menu.namespace = namespace
	menu.name      = name
	menu.data      = data
	menu.submit    = submit
	menu.cancel    = cancel
	menu.change    = change

	menu.close = function()

		Framework.UI.Menu.RegisteredTypes[type].close(namespace, name)

		for i=1, #Framework.UI.Menu.Opened, 1 do
			if Framework.UI.Menu.Opened[i] then
				if Framework.UI.Menu.Opened[i].type == type and Framework.UI.Menu.Opened[i].namespace == namespace and Framework.UI.Menu.Opened[i].name == name then
					Framework.UI.Menu.Opened[i] = nil
				end
			end
		end

		if close then
			close()
		end

	end

	menu.update = function(query, newData)

		for i=1, #menu.data.elements, 1 do
			local match = true

			for k,v in pairs(query) do
				if menu.data.elements[i][k] ~= v then
					match = false
				end
			end

			if match then
				for k,v in pairs(newData) do
					menu.data.elements[i][k] = v
				end
			end
		end

	end

	menu.refresh = function()
		Framework.UI.Menu.RegisteredTypes[type].open(namespace, name, menu.data)
	end

	menu.setElement = function(i, key, val)
		menu.data.elements[i][key] = val
	end

	menu.setElements = function(newElements)
		menu.data.elements = newElements
	end

	menu.setTitle = function(val)
		menu.data.title = val
	end

	menu.removeElement = function(query)
		for i=1, #menu.data.elements, 1 do
			for k,v in pairs(query) do
				if menu.data.elements[i] then
					if menu.data.elements[i][k] == v then
						table.remove(menu.data.elements, i)
						break
					end
				end

			end
		end
	end

	Framework.UI.Menu.Opened[#Framework.UI.Menu.Opened + 1] = menu
	Framework.UI.Menu.RegisteredTypes[type].open(namespace, name, data)

	return menu
end

function Framework.UI.Menu.Close(type, namespace, name)
	for i=1, #Framework.UI.Menu.Opened, 1 do
		if Framework.UI.Menu.Opened[i] then
			if Framework.UI.Menu.Opened[i].type == type and Framework.UI.Menu.Opened[i].namespace == namespace and Framework.UI.Menu.Opened[i].name == name then
				Framework.UI.Menu.Opened[i].close()
				Framework.UI.Menu.Opened[i] = nil
			end
		end
	end
end

function Framework.UI.Menu.CloseAll()
	for i=1, #Framework.UI.Menu.Opened, 1 do
		if Framework.UI.Menu.Opened[i] then
			Framework.UI.Menu.Opened[i].close()
			Framework.UI.Menu.Opened[i] = nil
		end
	end
end

function Framework.UI.Menu.GetOpened(type, namespace, name)
	for i=1, #Framework.UI.Menu.Opened, 1 do
		if Framework.UI.Menu.Opened[i] then
			if Framework.UI.Menu.Opened[i].type == type and Framework.UI.Menu.Opened[i].namespace == namespace and Framework.UI.Menu.Opened[i].name == name then
				return Framework.UI.Menu.Opened[i]
			end
		end
	end
end

function Framework.UI.Menu.GetOpenedMenus()
	return Framework.UI.Menu.Opened
end

function Framework.UI.Menu.IsOpen(type, namespace, name)
	return Framework.UI.Menu.GetOpened(type, namespace, name) ~= nil
end

function Framework.UI.ShowInventoryItemNotification(add, item, count)
	SendNUIMessage({
		action = 'inventoryNotification',
		add    = add,
		item   = item,
		count  = count
	})
end

function Framework.Game.GetPedMugshot(ped, transparent)
	if DoesEntityExist(ped) then
		local mugshot

		if transparent then
			mugshot = RegisterPedheadshotTransparent(ped)
		else
			mugshot = RegisterPedheadshot(ped)
		end

		while not IsPedheadshotReady(mugshot) do
			Wait(0)
		end

		return mugshot, GetPedheadshotTxdString(mugshot)
	else
		return
	end
end

function Framework.Game.SpawnObject(object, coords, cb, networked)
	networked = networked == nil and true or networked
	if networked then		
		local model = type(object) == 'number' and object or GetHashKey(object)
		local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)
		
		CreateThread(function()
			Framework.Streaming.RequestModel(model)

			local obj = CreateObject(model, vector.xyz, networked, false, true)
			if cb then
				cb(obj)
			end
		end)
	else
		Framework.Game.SpawnLocalObject(object, coords, cb)
	end
end

function Framework.Game.SpawnLocalObject(object, coords, cb)
	local model = type(object) == 'number' and object or GetHashKey(object)
	local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)
	local networked = false

	CreateThread(function()
		Framework.Streaming.RequestModel(model)

		local obj = CreateObject(model, vector.xyz, networked, false, true)
		if cb then
			cb(obj)
		end
	end)
end