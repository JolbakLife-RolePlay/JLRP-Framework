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
    NEW_PLAYER = "INSERT INTO `users` SET `citizenid` = ?, `identifier` = ?, `name` = ?, `group` = ?, `job` = ?, `gang` = ?, `accounts` = ?, `position` = ?, `metadata` = ?",
    LOAD_PLAYER = "SELECT * FROM users where identifier = ?",
    GET_JOBS = "SELECT * FROM jobs",
    GET_JOBGRADES = "SELECT * FROM job_grades",
    GET_GANGS = "SELECT * FROM gangs",
    GET_GANGGRADES = "SELECT * FROM gang_grades",
    CREATE_CITIZENID = "SELECT COUNT(*) as count FROM users WHERE citizenid = ?",
    CREATE_FINGERID = "SELECT COUNT(*) as count FROM `users` WHERE `metadata` LIKE ?",
    SAVE_PLAYER = "UPDATE users SET `group` = ?, `job` = ?, `gang` = ?, `accounts` = ?, `inventory` = ?, `position` = ?, `metadata` = ? WHERE `citizenid` = ?",
    MODIFY_DEATH = "UPDATE users SET is_dead = ? WHERE citizenid = ?",
    SET_PHONENUMBER = "UPDATE users SET phone_number = ? WHERE citizenid = ?",
}

OX_INVENTORY = exports.ox_inventory -- store metadata in a global variable