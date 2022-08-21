Config = {}
Config.Locale = 'en'

Config.DefaultSpawn = {x = -269.4, y = -955.3, z = 31.2, heading = 205.8} -- Default spawn point
Config.ForceJobDefaultDutyAtLogin = false -- true: Force duty state to Config.DefaultDuty | false: set duty state from database last saved
Config.DefaultDuty = false

Config.Accounts = {}
Config.Accounts.MoneyTypes = {bank = 'bank', money = 'money', black_money = 'black_money'}
Config.Accounts.StartingMoney = {bank = 5000, money = 500}
Config.Accounts.DontAllowMinus = {'bank', 'money', 'black_money'} -- Money that is not allowed going in minus
Config.Accounts.PayCheckInterval = 15 -- The time in minutes that it will give the paycheck

Config.Player = {}
Config.Player.PVP = true -- Enable or disable pvp on the server (Ability to shoot other players)
Config.Player.HealthRegenerator = true -- Re-generate health up to %50 if it goes below %50
Config.Player.MaxWeight = 30   -- The max inventory weight in KG
Config.Player.UpdateInterval = 1 -- how often to update player data in minutes
Config.Player.StatusInterval = 5000 -- how often to check hunger/thirst status in milliseconds
Config.Player.HungerRate = 1.5 -- Rate at which hunger goes down.
Config.Player.ThirstRate = 2.1 -- Rate at which thirst goes down.
Config.Player.StressRate = 3.0 -- Rate at which stress goes down.
Config.Player.DrunkRate = 5.5 -- Rate at which drunk goes down.
Config.Player.Bloodtypes = {
    "A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-",
}

Config.NativeNotify = false
Config.EnableHud = true -- Enabling the default hud? Display current job, gang, and accounts (black, bank & cash)
Config.MultiCharacter = false -- Enabling support for players having multiple characters - WOULD NOT BE IMPLEMENTED FOR NOW

Config.Server = {} -- General server config
Config.Server.Name = "JolbakLifeRP" -- Name of the RP server
Config.Server.UseConnectQueue = true -- Use connectqueue as a queue for your server
Config.Server.Closed = false -- Set server closed (no one can join except people with ace permission 'group.join')
Config.Server.ClosedReason = "Server Closed" -- Reason message to display when people can't join the server
Config.Server.Uptime = 0 -- Time the server has been up.
Config.Server.Whitelist = false -- Enable or disable whitelist on the server
Config.Server.WhitelistPermission = 'admin' -- Permission that's able to enter the server when the whitelist is on
Config.Server.Discord = "" -- Discord invite link
Config.Server.CheckDuplicateLicense = true -- Check for duplicate rockstar license on join
Config.Server.AdminGroups = {'developer', 'owner', 'superadmin', 'admin', 'mod'} -- Add as many groups as you want here after creating them in your server.cfg

