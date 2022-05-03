AddEventHandler('Framework:GetFrameworkObjects', function(cb)
	cb(Framework)
end)

exports('GetFrameworkObjects', function()
	return Framework
end)