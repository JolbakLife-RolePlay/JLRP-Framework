Framework.Table = {}

-- nil proof alternative to #table
function Framework.Table.Length(t)
	local count = 0

	for _, _ in pairs(t) do
		count = count + 1
	end

	return count
end

function Framework.Table.SizeOf(t) -- for compatibility with esx
	return Framework.Table.Length(t)
end

function Framework.Table.Set(t)
	local set = {}
	for _, v in ipairs(t) do set[v] = true end
	return set
end

function Framework.Table.IndexOf(t, value)
	for i = 1, Framework.Table.Length(t), 1 do
		if t[i] == value then
			return i
		end
	end

	return -1
end

function Framework.Table.LastIndexOf(t, value)
	for i = Framework.Table.Length(t), 1, -1 do
		if t[i] == value then
			return i
		end
	end

	return -1
end

function Framework.Table.Find(t, cb)
	for i = 1, Framework.Table.Length(t), 1 do
		if cb(t[i]) then
			return t[i]
		end
	end

	return nil
end

function Framework.Table.FindIndex(t, cb)
	for i = 1, Framework.Table.Length(t), 1 do
		if cb(t[i]) then
			return i
		end
	end

	return -1
end

function Framework.Table.Filter(t, cb)
	local newTable = {}

	for i = 1, Framework.Table.Length(t), 1 do
		if cb(t[i]) then
			table.insert(newTable, t[i])
		end
	end

	return newTable
end

function Framework.Table.Map(t, cb)
	local newTable = {}

	for i = 1, Framework.Table.Length(t), 1 do
		newTable[i] = cb(t[i], i)
	end

	return newTable
end

function Framework.Table.Reverse(t)
	local newTable = {}

	for i = Framework.Table.Length(t), 1, -1 do
		table.insert(newTable, t[i])
	end

	return newTable
end

function Framework.Table.Clone(t)
	if type(t) ~= 'table' then return t end

	local meta = getmetatable(t)
	local target = {}

	for k,v in pairs(t) do
		if type(v) == 'table' then
			target[k] = Framework.Table.Clone(v)
		else
			target[k] = v
		end
	end

	setmetatable(target, meta)

	return target
end

function Framework.Table.Concat(t1, t2)
	local t3 = Framework.Table.Clone(t1)

	for i = 1, Framework.Table.Length(t2), 1 do
		table.insert(t3, t2[i])
	end

	return t3
end

function Framework.Table.Join(t, sep)
	local sep = sep or ','
	local str = ''

	for i = 1, Framework.Table.Length(t), 1 do
		if i > 1 then
			str = str .. sep
		end

		str = str .. t[i]
	end

	return str
end

-- Credit: https://stackoverflow.com/a/15706820
-- Description: sort function for pairs
function Framework.Table.Sort(t, order)
	-- collect the keys
	local keys = {}

	for k, _ in pairs(t) do
		keys[#keys + 1] = k
	end

	-- if order function given, sort by it by passing the table and keys a, b,
	-- otherwise just sort the keys
	if order then
		table.sort(keys, function(a,b)
			return order(t, a, b)
		end)
	else
		table.sort(keys)
	end

	-- return the iterator function
	local i = 0

	return function()
		i = i + 1
		if keys[i] then
			return keys[i], t[keys[i]]
		end
	end
end

function Framework.Table.Dump(table, nb)
	if nb == nil then
		nb = 0
	end

	if type(table) == 'table' then
		local s = ''
		for i = 1, nb + 1, 1 do
			s = s .. "    "
		end

		s = '{\n'
		for k,v in pairs(table) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			for i = 1, nb, 1 do
				s = s .. "    "
			end
			s = s .. '['..k..'] = ' .. Framework.Table.Dump(v, nb + 1) .. ',\n'
		end

		for i = 1, nb, 1 do
			s = s .. "    "
		end

		return s .. '}'
	else
		return tostring(table)
	end
end