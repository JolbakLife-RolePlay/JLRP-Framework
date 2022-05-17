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

		for _, item in pairs(Framework.GetPlayerData().inventory) do
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

function Framework.ShowNotification(message, type, length)
	if Config.NativeNotify then
		Core.ShowNotification(message)
	else
		Core.ShowNUINotification(message, type, length)
	end
end

function Core.ShowNotification(message)
	BeginTextCommandThefeedPost("STRING")
	AddTextComponentSubstringPlayerName(message)
	EndTextCommandThefeedPostTicker(0, 1)
end

function Core.ShowNUINotification(message, type, length)
	if Framework.String.IsNull(message) then return end
	SendNUIMessage({
		action = 'showNotification',
		type = type or "info",
        length = length or 3000,
        message = message
	})
end

function Framework.GetMinimapAnchor()
    SetScriptGfxAlign(string.byte('L'), string.byte('B'))
    local minimapTopX, minimapTopY = GetScriptGfxPosition(-0.0045, 0.002 + (-0.188888))
    ResetScriptGfxAlign()
    local w, h = GetActiveScreenResolution()
	minimapTopX = w * minimapTopX
	minimapTopY = h * minimapTopY
    return minimapTopX, minimapTopY
end

--Framework.Progressbar("test", 25000,{FreezePlayer = false, animation ={type = "anim",dict = "mini@prostitutes@sexlow_veh", lib ="low_car_sex_to_prop_p2_player" }, onFinish = function())
function Framework.Progressbar(message, length, options)
	if Framework.String.IsNull(message) then return end
	if options.animation then 
        if options.animation.type == "anim" then
            Framework.Streaming.RequestAnimDict(options.animation.dict, function()
                TaskPlayAnim(Framework.PlayerData.ped, options.animation.dict, options.animation.lib, 1.0, 1.0, length, 1, 1.0, false, false, false)
            end)
        end
    end
    if options.FreezePlayer then FreezeEntityPosition(Framework.PlayerData.ped, options.FreezePlayer) end
    SendNuiMessage({
		action = 'progressBar',
        length = length or 5000,
        message = message
    })
    Wait(length)
    if options.FreezePlayer then FreezeEntityPosition(Framework.PlayerData.ped, not options.FreezePlayer) end
    if options.onFinish then options.onFinish() end
end

function Framework.TextUI(message, type)
	if Framework.String.IsNull(message) then return end
	SendNUIMessage({
        action = 'textUI',
		todo = 'show',
        message = message,
        type = type or 'info'
    })
end

function Framework.HideUI()
	SendNUIMessage({
        action = 'textUI',
		todo = 'hide'
    })
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

-- scaleform
function Framework.Scaleform.ShowFreemodeMessage(title, msg, sec)
	local scaleform = Framework.Scaleform.Utils.RequestScaleformMovie('MP_BIG_MESSAGE_FREEMODE')

	BeginScaleformMovieMethod(scaleform, 'SHOW_SHARD_WASTED_MP_MESSAGE')
	ScaleformMovieMethodAddParamTextureNameString(title)
	ScaleformMovieMethodAddParamTextureNameString(msg)
	EndScaleformMovieMethod()

	while sec > 0 do
		Wait(0)
		sec = sec - 0.01

		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
	end

	SetScaleformMovieAsNoLongerNeeded(scaleform)
end

function Framework.Scaleform.ShowBreakingNews(title, msg, bottom, sec)
	local scaleform = Framework.Scaleform.Utils.RequestScaleformMovie('BREAKING_NEWS')

	BeginScaleformMovieMethod(scaleform, 'SET_TEXT')
	ScaleformMovieMethodAddParamTextureNameString(msg)
	ScaleformMovieMethodAddParamTextureNameString(bottom)
	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(scaleform, 'SET_SCROLL_TEXT')
	ScaleformMovieMethodAddParamInt(0) -- top ticker
	ScaleformMovieMethodAddParamInt(0) -- Since this is the first string, start at 0
	ScaleformMovieMethodAddParamTextureNameString(title)

	EndScaleformMovieMethod()

	BeginScaleformMovieMethod(scaleform, 'DISPLAY_SCROLL_TEXT')
	ScaleformMovieMethodAddParamInt(0) -- Top ticker
	ScaleformMovieMethodAddParamInt(0) -- Index of string

	EndScaleformMovieMethod()

	while sec > 0 do
		Wait(0)
		sec = sec - 0.01

		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
	end

	SetScaleformMovieAsNoLongerNeeded(scaleform)
end

function Framework.Scaleform.ShowPopupWarning(title, msg, bottom, sec)
	local scaleform = Framework.Scaleform.Utils.RequestScaleformMovie('POPUP_WARNING')

	BeginScaleformMovieMethod(scaleform, 'SHOW_POPUP_WARNING')

	ScaleformMovieMethodAddParamFloat(500.0) -- black background
	ScaleformMovieMethodAddParamTextureNameString(title)
	ScaleformMovieMethodAddParamTextureNameString(msg)
	ScaleformMovieMethodAddParamTextureNameString(bottom)
	ScaleformMovieMethodAddParamBool(true)

	EndScaleformMovieMethod()

	while sec > 0 do
		Wait(0)
		sec = sec - 0.01

		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
	end

	SetScaleformMovieAsNoLongerNeeded(scaleform)
end

function Framework.Scaleform.ShowTrafficMovie(sec)
	local scaleform = Framework.Scaleform.Utils.RequestScaleformMovie('TRAFFIC_CAM')

	BeginScaleformMovieMethod(scaleform, 'PLAY_CAM_MOVIE')

	EndScaleformMovieMethod()

	while sec > 0 do
		Wait(0)
		sec = sec - 0.01

		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
	end

	SetScaleformMovieAsNoLongerNeeded(scaleform)
end

function Framework.Scaleform.Utils.RequestScaleformMovie(movie)
	local scaleform = RequestScaleformMovie(movie)

	while not HasScaleformMovieLoaded(scaleform) do
		Wait(0)
	end

	return scaleform
end

-- streaming
function Framework.Streaming.RequestModel(modelHash, cb)
	modelHash = (type(modelHash) == 'number' and modelHash or GetHashKey(modelHash))

	if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) do
			Wait(0)
		end
	end

	if cb ~= nil then
		cb()
	end
