Framework = {}
Framework.Jobs = {}
Framework.Gangs = {}
Framework.Items = {}
Framework.OneSync = {}

Core = {} -- For Internal Usage
Core.Player = {}
Core.Players = {}
Core.UsableItemsCallbacks = {}
Core.ServerCallbacks = {}
Core.TimeoutCount = -1
Core.CancelledTimeouts = {}
Core.RegisteredCommands = {}
Core.Pickups = {}
Core.PickupId = 0

QUERIES = {
    NEW_PLAYER = 'INSERT INTO `users` SET `citizenid` = ?, `identifier` = ?, `name` = ?, `group` = ?, `job` = ?, `gang` = ?, `accounts` = ?, `position` = ?, `metadata` = ?',
    LOAD_PLAYER = 'SELECT * FROM users where identifier = ?',
}

OX_INVENTORY = exports.ox_inventory -- store metadata in a global variable