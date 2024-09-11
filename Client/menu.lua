--[[
Copyright © 2024 Atoshi

All rights reserved.

This FiveM base, "Outlaws" and all of its associated files, code, and resources are protected by copyright law. Unauthorized reproduction, distribution, or modification of this base, in whole or in part, without the express permission of the copyright holder, is strictly prohibited.

For licensing inquiries or permission requests, please contact:

https://discord.gg/fivedev

Thank you for respecting our intellectual property rights.
]]

adminMenu = AdminMenu:new()

menu_admin = zUI.CreateMenu("", "Menu Administration", nil, nil, C.MenuBanner)
local menu_admin_self = zUI.CreateSubMenu(menu_admin, "", "Options Personnel")
local menu_admin_vehicle = zUI.CreateSubMenu(menu_admin, "", "Gestion des véhicules")
local menu_admin_players = zUI.CreateSubMenu(menu_admin, "", "Liste des joueurs")
local menu_admin_player = zUI.CreateSubMenu(menu_admin_players, "", "Gestion du joueur")
local menu_admin_player_actions = zUI.CreateSubMenu(menu_admin_player, "", "Actions")


--- Ajouter un bouton de joueur pour les joueurs normaux.
--- @param Items table : La table des éléments du menu.
--- @param playerData table : Les données du joueur à ajouter.
--- @param badge string : Le badge à afficher sur le bouton.
--- @param subMenu table : Le sous-menu à ouvrir lors de la sélection.
local function AddPlayerButton(Items, playerData, badge, subMenu)
    Items:AddButton("[" .. playerData.id .. "] " .. playerData.rpname, '', { HoverColor = "#f16625", LeftBadge = badge }, function(onSelected, onHovered)
        if onSelected then
            adminMenu.selectedPlayer = playerData
        end
    end, subMenu) 
end

--- Ajouter un bouton de joueur pour soi-même et les administrateurs avec un message d'alerte.
--- @param Items table : La table des éléments du menu.
--- @param playerData table : Les données du joueur à ajouter.
--- @param badge string : Le badge à afficher sur le bouton.
--- @param message string : Le message d'alerte à afficher lors de la sélection.
local function AddAlertButton(Items, playerData, badge, message)
    Items:AddButton("[" .. playerData.id .. "] " .. playerData.rpname, '', { HoverColor = "#f16625", LeftBadge = badge }, function(onSelected, onHovered)
        if onSelected then
            zUI.AlertInput("Avertissement !", nil, message)
        end
    end)  
end

menu_admin:SetItems(function(Items)
    Items:AddCheckbox("Mode Modération", "", adminMenu.staffMode, { LeftBadge = "NEW_STAR", HoverColor = "#f16625" }, function(onSelected, onHovered, isChecked)
        if onSelected then adminMenu:ToggleFeature("staffMode", isChecked) end
    end)

    if adminMenu.staffMode then
        Items:AddLine({ "#f16625" })
        Items:AddButton("Options Personnel", "", { RightLabel = '→', LeftBadge = "NEW_STAR", HoverColor = "#f16625" }, nil, menu_admin_self)
        Items:AddButton("Liste des joueurs", "", { RightLabel = '→', LeftBadge = "NEW_STAR", HoverColor = "#f16625" }, nil, menu_admin_players)
        Items:AddButton("Gestion des véhicules", "", { RightLabel = '→', LeftBadge = "NEW_STAR", HoverColor = "#f16625" }, nil, menu_admin_vehicle)
    end
end)

