function Framework.Game.Teleport(entity, coords, cb)
	local vector = type(coords) == "vector4" and coords or type(coords) == "vector3" and vector4(coords, 0.0) or vec(coords.x, coords.y, coords.z, coords.heading or 0.0)

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
	if key ~= 'inventory' and key ~= 'loadout' then
		if type(val) == 'table' or val ~= current then
			TriggerEvent('Framework:setPlayerData', key, val, current)
		end
	end
end

function Framework.Progressbar(message, length, options)
    exports["esx_progressbar"]:Progressbar(message,length, options)
end


function Framework.ShowNotification(message, type, length)
    if Config.NativeNotify then
		BeginTextCommandThefeedPost('STRING')
		AddTextComponentSubstringPlayerName(message)
		EndTextCommandThefeedPostTicker(0,1)
	else
		exports["esx_notify"]:Notify(type, length, message)
    end
end


function Framework.ShowAdvancedNotification(sender, subject, msg, textureDict, iconType, flash, saveToBrief, hudColorIndex)
	if saveToBrief == nil then saveToBrief = true end
	AddTextEntry('FrameworkAdvancedNotification', msg)
	BeginTextCommandThefeedPost('FrameworkAdvancedNotification')
	if hudColorIndex then ThefeedSetNextPostBackgroundColor(hudColorIndex) end
	EndTextCommandThefeedPostMessagetext(textureDict, textureDict, false, iconType, sender, subject)
	EndTextCommandThefeedPostTicker(flash or false, saveToBrief)
end

function Framework.ShowHelpNotification(msg, thisFrame, beep, duration)
	AddTextEntry('FrameworkHelpNotification', msg)

	if thisFrame then
		DisplayHelpTextThisFrame('FrameworkHelpNotification', false)
	else
		if beep == nil then beep = true end
		BeginTextCommandDisplayHelp('FrameworkHelpNotification')
		EndTextCommandDisplayHelp(0, false, beep, duration or -1)
	end
end

function Framework.ShowFloatingHelpNotification(msg, coords)
	AddTextEntry('esxFloatingHelpNotification', msg)
	SetFloatingHelpTextWorldPosition(1, coords)
	SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
	BeginTextCommandDisplayHelp('FrameworkFloatingHelpNotification')
	EndTextCommandDisplayHelp(2, false, false, -1)
end

function Framework.TriggerServerCallback(name, cb, ...)
	Core.ServerCallbacks[Core.CurrentRequestId] = cb

	TriggerServerEvent('Framework:triggerServerCallback', name, Core.CurrentRequestId, ...)

	if Core.CurrentRequestId < 65535 then
		Core.CurrentRequestId = Core.CurrentRequestId + 1
	else
		Core.CurrentRequestId = 0
	end
end