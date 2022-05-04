function Framework.GetWeaponList()
	return Config.Weapons
end

function Framework.GetWeapon(weaponName)
	weaponName = string.upper(weaponName)

	for k, v in ipairs(Framework.GetWeaponList()) do
		if v.name == weaponName then
			return k, v
		end
	end
end

function Framework.GetWeaponFromHash(weaponHash)
	for _, v in ipairs(Framework.GetWeaponList()) do
		if GetHashKey(v.name) == weaponHash then
			return v
		end
	end
end

function Framework.GetWeaponLabel(weaponName)
	weaponName = string.upper(weaponName)

	for _, v in ipairs(Framework.GetWeaponList()) do
		if v.name == weaponName then
			return v.label
		end
	end
end

function Framework.GetWeaponComponent(weaponName, weaponComponent)
	weaponName = string.upper(weaponName)

	for _, v in ipairs(Framework.GetWeaponList()) do
		if v.name == weaponName then
			for _, v2 in ipairs(v.components) do
				if v2.name == weaponComponent then
					return v2
				end
			end
		end
	end
end
