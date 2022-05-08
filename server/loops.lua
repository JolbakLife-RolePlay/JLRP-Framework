function PositionSync()
	CreateThread(
		function()
			while true do
				local xPlayers = Framework.GetPlayers()
				local count = #xPlayers
				if count > 0 then
					for i = 1, count do
						local xPlayer = xPlayers[i]
			
						local playerPed = GetPlayerPed(xPlayer.source)
						local playerCoords = GetEntityCoords(playerPed)
						local playerHeading = Framework.Math.Round(GetEntityHeading(playerPed), 1)
						local formattedCoords = {x = Framework.Math.Round(playerCoords.x, 1), y = Framework.Math.Round(playerCoords.y, 1), z = Framework.Math.Round(playerCoords.z, 1), heading = playerHeading}
						TriggerEvent('Framework:updateCoords', formattedCoords, xPlayer.source)
					end
				else
					Wait(3000)
				end
				Wait(2000)
			end
		end
	)
end

function DBSync()
	CreateThread(
		function()
			while true do
				--Wait(10 * 60 * 1000) -- every 10 mins
				Wait(5000)
				Core.SavePlayers()
			end
		end
	)
end