end

function Framework.Streaming.RequestStreamedTextureDict(textureDict, cb)
	if not HasStreamedTextureDictLoaded(textureDict) then
		RequestStreamedTextureDict(textureDict)

		while not HasStreamedTextureDictLoaded(textureDict) do
			Wait(0)
		end
	end

	if cb ~= nil then
		cb()
	end
end

function Framework.Streaming.RequestNamedPtfxAsset(assetName, cb)
	if not HasNamedPtfxAssetLoaded(assetName) then
		RequestNamedPtfxAsset(assetName)

		while not HasNamedPtfxAssetLoaded(assetName) do
			Wait(0)
		end
	end

	if cb ~= nil then
		cb()
	end
end

function Framework.Streaming.RequestAnimSet(animSet, cb)
	if not HasAnimSetLoaded(animSet) then
		RequestAnimSet(animSet)

		while not HasAnimSetLoaded(animSet) do
			Wait(0)
		end
	end

	if cb ~= nil then
		cb()
	end
end

function Framework.Streaming.RequestAnimDict(animDict, cb)
	if not HasAnimDictLoaded(animDict) then
		RequestAnimDict(animDict)

		while not HasAnimDictLoaded(animDict) do
			Wait(0)
		end
	end

	if cb ~= nil then
		cb()
	end
end

function Framework.Streaming.RequestWeaponAsset(weaponHash, cb)
	if not HasWeaponAssetLoaded(weaponHash) then
		RequestWeaponAsset(weaponHash)

		while not HasWeaponAssetLoaded(weaponHash) do
			Wait(0)
		end
	end

	if cb ~= nil then
		cb()
	end
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

-- object
function Framework.Game.SpawnObject(object, coords, cb, networked, heading)
	networked = networked == nil and true or networked
	if networked then		
		local model = type(object) == 'number' and object or GetHashKey(object)
		local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)
		local heading = heading ~= nil and heading or coords.h ~= nil and coords.h or coords.heading ~= nil and coords.heading or nil
		CreateThread(function()
			Framework.Streaming.RequestModel(model, function()
				Framework.TriggerServerCallback('JLRP-Framework:Framework.OneSync.SpawnObject', function(netID)
					while not NetworkDoesEntityExistWithNetworkId(netID) do Wait(50) end
					if cb then
						cb(NetToObj(netID))
					end
				end, model, vector, heading)
			end)
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
		Framework.Streaming.RequestModel(model, function()
			local obj = CreateObject(model, vector.xyz, networked, false, true)
			if cb then
				cb(obj)
			end
		end)
	end)
