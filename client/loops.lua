local isDead = false
local cam = nil
local angleY = 0.0
local angleZ = 0.0
function StartServerSyncLoops()
	CreateThread(
		function()
			local previousCoords =
				vector3(Framework.PlayerData.coords.x, Framework.PlayerData.coords.y, Framework.PlayerData.coords.z)

			while Framework.PlayerLoaded do
				local playerPed = PlayerPedId()
				if Framework.PlayerData.ped ~= playerPed then
					Framework.SetPlayerData("ped", playerPed)
				end

				if DoesEntityExist(Framework.PlayerData.ped) then
					local playerCoords = GetEntityCoords(Framework.PlayerData.ped)
					local distance = #(playerCoords - previousCoords)

					if distance > 1 then
						previousCoords = playerCoords
						local playerHeading = Framework.Math.Round(GetEntityHeading(Framework.PlayerData.ped), 1)
						local formattedCoords = {
							x = Framework.Math.Round(playerCoords.x, 1),
							y = Framework.Math.Round(playerCoords.y, 1),
							z = Framework.Math.Round(playerCoords.z, 1),
							heading = playerHeading
						}
						Framework.SetPlayerData("coords", formattedCoords)
					end
				end
				Wait(2000)
			end
		end
	)
end

if Config.EnableHud then
	CreateThread(
		function()
			local isPaused = false
			local time = 1000
			while true do
				if IsPauseMenuActive() and not isPaused then
					isPaused = true
					Framework.UI.HUD.SetDisplay(0.0)
				elseif not IsPauseMenuActive() and isPaused then
					isPaused = false
					Framework.UI.HUD.SetDisplay(1.0)
				end
				Wait(time)
			end
		end
	)
end

-- SetTimeout
CreateThread(
	function()
		while true do
			local sleep = 100
			if #Core.TimeoutCallbacks > 0 then
				local currTime = GetGameTimer()
				sleep = 0
				for i = 1, #Core.TimeoutCallbacks, 1 do
					if currTime >= Core.TimeoutCallbacks[i].time then
						Core.TimeoutCallbacks[i].cb()
						Core.TimeoutCallbacks[i] = nil
					end
				end
			end
			Wait(sleep)
		end
	end
)

local heading = 0
CreateThread(
	function()
		while true do
			if noclip then
				SetEntityCoordsNoOffset(Framework.PlayerData.ped, noclip_pos.x, noclip_pos.y, noclip_pos.z, 0, 0, 0)
				if IsControlPressed(1, 34) then
					heading = heading + 1.5
					if heading > 360 then
						heading = 0
					end

					SetEntityHeading(Framework.PlayerData.ped, heading)
				end

				if IsControlPressed(1, 9) then
					heading = heading - 1.5
					if heading < 0 then
						heading = 360
					end

					SetEntityHeading(Framework.PlayerData.ped, heading)
				end

				if IsControlPressed(1, 8) then
					noclip_pos = GetOffsetFromEntityInWorldCoords(Framework.PlayerData.ped, 0.0, 1.0, 0.0)
				end

				if IsControlPressed(1, 32) then
					noclip_pos = GetOffsetFromEntityInWorldCoords(Framework.PlayerData.ped, 0.0, -1.0, 0.0)
				end

				if IsControlPressed(1, 27) then
					noclip_pos = GetOffsetFromEntityInWorldCoords(Framework.PlayerData.ped, 0.0, 0.0, 1.0)
				end

				if IsControlPressed(1, 173) then
					noclip_pos = GetOffsetFromEntityInWorldCoords(Framework.PlayerData.ped, 0.0, 0.0, -1.0)
				end
			else
				Wait(2000)
			end
			Wait(0)
		end
	end
)

CreateThread(function()
	local PlayerPedID 
	local PlayerID = PlayerId()
	while true do
		if NetworkIsPlayerActive(PlayerID) then
			local PlayerPedID = PlayerPedId()

			if IsPedFatallyInjured(PlayerPedID) and not isDead then
				isDead = true

				local killerEntity, deathCause = GetPedSourceOfDeath(PlayerPedID), GetPedCauseOfDeath(PlayerPedID)
				local killerClientId = NetworkGetPlayerIndexFromPed(killerEntity)

				if killerEntity ~= PlayerPedID and killerClientId and NetworkIsPlayerActive(killerClientId) then
					PlayerKilledByPlayer(GetPlayerServerId(killerClientId), killerClientId, deathCause)
				else
					PlayerKilled(deathCause)
				end
				StartDeathCam()

			elseif not IsPedFatallyInjured(PlayerPedID) and isDead and cam ~= nil then
				isDead = false
				EndDeathCam()
			elseif cam and isDead then
				ProcessCamControls()
			else
				Wait(2000)
			end
			
		end
		Wait(0)
	end
end)

