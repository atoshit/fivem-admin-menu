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
local menu_admin_player_troll = zUI.CreateSubMenu(menu_admin_player, "", "Troll")
local menu_admin_player_teleport = zUI.CreateSubMenu(menu_admin_player, "", "Téléportation")
local menu_admin_player_infos = zUI.CreateSubMenu(menu_admin_player, "", "Informations")
local menu_admin_player_actions = zUI.CreateSubMenu(menu_admin_player, "", "Actions")
local menu_admin_player_actions_inventory = zUI.CreateSubMenu(menu_admin_player_actions, "", "Inventaire du joueur")

--- Ajouter un bouton de joueur pour les joueurs normaux.
--- @param Items table : La table des éléments du menu.
--- @param playerData table : Les données du joueur à ajouter.
--- @param badge string : Le badge à afficher sur le bouton.
--- @param subMenu table : Le sous-menu à ouvrir lors de la sélection.
local function AddPlayerButton(Items, playerData, badge, subMenu)
    Items:AddButton("[" .. playerData.id .. "] " .. playerData.rpname, '', { HoverColor = C.MainColor, LeftBadge = badge }, function(onSelected, onHovered)
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
    Items:AddButton("[" .. playerData.id .. "] " .. playerData.rpname, '', { HoverColor = C.MainColor, LeftBadge = badge }, function(onSelected, onHovered)
        if onSelected then
            zUI.AlertInput("Avertissement !", nil, message)
        end
    end)  
end

menu_admin:SetItems(function(Items)
    Items:AddCheckbox("Mode Modération", "", adminMenu.staffMode, { LeftBadge = "NEW_STAR", HoverColor = C.MainColor }, function(onSelected, onHovered, isChecked)
        if onSelected then adminMenu:ToggleFeature("staffMode", isChecked) end
    end)

    if adminMenu.staffMode then
        Items:AddLine({ C.MainColor })
        Items:AddButton("Options Personnel", "", { RightLabel = '→', LeftBadge = "NEW_STAR", HoverColor = C.MainColor }, nil, menu_admin_self)
        Items:AddButton("Liste des joueurs", "", { RightLabel = '→', LeftBadge = "NEW_STAR", HoverColor = C.MainColor }, nil, menu_admin_players)
        Items:AddButton("Gestion des véhicules", "", { RightLabel = '→', LeftBadge = "NEW_STAR", HoverColor = C.MainColor }, nil, menu_admin_vehicle)
    end
end)

menu_admin_self:SetItems(function(Items)
    Items:AddCheckbox("Noclip", "Activer/Désactiver le noclip", adminMenu.noclipActive, { HoverColor = C.MainColor }, function(onSelected, onHovered, isChecked)
        if onSelected then adminMenu:ToggleFeature("noclipActive", isChecked) end
    end)

    Items:AddCheckbox("Invincible", "Activer/Désactiver l'invincibilité", adminMenu.invincibleMode, { HoverColor = C.MainColor }, function(onSelected, onHovered, isChecked)
        if onSelected then adminMenu:ToggleFeature("invincibleMode", isChecked) end
    end)

    Items:AddCheckbox("Visible", "Activer/Désactiver l'invisibilité", adminMenu.visibleMode, { HoverColor = C.MainColor }, function(onSelected, onHovered, isChecked)
        if onSelected then adminMenu:ToggleFeature("visibleMode", isChecked) end
    end)

    Items:AddCheckbox("Stamina Infinie", "Activer/Desactiver la stamina infinie", adminMenu.infiniteStamina, { HoverColor = C.MainColor }, function(onSelected, onHovered, isChecked)
        if onSelected then adminMenu:ToggleFeature("infiniteStamina", isChecked) end
    end)

    Items:AddCheckbox("Vitesse de nage rapide", "Activer/Désactiver la vitesse de nage rapide", adminMenu.fastSwim, { HoverColor = C.MainColor }, function(onSelected, onHovered, isChecked)
        if onSelected then adminMenu:ToggleFeature("fastSwim", isChecked) end
    end)

    Items:AddCheckbox("Vitesse de course rapide", "Activer/Désactiver la vitesse de course rapide", adminMenu.fastRun, { HoverColor = C.MainColor }, function(onSelected, onHovered, isChecked)
        if onSelected then adminMenu:ToggleFeature("fastRun", isChecked) end
    end)

    Items:AddCheckbox("Super saut", "Activer/Désactiver le saut très haut", adminMenu.highJump, { HoverColor = C.MainColor }, function(onSelected, onHovered, isChecked)
        if onSelected then adminMenu:ToggleFeature("highJump", isChecked) end
    end)

    Items:AddButton("Heal", "Se guérir complètement", { HoverColor = C.MainColor }, function(onSelected, onHovered)
        if onSelected then adminMenu:Heal() end
    end)

    Items:AddButton("Armure", "S'ajouter de l'armure", { HoverColor = C.MainColor }, function(onSelected, onHovered)
        if onSelected then
            local amount = zUI.KeyboardInput("Quantité d'armure", nil, "Exemple: 60", 3)
            adminMenu:GiveArmor(tonumber(amount))
        end
    end)

    if not adminMenu.pedMode then
        Items:AddButton("Ped", "Changer son ped", { HoverColor = C.MainColor }, function(onSelected, onHovered)
            if onSelected then
                local model = zUI.KeyboardInput("Ped", nil, "Exemple: a_f_m_salton_01", 30)
                adminMenu:ChangePedModel(model)
            end
        end)
    else
        Items:AddButton("~#f16625~Reprendre son personnage~s~", "Reprendre son personnage d'origine", { HoverColor = C.MainColor }, function(onSelected, onHovered)
            if onSelected then adminMenu:RevertToPlayerModel() end
        end)
    end
end)

menu_admin_players:SetItems(function(Items)
    Items:AddButton("Rechercher un joueur", '', { HoverColor = C.MainColor, LeftBadge = "ARROW_RIGHT" }, function(onSelected, onHovered)
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

    Items:AddLine({ C.MainColor })

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
        Items:AddLine({ C.MainColor })
        Items:AddButton("Informations", "", { RightLabel = '→', HoverColor = C.MainColor }, nil, menu_admin_player_infos)
        Items:AddButton("Troll", "", { RightLabel = '→', HoverColor = C.MainColor }, nil, menu_admin_player_troll)
        Items:AddButton("Actions", "", { RightLabel = '→', HoverColor = C.MainColor }, nil, menu_admin_player_actions)
        Items:AddButton("Téléportation", "", { RightLabel = '→', HoverColor = C.MainColor }, nil, menu_admin_player_teleport)
    end
end)

menu_admin_player_infos:SetItems(function(Items)
    if adminMenu.selectedPlayer then
        Items:AddSeparator("[" .. adminMenu.selectedPlayer.id .. "] " .. adminMenu.selectedPlayer.rpname)
        Items:AddSeparator("Liquide: ~#50f41c~" .. adminMenu.selectedPlayer.accounts[2].money .. "~s~$")
        Items:AddSeparator("Banque: ~#50f41c~" .. adminMenu.selectedPlayer.accounts[3].money .. "~s~$")
        Items:AddSeparator("Job: ~#1862ed~" .. adminMenu.selectedPlayer.job.label .. "~s~")
        Items:AddSeparator("Grade: ~#1862ed~" .. adminMenu.selectedPlayer.job.grade_label .. "~s~")
        Items:AddSeparator("Salaire Automatique: ~#1862ed~" .. adminMenu.selectedPlayer.job.grade_salary .. "~s~$")
        Items:AddSeparator("Groupe: ~#eda618~" .. adminMenu.selectedPlayer.group .. "~s~")
        Items:AddSeparator("Discord ID: ~#eda618~" .. adminMenu.selectedPlayer.discord_id .. "~s~")
    end
end)

menu_admin_player_actions:SetItems(function(Items)
    if adminMenu.selectedPlayer then
        Items:AddSeparator("[" .. adminMenu.selectedPlayer.id .. "] " .. adminMenu.selectedPlayer.rpname)
        Items:AddLine({ C.MainColor })
        Items:AddButton("Inventaire", "", { RightLabel = '→', HoverColor = C.MainColor }, nil, menu_admin_player_actions_inventory)
    end
end)

menu_admin_player_actions_inventory:SetItems(function(Items)
    if adminMenu.selectedPlayer then
        Items:AddSeparator("[" .. adminMenu.selectedPlayer.id .. "] " .. adminMenu.selectedPlayer.rpname)
        Items:AddLine({ C.MainColor })

        for _, item in ipairs(adminMenu.selectedPlayer.inventory) do 
            Items:AddList(item.label .. " [~" .. C.MainColor .. "~" .. tostring(item.count) .. "~s~]", "", {"Supprimer", "Ajouter", "Reset"}, { HoverColor = C.MainColor }, function (onSelected, onHovered, onListChange, index)
                if onSelected then

                end
            end)
        end
    end
end)

menu_admin_player_troll:SetItems(function(Items)
    if adminMenu.selectedPlayer then
        Items:AddSeparator("[" .. adminMenu.selectedPlayer.id .. "] " .. adminMenu.selectedPlayer.rpname)

        if IsPedInAnyVehicle(adminMenu.selectedPlayer.ped, false) then
            local playerVehicle = GetVehiclePedIsIn(adminMenu.selectedPlayer.ped, false)
            
            if DoesEntityExist(playerVehicle) then

                Items:AddLine({ C.MainColor })

                Items:AddButton("Supprimer la voiture", '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
                    if onSelected then
                        DeleteEntity(playerVehicle)
                    end
                end)

                Items:AddList("Changer la couleur", "", adminMenu.colorOptions, {}, function (onSelected, onHovered, onListChange, index)
                    if onSelected then

                        local selectedColor = C.ColorOptions[index] 
                        local primaryColor = selectedColor.primary
                        local secondaryColor = selectedColor.secondary
                
                        if playerVehicle then
                            SetVehicleCustomPrimaryColour(playerVehicle, primaryColor[1], primaryColor[2], primaryColor[3])
                            SetVehicleCustomSecondaryColour(playerVehicle, secondaryColor[1], secondaryColor[2], secondaryColor[3])
                        end
                    end
                end)

                local engineHealth = GetVehicleEngineHealth(playerVehicle)
                local fuelLevel = GetVehicleFuelLevel(playerVehicle)

                if engineHealth ~= engineHealth then
                    print("Invalid Motor Healt, init now")
                    engineHealth = 1000.0
                    SetVehicleEngineHealth(playerVehicle, -engineHealth)
                end

                if engineHealth < 0 then
                    Items:AddButton("~#f16625~Réparer le moteur~s~", '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
                        if onSelected then
                            SetVehicleFixed(playerVehicle)
                            SetVehicleDeformationFixed(playerVehicle)
                        end
                    end)
                else
                    Items:AddButton("Casser le moteur", '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
                        if onSelected then
                            SetVehicleEngineHealth(playerVehicle, -2000)
                        end
                    end)
                end

                if fuelLevel > 10 then
                    Items:AddButton("Vider l'essence", '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
                        if onSelected then
                            SetVehicleFuelLevel(playerVehicle, 2.0)
                        end
                    end)
                else
                    Items:AddButton("~#f16625~Mettre le plein~s~", '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
                        if onSelected then
                            SetVehicleFuelLevel(playerVehicle, 100.0)
                        end
                    end)
                end

                local allTyresIntact = true
                local anyTyreBurst = false

                for i = 0, 5 do
                    if IsVehicleTyreBurst(playerVehicle, i, false) then
                        anyTyreBurst = true
                        allTyresIntact = false
                        break
                    end
                end

                if anyTyreBurst then
                    Items:AddButton("~#f16625~Réparer les pneus~s~", '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
                        if onSelected then
                            for i = 0, 5 do
                                SetVehicleTyreFixed(playerVehicle, i)
                            end
                        end
                    end)
                elseif allTyresIntact then
                    Items:AddButton("Crever les 4 pneus", '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
                        if onSelected then
                            for i = 0, 5 do
                                SetVehicleTyreBurst(playerVehicle, i, true, 1000.0)
                            end
                        end
                    end)
                end
            end
        end

        Items:AddLine({ C.MainColor })

        if not adminMenu.selectedPlayer.freeze then
            Items:AddButton("Freeze", '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
                if onSelected then
                    FreezeEntityPosition(adminMenu.selectedPlayer.ped, true)
                    adminMenu.selectedPlayer.freeze = true
                end
            end)
        else
            Items:AddButton("~#f16625~Unfreeze~s~", '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
                if onSelected then
                    FreezeEntityPosition(adminMenu.selectedPlayer.ped, false)
                    adminMenu.selectedPlayer.freeze = false
                end
            end)
        end

        if not adminMenu.selectedPlayer.inFire then
            Items:AddButton("Bruler le joueur", '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
                if onSelected then
                    StartEntityFire(adminMenu.selectedPlayer.ped) 
                    adminMenu.selectedPlayer.inFire = true
                end
            end)
        else
            Items:AddButton("~#f16625~Arrêter de le bruler~s~", '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
                if onSelected then
                    StopEntityFire(adminMenu.selectedPlayer.ped) 
                    adminMenu.selectedPlayer.inFire = false
                end
            end)
        end

        if IsPedRagdoll(adminMenu.selectedPlayer.ped) then
            Items:AddButton("~#f16625~Le joueur est par terre...~s~", '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
                if onSelected then
                end
            end)
        else
            Items:AddButton("Faire tomber le joueur", '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
                if onSelected then
                    SetPedToRagdoll(adminMenu.selectedPlayer.ped, 5000, 5000, 0, false, false, false)
                end
            end)
        end

        Items:AddButton("~#ed1818~Tuer~s~", '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
            if onSelected then
                SetEntityHealth(adminMenu.selectedPlayer.ped, 0)
            end
        end)
    end
end)

menu_admin_player_teleport:SetItems(function(Items)
    if adminMenu.selectedPlayer then
        Items:AddSeparator("[" .. adminMenu.selectedPlayer.id .. "] " .. adminMenu.selectedPlayer.rpname)

        Items:AddLine({ C.MainColor })

        Items:AddList("Téléportation Rapide", "", adminMenu.teleportOptions, {}, function (onSelected, onHovered, onListChange, index)
            if onSelected then
                local teleportLocation = C.TeleportOptions[index] 
                
                if IsPedInAnyVehicle(adminMenu.selectedPlayer.ped, false) then
                    SetPedCoordsKeepVehicle(adminMenu.selectedPlayer.ped, teleportLocation.coords.x, teleportLocation.coords.y, teleportLocation.coords.z)
                else
                    SetEntityCoords(adminMenu.selectedPlayer.ped, teleportLocation.coords.x, teleportLocation.coords.y, teleportLocation.coords.z)
                end
            end
        end)

        Items:AddButton("Téléporter sur lui", '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
            if onSelected then
                local playerCoords = GetEntityCoords(adminMenu.selectedPlayer.ped)
                SetEntityCoords(adminMenu.currentEntity, playerCoords.x, playerCoords.y, playerCoords.z)
            end
        end)

        Items:AddButton("Téléporter sur moi", '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
            if onSelected then
                local playerCoords = GetEntityCoords(adminMenu.currentEntity)
                SetEntityCoords(adminMenu.selectedPlayer.ped, playerCoords.x, playerCoords.y, playerCoords.z)
            end
        end)
    end
end)

menu_admin_vehicle:SetItems(function(Items)
    Items:AddButton("Spawn un véhicule", "", { HoverColor = C.MainColor }, function(onSelected, onHovered)
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

    if IsPedInAnyVehicle(adminMenu.currentEntity, false) then
        local currentVehicle = GetVehiclePedIsIn(adminMenu.currentEntity, false)

        Items:AddLine({ C.MainColor })

        Items:AddButton("Supprimer un véhicule", "", { HoverColor = C.MainColor }, function(onSelected, onHovered)
            if onSelected then
                local vehicle = GetVehiclePedIsIn(adminMenu.currentEntity, false)
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

        Items:AddList("Multiplicateur de vitesse", "", adminMenu.MultiplierList, {}, function (onSelected, onHovered, onListChange, index)
            if onSelected then
                local selectedMultiplier = C.MultiplierList[index]
                local multiplierValue = selectedMultiplier.value

                ModifyVehicleTopSpeed(currentVehicle, multiplierValue)
            end
        end)
    end
end)