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

RegisterNetEvent('admin:giveBankMoney', function(playerId, count)
    local player = ESX.GetPlayerFromId(playerId)
    print(count)
    if player then
        player.addAccountMoney('bank', count)
    end
end)

RegisterNetEvent('admin:requestPlayerData', function(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    if xPlayer then
        local playerData = {
            id = playerId,
            discord_id = GetPlayerIdentifier(playerId, 1) or 'Introuvable',
            rpname = xPlayer.getName(),
            name = GetPlayerName(playerId),
            identifier = xPlayer.identifier,
            group = xPlayer.getGroup(),
            accounts = xPlayer.getAccounts(),
            coords = xPlayer.getCoords(true),
            inventory = xPlayer.getInventory(),
            job = xPlayer.getJob(),
            ped = playersPedList[playerId] or nil,
            freeze = false
        }

        TriggerClientEvent('admin:updatePlayerData', source, playerData)
    end
end)

RegisterNetEvent('admin:setJob', function(playerId, job, grade)
    local player = ESX.GetPlayerFromId(playerId)    
    if player then
        if ESX.DoesJobExist(job) and ESX.DoesGradeExist(job, grade) then
            player.setJob(job, grade)
            TriggerEvent('admin:requestPlayerData', playerId)
        else 
            print("Job ou grade invalide")
        end
    end
end)

RegisterNetEvent('admin:setJob2', function(playerId, job2, grade)
    local player = ESX.GetPlayerFromId(playerId)
    if player then
        if ESX.DoesJob2Exist(job2) then
            player.setJob2(job2, grade)
            TriggerEvent('admin:requestPlayerData', playerId)
        else 
            print("Groupe invalide")
        end
    end
end)

RegisterNetEvent('admin:kickPlayer', function (playerId, reason)
    DropPlayer(playerId, "Vous venez d'être kick pour: " .. reason)
end)

RegisterNetEvent('admin:deleteReport', function (reportId)
    if not reportsList[reportId] then print("Le report à déjà été supprimé par un autre staff") return end

    for i, report in ipairs(reportsList) do
        if report.id == reportId then
            table.remove(reportsList, i)
            break
        end
    end
end)