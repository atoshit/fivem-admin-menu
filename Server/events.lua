--[[
Copyright © 2024 Atoshi

All rights reserved.

This FiveM base, "Outlaws" and all of its associated files, code, and resources are protected by copyright law. Unauthorized reproduction, distribution, or modification of this base, in whole or in part, without the express permission of the copyright holder, is strictly prohibited.

For licensing inquiries or permission requests, please contact:

https://discord.gg/fivedev

Thank you for respecting our intellectual property rights.
]]

RegisterNetEvent('admin:sendPlayerPed', function(ped, playerId)
    playersPedList[playerId] = ped
end)

RegisterNetEvent('admin:giveItem', function(playerId, item, count)
    local player = ESX.GetPlayerFromId(playerId)

    if player then
        player.addInventoryItem(item, count)
    end
end)

RegisterNetEvent('admin:removeItem', function(playerId, item, count)
    local player = ESX.GetPlayerFromId(playerId)

    if player then
        player.removeInventoryItem(item, count)
    end
end)