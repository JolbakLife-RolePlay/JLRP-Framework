AddEventHandler('GetFrameworkObjects', function(cb)
	cb(Framework)
end)

AddEventHandler('Framework:GetFrameworkObjects', function(cb)
	cb(Framework)
end)

AddEventHandler('Framework:getFrameworkObjects', function(cb)
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
	return Config
end