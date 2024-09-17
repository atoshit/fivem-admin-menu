ESX.RegisterServerCallback('admin:getPlayersList', function(source, cb)
    local playerList = {}
    playersPedList = {}

    for _, playerId in ipairs(GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(playerId)
        local identifier = xPlayer.identifier
        local discord_id = GetPlayerIdentifier(playerId, 1) or 'Introuvable'
        local name = GetPlayerName(playerId)

        playerList[#playerList + 1] = {
            id = playerId,
            discord_id = discord_id,
            rpname = xPlayer.getName(),
            name = name,
            identifier = identifier,
            group = xPlayer.getGroup(),
            accounts = xPlayer.getAccounts(),
            coords = xPlayer.getCoords(true),
            inventory = xPlayer.getInventory(),
            job = xPlayer.getJob(),
            freeze = false
        }

    end
end)

ESX.RegisterServerCallback('admin:checkPermissions', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'user' then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('admin:getReportsList', function(source, cb)
    cb(reportsList)
end)
