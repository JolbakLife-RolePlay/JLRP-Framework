-- NPWD Phone Compatibility
if GetResourceState('npwd') ~= 'missing' then

    Config.NPWD = true
    NPWD = exports.npwd

    AddEventHandler('JLRP-Framework:playerLoaded', function(playerId, xPlayer)
        while GetResourceState('npwd') ~= 'started' do Wait(0) end

        NPWD:newPlayer({
            source = playerId,
            identifier = xPlayer.identifier,
            phoneNumber = xPlayer.get('phoneNumber'),
            firstname = xPlayer.get('firstName'),
            lastname = xPlayer.get('lastName')
        })
    end)

    AddEventHandler('JLRP-Framework:playerLogout', function(playerId)
        NPWD:unloadPlayer(playerId)
    end)

    Core.GeneratePhoneNumber = function(citizenid)
        while GetResourceState('npwd') ~= 'started' do Wait(0) end

        local phoneNumber = NPWD:generatePhoneNumber()
        MySQL.update(QUERIES.SET_PHONENUMBER, { phoneNumber, citizenid })
        return phoneNumber
    end

    AddEventHandler('onServerResourceStart', function(resource)
        if resource == 'npwd' then
            while GetResourceState('npwd') ~= 'started' do Wait(500) end 
            local xPlayers = Framework.GetPlayers()
            if next(xPlayers) then
                Wait(100)
			    local isTable = type(xPlayers[1]) == 'table'

                for i = 1, #xPlayers do
                    -- Fallback to `GetPlayerFromId` if playerdata was not already returned
                    local xPlayer = isTable and xPlayers[i] or Framework.GetPlayerFromId(xPlayers[i])

                    NPWD:newPlayer({
                        source = xPlayer.source,
                        identifier = xPlayer.identifier,
                        phoneNumber = xPlayer.get('phoneNumber'),
                        firstname = xPlayer.getFirstname(),
                        lastname = xPlayer.getLastname()
                    })
                end
            end
        end
    end)

else Config.NPWD = false end
