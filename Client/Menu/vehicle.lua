menu_admin_vehicle = zUI.CreateSubMenu(menu_admin, "", "Gestion des véhicules")

menu_admin_vehicle:SetItems(function(Items)
    Items:AddButton("Spawn un véhicule", "", { HoverColor = C.MainColor }, function(onSelected, onHovered)
        if onSelected then
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                zUI.AlertInput("Avertissement !", nil, "Vous êtes déjà dans un véhicule.")
                return
            end

            local model = zUI.KeyboardInput("Modèle du véhicule", nil, "Exemple: sou_300dem", 30)
            local spawnCoords = GetEntityCoords(PlayerPedId())
            local spawnHeading = GetEntityHeading(PlayerPedId())
            local vehicle = AdminMenu:SpawnVehicle(model, spawnCoords, spawnHeading)
            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        end
    end)

    Items:AddList("Spawn Rapide", "", AdminMenu.quickSpawnList, {}, function (onSelected, onHovered, onListChange, index)
        if onSelected then
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                zUI.AlertInput("Avertissement !", nil, "Vous êtes déjà dans un véhicule.")
                return
            end

            local spawnCoords = GetEntityCoords(PlayerPedId())
            local spawnHeading = GetEntityHeading(PlayerPedId())

            local selectedVehicle = C.QuickSpawnVehicles[index] -- Récupère le modèle du véhicule sélectionné
            if selectedVehicle then
                local vehicle = AdminMenu:SpawnVehicle(selectedVehicle.model, spawnCoords, spawnHeading)
                TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            end
        end
    end)

    if IsPedInAnyVehicle(PlayerPedId(), false) then
        local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)

        Items:AddLine({ C.MainColor })

        Items:AddButton("Supprimer un véhicule", "", { HoverColor = C.MainColor }, function(onSelected, onHovered)
            if onSelected then
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                DeleteEntity(vehicle)
            end
        end)

        Items:AddButton("Réparer le véhicule", "", { HoverColor = C.MainColor }, function(onSelected, onHovered)
            if onSelected then
                SetVehicleFixed(currentVehicle)
                SetVehicleDeformationFixed(currentVehicle)
            end
        end)

        Items:AddButton("Mettre le plein", "", { HoverColor = C.MainColor }, function(onSelected, onHovered)
            if onSelected then
                SetVehicleFuelLevel(currentVehicle, 100.0)
            end
        end)

        Items:AddList("Changer la couleur", "", AdminMenu.colorOptions, {}, function (onSelected, onHovered, onListChange, index)
            if onSelected then
                local selectedColor = C.ColorOptions[index]
                local primaryColor = selectedColor.primary
                local secondaryColor = selectedColor.secondary

                if currentVehicle then
                    SetVehicleCustomPrimaryColour(currentVehicle, primaryColor[1], primaryColor[2], primaryColor[3])
                    SetVehicleCustomSecondaryColour(currentVehicle, secondaryColor[1], secondaryColor[2], secondaryColor[3])
                end
            end
        end)

        Items:AddList("Multiplicateur de vitesse", "", AdminMenu.MultiplierList, {}, function (onSelected, onHovered, onListChange, index)
            if onSelected then
                local selectedMultiplier = C.MultiplierList[index]
                local multiplierValue = selectedMultiplier.value

                ModifyVehicleTopSpeed(currentVehicle, multiplierValue)
            end
        end)
    end
end)