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
				local job     = xPlayer.job.grade_name
                local onDuty  = xPlayer.job.onDuty
				local salary  = xPlayer.job.grade_salary

				if salary > 0 then
					if job == 'unemployed' then -- unemployed
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