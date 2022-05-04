Config.DefaultWeaponTints = {
	[0] = _Locale('tint_default'),
	[1] = _Locale('tint_green'),
	[2] = _Locale('tint_gold'),
	[3] = _Locale('tint_pink'),
	[4] = _Locale('tint_army'),
	[5] = _Locale('tint_lspd'),
	[6] = _Locale('tint_orange'),
	[7] = _Locale('tint_platinum')
}

Config.Weapons = {
	-- Melee
	{name = 'WEAPON_DAGGER', label = _Locale('weapon_dagger'), components = {}},
	{name = 'WEAPON_BAT', label = _Locale('weapon_bat'), components = {}},
	{name = 'WEAPON_BATTLEAXE', label = _Locale('weapon_battleaxe'), components = {}},
	{
		name = 'WEAPON_KNUCKLE',
		label = _Locale('weapon_knuckle'),
		components = {
			{name = 'knuckle_base', label = _Locale('component_knuckle_base'), hash = GetHashKey("COMPONENT_KNUCKLE_VARMOD_BASE")},
			{name = 'knuckle_pimp', label = _Locale('component_knuckle_pimp'), hash = GetHashKey("COMPONENT_KNUCKLE_VARMOD_PIMP")},
			{name = 'knuckle_ballas', label = _Locale('component_knuckle_ballas'), hash = GetHashKey("COMPONENT_KNUCKLE_VARMOD_BALLAS")},
			{name = 'knuckle_dollar', label = _Locale('component_knuckle_dollar'), hash = GetHashKey("COMPONENT_KNUCKLE_VARMOD_DOLLAR")},
			{name = 'knuckle_diamond', label = _Locale('component_knuckle_diamond'), hash = GetHashKey("COMPONENT_KNUCKLE_VARMOD_DIAMOND")},
			{name = 'knuckle_hate', label = _Locale('component_knuckle_hate'), hash = GetHashKey("COMPONENT_KNUCKLE_VARMOD_HATE")},
			{name = 'knuckle_love', label = _Locale('component_knuckle_love'), hash = GetHashKey("COMPONENT_KNUCKLE_VARMOD_LOVE")},
			{name = 'knuckle_player', label = _Locale('component_knuckle_player'), hash = GetHashKey("COMPONENT_KNUCKLE_VARMOD_PLAYER")},
			{name = 'knuckle_king', label = _Locale('component_knuckle_king'), hash = GetHashKey("COMPONENT_KNUCKLE_VARMOD_KING")},
			{name = 'knuckle_vagos', label = _Locale('component_knuckle_vagos'), hash = GetHashKey("COMPONENT_KNUCKLE_VARMOD_VAGOS")}
		}
	},
	{name = 'WEAPON_BOTTLE', label = _Locale('weapon_bottle'), components = {}},
	{name = 'WEAPON_CROWBAR', label = _Locale('weapon_crowbar'), components = {}},
	{name = 'WEAPON_FLASHLIGHT', label = _Locale('weapon_flashlight'), components = {}},
	{name = 'WEAPON_GOLFCLUB', label = _Locale('weapon_golfclub'), components = {}},
	{name = 'WEAPON_HAMMER', label = _Locale('weapon_hammer'), components = {}},
	{name = 'WEAPON_HATCHET', label = _Locale('weapon_hatchet'), components = {}},
	{name = 'WEAPON_KNIFE', label = _Locale('weapon_knife'), components = {}},
	{name = 'WEAPON_MACHETE', label = _Locale('weapon_machete'), components = {}},
	{name = 'WEAPON_NIGHTSTICK', label = _Locale('weapon_nightstick'), components = {}},
	{name = 'WEAPON_WRENCH', label = _Locale('weapon_wrench'), components = {}},
	{name = 'WEAPON_POOLCUE', label = _Locale('weapon_poolcue'), components = {}},
	{name = 'WEAPON_STONE_HATCHET', label = _Locale('weapon_stone_hatchet'), components = {}},
	{
		name = 'WEAPON_SWITCHBLADE',
		label = _Locale('weapon_switchblade'),
		components = {
			{name = 'handle_default', label = _Locale('component_handle_default'), hash = GetHashKey("COMPONENT_SWITCHBLADE_VARMOD_BASE")},
			{name = 'handle_vip', label = _Locale('component_handle_vip'), hash = GetHashKey("COMPONENT_SWITCHBLADE_VARMOD_VAR1")},
			{name = 'handle_bodyguard', label = _Locale('component_handle_bodyguard'), hash = GetHashKey("COMPONENT_SWITCHBLADE_VARMOD_VAR2")}
		}
	},
	-- Handguns
	{
		name = 'WEAPON_APPISTOL',
		label = _Locale('weapon_appistol'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_PISTOL")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_APPISTOL_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_APPISTOL_CLIP_02")},
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_PI_FLSH")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_PI_SUPP")},
			{name = 'luxary_finish', label = _Locale('component_luxary_finish'), hash = GetHashKey("COMPONENT_APPISTOL_VARMOD_LUXE")}
		}
	},
	{name = 'WEAPON_CERAMICPISTOL', label = _Locale('weapon_ceramicpistol'), tints = Config.DefaultWeaponTints, components = {}, ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_PISTOL")}},
	{
		name = 'WEAPON_COMBATPISTOL',
		label = _Locale('weapon_combatpistol'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_PISTOL")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_COMBATPISTOL_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_COMBATPISTOL_CLIP_02")},
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_PI_FLSH")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_PI_SUPP")},
			{name = 'luxary_finish', label = _Locale('component_luxary_finish'), hash = GetHashKey("COMPONENT_COMBATPISTOL_VARMOD_LOWRIDER")}
		}
	},
	{name = 'WEAPON_DOUBLEACTION', label = _Locale('weapon_doubleaction'), tints = Config.DefaultWeaponTints, components = {}, ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_PISTOL")}},
	{name = 'WEAPON_NAVYREVOLVER', label = _Locale('weapon_navyrevolver'), tints = Config.DefaultWeaponTints, components = {}, ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_PISTOL")}},
	{name = 'WEAPON_FLAREGUN', label = _Locale('weapon_flaregun'), tints = Config.DefaultWeaponTints, components = {}, ammo = {label = _Locale('ammo_flaregun'), hash = GetHashKey("AMMO_FLAREGUN")}},
	{name = 'WEAPON_GADGETPISTOL', label = _Locale('weapon_gadgetpistol'), tints = Config.DefaultWeaponTints, components = {}, ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_PISTOL")}},
	{
		name = 'WEAPON_HEAVYPISTOL',
		label = _Locale('weapon_heavypistol'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_PISTOL")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_HEAVYPISTOL_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_HEAVYPISTOL_CLIP_02")},
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_PI_FLSH")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_PI_SUPP")},
			{name = 'luxary_finish', label = _Locale('component_luxary_finish'), hash = GetHashKey("COMPONENT_HEAVYPISTOL_VARMOD_LUXE")}
		}
	},
	{
		name = 'WEAPON_REVOLVER',
		label = _Locale('weapon_revolver'),
		ammo = {label = _Locale('ammo_rounds'),hash = GetHashKey("AMMO_PISTOL")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_REVOLVER_CLIP_01")},
			{name = 'vip_finish', label = _Locale('component_vip_finish'), hash = GetHashKey("COMPONENT_REVOLVER_VARMOD_BOSS")},
			{name = 'bodyguard_finish', label = _Locale('component_bodyguard_finish'), hash = GetHashKey("COMPONENT_REVOLVER_VARMOD_GOON")}
		}
	},
	{
		name = 'WEAPON_REVOLVER_MK2',
		label = _Locale('weapon_revolver_mk2'),
		ammo = {label = _Locale('ammo_rounds'),hash = GetHashKey("AMMO_PISTOL")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_REVOLVER_MK2_CLIP_01")},
			{name = 'ammo_tracer', label = _Locale('component_ammo_tracer'), hash = GetHashKey("COMPONENT_REVOLVER_MK2_CLIP_TRACER")},
			{name = 'ammo_incendiary', label = _Locale('component_ammo_incendiary'), hash = GetHashKey("COMPONENT_REVOLVER_MK2_CLIP_INCENDIARY")},
			{name = 'ammo_hollowpoint', label = _Locale('component_ammo_hollowpoint'), hash = GetHashKey("COMPONENT_REVOLVER_MK2_CLIP_HOLLOWPOINT")},
			{name = 'ammo_fmj', label = _Locale('component_ammo_fmj'), hash = GetHashKey("COMPONENT_REVOLVER_MK2_CLIP_FMJ")},
			{name = 'scope_holo', label = _Locale('component_scope_holo'), hash = GetHashKey("COMPONENT_AT_SIGHTS")},
			{name = 'scope_small', label = _Locale('component_ammo_fmj'), hash = GetHashKey("COMPONENT_AT_SCOPE_MACRO_MK2")},
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_PI_FLSH")},
			{name = 'compensator', label = _Locale('component_compensator'), hash = GetHashKey("COMPONENT_AT_PI_COMP_03")},
			{name = 'camo_finish', label = _Locale('component_camo_finish'), hash = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO")},
			{name = 'camo_finish2', label = _Locale('component_camo_finish2'), hash = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_02")},
			{name = 'camo_finish3', label = _Locale('component_camo_finish3'), hash = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_03")},
			{name = 'camo_finish4', label = _Locale('component_camo_finish4'), hash = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_04")},
			{name = 'camo_finish5', label = _Locale('component_camo_finish5'), hash = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_05")},
			{name = 'camo_finish6', label = _Locale('component_camo_finish6'), hash = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_06")},
			{name = 'camo_finish7', label = _Locale('component_camo_finish7'), hash = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_07")},
			{name = 'camo_finish8', label = _Locale('component_camo_finish8'), hash = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_08")},
			{name = 'camo_finish9', label = _Locale('component_camo_finish9'), hash = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_09")},
			{name = 'camo_finish10', label = _Locale('component_camo_finish10'), hash = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_10")},
			{name = 'camo_finish11', label = _Locale('component_camo_finish11'), hash = GetHashKey("COMPONENT_REVOLVER_MK2_CAMO_IND_01")}
		}
	},
	{name = 'WEAPON_MARKSMANPISTOL', label = _Locale('weapon_marksmanpistol'), tints = Config.DefaultWeaponTints, components = {}, ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_PISTOL")}},
	{
		name = 'WEAPON_PISTOL',
		label = _Locale('weapon_pistol'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_PISTOL")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_PISTOL_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_PISTOL_CLIP_02")},
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_PI_FLSH")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_PI_SUPP_02")},
			{name = 'luxary_finish', label = _Locale('component_luxary_finish'), hash = GetHashKey("COMPONENT_PISTOL_VARMOD_LUXE")}
		}
	},
	{
		name = 'WEAPON_PISTOL_MK2',
		label = _Locale('weapon_pistol_mk2'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_PISTOL")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_PISTOL_MK2_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_PISTOL_MK2_CLIP_02")},
			{name = 'ammo_tracer', label = _Locale('component_ammo_tracer'), hash = GetHashKey("COMPONENT_PISTOL_MK2_CLIP_TRACER")},
			{name = 'ammo_incendiary', label = _Locale('component_ammo_incendiary'), hash = GetHashKey("COMPONENT_PISTOL_MK2_CLIP_INCENDIARY")},
			{name = 'ammo_hollowpoint', label = _Locale('component_ammo_hollowpoint'), hash = GetHashKey("COMPONENT_PISTOL_MK2_CLIP_HOLLOWPOINT")},
			{name = 'ammo_fmj', label = _Locale('component_ammo_fmj'), hash = GetHashKey("COMPONENT_PISTOL_MK2_CLIP_FMJ")},
			{name = 'scope', label = _Locale('component_scope'), hash = GetHashKey("COMPONENT_AT_PI_RAIL")},
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_PI_FLSH_02")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_PI_SUPP_02")},
			{name = 'compensator', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_PI_COMP")},
			{name = 'camo_finish', label = _Locale('component_camo_finish'), hash = GetHashKey("COMPONENT_PISTOL_MK2_CAMO")},
			{name = 'camo_finish2', label = _Locale('component_camo_finish2'), hash = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_02")},
			{name = 'camo_finish3', label = _Locale('component_camo_finish3'), hash = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_03")},
			{name = 'camo_finish4', label = _Locale('component_camo_finish4'), hash = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_04")},
			{name = 'camo_finish5', label = _Locale('component_camo_finish5'), hash = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_05")},
			{name = 'camo_finish6', label = _Locale('component_camo_finish6'), hash = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_06")},
			{name = 'camo_finish7', label = _Locale('component_camo_finish7'), hash = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_07")},
			{name = 'camo_finish8', label = _Locale('component_camo_finish8'), hash = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_08")},
			{name = 'camo_finish9', label = _Locale('component_camo_finish9'), hash = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_09")},
			{name = 'camo_finish10', label = _Locale('component_camo_finish10'), hash = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_10")},
			{name = 'camo_finish11', label = _Locale('component_camo_finish11'), hash = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_IND_01")},
			{name = 'camo_slide_finish', label = _Locale('component_camo_slide_finish'), hash = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_SLIDE")},
			{name = 'camo_slide_finish2', label = _Locale('component_camo_slide_finish2'), hash = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_02_SLIDE")},
			{name = 'camo_slide_finish3', label = _Locale('component_camo_slide_finish3'), hash = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_03_SLIDE")},
			{name = 'camo_slide_finish4', label = _Locale('component_camo_slide_finish4'), hash = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_04_SLIDE")},
			{name = 'camo_slide_finish5', label = _Locale('component_camo_slide_finish5'), hash = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_05_SLIDE")},
			{name = 'camo_slide_finish6', label = _Locale('component_camo_slide_finish6'), hash = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_06_SLIDE")},
			{name = 'camo_slide_finish7', label = _Locale('component_camo_slide_finish7'), hash = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_07_SLIDE")},
			{name = 'camo_slide_finish8', label = _Locale('component_camo_slide_finish8'), hash = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_08_SLIDE")},
			{name = 'camo_slide_finish9', label = _Locale('component_camo_slide_finish9'), hash = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_09_SLIDE")},
			{name = 'camo_slide_finish10', label = _Locale('component_camo_slide_finish10'), hash = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_10_SLIDE")},
			{name = 'camo_slide_finish11', label = _Locale('component_camo_slide_finish11'), hash = GetHashKey("COMPONENT_PISTOL_MK2_CAMO_IND_01_SLIDE")}
		}
	},
	{
		name = 'WEAPON_PISTOL50',
		label = _Locale('weapon_pistol50'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_PISTOL")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_PISTOL50_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_PISTOL50_CLIP_02")},
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_PI_FLSH")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_AR_SUPP_02")},
			{name = 'luxary_finish', label = _Locale('component_luxary_finish'), hash = GetHashKey("COMPONENT_PISTOL50_VARMOD_LUXE")}
		}
	},
	{
		name = 'WEAPON_SNSPISTOL',
		label = _Locale('weapon_snspistol'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_PISTOL")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_SNSPISTOL_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_SNSPISTOL_CLIP_02")},
			{name = 'luxary_finish', label = _Locale('component_luxary_finish'), hash = GetHashKey("COMPONENT_SNSPISTOL_VARMOD_LOWRIDER")}
		}
	},
	{
		name = 'WEAPON_SNSPISTOL_MK2',
		label = _Locale('weapon_snspistol_mk2'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_PISTOL")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CLIP_02")},
			{name = 'ammo_tracer', label = _Locale('component_ammo_tracer'), hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CLIP_TRACER")},
			{name = 'ammo_incendiary', label = _Locale('component_ammo_incendiary'), hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CLIP_INCENDIARY")},
			{name = 'ammo_hollowpoint', label = _Locale('component_ammo_hollowpoint'), hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CLIP_HOLLOWPOINT")},
			{name = 'ammo_fmj', label = _Locale('component_ammo_fmj'), hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CLIP_FMJ")},
			{name = 'scope', label = _Locale('component_scope'), hash = GetHashKey("COMPONENT_AT_PI_RAIL_02")},
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_PI_FLSH_03")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_PI_SUPP_02")},
			{name = 'compensator', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_PI_COMP_02")},
			{name = 'camo_finish', label = _Locale('component_camo_finish'), hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO")},
			{name = 'camo_finish2', label = _Locale('component_camo_finish2'), hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_02")},
			{name = 'camo_finish3', label = _Locale('component_camo_finish3'), hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_03")},
			{name = 'camo_finish4', label = _Locale('component_camo_finish4'), hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_04")},
			{name = 'camo_finish5', label = _Locale('component_camo_finish5'), hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_05")},
			{name = 'camo_finish6', label = _Locale('component_camo_finish6'), hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_06")},
			{name = 'camo_finish7', label = _Locale('component_camo_finish7'), hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_07")},
			{name = 'camo_finish8', label = _Locale('component_camo_finish8'), hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_08")},
			{name = 'camo_finish9', label = _Locale('component_camo_finish9'), hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_09")},
			{name = 'camo_finish10', label = _Locale('component_camo_finish10'), hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_10")},
			{name = 'camo_finish11', label = _Locale('component_camo_finish11'), hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_IND_01")},
			{name = 'camo_slide_finish', label = _Locale('component_camo_slide_finish'), hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_SLIDE")},
			{name = 'camo_slide_finish2', label = _Locale('component_camo_slide_finish2'), hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_02_SLIDE")},
			{name = 'camo_slide_finish3', label = _Locale('component_camo_slide_finish3'), hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_03_SLIDE")},
			{name = 'camo_slide_finish4', label = _Locale('component_camo_slide_finish4'), hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_04_SLIDE")},
			{name = 'camo_slide_finish5', label = _Locale('component_camo_slide_finish5'), hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_05_SLIDE")},
			{name = 'camo_slide_finish6', label = _Locale('component_camo_slide_finish6'), hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_06_SLIDE")},
			{name = 'camo_slide_finish7', label = _Locale('component_camo_slide_finish7'), hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_07_SLIDE")},
			{name = 'camo_slide_finish8', label = _Locale('component_camo_slide_finish8'), hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_08_SLIDE")},
			{name = 'camo_slide_finish9', label = _Locale('component_camo_slide_finish9'), hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_09_SLIDE")},
			{name = 'camo_slide_finish10', label = _Locale('component_camo_slide_finish10'), hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_10_SLIDE")},
			{name = 'camo_slide_finish11', label = _Locale('component_camo_slide_finish11'), hash = GetHashKey("COMPONENT_SNSPISTOL_MK2_CAMO_IND_01_SLIDE")}
		}
	},
	{name = 'WEAPON_STUNGUN', label = _Locale('weapon_stungun'), tints = Config.DefaultWeaponTints, components = {}},
	{name = 'WEAPON_RAYPISTOL', label = _Locale('weapon_raypistol'), tints = Config.DefaultWeaponTints, components = {}},
	{
		name = 'WEAPON_VINTAGEPISTOL',
		label = _Locale('weapon_vintagepistol'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_PISTOL")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_VINTAGEPISTOL_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_VINTAGEPISTOL_CLIP_02")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_PI_SUPP")}
		}
	},
	-- Shotguns
	{
		name = 'WEAPON_ASSAULTSHOTGUN',
		label = _Locale('weapon_assaultshotgun'),
		ammo = {label = _Locale('ammo_shells'), hash = GetHashKey("AMMO_SHOTGUN")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_ASSAULTSHOTGUN_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_ASSAULTSHOTGUN_CLIP_02")},
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_AR_SUPP")},
			{name = 'grip', label = _Locale('component_grip'), hash = GetHashKey("COMPONENT_AT_AR_AFGRIP")}
		}
	},
	{name = 'WEAPON_AUTOSHOTGUN', label = _Locale('weapon_autoshotgun'), tints = Config.DefaultWeaponTints, components = {}, ammo = {label = _Locale('ammo_shells'), hash = GetHashKey("AMMO_SHOTGUN")}},
	{
		name = 'WEAPON_BULLPUPSHOTGUN',
		label = _Locale('weapon_bullpupshotgun'),
		ammo = {label = _Locale('ammo_shells'), hash = GetHashKey("AMMO_SHOTGUN")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_AR_SUPP_02")},
			{name = 'grip', label = _Locale('component_grip'), hash = GetHashKey("COMPONENT_AT_AR_AFGRIP")}
		}
	},
	{
		name = 'WEAPON_COMBATSHOTGUN',
		label = _Locale('weapon_combatshotgun'),
		ammo = {label = _Locale('ammo_shells'), hash = GetHashKey("AMMO_SHOTGUN")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_AR_SUPP")}
		}
	},
	{name = 'WEAPON_DBSHOTGUN', label = _Locale('weapon_dbshotgun'), tints = Config.DefaultWeaponTints, components = {}, ammo = {label = _Locale('ammo_shells'), hash = GetHashKey("AMMO_SHOTGUN")}},
	{
		name = 'WEAPON_HEAVYSHOTGUN',
		label = _Locale('weapon_heavyshotgun'),
		ammo = {label = _Locale('ammo_shells'), hash = GetHashKey("AMMO_SHOTGUN")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_HEAVYSHOTGUN_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_HEAVYSHOTGUN_CLIP_02")},
			{name = 'clip_drum', label = _Locale('component_clip_drum'), hash = GetHashKey("COMPONENT_HEAVYSHOTGUN_CLIP_03")},
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_AR_SUPP_02")},
			{name = 'grip', label = _Locale('component_grip'), hash = GetHashKey("COMPONENT_AT_AR_AFGRIP")}
		}
	},
	{name = 'WEAPON_MUSKET', label = _Locale('weapon_musket'), tints = Config.DefaultWeaponTints, components = {}, ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_SHOTGUN")}},
	{
		name = 'WEAPON_PUMPSHOTGUN',
		label = _Locale('weapon_pumpshotgun'),
		ammo = {label = _Locale('ammo_shells'), hash = GetHashKey("AMMO_SHOTGUN")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_SR_SUPP")},
			{name = 'luxary_finish', label = _Locale('component_luxary_finish'), hash = GetHashKey("COMPONENT_PUMPSHOTGUN_VARMOD_LOWRIDER")}
		}
	},
	{
		name = 'WEAPON_PUMPSHOTGUN_MK2',
		label = _Locale('weapon_pumpshotgun_mk2'),
		ammo = {label = _Locale('ammo_shells'), hash = GetHashKey("AMMO_SHOTGUN")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'shells_default', label = _Locale('component_shells_default'), hash = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CLIP_01")},
			{name = 'shells_incendiary', label = _Locale('component_shells_incendiary'), hash = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CLIP_INCENDIARY")},
			{name = 'shells_armor', label = _Locale('component_shells_armor'), hash = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CLIP_ARMORPIERCING")},
			{name = 'shells_hollowpoint', label = _Locale('component_shells_hollowpoint'), hash = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CLIP_HOLLOWPOINT")},
			{name = 'shells_explosive', label = _Locale('component_shells_explosive'), hash = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CLIP_EXPLOSIVE")},
			{name = 'scope_holo', label = _Locale('component_scope_holo'), hash = GetHashKey("COMPONENT_AT_SIGHTS")},
			{name = 'scope_small', label = _Locale('component_scope_small'), hash = GetHashKey("COMPONENT_AT_SCOPE_MACRO_MK2")},
			{name = 'scope_medium', label = _Locale('component_scope_medium'), hash = GetHashKey("COMPONENT_AT_SCOPE_SMALL_MK2")},
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_SR_SUPP_03")},
			{name = 'muzzle_squared', label = _Locale('component_muzzle_squared'), hash = GetHashKey("COMPONENT_AT_MUZZLE_08")},
			{name = 'camo_finish', label = _Locale('component_camo_finish'), hash = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO")},
			{name = 'camo_finish2', label = _Locale('component_camo_finish2'), hash = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_02")},
			{name = 'camo_finish3', label = _Locale('component_camo_finish3'), hash = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_03")},
			{name = 'camo_finish4', label = _Locale('component_camo_finish4'), hash = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_04")},
			{name = 'camo_finish5', label = _Locale('component_camo_finish5'), hash = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_05")},
			{name = 'camo_finish6', label = _Locale('component_camo_finish6'), hash = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_06")},
			{name = 'camo_finish7', label = _Locale('component_camo_finish7'), hash = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_07")},
			{name = 'camo_finish8', label = _Locale('component_camo_finish8'), hash = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_08")},
			{name = 'camo_finish9', label = _Locale('component_camo_finish9'), hash = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_09")},
			{name = 'camo_finish10', label = _Locale('component_camo_finish10'), hash = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_10")},
			{name = 'camo_finish11', label = _Locale('component_camo_finish11'), hash = GetHashKey("COMPONENT_PUMPSHOTGUN_MK2_CAMO_IND_01")}
		}
	},
	{
		name = 'WEAPON_SAWNOFFSHOTGUN',
		label = _Locale('weapon_sawnoffshotgun'),
		ammo = {label = _Locale('ammo_shells'), hash = GetHashKey("AMMO_SHOTGUN")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'luxary_finish', label = _Locale('component_luxary_finish'), hash = GetHashKey("COMPONENT_SAWNOFFSHOTGUN_VARMOD_LUXE")}
		}
	},
	-- SMG & LMG
	{
		name = 'WEAPON_ASSAULTSMG',
		label = _Locale('weapon_assaultsmg'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_SMG")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_ASSAULTSMG_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_ASSAULTSMG_CLIP_02")},
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
			{name = 'scope', label = _Locale('component_scope'), hash = GetHashKey("COMPONENT_AT_SCOPE_MACRO")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_AR_SUPP_02")},
			{name = 'luxary_finish', label = _Locale('component_luxary_finish'), hash = GetHashKey("COMPONENT_ASSAULTSMG_VARMOD_LOWRIDER")}
		}
	},
	{
		name = 'WEAPON_COMBATMG',
		label = _Locale('weapon_combatmg'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_MG")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_COMBATMG_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_COMBATMG_CLIP_02")},
			{name = 'scope', label = _Locale('component_scope'), hash = GetHashKey("COMPONENT_AT_SCOPE_MEDIUM")},
			{name = 'grip', label = _Locale('component_grip'), hash = GetHashKey("COMPONENT_AT_AR_AFGRIP")},
			{name = 'luxary_finish', label = _Locale('component_luxary_finish'), hash = GetHashKey("COMPONENT_COMBATMG_VARMOD_LOWRIDER")}
		}
	},
	{
		name = 'WEAPON_COMBATMG_MK2',
		label = _Locale('weapon_combatmg_mk2'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_MG")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_COMBATMG_MK2_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_COMBATMG_MK2_CLIP_02")},
			{name = 'ammo_tracer', label = _Locale('component_ammo_tracer'), hash = GetHashKey("COMPONENT_COMBATMG_MK2_CLIP_TRACER")},
			{name = 'ammo_incendiary', label = _Locale('component_ammo_incendiary'), hash = GetHashKey("COMPONENT_COMBATMG_MK2_CLIP_INCENDIARY")},
			{name = 'ammo_hollowpoint', label = _Locale('component_ammo_hollowpoint'), hash = GetHashKey("COMPONENT_COMBATMG_MK2_CLIP_ARMORPIERCING")},
			{name = 'ammo_fmj', label = _Locale('component_ammo_fmj'), hash = GetHashKey("COMPONENT_COMBATMG_MK2_CLIP_FMJ")},
			{name = 'grip', label = _Locale('component_grip'), hash = GetHashKey("COMPONENT_AT_AR_AFGRIP_02")},
			{name = 'scope_holo', label = _Locale('component_scope_holo'), hash = GetHashKey("COMPONENT_AT_SIGHTS")},
			{name = 'scope_medium', label = _Locale('component_scope_medium'), hash = GetHashKey("COMPONENT_AT_SCOPE_SMALL_MK2")},
			{name = 'scope_large', label = _Locale('component_scope_large'), hash = GetHashKey("COMPONENT_AT_SCOPE_MEDIUM_MK2")},
			{name = 'muzzle_flat', label = _Locale('component_muzzle_flat'), hash = GetHashKey("COMPONENT_AT_MUZZLE_01")},
			{name = 'muzzle_tactical', label = _Locale('component_muzzle_tactical'), hash = GetHashKey("COMPONENT_AT_MUZZLE_02")},
			{name = 'muzzle_fat', label = _Locale('component_muzzle_fat'), hash = GetHashKey("COMPONENT_AT_MUZZLE_03")},
			{name = 'muzzle_precision', label = _Locale('component_muzzle_precision'), hash = GetHashKey("COMPONENT_AT_MUZZLE_04")},
			{name = 'muzzle_heavy', label = _Locale('component_muzzle_heavy'), hash = GetHashKey("COMPONENT_AT_MUZZLE_05")},
			{name = 'muzzle_slanted', label = _Locale('component_muzzle_slanted'), hash = GetHashKey("COMPONENT_AT_MUZZLE_06")},
			{name = 'muzzle_split', label = _Locale('component_muzzle_split'), hash = GetHashKey("COMPONENT_AT_MUZZLE_07")},
			{name = 'barrel_default', label = _Locale('component_barrel_default'), hash = GetHashKey("COMPONENT_AT_MG_BARREL_01")},
			{name = 'barrel_heavy', label = _Locale('component_barrel_heavy'), hash = GetHashKey("COMPONENT_AT_MG_BARREL_02")},
			{name = 'camo_finish', label = _Locale('component_camo_finish'), hash = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO")},
			{name = 'camo_finish2', label = _Locale('component_camo_finish2'), hash = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_02")},
			{name = 'camo_finish3', label = _Locale('component_camo_finish3'), hash = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_03")},
			{name = 'camo_finish4', label = _Locale('component_camo_finish4'), hash = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_04")},
			{name = 'camo_finish5', label = _Locale('component_camo_finish5'), hash = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_05")},
			{name = 'camo_finish6', label = _Locale('component_camo_finish6'), hash = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_06")},
			{name = 'camo_finish7', label = _Locale('component_camo_finish7'), hash = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_07")},
			{name = 'camo_finish8', label = _Locale('component_camo_finish8'), hash = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_08")},
			{name = 'camo_finish9', label = _Locale('component_camo_finish9'), hash = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_09")},
			{name = 'camo_finish10', label = _Locale('component_camo_finish10'), hash = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_10")},
			{name = 'camo_finish11', label = _Locale('component_camo_finish11'), hash = GetHashKey("COMPONENT_COMBATMG_MK2_CAMO_IND_01")}
		}
	},
	{
		name = 'WEAPON_COMBATPDW',
		label = _Locale('weapon_combatpdw'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_SMG")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_COMBATPDW_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_COMBATPDW_CLIP_02")},
			{name = 'clip_drum', label = _Locale('component_clip_drum'), hash = GetHashKey("COMPONENT_COMBATPDW_CLIP_03")},
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
			{name = 'grip', label = _Locale('component_grip'), hash = GetHashKey("COMPONENT_AT_AR_AFGRIP")},
			{name = 'scope', label = _Locale('component_scope'), hash = GetHashKey("COMPONENT_AT_SCOPE_SMALL")}
		}
	},
	{
		name = 'WEAPON_GUSENBERG',
		label = _Locale('weapon_gusenberg'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_MG")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_GUSENBERG_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_GUSENBERG_CLIP_02")}
		}
	},
	{
		name = 'WEAPON_MACHINEPISTOL',
		label = _Locale('weapon_machinepistol'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_PISTOL")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_MACHINEPISTOL_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_MACHINEPISTOL_CLIP_02")},
			{name = 'clip_drum', label = _Locale('component_clip_drum'), hash = GetHashKey("COMPONENT_MACHINEPISTOL_CLIP_03")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_PI_SUPP")}
		}
	},
	{
		name = 'WEAPON_MG',
		label = _Locale('weapon_mg'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_MG")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_MG_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_MG_CLIP_02")},
			{name = 'scope', label = _Locale('component_scope'), hash = GetHashKey("COMPONENT_AT_SCOPE_SMALL_02")},
			{name = 'luxary_finish', label = _Locale('component_luxary_finish'), hash = GetHashKey("COMPONENT_MG_VARMOD_LOWRIDER")}
		}
	},
	{
		name = 'WEAPON_MICROSMG',
		label = _Locale('weapon_microsmg'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_SMG")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_MICROSMG_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_MICROSMG_CLIP_02")},
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_PI_FLSH")},
			{name = 'scope', label = _Locale('component_scope'), hash = GetHashKey("COMPONENT_AT_SCOPE_MACRO")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_AR_SUPP_02")},
			{name = 'luxary_finish', label = _Locale('component_luxary_finish'), hash = GetHashKey("COMPONENT_MICROSMG_VARMOD_LUXE")}
		}
	},
	{
		name = 'WEAPON_MINISMG',
		label = _Locale('weapon_minismg'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_SMG")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_MINISMG_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_MINISMG_CLIP_02")}
		}
	},
	{
		name = 'WEAPON_SMG',
		label = _Locale('weapon_smg'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_SMG")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_SMG_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_SMG_CLIP_02")},
			{name = 'clip_drum', label = _Locale('component_clip_drum'), hash = GetHashKey("COMPONENT_SMG_CLIP_03")},
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
			{name = 'scope', label = _Locale('component_scope'), hash = GetHashKey("COMPONENT_AT_SCOPE_MACRO_02")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_PI_SUPP")},
			{name = 'luxary_finish', label = _Locale('component_luxary_finish'), hash = GetHashKey("COMPONENT_SMG_VARMOD_LUXE")}
		}
	},
	{
		name = 'WEAPON_SMG_MK2',
		label = _Locale('weapon_smg_mk2'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_SMG")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_SMG_MK2_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_SMG_MK2_CLIP_02")},
			{name = 'ammo_tracer', label = _Locale('component_ammo_tracer'), hash = GetHashKey("COMPONENT_SMG_MK2_CLIP_TRACER")},
			{name = 'ammo_incendiary', label = _Locale('component_ammo_incendiary'), hash = GetHashKey("COMPONENT_SMG_MK2_CLIP_INCENDIARY")},
			{name = 'ammo_hollowpoint', label = _Locale('component_ammo_hollowpoint'), hash = GetHashKey("COMPONENT_SMG_MK2_CLIP_HOLLOWPOINT")},
			{name = 'ammo_fmj', label = _Locale('component_ammo_fmj'), hash = GetHashKey("COMPONENT_SMG_MK2_CLIP_FMJ")},
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
			{name = 'scope_holo', label = _Locale('component_scope_holo'), hash = GetHashKey("COMPONENT_AT_SIGHTS_SMG")},
			{name = 'scope_small', label = _Locale('component_scope_small'), hash = GetHashKey("COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2")},
			{name = 'scope_medium', label = _Locale('component_scope_medium'), hash = GetHashKey("COMPONENT_AT_SCOPE_SMALL_SMG_MK2")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_PI_SUPP")},
			{name = 'muzzle_flat', label = _Locale('component_muzzle_flat'), hash = GetHashKey("COMPONENT_AT_MUZZLE_01")},
			{name = 'muzzle_tactical', label = _Locale('component_muzzle_tactical'), hash = GetHashKey("COMPONENT_AT_MUZZLE_02")},
			{name = 'muzzle_fat', label = _Locale('component_muzzle_fat'), hash = GetHashKey("COMPONENT_AT_MUZZLE_03")},
			{name = 'muzzle_precision', label = _Locale('component_muzzle_precision'), hash = GetHashKey("COMPONENT_AT_MUZZLE_04")},
			{name = 'muzzle_heavy', label = _Locale('component_muzzle_heavy'), hash = GetHashKey("COMPONENT_AT_MUZZLE_05")},
			{name = 'muzzle_slanted', label = _Locale('component_muzzle_slanted'), hash = GetHashKey("COMPONENT_AT_MUZZLE_06")},
			{name = 'muzzle_split', label = _Locale('component_muzzle_split'), hash = GetHashKey("COMPONENT_AT_MUZZLE_07")},
			{name = 'barrel_default', label = _Locale('component_barrel_default'), hash = GetHashKey("COMPONENT_AT_SB_BARREL_01")},
			{name = 'barrel_heavy', label = _Locale('component_barrel_heavy'), hash = GetHashKey("COMPONENT_AT_SB_BARREL_02")},
			{name = 'camo_finish', label = _Locale('component_camo_finish'), hash = GetHashKey("COMPONENT_SMG_MK2_CAMO")},
			{name = 'camo_finish2', label = _Locale('component_camo_finish2'), hash = GetHashKey("COMPONENT_SMG_MK2_CAMO_02")},
			{name = 'camo_finish3', label = _Locale('component_camo_finish3'), hash = GetHashKey("COMPONENT_SMG_MK2_CAMO_03")},
			{name = 'camo_finish4', label = _Locale('component_camo_finish4'), hash = GetHashKey("COMPONENT_SMG_MK2_CAMO_04")},
			{name = 'camo_finish5', label = _Locale('component_camo_finish5'), hash = GetHashKey("COMPONENT_SMG_MK2_CAMO_05")},
			{name = 'camo_finish6', label = _Locale('component_camo_finish6'), hash = GetHashKey("COMPONENT_SMG_MK2_CAMO_06")},
			{name = 'camo_finish7', label = _Locale('component_camo_finish7'), hash = GetHashKey("COMPONENT_SMG_MK2_CAMO_07")},
			{name = 'camo_finish8', label = _Locale('component_camo_finish8'), hash = GetHashKey("COMPONENT_SMG_MK2_CAMO_08")},
			{name = 'camo_finish9', label = _Locale('component_camo_finish9'), hash = GetHashKey("COMPONENT_SMG_MK2_CAMO_09")},
			{name = 'camo_finish10', label = _Locale('component_camo_finish10'), hash = GetHashKey("COMPONENT_SMG_MK2_CAMO_10")},
			{name = 'camo_finish11', label = _Locale('component_camo_finish11'), hash = GetHashKey("COMPONENT_SMG_MK2_CAMO_IND_01")}
		}
	},
	{name = 'WEAPON_RAYCARBINE', label = _Locale('weapon_raycarbine'), ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_SMG")}, tints = Config.DefaultWeaponTints, components = {}},
	-- Rifles
	{
		name = 'WEAPON_ADVANCEDRIFLE',
		label = _Locale('weapon_advancedrifle'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_RIFLE")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_ADVANCEDRIFLE_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_ADVANCEDRIFLE_CLIP_02")},
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
			{name = 'scope', label = _Locale('component_scope'), hash = GetHashKey("COMPONENT_AT_SCOPE_SMALL")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_AR_SUPP")},
			{name = 'luxary_finish', label = _Locale('component_luxary_finish'), hash = GetHashKey("COMPONENT_ADVANCEDRIFLE_VARMOD_LUXE")}
		}
	},
	{
		name = 'WEAPON_ASSAULTRIFLE',
		label = _Locale('weapon_assaultrifle'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_RIFLE")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_ASSAULTRIFLE_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_ASSAULTRIFLE_CLIP_02")},
			{name = 'clip_drum', label = _Locale('component_clip_drum'), hash = GetHashKey("COMPONENT_ASSAULTRIFLE_CLIP_03")},
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
			{name = 'scope', label = _Locale('component_scope'), hash = GetHashKey("COMPONENT_AT_SCOPE_MACRO")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_AR_SUPP_02")},
			{name = 'grip', label = _Locale('component_grip'), hash = GetHashKey("COMPONENT_AT_AR_AFGRIP")},
			{name = 'luxary_finish', label = _Locale('component_luxary_finish'), hash = GetHashKey("COMPONENT_ASSAULTRIFLE_VARMOD_LUXE")}
		}
	},
	{
		name = 'WEAPON_ASSAULTRIFLE_MK2',
		label = _Locale('weapon_assaultrifle_mk2'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_RIFLE")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CLIP_02")},
			{name = 'ammo_tracer', label = _Locale('component_ammo_tracer'), hash = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CLIP_TRACER")},
			{name = 'ammo_incendiary', label = _Locale('component_ammo_incendiary'), hash = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CLIP_INCENDIARY")},
			{name = 'ammo_armor', label = _Locale('component_ammo_armor'), hash = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CLIP_ARMORPIERCING")},
			{name = 'ammo_fmj', label = _Locale('component_ammo_fmj'), hash = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CLIP_FMJ")},
			{name = 'grip', label = _Locale('component_grip'), hash = GetHashKey("COMPONENT_AT_AR_AFGRIP_02")},
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
			{name = 'scope_holo', label = _Locale('component_scope_holo'), hash = GetHashKey("COMPONENT_AT_SIGHTS")},
			{name = 'scope_small', label = _Locale('component_scope_small'), hash = GetHashKey("COMPONENT_AT_SCOPE_MACRO_MK2")},
			{name = 'scope_large', label = _Locale('component_scope_large'), hash = GetHashKey("COMPONENT_AT_SCOPE_MEDIUM_MK2")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_AR_SUPP_02")},
			{name = 'muzzle_flat', label = _Locale('component_muzzle_flat'), hash = GetHashKey("COMPONENT_AT_MUZZLE_01")},
			{name = 'muzzle_tactical', label = _Locale('component_muzzle_tactical'), hash = GetHashKey("COMPONENT_AT_MUZZLE_02")},
			{name = 'muzzle_fat', label = _Locale('component_muzzle_fat'), hash = GetHashKey("COMPONENT_AT_MUZZLE_03")},
			{name = 'muzzle_precision', label = _Locale('component_muzzle_precision'), hash = GetHashKey("COMPONENT_AT_MUZZLE_04")},
			{name = 'muzzle_heavy', label = _Locale('component_muzzle_heavy'), hash = GetHashKey("COMPONENT_AT_MUZZLE_05")},
			{name = 'muzzle_slanted', label = _Locale('component_muzzle_slanted'), hash = GetHashKey("COMPONENT_AT_MUZZLE_06")},
			{name = 'muzzle_split', label = _Locale('component_muzzle_split'), hash = GetHashKey("COMPONENT_AT_MUZZLE_07")},
			{name = 'barrel_default', label = _Locale('component_barrel_default'), hash = GetHashKey("COMPONENT_AT_AR_BARREL_01")},
			{name = 'barrel_heavy', label = _Locale('component_barrel_heavy'), hash = GetHashKey("COMPONENT_AT_AR_BARREL_02")},
			{name = 'camo_finish', label = _Locale('component_camo_finish'), hash = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO")},
			{name = 'camo_finish2', label = _Locale('component_camo_finish2'), hash = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_02")},
			{name = 'camo_finish3', label = _Locale('component_camo_finish3'), hash = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_03")},
			{name = 'camo_finish4', label = _Locale('component_camo_finish4'), hash = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_04")},
			{name = 'camo_finish5', label = _Locale('component_camo_finish5'), hash = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_05")},
			{name = 'camo_finish6', label = _Locale('component_camo_finish6'), hash = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_06")},
			{name = 'camo_finish7', label = _Locale('component_camo_finish7'), hash = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_07")},
			{name = 'camo_finish8', label = _Locale('component_camo_finish8'), hash = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_08")},
			{name = 'camo_finish9', label = _Locale('component_camo_finish9'), hash = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_09")},
			{name = 'camo_finish10', label = _Locale('component_camo_finish10'), hash = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_10")},
			{name = 'camo_finish11', label = _Locale('component_camo_finish11'), hash = GetHashKey("COMPONENT_ASSAULTRIFLE_MK2_CAMO_IND_01")}
		}
	},
	{
		name = 'WEAPON_BULLPUPRIFLE',
		label = _Locale('weapon_bullpuprifle'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_RIFLE")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_BULLPUPRIFLE_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_BULLPUPRIFLE_CLIP_02")},
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
			{name = 'scope', label = _Locale('component_scope'), hash = GetHashKey("COMPONENT_AT_SCOPE_SMALL")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_AR_SUPP")},
			{name = 'grip', label = _Locale('component_grip'), hash = GetHashKey("COMPONENT_AT_AR_AFGRIP")},
			{name = 'luxary_finish', label = _Locale('component_luxary_finish'), hash = GetHashKey("COMPONENT_BULLPUPRIFLE_VARMOD_LOW")}
		}
	},
	{
		name = 'WEAPON_BULLPUPRIFLE_MK2',
		label = _Locale('weapon_bullpuprifle_mk2'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_RIFLE")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CLIP_02")},
			{name = 'ammo_tracer', label = _Locale('component_ammo_tracer'), hash = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CLIP_TRACER")},
			{name = 'ammo_incendiary', label = _Locale('component_ammo_incendiary'), hash = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CLIP_INCENDIARY")},
			{name = 'ammo_armor', label = _Locale('component_ammo_armor'), hash = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CLIP_ARMORPIERCING")},
			{name = 'ammo_fmj', label = _Locale('component_ammo_fmj'), hash = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CLIP_FMJ")},
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
			{name = 'scope_holo', label = _Locale('component_scope_holo'), hash = GetHashKey("COMPONENT_AT_SIGHTS")},
			{name = 'scope_small', label = _Locale('component_scope_small'), hash = GetHashKey("COMPONENT_AT_SCOPE_MACRO_02_MK2")},
			{name = 'scope_medium', label = _Locale('component_scope_medium'), hash = GetHashKey("COMPONENT_AT_SCOPE_SMALL_MK2")},
			{name = 'barrel_default', label = _Locale('component_barrel_default'), hash = GetHashKey("COMPONENT_AT_BP_BARREL_01")},
			{name = 'barrel_heavy', label = _Locale('component_barrel_heavy'), hash = GetHashKey("COMPONENT_AT_BP_BARREL_02")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_AR_SUPP")},
			{name = 'muzzle_flat', label = _Locale('component_muzzle_flat'), hash = GetHashKey("COMPONENT_AT_MUZZLE_01")},
			{name = 'muzzle_tactical', label = _Locale('component_muzzle_tactical'), hash = GetHashKey("COMPONENT_AT_MUZZLE_02")},
			{name = 'muzzle_fat', label = _Locale('component_muzzle_fat'), hash = GetHashKey("COMPONENT_AT_MUZZLE_03")},
			{name = 'muzzle_precision', label = _Locale('component_muzzle_precision'), hash = GetHashKey("COMPONENT_AT_MUZZLE_04")},
			{name = 'muzzle_heavy', label = _Locale('component_muzzle_heavy'), hash = GetHashKey("COMPONENT_AT_MUZZLE_05")},
			{name = 'muzzle_slanted', label = _Locale('component_muzzle_slanted'), hash = GetHashKey("COMPONENT_AT_MUZZLE_06")},
			{name = 'muzzle_split', label = _Locale('component_muzzle_split'), hash = GetHashKey("COMPONENT_AT_MUZZLE_07")},
			{name = 'grip', label = _Locale('component_grip'), hash = GetHashKey("COMPONENT_AT_AR_AFGRIP_02")},
			{name = 'camo_finish', label = _Locale('component_camo_finish'), hash = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO")},
			{name = 'camo_finish2', label = _Locale('component_camo_finish2'), hash = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_02")},
			{name = 'camo_finish3', label = _Locale('component_camo_finish3'), hash = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_03")},
			{name = 'camo_finish4', label = _Locale('component_camo_finish4'), hash = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_04")},
			{name = 'camo_finish5', label = _Locale('component_camo_finish5'), hash = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_05")},
			{name = 'camo_finish6', label = _Locale('component_camo_finish6'), hash = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_06")},
			{name = 'camo_finish7', label = _Locale('component_camo_finish7'), hash = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_07")},
			{name = 'camo_finish8', label = _Locale('component_camo_finish8'), hash = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_08")},
			{name = 'camo_finish9', label = _Locale('component_camo_finish9'), hash = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_09")},
			{name = 'camo_finish10', label = _Locale('component_camo_finish10'), hash = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_10")},
			{name = 'camo_finish11', label = _Locale('component_camo_finish11'), hash = GetHashKey("COMPONENT_BULLPUPRIFLE_MK2_CAMO_IND_01")}
		}
	},
	{
		name = 'WEAPON_CARBINERIFLE',
		label = _Locale('weapon_carbinerifle'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_RIFLE")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_CARBINERIFLE_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_CARBINERIFLE_CLIP_02")},
			{name = 'clip_box', label = _Locale('component_clip_box'), hash = GetHashKey("COMPONENT_CARBINERIFLE_CLIP_03")},
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
			{name = 'scope', label = _Locale('component_scope'), hash = GetHashKey("COMPONENT_AT_SCOPE_MEDIUM")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_AR_SUPP")},
			{name = 'grip', label = _Locale('component_grip'), hash = GetHashKey("COMPONENT_AT_AR_AFGRIP")},
			{name = 'luxary_finish', label = _Locale('component_luxary_finish'), hash = GetHashKey("COMPONENT_CARBINERIFLE_VARMOD_LUXE")}
		}
	},
	{
		name = 'WEAPON_CARBINERIFLE_MK2',
		label = _Locale('weapon_carbinerifle_mk2'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_RIFLE")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CLIP_02")},
			{name = 'ammo_tracer', label = _Locale('component_ammo_tracer'), hash = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CLIP_TRACER")},
			{name = 'ammo_incendiary', label = _Locale('component_ammo_incendiary'), hash = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CLIP_INCENDIARY")},
			{name = 'ammo_armor', label = _Locale('component_ammo_armor'), hash = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CLIP_ARMORPIERCING")},
			{name = 'ammo_fmj', label = _Locale('component_ammo_fmj'), hash = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CLIP_FMJ")},
			{name = 'grip', label = _Locale('component_grip'), hash = GetHashKey("COMPONENT_AT_AR_AFGRIP_02")},
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
			{name = 'scope_holo', label = _Locale('component_scope_holo'), hash = GetHashKey("COMPONENT_AT_SIGHTS")},
			{name = 'scope_medium', label = _Locale('component_scope_medium'), hash = GetHashKey("COMPONENT_AT_SCOPE_MACRO_MK2")},
			{name = 'scope_large', label = _Locale('component_scope_large'), hash = GetHashKey("COMPONENT_AT_SCOPE_MEDIUM_MK2")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_AR_SUPP")},
			{name = 'muzzle_flat', label = _Locale('component_muzzle_flat'), hash = GetHashKey("COMPONENT_AT_MUZZLE_01")},
			{name = 'muzzle_tactical', label = _Locale('component_muzzle_tactical'), hash = GetHashKey("COMPONENT_AT_MUZZLE_02")},
			{name = 'muzzle_fat', label = _Locale('component_muzzle_fat'), hash = GetHashKey("COMPONENT_AT_MUZZLE_03")},
			{name = 'muzzle_precision', label = _Locale('component_muzzle_precision'), hash = GetHashKey("COMPONENT_AT_MUZZLE_04")},
			{name = 'muzzle_heavy', label = _Locale('component_muzzle_heavy'), hash = GetHashKey("COMPONENT_AT_MUZZLE_05")},
			{name = 'muzzle_slanted', label = _Locale('component_muzzle_slanted'), hash = GetHashKey("COMPONENT_AT_MUZZLE_06")},
			{name = 'muzzle_split', label = _Locale('component_muzzle_split'), hash = GetHashKey("COMPONENT_AT_MUZZLE_07")},
			{name = 'barrel_default', label = _Locale('component_barrel_default'), hash = GetHashKey("COMPONENT_AT_CR_BARREL_01")},
			{name = 'barrel_heavy', label = _Locale('component_barrel_heavy'), hash = GetHashKey("COMPONENT_AT_CR_BARREL_02")},
			{name = 'camo_finish', label = _Locale('component_camo_finish'), hash = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO")},
			{name = 'camo_finish2', label = _Locale('component_camo_finish2'), hash = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_02")},
			{name = 'camo_finish3', label = _Locale('component_camo_finish3'), hash = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_03")},
			{name = 'camo_finish4', label = _Locale('component_camo_finish4'), hash = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_04")},
			{name = 'camo_finish5', label = _Locale('component_camo_finish5'), hash = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_05")},
			{name = 'camo_finish6', label = _Locale('component_camo_finish6'), hash = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_06")},
			{name = 'camo_finish7', label = _Locale('component_camo_finish7'), hash = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_07")},
			{name = 'camo_finish8', label = _Locale('component_camo_finish8'), hash = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_08")},
			{name = 'camo_finish9', label = _Locale('component_camo_finish9'), hash = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_09")},
			{name = 'camo_finish10', label = _Locale('component_camo_finish10'), hash = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_10")},
			{name = 'camo_finish11', label = _Locale('component_camo_finish11'), hash = GetHashKey("COMPONENT_CARBINERIFLE_MK2_CAMO_IND_01")}
		}
	},
	{
		name = 'WEAPON_COMPACTRIFLE',
		label = _Locale('weapon_compactrifle'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_RIFLE")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_COMPACTRIFLE_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_COMPACTRIFLE_CLIP_02")},
			{name = 'clip_drum', label = _Locale('component_clip_drum'), hash = GetHashKey("COMPONENT_COMPACTRIFLE_CLIP_03")}
		}
	},
	{
		name = 'WEAPON_MILITARYRIFLE',
		label = _Locale('weapon_militaryrifle'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_RIFLE")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_MILITARYRIFLE_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_MILITARYRIFLE_CLIP_02")},
			{name = 'ironsights', label = _Locale('component_ironsights'), hash = GetHashKey("COMPONENT_MILITARYRIFLE_SIGHT_01")},
			{name = 'scope', label = _Locale('component_scope'), hash = GetHashKey("COMPONENT_AT_SCOPE_SMALL")},
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_AR_SUPP")}
		}
	},
	{
		name = 'WEAPON_SPECIALCARBINE',
		label = _Locale('weapon_specialcarbine'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_RIFLE")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_SPECIALCARBINE_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_SPECIALCARBINE_CLIP_02")},
			{name = 'clip_drum', label = _Locale('component_clip_drum'), hash = GetHashKey("COMPONENT_SPECIALCARBINE_CLIP_03")},
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
			{name = 'scope', label = _Locale('component_scope'), hash = GetHashKey("COMPONENT_AT_SCOPE_MEDIUM")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_AR_SUPP_02")},
			{name = 'grip', label = _Locale('component_grip'), hash = GetHashKey("COMPONENT_AT_AR_AFGRIP")},
			{name = 'luxary_finish', label = _Locale('component_luxary_finish'), hash = GetHashKey("COMPONENT_SPECIALCARBINE_VARMOD_LOWRIDER")}
		}
	},
	{
		name = 'WEAPON_SPECIALCARBINE_MK2',
		label = _Locale('weapon_specialcarbine_mk2'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_RIFLE")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CLIP_02")},
			{name = 'ammo_tracer', label = _Locale('component_ammo_tracer'), hash = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CLIP_TRACER")},
			{name = 'ammo_incendiary', label = _Locale('component_ammo_incendiary'), hash = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CLIP_INCENDIARY")},
			{name = 'ammo_armor', label = _Locale('component_ammo_armor'), hash = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CLIP_ARMORPIERCING")},
			{name = 'ammo_fmj', label = _Locale('component_ammo_fmj'), hash = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CLIP_FMJ")},
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
			{name = 'scope_holo', label = _Locale('component_scope_holo'), hash = GetHashKey("COMPONENT_AT_SIGHTS")},
			{name = 'scope_small', label = _Locale('component_scope_small'), hash = GetHashKey("COMPONENT_AT_SCOPE_MACRO_MK2")},
			{name = 'scope_large', label = _Locale('component_scope_large'), hash = GetHashKey("COMPONENT_AT_SCOPE_MEDIUM_MK2")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_AR_SUPP_02")},
			{name = 'muzzle_flat', label = _Locale('component_muzzle_flat'), hash = GetHashKey("COMPONENT_AT_MUZZLE_01")},
			{name = 'muzzle_tactical', label = _Locale('component_muzzle_tactical'), hash = GetHashKey("COMPONENT_AT_MUZZLE_02")},
			{name = 'muzzle_fat', label = _Locale('component_muzzle_fat'), hash = GetHashKey("COMPONENT_AT_MUZZLE_03")},
			{name = 'muzzle_precision', label = _Locale('component_muzzle_precision'), hash = GetHashKey("COMPONENT_AT_MUZZLE_04")},
			{name = 'muzzle_heavy', label = _Locale('component_muzzle_heavy'), hash = GetHashKey("COMPONENT_AT_MUZZLE_05")},
			{name = 'muzzle_slanted', label = _Locale('component_muzzle_slanted'), hash = GetHashKey("COMPONENT_AT_MUZZLE_06")},
			{name = 'muzzle_split', label = _Locale('component_muzzle_split'), hash = GetHashKey("COMPONENT_AT_MUZZLE_07")},
			{name = 'grip', label = _Locale('component_grip'), hash = GetHashKey("COMPONENT_AT_AR_AFGRIP_02")},
			{name = 'barrel_default', label = _Locale('component_barrel_default'), hash = GetHashKey("COMPONENT_AT_SC_BARREL_01")},
			{name = 'barrel_heavy', label = _Locale('component_barrel_heavy'), hash = GetHashKey("COMPONENT_AT_SC_BARREL_02")},
			{name = 'camo_finish', label = _Locale('component_camo_finish'), hash = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO")},
			{name = 'camo_finish2', label = _Locale('component_camo_finish2'), hash = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_02")},
			{name = 'camo_finish3', label = _Locale('component_camo_finish3'), hash = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_03")},
			{name = 'camo_finish4', label = _Locale('component_camo_finish4'), hash = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_04")},
			{name = 'camo_finish5', label = _Locale('component_camo_finish5'), hash = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_05")},
			{name = 'camo_finish6', label = _Locale('component_camo_finish6'), hash = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_06")},
			{name = 'camo_finish7', label = _Locale('component_camo_finish7'), hash = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_07")},
			{name = 'camo_finish8', label = _Locale('component_camo_finish8'), hash = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_08")},
			{name = 'camo_finish9', label = _Locale('component_camo_finish9'), hash = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_09")},
			{name = 'camo_finish10', label = _Locale('component_camo_finish10'), hash = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_10")},
			{name = 'camo_finish11', label = _Locale('component_camo_finish11'), hash = GetHashKey("COMPONENT_SPECIALCARBINE_MK2_CAMO_IND_01")}
		}
	},
	-- Sniper
	{
		name = 'WEAPON_HEAVYSNIPER',
		label = _Locale('weapon_heavysniper'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_SNIPER")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'scope', label = _Locale('component_scope'), hash = GetHashKey("COMPONENT_AT_SCOPE_LARGE")},
			{name = 'scope_advanced', label = _Locale('component_scope_advanced'), hash = GetHashKey("COMPONENT_AT_SCOPE_MAX")}
		}
	},
	{
		name = 'WEAPON_HEAVYSNIPER_MK2',
		label = _Locale('weapon_heavysniper_mk2'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_SNIPER")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CLIP_02")},
			{name = 'ammo_incendiary', label = _Locale('component_ammo_incendiary'), hash = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CLIP_INCENDIARY")},
			{name = 'ammo_armor', label = _Locale('component_ammo_armor'), hash = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CLIP_ARMORPIERCING")},
			{name = 'ammo_fmj', label = _Locale('component_ammo_fmj'), hash = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CLIP_FMJ")},
			{name = 'ammo_explosive', label = _Locale('component_ammo_explosive'), hash = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CLIP_EXPLOSIVE")},
			{name = 'scope_zoom', label = _Locale('component_scope_zoom'), hash = GetHashKey("COMPONENT_AT_SCOPE_LARGE_MK2")},
			{name = 'scope_advanced', label = _Locale('component_scope_advanced'), hash = GetHashKey("COMPONENT_AT_SCOPE_MAX")},
			{name = 'scope_nightvision', label = _Locale('component_scope_nightvision'), hash = GetHashKey("COMPONENT_AT_SCOPE_NV")},
			{name = 'scope_thermal', label = _Locale('component_scope_thermal'), hash = GetHashKey("COMPONENT_AT_SCOPE_THERMAL")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_SR_SUPP_03")},
			{name = 'muzzle_squared', label = _Locale('component_muzzle_squared'), hash = GetHashKey("COMPONENT_AT_MUZZLE_08")},
			{name = 'muzzle_bell', label = _Locale('component_muzzle_bell'), hash = GetHashKey("COMPONENT_AT_MUZZLE_09")},
			{name = 'barrel_default', label = _Locale('component_barrel_default'), hash = GetHashKey("COMPONENT_AT_SR_BARREL_01")},
			{name = 'barrel_heavy', label = _Locale('component_barrel_heavy'), hash = GetHashKey("COMPONENT_AT_SR_BARREL_02")},
			{name = 'camo_finish', label = _Locale('component_camo_finish'), hash = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO")},
			{name = 'camo_finish2', label = _Locale('component_camo_finish2'), hash = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_02")},
			{name = 'camo_finish3', label = _Locale('component_camo_finish3'), hash = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_03")},
			{name = 'camo_finish4', label = _Locale('component_camo_finish4'), hash = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_04")},
			{name = 'camo_finish5', label = _Locale('component_camo_finish5'), hash = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_05")},
			{name = 'camo_finish6', label = _Locale('component_camo_finish6'), hash = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_06")},
			{name = 'camo_finish7', label = _Locale('component_camo_finish7'), hash = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_07")},
			{name = 'camo_finish8', label = _Locale('component_camo_finish8'), hash = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_08")},
			{name = 'camo_finish9', label = _Locale('component_camo_finish9'), hash = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_09")},
			{name = 'camo_finish10', label = _Locale('component_camo_finish10'), hash = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_10")},
			{name = 'camo_finish11', label = _Locale('component_camo_finish11'), hash = GetHashKey("COMPONENT_HEAVYSNIPER_MK2_CAMO_IND_01")}
		}
	},
	{
		name = 'WEAPON_MARKSMANRIFLE',
		label = _Locale('weapon_marksmanrifle'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_SNIPER")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_MARKSMANRIFLE_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_MARKSMANRIFLE_CLIP_02")},
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
			{name = 'scope', label = _Locale('component_scope'), hash = GetHashKey("COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_AR_SUPP")},
			{name = 'grip', label = _Locale('component_grip'), hash = GetHashKey("COMPONENT_AT_AR_AFGRIP")},
			{name = 'luxary_finish', label = _Locale('component_luxary_finish'), hash = GetHashKey("COMPONENT_MARKSMANRIFLE_VARMOD_LUXE")}
		}
	},
	{
		name = 'WEAPON_MARKSMANRIFLE_MK2',
		label = _Locale('weapon_marksmanrifle_mk2'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_SNIPER")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'clip_default', label = _Locale('component_clip_default'), hash = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CLIP_01")},
			{name = 'clip_extended', label = _Locale('component_clip_extended'), hash = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CLIP_02")},
			{name = 'ammo_tracer', label = _Locale('component_ammo_tracer'), hash = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CLIP_TRACER")},
			{name = 'ammo_incendiary', label = _Locale('component_ammo_incendiary'), hash = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CLIP_INCENDIARY")},
			{name = 'ammo_armor', label = _Locale('component_ammo_armor'), hash = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CLIP_ARMORPIERCING")},
			{name = 'ammo_fmj', label = _Locale('component_ammo_fmj'), hash = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CLIP_FMJ")},
			{name = 'scope_holo', label = _Locale('component_scope_holo'), hash = GetHashKey("COMPONENT_AT_SIGHTS")},
			{name = 'scope_large', label = _Locale('component_scope_large'), hash = GetHashKey("COMPONENT_AT_SCOPE_MEDIUM_MK2")},
			{name = 'scope_zoom', label = _Locale('component_scope_zoom'), hash = GetHashKey("COMPONENT_AT_SCOPE_LARGE_FIXED_ZOOM_MK2")},
			{name = 'flashlight', label = _Locale('component_flashlight'), hash = GetHashKey("COMPONENT_AT_AR_FLSH")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_AR_SUPP")},
			{name = 'muzzle_flat', label = _Locale('component_muzzle_flat'), hash = GetHashKey("COMPONENT_AT_MUZZLE_01")},
			{name = 'muzzle_tactical', label = _Locale('component_muzzle_tactical'), hash = GetHashKey("COMPONENT_AT_MUZZLE_02")},
			{name = 'muzzle_fat', label = _Locale('component_muzzle_fat'), hash = GetHashKey("COMPONENT_AT_MUZZLE_03")},
			{name = 'muzzle_precision', label = _Locale('component_muzzle_precision'), hash = GetHashKey("COMPONENT_AT_MUZZLE_04")},
			{name = 'muzzle_heavy', label = _Locale('component_muzzle_heavy'), hash = GetHashKey("COMPONENT_AT_MUZZLE_05")},
			{name = 'muzzle_slanted', label = _Locale('component_muzzle_slanted'), hash = GetHashKey("COMPONENT_AT_MUZZLE_06")},
			{name = 'muzzle_split', label = _Locale('component_muzzle_split'), hash = GetHashKey("COMPONENT_AT_MUZZLE_07")},
			{name = 'barrel_default', label = _Locale('component_barrel_default'), hash = GetHashKey("COMPONENT_AT_MRFL_BARREL_01")},
			{name = 'barrel_heavy', label = _Locale('component_barrel_heavy'), hash = GetHashKey("COMPONENT_AT_MRFL_BARREL_02")},
			{name = 'grip', label = _Locale('component_grip'), hash = GetHashKey("COMPONENT_AT_AR_AFGRIP_02")},
			{name = 'camo_finish', label = _Locale('component_camo_finish'), hash = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO")},
			{name = 'camo_finish2', label = _Locale('component_camo_finish2'), hash = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_02")},
			{name = 'camo_finish3', label = _Locale('component_camo_finish3'), hash = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_03")},
			{name = 'camo_finish4', label = _Locale('component_camo_finish4'), hash = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_04")},
			{name = 'camo_finish5', label = _Locale('component_camo_finish5'), hash = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_05")},
			{name = 'camo_finish6', label = _Locale('component_camo_finish6'), hash = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_06")},
			{name = 'camo_finish7', label = _Locale('component_camo_finish7'), hash = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_07")},
			{name = 'camo_finish8', label = _Locale('component_camo_finish8'), hash = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_08")},
			{name = 'camo_finish9', label = _Locale('component_camo_finish9'), hash = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_09")},
			{name = 'camo_finish10', label = _Locale('component_camo_finish10'), hash = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_10")},
			{name = 'camo_finish11', label = _Locale('component_camo_finish11'), hash = GetHashKey("COMPONENT_MARKSMANRIFLE_MK2_CAMO_IND_01")}
		}
	},
	{
		name = 'WEAPON_SNIPERRIFLE',
		label = _Locale('weapon_sniperrifle'),
		ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_SNIPER")},
		tints = Config.DefaultWeaponTints,
		components = {
			{name = 'scope', label = _Locale('component_scope'), hash = GetHashKey("COMPONENT_AT_SCOPE_LARGE")},
			{name = 'scope_advanced', label = _Locale('component_scope_advanced'), hash = GetHashKey("COMPONENT_AT_SCOPE_MAX")},
			{name = 'suppressor', label = _Locale('component_suppressor'), hash = GetHashKey("COMPONENT_AT_AR_SUPP_02")},
			{name = 'luxary_finish', label = _Locale('component_luxary_finish'), hash = GetHashKey("COMPONENT_SNIPERRIFLE_VARMOD_LUXE")}
		}
	},
	-- Heavy / Launchers
	{name = 'WEAPON_COMPACTLAUNCHER', label = _Locale('weapon_compactlauncher'), tints = Config.DefaultWeaponTints, components = {}, ammo = {label = _Locale('ammo_grenadelauncher'), hash = GetHashKey("AMMO_GRENADELAUNCHER")}},
	{name = 'WEAPON_FIREWORK', label = _Locale('weapon_firework'), components = {}, ammo = {label = _Locale('ammo_firework'), hash = GetHashKey("AMMO_FIREWORK")}},
	{name = 'WEAPON_GRENADELAUNCHER', label = _Locale('weapon_grenadelauncher'), tints = Config.DefaultWeaponTints, components = {}, ammo = {label = _Locale('ammo_grenadelauncher'), hash = GetHashKey("AMMO_GRENADELAUNCHER")}},
	{name = 'WEAPON_HOMINGLAUNCHER', label = _Locale('weapon_hominglauncher'), tints = Config.DefaultWeaponTints, components = {}, ammo = {label = _Locale('ammo_rockets'), hash = GetHashKey("AMMO_HOMINGLAUNCHER")}},
	{name = 'WEAPON_MINIGUN', label = _Locale('weapon_minigun'), tints = Config.DefaultWeaponTints, components = {}, ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_MINIGUN")}},
	{name = 'WEAPON_RAILGUN', label = _Locale('weapon_railgun'), tints = Config.DefaultWeaponTints, components = {}, ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_RAILGUN")}},
	{name = 'WEAPON_RPG', label = _Locale('weapon_rpg'), tints = Config.DefaultWeaponTints, components = {}, ammo = {label = _Locale('ammo_rockets'), hash = GetHashKey("AMMO_RPG")}},
	{name = 'WEAPON_RAYMINIGUN', label = _Locale('weapon_rayminigun'), tints = Config.DefaultWeaponTints, components = {}, ammo = {label = _Locale('ammo_rounds'), hash = GetHashKey("AMMO_MINIGUN")}},
	-- Thrown
	{name = 'WEAPON_BALL', label = _Locale('weapon_ball'), components = {}, ammo = {label = _Locale('ammo_ball'), hash = GetHashKey("AMMO_BALL")}},
	{name = 'WEAPON_BZGAS', label = _Locale('weapon_bzgas'), components = {}, ammo = {label = _Locale('ammo_bzgas'), hash = GetHashKey("AMMO_BZGAS")}},
	{name = 'WEAPON_FLARE', label = _Locale('weapon_flare'), components = {}, ammo = {label = _Locale('ammo_flare'), hash = GetHashKey("AMMO_FLARE")}},
	{name = 'WEAPON_GRENADE', label = _Locale('weapon_grenade'), components = {}, ammo = {label = _Locale('ammo_grenade'), hash = GetHashKey("AMMO_GRENADE")}},
	{name = 'WEAPON_PETROLCAN', label = _Locale('weapon_petrolcan'), components = {}, ammo = {label = _Locale('ammo_petrol'), hash = GetHashKey("AMMO_PETROLCAN")}},
	{name = 'WEAPON_HAZARDCAN', label = _Locale('weapon_hazardcan'), components = {}, ammo = {label = _Locale('ammo_petrol'), hash = GetHashKey("AMMO_PETROLCAN")}},
	{name = 'WEAPON_MOLOTOV', label = _Locale('weapon_molotov'), components = {}, ammo = {label = _Locale('ammo_molotov'), hash = GetHashKey("AMMO_MOLOTOV")}},
	{name = 'WEAPON_PROXMINE', label = _Locale('weapon_proxmine'), components = {}, ammo = {label = _Locale('ammo_proxmine'), hash = GetHashKey("AMMO_PROXMINE")}},
	{name = 'WEAPON_PIPEBOMB', label = _Locale('weapon_pipebomb'), components = {}, ammo = {label = _Locale('ammo_pipebomb'), hash = GetHashKey("AMMO_PIPEBOMB")}},
	{name = 'WEAPON_SNOWBALL', label = _Locale('weapon_snowball'), components = {}, ammo = {label = _Locale('ammo_snowball'), hash = GetHashKey("AMMO_SNOWBALL")}},
	{name = 'WEAPON_STICKYBOMB', label = _Locale('weapon_stickybomb'), components = {}, ammo = {label = _Locale('ammo_stickybomb'), hash = GetHashKey("AMMO_STICKYBOMB")}},
	{name = 'WEAPON_SMOKEGRENADE', label = _Locale('weapon_smokegrenade'), components = {}, ammo = {label = _Locale('ammo_smokebomb'), hash = GetHashKey("AMMO_SMOKEGRENADE")}},
	-- Tools
	{name = 'WEAPON_FIREEXTINGUISHER', label = _Locale('weapon_fireextinguisher'), components = {}, ammo = {label = _Locale('ammo_charge'), hash = GetHashKey("AMMO_FIREEXTINGUISHER")}},
	{name = 'WEAPON_DIGISCANNER', label = _Locale('weapon_digiscanner'), components = {}},
	{name = 'GADGET_PARACHUTE', label = _Locale('gadget_parachute'), components = {}}
}