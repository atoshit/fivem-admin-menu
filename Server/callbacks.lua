--[[
Copyright © 2024 Atoshi

All rights reserved.

This FiveM base, "Outlaws" and all of its associated files, code, and resources are protected by copyright law. Unauthorized reproduction, distribution, or modification of this base, in whole or in part, without the express permission of the copyright holder, is strictly prohibited.

For licensing inquiries or permission requests, please contact:

https://discord.gg/fivedev

Thank you for respecting our intellectual property rights.
]]

playersPedList = {}

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
            ped = nil,
            freeze = false
        }

        TriggerClientEvent('admin:getPlayerPed', playerId, playerId)
    end

    SetTimeout(1000, function()
        for i, player in ipairs(playerList) do
            if playersPedList[player.id] then
                playerList[i].ped = playersPedList[player.id]
            end
        end
        cb(playerList)
    end)
end)

ESX.RegisterServerCallback('admin:checkPermissions', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getGroup() ~= 'user' then
        cb(true)
    else
        cb(false)
    end
end)