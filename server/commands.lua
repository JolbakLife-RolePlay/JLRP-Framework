Framework.RegisterCommand('setcoords', 'admin', function(xPlayer, args, showError)
	xPlayer.setPosition({x = args.x, y = args.y, z = args.z})
end, false, {help = _Locale('command_setcoords'), validate = true, arguments = {
	{name = 'x', help = _Locale('command_setcoords_x'), type = 'number'},
	{name = 'y', help = _Locale('command_setcoords_y'), type = 'number'},
	{name = 'z', help = _Locale('command_setcoords_z'), type = 'number'}
}})

Framework.RegisterCommand('setjob', 'admin', function(xPlayer, args, showError)
	if Framework.DoesJobExist(args.job, args.grade) then
		args.playerId.setJob(args.job, args.grade)
	else
		showError(_Locale('command_setjob_invalid'))
	end
end, true, {help = _Locale('command_setjob'), validate = true, arguments = {
	{name = 'playerId', help = _Locale('commandgeneric_playerid'), type = 'player'},
	{name = 'job', help = _Locale('command_setjob_job'), type = 'string'},
	{name = 'grade', help = _Locale('command_setjob_grade'), type = 'number'}
}})

Framework.RegisterCommand('removejob', 'admin', function(xPlayer, args, showError)
    args.playerId.setJob('unemployed', 0)
end, true, {help = _Locale('command_removejob'), validate = true, arguments = {
	{name = 'playerId', help = _Locale('commandgeneric_playerid'), type = 'player'}
}})

Framework.RegisterCommand('setgang', "superadmin", function(xPlayer, args, showError)
	if Framework.DoesGangExist(args.gang, args.grade) then
		args.playerId.setGang(args.gang, args.grade)
	else
		showError(_Locale('command_setgang_invalid'))
	end
end, true, {help = _Locale('command_gangjob'), validate = true, arguments = {
	{name = 'playerId', help = _Locale('commandgeneric_playerid'), type = 'player'},
	{name = 'gang', help = _Locale('command_setgang_gang'), type = 'string'},
	{name = 'grade', help = _Locale('command_setgang_grade'), type = 'number'}
}})

Framework.RegisterCommand('removegang', "superadmin", function(xPlayer, args, showError)
    args.playerId.setGang('nogang', 0)
	end, true, {help = _Locale('command_removegang'), validate = true, arguments = {
	{name = 'playerId', help = _Locale('commandgeneric_playerid'), type = 'player'}
}})

Framework.RegisterCommand('car', 'admin', function(xPlayer, args, showError)
	if not args.car then args.car = "Prototipo" end
	xPlayer.triggerEvent('JLRP-Framework:spawnVehicle', args.car)
end, false, {help = _Locale('command_car'), validate = false, arguments = {
	{name = 'car', help = _Locale('command_car_car'), type = 'any'}
}})

Framework.RegisterCommand('bf400', 'mod', function(xPlayer, args, showError)
	xPlayer.triggerEvent('JLRP-Framework:spawnVehicle', "bf400")
end, false, {help = "Spawn a bf400 motorcycle"})

Framework.RegisterCommand('dv', 'mod', function(xPlayer, args, showError)
    local playerPed = GetPlayerPed(xPlayer.source)
    if not args.radius then
        local vehicle = GetVehiclePedIsIn(playerPed)
        if vehicle ~= 0 then
            Framework.OneSync.Delete(vehicle)
        else
            local vehicles = Framework.OneSync.GetVehiclesInArea(GetEntityCoords(playerPed), tonumber(args.radius) or 4.0)
            for i = 1, #vehicles do
                Framework.OneSync.Delete(vehicles[i].entity)
            end
        end
    else
        local vehicles = Framework.OneSync.GetVehiclesInArea(GetEntityCoords(playerPed), tonumber(args.radius))
        for i = 1, #vehicles do
			Framework.OneSync.Delete(vehicles[i].entity)
		end
    end
end, false, {help = _Locale('command_cardel'), validate = false, arguments = {
	{name = 'radius', help = _Locale('command_cardel_radius'), type = 'any'}
}})