menu_admin_self:SetItems(function(Items)
    Items:AddCheckbox("Noclip", "Activer/Désactiver le noclip", adminMenu.noclipActive, { HoverColor = "#f16625" }, function(onSelected, onHovered, isChecked)
        if onSelected then adminMenu:ToggleFeature("noclipActive", isChecked) end
    end)

    Items:AddCheckbox("Invincible", "Activer/Désactiver l'invincibilité", adminMenu.invincibleMode, { HoverColor = "#f16625" }, function(onSelected, onHovered, isChecked)
        if onSelected then adminMenu:ToggleFeature("invincibleMode", isChecked) end
    end)

    Items:AddCheckbox("Visible", "Activer/Désactiver l'invisibilité", adminMenu.visibleMode, { HoverColor = "#f16625" }, function(onSelected, onHovered, isChecked)
        if onSelected then adminMenu:ToggleFeature("visibleMode", isChecked) end
    end)

    Items:AddCheckbox("Stamina Infinie", "Activer/Desactiver la stamina infinie", adminMenu.infiniteStamina, { HoverColor = "#f16625" }, function(onSelected, onHovered, isChecked)
        if onSelected then adminMenu:ToggleFeature("infiniteStamina", isChecked) end
    end)

    Items:AddButton("Heal", "Se guérir complètement", { HoverColor = "#f16625" }, function(onSelected, onHovered)
        if onSelected then adminMenu:Heal() end
    end)

    Items:AddButton("Armure", "S'ajouter de l'armure", { HoverColor = "#f16625" }, function(onSelected, onHovered)
        if onSelected then
            local amount = zUI.KeyboardInput("Quantité d'armure", nil, "Exemple: 60", 3)
            adminMenu:GiveArmor(tonumber(amount))
        end
    end)

    if not adminMenu.pedMode then
        Items:AddButton("Ped", "Changer son ped", { HoverColor = "#f16625" }, function(onSelected, onHovered)
            if onSelected then
                local model = zUI.KeyboardInput("Ped", nil, "Exemple: a_f_m_salton_01", 30)
                adminMenu:ChangePedModel(model)
            end
        end)
    else
        Items:AddButton("Reprendre son personnage", "Reprendre son personnage d'origine", { HoverColor = "#f16625" }, function(onSelected, onHovered)
            if onSelected then adminMenu:RevertToPlayerModel() end
        end)
    end
end)

menu_admin_players:SetItems(function(Items)
    Items:AddButton("Rechercher un joueur", '', { HoverColor = "#f16625", LeftBadge = "ARROW_RIGHT" }, function(onSelected, onHovered)
        if onSelected then
            adminMenu.searchInput = zUI.KeyboardInput("Recherche", nil, "Exemple: Lenny", 30)
            adminMenu.filteredPlayersList = {}

            for _, player in ipairs(adminMenu.playersList) do
                if not adminMenu.searchInput or adminMenu.searchInput == "" or 
                   string.find(string.lower(player.rpname), string.lower(adminMenu.searchInput)) or
                   string.find(tostring(player.id), tostring(adminMenu.searchInput)) then
                    table.insert(adminMenu.filteredPlayersList, player)
                end
            end
        end
    end)

    Items:AddLine({ "#f16625" })

    local playersToShow = #adminMenu.filteredPlayersList > 0 and adminMenu.filteredPlayersList or adminMenu.playersList

    for _, playerData in ipairs(playersToShow) do
        --if tonumber(playerData.id) == tonumber(GetPlayerServerId(PlayerId())) then
        --    AddAlertButton(Items, playerData, "LOCK_ICON", "Vous ne pouvez pas intéragir sur vous même")
        --elseif playerData.group ~= 'user' then
        --    AddAlertButton(Items, playerData, "HOST_CROWN", "Vous ne pouvez pas intéragir sur un autre administrateur.")
        --else
            AddPlayerButton(Items, playerData, "TICK_ICON", menu_admin_player)
        --end
    end
end)

menu_admin_player:SetItems(function(Items)
    if adminMenu.selectedPlayer then
        Items:AddSeparator("[" .. adminMenu.selectedPlayer.id .. "] " .. adminMenu.selectedPlayer.rpname)

        Items:AddLine({ "#f16625" })

        Items:AddButton("Actions", "", { RightLabel = '→', HoverColor = "#f16625" }, nil, menu_admin_player_actions)
    end
end)

