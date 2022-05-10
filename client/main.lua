if not Config.MultiCharacter then
	CreateThread(function()
		while true do
			Wait(0)
			if NetworkIsPlayerActive(PlayerId()) then
				exports.spawnmanager:setAutoSpawn(false)
				DoScreenFadeOut(0)
				Wait(1000)
				TriggerServerEvent('JLRP-Framework:onPlayerJoined')
				break
			end
		end
	end)
end