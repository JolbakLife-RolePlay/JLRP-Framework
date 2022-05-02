Config = {}
Config.Locale = 'en'

Config.MaxWeight = 30   -- The max inventory weight in KG
Config.EnablePVP = true -- Enable or disable pvp on the server (Ability to shoot other players)

Config.MultiCharacter = false -- Enabling support for players having multiple characters - would not be implemented for now

Config.OxInventory = true -- Enabling ox_inventory integration with the framework

Config.Server = {} -- General server config
Config.Server.Name = "JolbakLifeRP" -- Name of the RP server
Config.Server.UseConnectQueue = true -- Use connectqueue as a queue for your server
Config.Server.Closed = false -- Set server closed (no one can join except people with ace permission 'qbadmin.join')
Config.Server.ClosedReason = "Server Closed" -- Reason message to display when people can't join the server
Config.Server.Uptime = 0 -- Time the server has been up.
Config.Server.Whitelist = false -- Enable or disable whitelist on the server
Config.Server.WhitelistPermission = 'admin' -- Permission that's able to enter the server when the whitelist is on
Config.Server.Discord = "" -- Discord invite link
Config.Server.CheckDuplicateLicense = true -- Check for duplicate rockstar license on join
Config.Server.Permissions = {'developer', 'god', 'superadmin', 'admin', 'mod'} -- Add as many groups as you want here after creating them in your server.cfg