menu_admin_player_actions:SetItems(function(Items)
    if adminMenu.selectedPlayer then
        Items:AddSeparator("[" .. adminMenu.selectedPlayer.id .. "] " .. adminMenu.selectedPlayer.rpname)

        Items:AddLine({ "#f16625" })

        if not adminMenu.selectedPlayer.freeze then
            Items:AddButton("Freeze", '', { HoverColor = "#f16625" }, function(onSelected, onHovered)
                if onSelected then
                    FreezeEntityPosition(adminMenu.selectedPlayer.ped, true)
                    adminMenu.selectedPlayer.freeze = true
                end
            end)
        else
            Items:AddButton("Unfreeze", '', { HoverColor = "#f16625" }, function(onSelected, onHovered)
                if onSelected then
                    FreezeEntityPosition(adminMenu.selectedPlayer.ped, false)
                    adminMenu.selectedPlayer.freeze = false
                end
            end)
        end

        if not adminMenu.selectedPlayer.inFire then
            Items:AddButton("Bruler le joueur", '', { HoverColor = "#f16625" }, function(onSelected, onHovered)
                if onSelected then
                    StartEntityFire(adminMenu.selectedPlayer.ped) 
                    adminMenu.selectedPlayer.inFire = true
                end
            end)
        else
            Items:AddButton("Arrêter de le bruler", '', { HoverColor = "#f16625" }, function(onSelected, onHovered)
                if onSelected then
                    StopEntityFire(adminMenu.selectedPlayer.ped) 
                    adminMenu.selectedPlayer.inFire = false
                end
            end)
        end

        Items:AddList("Téléportation Rapide", "", adminMenu.teleportOptions, {}, function (onSelected, onHovered, onListChange, index)
            if onSelected then
                local teleportLocation = C.TeleportOptions[index] 
                local playerCoords = GetEntityCoords(adminMenu.currentEntity)
        
                if IsPedInAnyVehicle(adminMenu.currentEntity, false) then
                    SetPedCoordsKeepVehicle(adminMenu.currentEntity, teleportLocation.coords.x, teleportLocation.coords.y, teleportLocation.coords.z)
                else
                    SetEntityCoords(adminMenu.currentEntity, teleportLocation.coords.x, teleportLocation.coords.y, teleportLocation.coords.z)
                end
            end
        end)
    end
end)

menu_admin_vehicle:SetItems(function(Items)
    Items:AddButton("Spawn un véhicule", "", { HoverColor = "#f16625" }, function(onSelected, onHovered)
        if onSelected then
            if IsPedInAnyVehicle(adminMenu.currentEntity, false) then
                zUI.AlertInput("Avertissement !", nil, "Vous êtes déjà dans un véhicule.")
                return
            end

            local model = zUI.KeyboardInput("Modèle du véhicule", nil, "Exemple: sou_300dem", 30)
            local spawnCoords = GetEntityCoords(adminMenu.currentEntity)
            local spawnHeading = GetEntityHeading(adminMenu.currentEntity)
            adminMenu:SpawnVehicle(model, spawnCoords, spawnHeading)
        end
    end)

    Items:AddList("Spawn Rapide", "", adminMenu.quickSpawnList, {}, function (onSelected, onHovered, onListChange, index)
        if onSelected then
            if IsPedInAnyVehicle(adminMenu.currentEntity, false) then
                zUI.AlertInput("Avertissement !", nil, "Vous êtes déjà dans un véhicule.")
                return
            end

            local spawnCoords = GetEntityCoords(adminMenu.currentEntity)
            local spawnHeading = GetEntityHeading(adminMenu.currentEntity)
    
            local selectedVehicle = C.QuickSpawnVehicles[index] -- Récupère le modèle du véhicule sélectionné
            if selectedVehicle then
                adminMenu:SpawnVehicle(selectedVehicle.model, spawnCoords, spawnHeading)
            end
        end
    end)

    Items:AddButton("Supprimer un véhicule", "", { HoverColor = "#f16625" }, function(onSelected, onHovered)
        if onSelected then
            if not IsPedInAnyVehicle(adminMenu.currentEntity, false) then
                zUI.AlertInput("Avertissement !", nil, "Vous êtes pas dans un véhicule.")
                return
            end

            local vehicle = GetVehiclePedIsIn(adminMenu.currentEntity, false)
            DeleteEntity(vehicle)
        end
    end)

    if IsPedInAnyVehicle(adminMenu.currentEntity, false) then
        local currentVehicle = GetVehiclePedIsIn(adminMenu.currentEntity, false)

        Items:AddLine({ "#f16625" })

        Items:AddButton("Réparer le véhicule", "", { HoverColor = "#f16625" }, function(onSelected, onHovered)
            if onSelected then
                SetVehicleFixed(currentVehicle)
                SetVehicleDeformationFixed(currentVehicle)
            end
        end)

        Items:AddButton("Mettre le plein", "", { HoverColor = "#f16625" }, function(onSelected, onHovered)
            if onSelected then
                SetVehicleFuelLevel(currentVehicle, 100.0)
            end
        end)

        Items:AddList("Changer la couleur", "", adminMenu.colorOptions, {}, function (onSelected, onHovered, onListChange, index)
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
    end
end)