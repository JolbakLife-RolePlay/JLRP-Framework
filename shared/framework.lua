AddEventHandler('GetFrameworkObjects', function(cb)
	cb(Framework)
end)

AddEventHandler('JLRP-Framework:GetFrameworkObjects', function(cb)
	cb(Framework)
end)

AddEventHandler('JLRP-Framework:getFrameworkObjects', function(cb)
	cb(Framework)
end)

exports('GetFrameworkObjects', function()
	return Framework
end)

AddEventHandler('esx:getSharedObject', function(cb) -- for compatibility with esx
	cb(Framework)
end)

exports('getSharedObject', function() -- for compatibility with esx
	return Framework
end)

function Framework.GetConfig()
	Config.OxInventory = true -- for compatibility with esx
	return Config
end