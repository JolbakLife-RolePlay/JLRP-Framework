SetConvarReplicated('inventory:framework', 'esx')
SetConvarReplicated('inventory:weight', Config.Player.MaxWeight * 1000)

Framework.RegisterServerCallback('JLRP-Framework:isUserAdmin', function(source, cb)
	cb(Core.IsPlayerAdmin(source))
end)