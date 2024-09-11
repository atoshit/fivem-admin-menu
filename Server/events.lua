RegisterNetEvent('admin:sendPlayerPed', function(ped, playerId)
    playersPedList[playerId] = ped
end)