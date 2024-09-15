RegisterNetEvent('admin:updatePlayerData', function(playerData)
    if playerData and AdminMenu.selectedPlayer and playerData.id == AdminMenu.selectedPlayer.id then
        AdminMenu.selectedPlayer = playerData
    end
end)

RegisterNetEvent('admin:applyWeather', function(weather)
    SetWeatherTypeNowPersist(weather)
    SetWeatherTypeNow(weather)
    SetOverrideWeather(weather)
end)

RegisterNetEvent('admin:applyTime', function(time)
    NetworkOverrideClockTime(time, 0, 0)
end)