RegisterNetEvent('admin:getPlayerPed', function(playerId)
    local playerPed = PlayerPedId() 
    TriggerServerEvent('admin:sendPlayerPed', playerPed, playerId)
end)