Framework.RegisterCommand('dvfor', "mod", function(xPlayer, args, showError)
	args.playerId.triggerEvent('JLRP-Framework:deleteVehicle')
end, false, {help = _Locale('command_cardel_for'), validate = true, arguments = {
	{name = 'playerId', help = _Locale('commandgeneric_playerid'), type = 'player'}
}})

Framework.RegisterCommand('setaccountmoney', 'superadmin', function(xPlayer, args, showError)
	if args.playerId.getAccount(args.account) then
		args.playerId.setAccountMoney(args.account, args.amount)
	else
		showError(_Locale('command_giveaccountmoney_invalid'))
	end
end, true, {help = _Locale('command_setaccountmoney'), validate = true, arguments = {
	{name = 'playerId', help = _Locale('commandgeneric_playerid'), type = 'player'},
	{name = 'account', help = _Locale('command_giveaccountmoney_account'), type = 'string'},
	{name = 'amount', help = _Locale('command_setaccountmoney_amount'), type = 'number'}
}})

Framework.RegisterCommand('giveaccountmoney', 'superadmin', function(xPlayer, args, showError)
	if args.playerId.getAccount(args.account) then
		args.playerId.addAccountMoney(args.account, args.amount)
	else
		showError(_Locale('command_giveaccountmoney_invalid'))
	end
end, true, {help = _Locale('command_giveaccountmoney'), validate = true, arguments = {
	{name = 'playerId', help = _Locale('commandgeneric_playerid'), type = 'player'},
	{name = 'account', help = _Locale('command_giveaccountmoney_account'), type = 'string'},
	{name = 'amount', help = _Locale('command_giveaccountmoney_amount'), type = 'number'}
}})

Framework.RegisterCommand({'clear', 'clearchat'}, 'user', function(xPlayer, args, showError)
	xPlayer.triggerEvent('chat:clear')
end, false, {help = _Locale('command_clear')})

Framework.RegisterCommand('clearallchats', 'superadmin', function(xPlayer, args, showError)
	TriggerClientEvent('chat:clear', -1)
end, false, {help = _Locale('command_clearall')})

Framework.RegisterCommand('setgroup', 'owner', function(xPlayer, args, showError)
	if not args.playerId then args.playerId = xPlayer.source end
	args.playerId.setGroup(args.group)
end, true, {help = _Locale('command_setgroup'), validate = true, arguments = {
	{name = 'playerId', help = _Locale('commandgeneric_playerid'), type = 'player'},
	{name = 'group', help = _Locale('command_setgroup_group'), type = 'string'},
}})

Framework.RegisterCommand('admin', 'mod', function(xPlayer, args, showError)
	if Core.IsPlayerAdmin(xPlayer.source) then
		local admin = xPlayer.adminDuty()
		xPlayer.adminDuty(not admin)
	else
		showError(_Locale('command_adminduty_not_authorized'))
	end
end, false, {help = _Locale('command_adminduty'), validate = false })

Framework.RegisterCommand('save', 'superadmin', function(xPlayer, args, showError)
	Core.SavePlayer(args.playerId)
end, true, {help = _Locale('command_save'), validate = true, arguments = {
	{name = 'playerId', help = _Locale('commandgeneric_playerid'), type = 'player'}
}})

Framework.RegisterCommand('saveall', 'superadmin', function(xPlayer, args, showError)
	Core.SavePlayers()
end, true, {help = _Locale('command_saveall')})

Framework.RegisterCommand('group', "user", function(xPlayer, args, showError)
	print(xPlayer.getName()..", You are currently: ^5".. xPlayer.getGroup() .. "^0 | onDuty = "..tostring(xPlayer.adminDuty()))
end, true)

Framework.RegisterCommand('job', "user", function(xPlayer, args, showError)
	print(xPlayer.getName()..", You are currently: ^5".. xPlayer.getJob().name.. "^0 - ^5".. xPlayer.getJob().grade_label .. "^0 | onDuty = "..tostring(xPlayer.getDuty()))
end, true)

Framework.RegisterCommand('gang', "user", function(xPlayer, args, showError)
	print(xPlayer.getName()..", You are currently: ^5".. xPlayer.getGang().name.. "^0 - ^5".. xPlayer.getGang().grade_label .. "^0")
end, true)

