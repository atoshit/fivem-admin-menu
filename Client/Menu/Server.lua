menu_admin_server = zUI.CreateSubMenu(menu_admin, "", "Gestion du serveur")
menu_admin_server_weather = zUI.CreateSubMenu(menu_admin_server, "", "Gestion du temps")

menu_admin_server:SetItems(function(Items)
    Items:AddList("Changer la météo", "", AdminMenu.weatherOptions, {}, function(onSelected, onHovered, onListChange, index)
        if onSelected then
            local weather = C.WeatherList[index]
            TriggerServerEvent('admin:changeWeather', weather.value)
            print(weather.value, weather.name)
        end
    end)

    Items:AddList("Changer l'heure", "", AdminMenu.timeOptions, {}, function(onSelected, onHovered, onListChange, index)
        if onSelected then
            local time = C.TimeOptions[index]
            TriggerServerEvent('admin:changeTime', time.value)
            print(time.value, time.name)
        end
    end)
end)