end

function Framework.Game.DeleteObject(object, cb)
	--SetEntityAsMissionEntity(object, false, true) ?
	Framework.TriggerServerCallback('JLRP-Framework:Framework.OneSync.Delete', function(response)
		if cb then
			cb(response)
		end
	end, ObjToNet(object))
end

-- vehicle
function Framework.Game.SpawnVehicle(vehicle, coords, heading, cb, networked)
	networked = networked == nil and true or networked
	if networked then
		local model = (type(vehicle) == 'number' and vehicle or GetHashKey(vehicle))
		local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)
		
		CreateThread(function()
			Framework.Streaming.RequestModel(model, function()
				Framework.TriggerServerCallback('JLRP-Framework:Framework.OneSync.SpawnVehicle', function(netID)
					while not NetworkDoesEntityExistWithNetworkId(netID) do Wait(50) end
					local vehicle = NetToVeh(netID)
					SetNetworkIdCanMigrate(netID, true)
					SetEntityAsMissionEntity(vehicle, true, false)
					SetVehicleHasBeenOwnedByPlayer(vehicle, true)
					SetVehicleNeedsToBeHotwired(vehicle, false)
					SetModelAsNoLongerNeeded(model)
					SetVehRadioStation(vehicle, 'OFF')
					--TriggerServerEvent('JLRP-VehicleRemote:AddKeys', GetVehicleNumberPlateText(vehicle))
					RequestCollisionAtCoord(vector.xyz)
					while not HasCollisionLoadedAroundEntity(vehicle) do
						Wait(0)
					end

					if cb then
						cb(vehicle)
					end
				end, model, vector, heading)
			end)
		end)
	else
		Framework.Game.SpawnLocalVehicle(vehicle, coords, heading, cb)
	end
end

function Framework.Game.SpawnLocalVehicle(vehicle, coords, heading, cb)
	local model = (type(vehicle) == 'number' and vehicle or GetHashKey(vehicle))
	local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)
	local networked = false

	CreateThread(function()
		Framework.Streaming.RequestModel(model, function()
			local vehicle = CreateVehicle(model, vector.xyz, heading, networked, false)
			SetVehicleHasBeenOwnedByPlayer(vehicle, true)
			SetVehicleNeedsToBeHotwired(vehicle, false)
			SetModelAsNoLongerNeeded(model)
			SetVehRadioStation(vehicle, 'OFF')
			RequestCollisionAtCoord(vector.xyz)
			while not HasCollisionLoadedAroundEntity(vehicle) do
				Wait(0)
			end

			if cb then
				cb(vehicle)
			end
		end)
	end)
end

function Framework.Game.DeleteVehicle(vehicle, cb)
	--SetEntityAsMissionEntity(vehicle, false, true) ?
	Framework.TriggerServerCallback('JLRP-Framework:Framework.OneSync.Delete', function(response)
		--TriggerServerEvent('JLRP-VehicleRemote:RemoveKey', GetVehicleNumberPlateText(vehicle))
		if cb then
			cb(response)
		end
	end, VehToNet(vehicle))
end

function Framework.Game.IsVehicleEmpty(vehicle)
	local passengers = GetVehicleNumberOfPassengers(vehicle)
	local driverSeatFree = IsVehicleSeatFree(vehicle, -1)

	return passengers == 0 and driverSeatFree
end

-- ped
function Framework.Game.SpawnPed(ped, coords, heading, cb, networked)
	networked = networked == nil and true or networked
	if networked then		
		local model = type(object) == 'number' and object or GetHashKey(object)
		local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)

		CreateThread(function()
			Framework.Streaming.RequestModel(model, function()
				Framework.TriggerServerCallback('JLRP-Framework:Framework.OneSync.SpawnPed', function(netID)
					while not NetworkDoesEntityExistWithNetworkId(netID) do Wait(50) end
					if cb then
						cb(NetToPed(netID))
					end
				end, model, vector, heading)
			end)
		end)
	else
		Framework.Game.SpawnLocalObject(object, coords, heading, cb)
	end
