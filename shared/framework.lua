AddEventHandler('GetFrameworkObjects', function(cb)
	cb(Framework)
end)

exports('GetFrameworkObjects', function()
	return Framework
end)

function Framework.GetConfig()
	return Config
end