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
						TriggerEvent('JLRP-Framework:updateCoords', formattedCoords, xPlayer.source)
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
				Wait(5 * 60 * 1000) -- every 5 mins
				Core.SavePlayers()
			end
		end
	)
end

function PayCheck()
	CreateThread(function()
		while true do
			Wait(Config.Accounts.PayCheckInterval * 60 * 1000)
			local xPlayers = Framework.GetPlayers()
			for _, xPlayer in pairs(xPlayers) do
				local job = xPlayer.getJob()
				local jobName = job.grade_name
                local onDuty = job.onDuty
				local salary = job.grade_salary

				if salary > 0 then
					if jobName == 'unemployed' then -- unemployed
						xPlayer.addAccountMoney('bank', salary)
						TriggerClientEvent('JLRP-Framework:showAdvancedNotification', xPlayer.source, _Locale('bank'), _Locale('received_paycheck'), _Locale('received_help', salary), 'CHAR_BANK_MAZE', 9, nil, nil, 195)
					elseif onDuty then -- generic job
						xPlayer.addAccountMoney('bank', salary)
						TriggerClientEvent('JLRP-Framework:showAdvancedNotification', xPlayer.source, _Locale('bank'), _Locale('received_paycheck'), _Locale('received_salary', salary), 'CHAR_BANK_MAZE', 9, nil, nil, 195)
					end
				end
			end
		end
	end)
end

function StatusUpdate()
	CreateThread(
		function()
			while true do
				local xPlayers = Framework.GetPlayers()
				local count = #xPlayers
				if count and count > 0 then
					for i = 1, count do
						local xPlayer = xPlayers[i]
						
						if not xPlayer.getMetadata('dead') then
							local newHunger = xPlayer.getMetadata('hunger') - Config.Player.HungerRate
							if newHunger < 0 then newHunger = 0 end
							xPlayer.setMetadata('hunger', newHunger)

							local newThirst = xPlayer.getMetadata('thirst') - Config.Player.ThirstRate
							if newThirst < 0 then newThirst = 0 end
							xPlayer.setMetadata('thirst', newThirst)

							local newStress = xPlayer.getMetadata('stress') - Config.Player.StressRate
							if newStress < 0 then newStress = 0 end
							xPlayer.setMetadata('stress', newStress)

							local newDrunk = xPlayer.getMetadata('drunk') - Config.Player.DrunkRate
							if newDrunk < 0 then newDrunk = 0 end
							xPlayer.setMetadata('drunk', newDrunk)

							xPlayer.syncMetadata()
							xPlayer.triggerEvent('JLRP-Framework:updateStatus', newHunger, newThirst, newStress, newDrunk)
						end
					end
				end
				Wait(Config.Player.UpdateInterval * 60000)
			end
		end
	)
end