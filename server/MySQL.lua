MySQL.ready(function()
	TriggerEvent('__cfx_export_ox_inventory_Items', function(ref)
		if ref then
			Framework.Items = ref()
		end
	end)

	AddEventHandler('ox_inventory:itemList', function(items)
		Framework.Items = items
	end)

	while not next(Framework.Items) do Wait(50) end

	Core.RefreshJobs()

	Core.RefreshGangs()

	print('[^2INFO^7] ^5JLRP-FRAMEWORK^0 INITIALIZED')

	PositionSync()
	DBSync()
	PayCheck()
	StatusUpdate()
end)

function Core.RefreshJobs()
	local Jobs = {}
	local jobs = MySQL.query.await(QUERIES.GET_JOBS)

	for _, v in ipairs(jobs) do
		Jobs[v.name] = v
		Jobs[v.name].grades = {}
	end

	local jobGrades = MySQL.query.await(QUERIES.GET_JOBGRADES)

	for _, v in ipairs(jobGrades) do
		if Jobs[v.job_name] then
			Jobs[v.job_name].grades[tostring(v.grade)] = v
		else
			print(('[^3WARNING^7] Ignoring job grades for ^5"%s"^0 due to missing job'):format(v.job_name))
		end
	end

	for _, v in pairs(Jobs) do
		if Framework.Table.Length(v.grades) == 0 then
			Jobs[v.name] = nil
			print(('[^3WARNING^7] Ignoring job ^5"%s"^0 due to no job grades found'):format(v.name))
		end
	end

	if not Jobs then
		Framework.Jobs['unemployed'] = {
			label = 'Unemployed',
			grades = {
				['0'] = {
					grade = 0,
					label = 'Unemployed',
					salary = 200,
                    onDuty = false,
					skin_male = {},
					skin_female = {}
				}
			}
		}
	else
		Framework.Jobs = Jobs
	end
end

function Core.RefreshGangs()
	local Gangs = {}
	local gangs = MySQL.query.await(QUERIES.GET_GANGS)

	for _, v in ipairs(gangs) do
		Gangs[v.name] = v
		Gangs[v.name].grades = {}
	end

	local gangGrades = MySQL.query.await(QUERIES.GET_GANGGRADES)

	for _, v in ipairs(gangGrades) do
		if Gangs[v.gang_name] then
			Gangs[v.gang_name].grades[tostring(v.grade)] = v
		else
			print(('[^3WARNING^7] Ignoring gang grades for ^5"%s"^0 due to missing gang'):format(v.gang_name))
		end
	end

	for _, v in pairs(Gangs) do
		if Framework.Table.Length(v.grades) == 0 then
			Gangs[v.name] = nil
			print(('[^3WARNING^7] Ignoring gang ^5"%s"^0 due to no gang grades found'):format(v.name))
		end
	end

	if not Gangs then
		Framework.Gangs['nogang'] = {
			label = 'NoGang',
			grades = {
				['0'] = {
					grade = 0,
					label = 'NoGang',
					salary = 0,
					skin_male = {},
					skin_female = {}
				}
			}
		}
	else
		Framework.Gangs = Gangs
	end

end