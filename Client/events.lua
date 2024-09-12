--[[
Copyright © 2024 Atoshi

All rights reserved.

This FiveM base, "Outlaws" and all of its associated files, code, and resources are protected by copyright law. Unauthorized reproduction, distribution, or modification of this base, in whole or in part, without the express permission of the copyright holder, is strictly prohibited.

For licensing inquiries or permission requests, please contact:

https://discord.gg/fivedev

Thank you for respecting our intellectual property rights.
]]

RegisterNetEvent('admin:getPlayerPed', function(playerId)
    local playerPed = PlayerPedId() 
    TriggerServerEvent('admin:sendPlayerPed', playerPed, playerId)
end)

RegisterNetEvent('admin:updatePlayerData')
AddEventHandler('admin:updatePlayerData', function(playerData)
    if playerData and AdminMenu.selectedPlayer and playerData.id == AdminMenu.selectedPlayer.id then
        AdminMenu.selectedPlayer = playerData
    end
end)