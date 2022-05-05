if Config.OxInventory then
	SetConvarReplicated('inventory:framework', 'esx')
	SetConvarReplicated('inventory:weight', Config.Player.MaxWeight * 1000)
end