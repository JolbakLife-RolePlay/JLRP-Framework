Config = {}
Config.Locale = 'en'

Config.DefaultSpawn = {x = -269.4, y = -955.3, z = 31.2, heading = 205.8} -- Default spawn point
Config.ForceJobDefaultDutyAtLogin = false -- true: Force duty state to jobdefaultDuty | false: set duty state from database last saved
Config.DefaultDuty = false
Config.DistanceGive = 4.0 -- Max distance when giving items, weapons etc.

Config.Accounts = {}
Config.Accounts.MoneyTypes = {bank = 'bank', money = 'money', black_money = 'black_money'}
Config.Accounts.StartingMoney = {bank = 5000, money = 500, black_money = 0}
Config.Accounts.DontAllowMinus = {'cash', 'black_money', 'crypto'} -- Money that is not allowed going in minus
Config.Accounts.PayCheckTimeOut = 15 -- The time in minutes that it will give the paycheck
Config.Accounts.PayCheckSociety = false -- If true paycheck will come from the society account that the player is employed at, requires qb-bossmenu

Config.Player = {}
Config.Player.PVP = true -- Enable or disable pvp on the server (Ability to shoot other players)
Config.Player.HealthRegenerator = true -- Re-generate health up to %50 if it goes below %50
Config.Player.MaxWeight = 30   -- The max inventory weight in KG
Config.Player.HungerRate = 4.2 -- Rate at which hunger goes down.
Config.Player.ThirstRate = 3.8 -- Rate at which thirst goes down.
Config.Player.Bloodtypes = {
    "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-",
}

Config.NativeNotify = true
Config.EnableHud = true -- Enabling the default hud? Display current job, gang, and accounts (black, bank & cash)
Config.MultiCharacter = false -- Enabling support for players having multiple characters - would not be implemented for now
Config.OxInventory = false -- Enabling ox_inventory integration with the framework

Config.Server = {} -- General server config
Config.Server.Name = "FrameworkRP" -- Name of the RP server
Config.Server.UseConnectQueue = true -- Use connectqueue as a queue for your server
Config.Server.Closed = false -- Set server closed (no one can join except people with ace permission 'qbadmin.join')
Config.Server.ClosedReason = "Server Closed" -- Reason message to display when people can't join the server
Config.Server.Uptime = 0 -- Time the server has been up.
Config.Server.Whitelist = false -- Enable or disable whitelist on the server
Config.Server.WhitelistPermission = 'admin' -- Permission that's able to enter the server when the whitelist is on
Config.Server.Discord = "" -- Discord invite link
Config.Server.CheckDuplicateLicense = true -- Check for duplicate rockstar license on join
Config.Server.AdminGroups = {'developer', 'god', 'superadmin', 'admin', 'mod'} -- Add as many groups as you want here after creating them in your server.cfg

