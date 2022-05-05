function DBSync()
	CreateThread(function()
		while true do
			--Wait(10 * 60 * 1000) -- every 10 mins
            Wait(5000)
			Core.SavePlayers()
		end
	end)
end