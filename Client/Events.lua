RegisterNetEvent('admin:updatePlayerData', function(playerData)
    if playerData and AdminMenu.selectedPlayer and playerData.id == AdminMenu.selectedPlayer.id then
        AdminMenu.selectedPlayer = playerData
    end
end)