end

function Framework.Game.SpawnLocalPed(object, coords, heading, cb)
	local model = type(object) == 'number' and object or GetHashKey(object)
	local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)
	local networked = false

	CreateThread(function()
		Framework.Streaming.RequestModel(model, function()
			local ped = CreatePed(0, model, vector.x, vector.y, vector.z, heading, networked, true)
			if cb then
				cb(ped)
			end
		end)
	end)
end

function Framework.Game.DeletePed(ped, cb)
	--SetEntityAsMissionEntity(ped, false, true) ?
	Framework.TriggerServerCallback('JLRP-Framework:Framework.OneSync.Delete', function(response)
		if cb then
			cb(response)
		end
	end, PedToNet(ped))
end

function Framework.Game.GetObjects() -- for compatibility with esx
	return GetGamePool('CObject')
end

function Framework.Game.GetPeds(onlyOtherPeds) -- for compatibility with esx
	local peds, myPed, pool = {}, Framework.PlayerData.ped, GetGamePool('CPed')

	for i=1, #pool do
        if ((onlyOtherPeds and pool[i] ~= myPed) or not onlyOtherPeds) then
			peds[#peds + 1] = pool[i]
        end
    end

	return peds
end

function Framework.Game.GetVehicles() -- for compatibility with esx
	return GetGamePool('CVehicle')
end

function Framework.Game.GetPlayers(onlyOtherPlayers, returnKeyValue, returnPeds)
	local players, myPlayer = {}, PlayerId()

	for _, player in ipairs(GetActivePlayers()) do
		local ped = GetPlayerPed(player)

		if DoesEntityExist(ped) and ((onlyOtherPlayers and player ~= myPlayer) or not onlyOtherPlayers) then
			if returnKeyValue then
				players[player] = ped
			else
				players[#players + 1] = returnPeds and ped or player
			end
		end
	end

	return players
end

local function EnumerateEntitiesWithinDistance(entities, isPlayerEntities, coords, maxDistance)
	local nearbyEntities = {}

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = Framework.PlayerData.ped
		coords = GetEntityCoords(playerPed)
	end

	for k,entity in pairs(entities) do
		local distance = #(coords - GetEntityCoords(entity))

		if distance <= maxDistance then
			nearbyEntities[#nearbyEntities + 1] = isPlayerEntities and k or entity
		end
	end

	return nearbyEntities
end

function Framework.Game.GetClosestEntity(entities, isPlayerEntities, coords, modelFilter)
	local closestEntity, closestEntityDistance, filteredEntities = -1, -1, nil

	if coords then
		coords = vector3(coords.x, coords.y, coords.z)
	else
		local playerPed = Framework.PlayerData.ped
		coords = GetEntityCoords(playerPed)
	end

	if modelFilter then
		filteredEntities = {}

		for k,entity in pairs(entities) do
			if modelFilter[GetEntityModel(entity)] then
				filteredEntities[#filteredEntities + 1] = entity
			end
		end
	end

	for k,entity in pairs(filteredEntities or entities) do
		local distance = #(coords - GetEntityCoords(entity))

		if closestEntityDistance == -1 or distance < closestEntityDistance then
			closestEntity, closestEntityDistance = isPlayerEntities and k or entity, distance
		end
	end

	return closestEntity, closestEntityDistance
end

function Framework.Game.GetClosestObject(coords, modelFilter)
	return Framework.Game.GetClosestEntity(Framework.Game.GetObjects(), false, coords, modelFilter)
end

function Framework.Game.GetClosestPed(coords, modelFilter)
	return Framework.Game.GetClosestEntity(Framework.Game.GetPeds(true), false, coords, modelFilter)
end

function Framework.Game.GetClosestPlayer(coords)
	return Framework.Game.GetClosestEntity(Framework.Game.GetPlayers(true, true), true, coords, nil)
end

function Framework.Game.GetClosestVehicle(coords, modelFilter)
	return Framework.Game.GetClosestEntity(Framework.Game.GetVehicles(), false, coords, modelFilter)
end

function Framework.Game.GetPlayersInArea(coords, maxDistance)
	return EnumerateEntitiesWithinDistance(Framework.Game.GetPlayers(true, true), true, coords, maxDistance)
end

function Framework.Game.GetVehiclesInArea(coords, maxDistance)
	return EnumerateEntitiesWithinDistance(Framework.Game.GetVehicles(), false, coords, maxDistance)
end

function Framework.Game.IsSpawnPointClear(coords, maxDistance)
	return #Framework.Game.GetVehiclesInArea(coords, maxDistance) == 0
end

function Framework.Game.GetVehicleInDirection()
	local playerPed    = Framework.PlayerData.ped
	local playerCoords = GetEntityCoords(playerPed)
	local inDirection  = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
	local rayHandle    = StartExpensiveSynchronousShapeTestLosProbe(playerCoords, inDirection, 10, playerPed, 0)
	local numRayHandle, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)

	if hit == 1 and GetEntityType(entityHit) == 2 then
		local entityCoords = GetEntityCoords(entityHit)
		return entityHit, entityCoords
	end

	return nil
end

function Framework.Game.GetVehicleProperties(vehicle)
	if DoesEntityExist(vehicle) then
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		local hasCustomPrimaryColor = GetIsVehiclePrimaryColourCustom(vehicle)
		local customPrimaryColor = nil
		if hasCustomPrimaryColor then
			local r, g, b = GetVehicleCustomPrimaryColour(vehicle)
			customPrimaryColor = { r, g, b }
		end
		
		local hasCustomSecondaryColor = GetIsVehicleSecondaryColourCustom(vehicle)
		local customSecondaryColor = nil
		if hasCustomSecondaryColor then
			local r, g, b = GetVehicleCustomSecondaryColour(vehicle)
			customSecondaryColor = { r, g, b }
		end
		local extras = {}

		for extraId=0, 12 do
			if DoesExtraExist(vehicle, extraId) then
				local state = IsVehicleExtraTurnedOn(vehicle, extraId) == 1
				extras[tostring(extraId)] = state
			end
		end

		local doorsBroken, windowsBroken, tyreBurst = {}, {}, {}
		local numWheels = tostring(GetVehicleNumberOfWheels(vehicle))

		local TyresIndex = { -- Wheel index list according to the number of vehicle wheels.
				['2'] = {0, 4}, -- Bike and cycle.
				['3'] = {0, 1, 4, 5}, -- Vehicle with 3 wheels (get for wheels because some 3 wheels vehicles have 2 wheels on front and one rear or the reverse).
				['4'] = {0, 1, 4, 5}, -- Vehicle with 4 wheels.
				['6'] = {0, 1, 2, 3, 4, 5}, -- Vehicle with 6 wheels.
		}

		for tyre,idx in pairs(TyresIndex[numWheels]) do
				if IsVehicleTyreBurst(vehicle, idx, false) then
						tyreBurst[tostring(idx)] = true
				else
						tyreBurst[tostring(idx)] = false
				end
		end

		for windowId = 0, 7 do -- 13
				if not IsVehicleWindowIntact(vehicle, windowId) then 
						windowsBroken[tostring(windowId)] = true
				else
						windowsBroken[tostring(windowId)] = false
				end
		end

		for doorsId = 0, GetNumberOfVehicleDoors(vehicle) do
				if IsVehicleDoorDamaged(vehicle, doorsId) then 
						doorsBroken[tostring(doorsId)] = true
				else
						doorsBroken[tostring(doorsId)] = false
				end
		end

		return {
			model             = GetEntityModel(vehicle),
			doorsBroken       = doorsBroken,
			windowsBroken     = windowsBroken,
			tyreBurst         = tyreBurst,		
			plate             = Framework.Math.Trim(GetVehicleNumberPlateText(vehicle)),
			plateIndex        = GetVehicleNumberPlateTextIndex(vehicle),

			bodyHealth        = Framework.Math.Round(GetVehicleBodyHealth(vehicle), 1),
			engineHealth      = Framework.Math.Round(GetVehicleEngineHealth(vehicle), 1),
			tankHealth        = Framework.Math.Round(GetVehiclePetrolTankHealth(vehicle), 1),

			fuelLevel         = Framework.Math.Round(GetVehicleFuelLevel(vehicle), 1),
			dirtLevel         = Framework.Math.Round(GetVehicleDirtLevel(vehicle), 1),
			color1            = colorPrimary,
			color2            = colorSecondary,
			customPrimaryColor = customPrimaryColor,
			customSecondaryColor = customSecondaryColor,

			pearlescentColor  = pearlescentColor,
			wheelColor        = wheelColor,

			wheels            = GetVehicleWheelType(vehicle),
			windowTint        = GetVehicleWindowTint(vehicle),
			xenonColor        = GetVehicleXenonLightsColor(vehicle),

			neonEnabled       = {
				IsVehicleNeonLightEnabled(vehicle, 0),
				IsVehicleNeonLightEnabled(vehicle, 1),
				IsVehicleNeonLightEnabled(vehicle, 2),
				IsVehicleNeonLightEnabled(vehicle, 3)
			},

			neonColor         = table.pack(GetVehicleNeonLightsColour(vehicle)),
			extras            = extras,
			tyreSmokeColor    = table.pack(GetVehicleTyreSmokeColor(vehicle)),

			modSpoilers       = GetVehicleMod(vehicle, 0),
			modFrontBumper    = GetVehicleMod(vehicle, 1),
			modRearBumper     = GetVehicleMod(vehicle, 2),
			modSideSkirt      = GetVehicleMod(vehicle, 3),
			modExhaust        = GetVehicleMod(vehicle, 4),
			modFrame          = GetVehicleMod(vehicle, 5),
			modGrille         = GetVehicleMod(vehicle, 6),
			modHood           = GetVehicleMod(vehicle, 7),
			modFender         = GetVehicleMod(vehicle, 8),
			modRightFender    = GetVehicleMod(vehicle, 9),
			modRoof           = GetVehicleMod(vehicle, 10),

			modEngine         = GetVehicleMod(vehicle, 11),
			modBrakes         = GetVehicleMod(vehicle, 12),
			modTransmission   = GetVehicleMod(vehicle, 13),
			modHorns          = GetVehicleMod(vehicle, 14),
			modSuspension     = GetVehicleMod(vehicle, 15),
			modArmor          = GetVehicleMod(vehicle, 16),

			modTurbo          = IsToggleModOn(vehicle, 18),
			modSmokeEnabled   = IsToggleModOn(vehicle, 20),
			modXenon          = IsToggleModOn(vehicle, 22),

			modFrontWheels    = GetVehicleMod(vehicle, 23),
			modBackWheels     = GetVehicleMod(vehicle, 24),

			modPlateHolder    = GetVehicleMod(vehicle, 25),
			modVanityPlate    = GetVehicleMod(vehicle, 26),
			modTrimA          = GetVehicleMod(vehicle, 27),
			modOrnaments      = GetVehicleMod(vehicle, 28),
			modDashboard      = GetVehicleMod(vehicle, 29),
			modDial           = GetVehicleMod(vehicle, 30),
			modDoorSpeaker    = GetVehicleMod(vehicle, 31),
			modSeats          = GetVehicleMod(vehicle, 32),
			modSteeringWheel  = GetVehicleMod(vehicle, 33),
			modShifterLeavers = GetVehicleMod(vehicle, 34),
			modAPlate         = GetVehicleMod(vehicle, 35),
			modSpeakers       = GetVehicleMod(vehicle, 36),
			modTrunk          = GetVehicleMod(vehicle, 37),
			modHydrolic       = GetVehicleMod(vehicle, 38),
			modEngineBlock    = GetVehicleMod(vehicle, 39),
			modAirFilter      = GetVehicleMod(vehicle, 40),
			modStruts         = GetVehicleMod(vehicle, 41),
			modArchCover      = GetVehicleMod(vehicle, 42),
			modAerials        = GetVehicleMod(vehicle, 43),
			modTrimB          = GetVehicleMod(vehicle, 44),
			modTank           = GetVehicleMod(vehicle, 45),
			modDoorR          = GetVehicleMod(vehicle, 47),
			modLivery         = GetVehicleLivery(vehicle),
			modLightbar       = GetVehicleMod(vehicle, 49),
		}
	else
		return
	end
end

function Framework.Game.SetVehicleProperties(vehicle, props)
	if DoesEntityExist(vehicle) then
		local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
		local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
		SetVehicleModKit(vehicle, 0)

		if props.plate then SetVehicleNumberPlateText(vehicle, props.plate) end
		if props.plateIndex then SetVehicleNumberPlateTextIndex(vehicle, props.plateIndex) end
		if props.bodyHealth then SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0) end
		if props.engineHealth then SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0) end
		if props.tankHealth then SetVehiclePetrolTankHealth(vehicle, props.tankHealth + 0.0) end
		if props.fuelLevel then SetVehicleFuelLevel(vehicle, props.fuelLevel + 0.0) end
		if props.dirtLevel then SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0) end
		if props.customPrimaryColor then SetVehicleCustomPrimaryColour(vehicle, props.customPrimaryColor[1], props.customPrimaryColor[2], props.customPrimaryColor[3]) end 
		if props.customSecondaryColor then SetVehicleCustomSecondaryColour(vehicle, props.customSecondaryColor[1], props.customSecondaryColor[2], props.customSecondaryColor[3]) end
		if props.color1 then SetVehicleColours(vehicle, props.color1, colorSecondary) end
		if props.color2 then SetVehicleColours(vehicle, props.color1 or colorPrimary, props.color2) end
		if props.pearlescentColor then SetVehicleExtraColours(vehicle, props.pearlescentColor, wheelColor) end
		if props.wheelColor then SetVehicleExtraColours(vehicle, props.pearlescentColor or pearlescentColor, props.wheelColor) end
		if props.wheels then SetVehicleWheelType(vehicle, props.wheels) end
		if props.windowTint then SetVehicleWindowTint(vehicle, props.windowTint) end

		if props.neonEnabled then
			SetVehicleNeonLightEnabled(vehicle, 0, props.neonEnabled[1])
			SetVehicleNeonLightEnabled(vehicle, 1, props.neonEnabled[2])
			SetVehicleNeonLightEnabled(vehicle, 2, props.neonEnabled[3])
			SetVehicleNeonLightEnabled(vehicle, 3, props.neonEnabled[4])
		end

		if props.extras then
			for extraId,enabled in pairs(props.extras) do
				if enabled then
					SetVehicleExtra(vehicle, tonumber(extraId), 0)
				else
					SetVehicleExtra(vehicle, tonumber(extraId), 1)
				end
			end
		end

		if props.neonColor then SetVehicleNeonLightsColour(vehicle, props.neonColor[1], props.neonColor[2], props.neonColor[3]) end
		if props.xenonColor then SetVehicleXenonLightsColor(vehicle, props.xenonColor) end
		if props.modSmokeEnabled then ToggleVehicleMod(vehicle, 20, true) end
		if props.tyreSmokeColor then SetVehicleTyreSmokeColor(vehicle, props.tyreSmokeColor[1], props.tyreSmokeColor[2], props.tyreSmokeColor[3]) end
		if props.modSpoilers then SetVehicleMod(vehicle, 0, props.modSpoilers, false) end
		if props.modFrontBumper then SetVehicleMod(vehicle, 1, props.modFrontBumper, false) end
		if props.modRearBumper then SetVehicleMod(vehicle, 2, props.modRearBumper, false) end
		if props.modSideSkirt then SetVehicleMod(vehicle, 3, props.modSideSkirt, false) end
		if props.modExhaust then SetVehicleMod(vehicle, 4, props.modExhaust, false) end
		if props.modFrame then SetVehicleMod(vehicle, 5, props.modFrame, false) end
		if props.modGrille then SetVehicleMod(vehicle, 6, props.modGrille, false) end
		if props.modHood then SetVehicleMod(vehicle, 7, props.modHood, false) end
		if props.modFender then SetVehicleMod(vehicle, 8, props.modFender, false) end
		if props.modRightFender then SetVehicleMod(vehicle, 9, props.modRightFender, false) end
		if props.modRoof then SetVehicleMod(vehicle, 10, props.modRoof, false) end
		if props.modEngine then SetVehicleMod(vehicle, 11, props.modEngine, false) end
		if props.modBrakes then SetVehicleMod(vehicle, 12, props.modBrakes, false) end
		if props.modTransmission then SetVehicleMod(vehicle, 13, props.modTransmission, false) end
		if props.modHorns then SetVehicleMod(vehicle, 14, props.modHorns, false) end
		if props.modSuspension then SetVehicleMod(vehicle, 15, props.modSuspension, false) end
		if props.modArmor then SetVehicleMod(vehicle, 16, props.modArmor, false) end
		if props.modTurbo then ToggleVehicleMod(vehicle,  18, props.modTurbo) end
		if props.modXenon then ToggleVehicleMod(vehicle,  22, props.modXenon) end
		if props.modFrontWheels then SetVehicleMod(vehicle, 23, props.modFrontWheels, false) end
		if props.modBackWheels then SetVehicleMod(vehicle, 24, props.modBackWheels, false) end
		if props.modPlateHolder then SetVehicleMod(vehicle, 25, props.modPlateHolder, false) end
		if props.modVanityPlate then SetVehicleMod(vehicle, 26, props.modVanityPlate, false) end
		if props.modTrimA then SetVehicleMod(vehicle, 27, props.modTrimA, false) end
		if props.modOrnaments then SetVehicleMod(vehicle, 28, props.modOrnaments, false) end
		if props.modDashboard then SetVehicleMod(vehicle, 29, props.modDashboard, false) end
		if props.modDial then SetVehicleMod(vehicle, 30, props.modDial, false) end
		if props.modDoorSpeaker then SetVehicleMod(vehicle, 31, props.modDoorSpeaker, false) end
		if props.modSeats then SetVehicleMod(vehicle, 32, props.modSeats, false) end
		if props.modSteeringWheel then SetVehicleMod(vehicle, 33, props.modSteeringWheel, false) end
		if props.modShifterLeavers then SetVehicleMod(vehicle, 34, props.modShifterLeavers, false) end
		if props.modAPlate then SetVehicleMod(vehicle, 35, props.modAPlate, false) end
		if props.modSpeakers then SetVehicleMod(vehicle, 36, props.modSpeakers, false) end
		if props.modTrunk then SetVehicleMod(vehicle, 37, props.modTrunk, false) end
		if props.modHydrolic then SetVehicleMod(vehicle, 38, props.modHydrolic, false) end
		if props.modEngineBlock then SetVehicleMod(vehicle, 39, props.modEngineBlock, false) end
		if props.modAirFilter then SetVehicleMod(vehicle, 40, props.modAirFilter, false) end
		if props.modStruts then SetVehicleMod(vehicle, 41, props.modStruts, false) end
		if props.modArchCover then SetVehicleMod(vehicle, 42, props.modArchCover, false) end
		if props.modAerials then SetVehicleMod(vehicle, 43, props.modAerials, false) end
		if props.modTrimB then SetVehicleMod(vehicle, 44, props.modTrimB, false) end
		if props.modTank then SetVehicleMod(vehicle, 45, props.modTank, false) end
		if props.modWindows then SetVehicleMod(vehicle, 46, props.modWindows, false) end

		if props.modLivery then
			SetVehicleLivery(vehicle, props.modLivery)
		end

		if props.windowsBroken then
			for k, v in pairs(props.windowsBroken) do
					if v then SmashVehicleWindow(vehicle, tonumber(k)) end
			end
		end
	
		if props.doorsBroken then
			for k, v in pairs(props.doorsBroken) do
				if v then SetVehicleDoorBroken(vehicle, tonumber(k), true) end
			end
		end
		
		if props.tyreBurst then
			for k, v in pairs(props.tyreBurst) do
				if v then SetVehicleTyreBurst(vehicle, tonumber(k), true, 1000.0) end
			end
		end
	end
end

function Framework.Game.Utils.DrawText3D(coords, text, size, font)
	local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)

	local camCoords = GetFinalRenderedCamCoord()
	local distance = #(vector - camCoords)

	if not size then size = 1 end
	if not font then font = 0 end

	local scale = (size / distance) * 2
	local fov = (1 / GetGameplayCamFov()) * 100
	scale = scale * fov

	SetTextScale(0.0 * scale, 0.55 * scale)
	SetTextFont(font)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	BeginTextCommandDisplayText('STRING')
	SetTextCentre(true)
	AddTextComponentSubstringPlayerName(text)
	SetDrawOrigin(vector.xyz, 0)
	EndTextCommandDisplayText(0.0, 0.0)
	ClearDrawOrigin()
end

function Framework.SyncMetadata()
	TriggerServerEvent('JLRP-Framework:onMetadataChange', Framework.PlayerData.metadata)
end