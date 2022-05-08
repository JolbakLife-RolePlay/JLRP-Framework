Framework = {}
Framework.Jobs = {}
Framework.Gangs = {}
Framework.Items = {}
Framework.Shared = {}
Framework.Player = {}
Framework.Players = {}
Framework.Functions = {}

Core = {} -- For Internal Usage
Core.Player = {}
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