function PlayerKilledByPlayer(killerServerId, killerClientId, deathCause)
	local victimCoords = GetEntityCoords(PlayerPedId())
	local killerCoords = GetEntityCoords(GetPlayerPed(killerClientId))
	local distance = #(victimCoords - killerCoords)

	local data = {
		victimCoords = {x = Framework.Math.Round(victimCoords.x, 1), y = Framework.Math.Round(victimCoords.y, 1), z = Framework.Math.Round(victimCoords.z, 1)},
		killerCoords = {x = Framework.Math.Round(killerCoords.x, 1), y = Framework.Math.Round(killerCoords.y, 1), z = Framework.Math.Round(killerCoords.z, 1)},

		killedByPlayer = true,
		deathCause = deathCause,
		distance = Framework.Math.Round(distance, 1),

		killerServerId = killerServerId,
		killerClientId = killerClientId
	}

	TriggerEvent('JLRP-Framework:onPlayerDeath', data)
	TriggerServerEvent('JLRP-Framework:onPlayerDeath', data)
end

function PlayerKilled(deathCause)
	local playerPed = PlayerPedId()
	local victimCoords = GetEntityCoords(playerPed)

	local data = {
		victimCoords = {x = Framework.Math.Round(victimCoords.x, 1), y = Framework.Math.Round(victimCoords.y, 1), z = Framework.Math.Round(victimCoords.z, 1)},

		killedByPlayer = false,
		deathCause = deathCause
	}

	TriggerEvent('JLRP-Framework:onPlayerDeath', data)
	TriggerServerEvent('JLRP-Framework:onPlayerDeath', data)
end

-- initialize camera
function StartDeathCam()
    ClearFocus()
    local playerPed = PlayerPedId()
    cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", GetEntityCoords(playerPed), 0, 0, 0, GetGameplayCamFov())
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 1000, true, false)
end

-- destroy camera
function EndDeathCam()
    ClearFocus()
    RenderScriptCams(false, false, 0, true, false)
    DestroyCam(cam, false)
    cam = nil
end

-- process camera controls
function ProcessCamControls()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    -- disable 1st person as the 1st person camera can cause some glitches
    DisableFirstPersonCamThisFrame()
    -- calculate new position
    local newPos = ProcessNewPosition()
    -- focus cam area
    SetFocusArea(newPos.x, newPos.y, newPos.z, 0.0, 0.0, 0.0)
    -- set coords of cam
    SetCamCoord(cam, newPos.x, newPos.y, newPos.z)
    -- set rotation
    PointCamAtCoord(cam, playerCoords.x, playerCoords.y, playerCoords.z + 0.5)
end

function ProcessNewPosition()
    local mouseX = 0.0
    local mouseY = 0.0
    -- keyboard
    if (IsInputDisabled(0)) then
        -- rotation
        mouseX = GetDisabledControlNormal(1, 1) * 8.0
        mouseY = GetDisabledControlNormal(1, 2) * 8.0  
    -- controller
    else
        -- rotation
        mouseX = GetDisabledControlNormal(1, 1) * 1.5
        mouseY = GetDisabledControlNormal(1, 2) * 1.5
    end
    angleZ = angleZ - mouseX -- around Z axis (left / right)
    angleY = angleY + mouseY -- up / down
    -- limit up / down angle to 90°
    if (angleY > 89.0) then angleY = 89.0 elseif (angleY < -89.0) then angleY = -89.0 end
    local pCoords = GetEntityCoords(PlayerPedId())
    local behindCam = {
        x = pCoords.x + ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * (5.5 + 0.5),
        y = pCoords.y + ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * (5.5 + 0.5),
        z = pCoords.z + ((Sin(angleY))) * (5.5 + 0.5)
    }

    local rayHandle = StartShapeTestRay(pCoords.x, pCoords.y, pCoords.z + 0.5, behindCam.x, behindCam.y, behindCam.z, -1, PlayerPedId(), 0)
    local a, hitBool, hitCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
    local maxRadius = 5.5

    if (hitBool and Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords) < 5.5 + 0.5) then
        maxRadius = Vdist(pCoords.x, pCoords.y, pCoords.z + 0.5, hitCoords)
    end

    local offset = {
        x = ((Cos(angleZ) * Cos(angleY)) + (Cos(angleY) * Cos(angleZ))) / 2 * maxRadius,
        y = ((Sin(angleZ) * Cos(angleY)) + (Cos(angleY) * Sin(angleZ))) / 2 * maxRadius,
        z = ((Sin(angleY))) * maxRadius
    }

    local pos = {
        x = pCoords.x + offset.x,
        y = pCoords.y + offset.y,
        z = pCoords.z + offset.z
    }
	
    return pos
end