Framework.RegisterCommand('info', "user", function(xPlayer, args, showError)
	local job = xPlayer.getJob().label
	local jobgrade = xPlayer.getJob().grade_name
	local gang = xPlayer.getGang().label
	print("^2ID : ^5"..xPlayer.source.." ^0| ^2Name:^5"..xPlayer.getName().." ^0 | ^2Group:^5"..xPlayer.getGroup().."^0(onDuty: "..tostring(xPlayer.adminDuty())..") | ^2Job:^5".. job.."^0 | ^2Gang:^5".. gang.."^0")
end, true)

Framework.RegisterCommand('coords', "admin", function(xPlayer, args, showError)
	local coords = GetEntityCoords(GetPlayerPed(xPlayer.source), false)
	local heading = GetEntityHeading(GetPlayerPed(xPlayer.source))
	print("Coords - Vector3: ^5".. vector3(coords.x,coords.y,coords.z).. "^0")
	print("Coords - Vector4: ^5".. vector4(coords.x, coords.y, coords.z, heading) .. "^0")
end, true)

Framework.RegisterCommand('tpm', "mod", function(xPlayer, args, showError)
	xPlayer.triggerEvent("JLRP-Framework:tpm")
end, true)

Framework.RegisterCommand('goto', "admin", function(xPlayer, args, showError)
	local targetCoords = args.playerId.getCoords()
	xPlayer.setCoords(targetCoords)
end, true, {help = _Locale('command_goto'), validate = true, arguments = {
	{name = 'playerId', help = _Locale('commandgeneric_playerid'), type = 'player'}
}})

Framework.RegisterCommand('bring', "admin", function(xPlayer, args, showError)
	local playerCoords = xPlayer.getCoords()
	args.playerId.setCoords(playerCoords)
end, true, {help = _Locale('command_bring'), validate = true, arguments = {
	{name = 'playerId', help = _Locale('commandgeneric_playerid'), type = 'player'}
}})

Framework.RegisterCommand('kill', "admin", function(xPlayer, args, showError)
	args.playerId.triggerEvent("JLRP-Framework:killPlayer")
end, true, {help = _Locale('command_kill'), validate = true, arguments = {
	{name = 'playerId', help = _Locale('commandgeneric_playerid'), type = 'player'}
}})

Framework.RegisterCommand('freeze', "admin", function(xPlayer, args, showError)
	args.playerId.triggerEvent('JLRP-Framework:freezePlayer', "freeze")
end, true, {help = _Locale('command_freeze'), validate = true, arguments = {
	{name = 'playerId', help = _Locale('commandgeneric_playerid'), type = 'player'}
}})

Framework.RegisterCommand('unfreeze', "admin", function(xPlayer, args, showError)
	args.playerId.triggerEvent('JLRP-Framework:freezePlayer', "unfreeze")
end, true, {help = _Locale('command_Localenfreeze'), validate = true, arguments = {
	{name = 'playerId', help = _Locale('commandgeneric_playerid'), type = 'player'}
}})

Framework.RegisterCommand("noclip", "mod", function(xPlayer, args, showError)
	xPlayer.triggerEvent('JLRP-Framework:noclip')
end, false)

Framework.RegisterCommand('players', "developer", function(xPlayer, args, showError)
	local xPlayers = Framework.GetPlayers()
	print("^5"..#xPlayers.." ^2online player(s)^0")
	for _, xPlayer in pairs(xPlayers) do
		print("^1[ ^2ID : ^5"..xPlayer.source.." ^0| ^2Name : ^5"..xPlayer.getName().." ^0 | ^2Group : ^5"..xPlayer.getGroup().." ^0 | ^2CitizenID : ^5"..xPlayer.citizenid.." ^0 | ^2Identifier : ^5".. xPlayer.identifier .."^1]^0\n")
	end
end, true)

Framework.RegisterCommand({'refreshjobs', 'jobs'}, 'developer', function(xPlayer, args, showError)
    Framework.RefreshJobs()
end, true, {help = _Locale('command_refreshjobs')})