menu_admin = zUI.CreateMenu("", "Menu Administration", nil, nil, C.MenuBanner)
local menu_admin_self = zUI.CreateSubMenu(menu_admin, "", "Options Personnel")
local menu_admin_vehicle = zUI.CreateSubMenu(menu_admin, "", "Gestion des véhicules")
local menu_admin_players = zUI.CreateSubMenu(menu_admin, "", "Liste des joueurs")

local menu_admin_reports = zUI.CreateSubMenu(menu_admin, "", "Gestion des reports")
local menu_admin_report = zUI.CreateSubMenu(menu_admin_reports, "", "Gestion du report(s)")

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
            AdminMenu.selectedPlayer = playerData
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
    Items:AddCheckbox("Mode Modération", "", AdminMenu.staffMode, { LeftBadge = "NEW_STAR", HoverColor = C.MainColor }, function(onSelected, onHovered, isChecked)
        if onSelected then 
            AdminMenu:ToggleFeature("staffMode", isChecked) 
            AdminMenu:FetchReportsList() 
        end
    end)

    if AdminMenu.staffMode then
        Items:AddLine({ C.MainColor })
        Items:AddButton("Options Personnel", "", { RightLabel = '→', LeftBadge = "NEW_STAR", HoverColor = C.MainColor }, nil, menu_admin_self)
        Items:AddButton("Liste des joueurs", "", { RightLabel = '→', LeftBadge = "NEW_STAR", HoverColor = C.MainColor }, nil, menu_admin_players)
        Items:AddButton("Gestion des véhicules", "", { RightLabel = '→', LeftBadge = "NEW_STAR", HoverColor = C.MainColor }, nil, menu_admin_vehicle)
        Items:AddButton("Gestion des report(s) (~#f16625~" .. #AdminMenu.reportsList .. "~s~)", "", { RightLabel = '→', LeftBadge = "NEW_STAR", HoverColor = C.MainColor }, function (onSelected)
            if onSelected then
                AdminMenu:FetchReportsList()
            end
        end, menu_admin_reports)
    end
end)

menu_admin_self:SetItems(function(Items)
    Items:AddCheckbox("Noclip", "Activer/Désactiver le noclip", AdminMenu.noclipActive, { HoverColor = C.MainColor }, function(onSelected, onHovered, isChecked)
        if onSelected then AdminMenu:ToggleFeature("noclipActive", isChecked) end
    end)

    Items:AddCheckbox("Invincible", "Activer/Désactiver l'invincibilité", AdminMenu.invincibleMode, { HoverColor = C.MainColor }, function(onSelected, onHovered, isChecked)
        if onSelected then AdminMenu:ToggleFeature("invincibleMode", isChecked) end
    end)

    Items:AddCheckbox("Visible", "Activer/Désactiver l'invisibilité", AdminMenu.visibleMode, { HoverColor = C.MainColor }, function(onSelected, onHovered, isChecked)
        if onSelected then AdminMenu:ToggleFeature("visibleMode", isChecked) end
    end)

    Items:AddCheckbox("Stamina Infinie", "Activer/Desactiver la stamina infinie", AdminMenu.infiniteStamina, { HoverColor = C.MainColor }, function(onSelected, onHovered, isChecked)
        if onSelected then AdminMenu:ToggleFeature("infiniteStamina", isChecked) end
    end)

    Items:AddCheckbox("Vitesse de nage rapide", "Activer/Désactiver la vitesse de nage rapide", AdminMenu.fastSwim, { HoverColor = C.MainColor }, function(onSelected, onHovered, isChecked)
        if onSelected then AdminMenu:ToggleFeature("fastSwim", isChecked) end
    end)

    Items:AddCheckbox("Vitesse de course rapide", "Activer/Désactiver la vitesse de course rapide", AdminMenu.fastRun, { HoverColor = C.MainColor }, function(onSelected, onHovered, isChecked)
        if onSelected then AdminMenu:ToggleFeature("fastRun", isChecked) end
    end)

    Items:AddCheckbox("Super saut", "Activer/Désactiver le saut très haut", AdminMenu.highJump, { HoverColor = C.MainColor }, function(onSelected, onHovered, isChecked)
        if onSelected then AdminMenu:ToggleFeature("highJump", isChecked) end
    end)

    Items:AddButton("Heal", "Se guérir complètement", { HoverColor = C.MainColor }, function(onSelected, onHovered)
        if onSelected then AdminMenu:Heal() end
    end)

    Items:AddButton("Armure", "S'ajouter de l'armure", { HoverColor = C.MainColor }, function(onSelected, onHovered)
        if onSelected then
            local amount = zUI.KeyboardInput("Quantité d'armure", nil, "Exemple: 60", 3)
            AdminMenu:GiveArmor(tonumber(amount))
        end
    end)

    if not AdminMenu.pedMode then
        Items:AddButton("Ped", "Changer son ped", { HoverColor = C.MainColor }, function(onSelected, onHovered)
            if onSelected then
                local model = zUI.KeyboardInput("Ped", nil, "Exemple: a_f_m_salton_01", 30)
                AdminMenu:ChangePedModel(model)
            end
        end)
    else
        Items:AddButton("~#f16625~Reprendre son personnage~s~", "Reprendre son personnage d'origine", { HoverColor = C.MainColor }, function(onSelected, onHovered)
            if onSelected then AdminMenu:RevertToPlayerModel() end
        end)
    end
end)

menu_admin_players:SetItems(function(Items)
    Items:AddButton("Rechercher un joueur", '', { HoverColor = C.MainColor, LeftBadge = "ARROW_RIGHT" }, function(onSelected, onHovered)
        if onSelected then
            AdminMenu.searchInput = zUI.KeyboardInput("Recherche", nil, "Exemple: Lenny", 30)
            AdminMenu.filteredPlayersList = {}

            for _, player in ipairs(AdminMenu.playersList) do
                if not AdminMenu.searchInput or AdminMenu.searchInput == "" or 
                   string.find(string.lower(player.rpname), string.lower(AdminMenu.searchInput)) or
                   string.find(tostring(player.id), tostring(AdminMenu.searchInput)) then
                    table.insert(AdminMenu.filteredPlayersList, player)
                end
            end
        end
    end)

    Items:AddLine({ C.MainColor })

    local playersToShow = #AdminMenu.filteredPlayersList > 0 and AdminMenu.filteredPlayersList or AdminMenu.playersList

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
    if AdminMenu.selectedPlayer then
        Items:AddSeparator("[" .. AdminMenu.selectedPlayer.id .. "] " .. AdminMenu.selectedPlayer.rpname)
        Items:AddLine({ C.MainColor })
        Items:AddButton("Informations", "", { RightLabel = '→', HoverColor = C.MainColor }, function (onSelected)
            if onSelected then
                TriggerServerEvent('admin:requestPlayerData', AdminMenu.selectedPlayer.id)
            end
        end, menu_admin_player_infos)
        Items:AddButton("Troll", "", { RightLabel = '→', HoverColor = C.MainColor }, nil, menu_admin_player_troll)
        Items:AddButton("Actions", "", { RightLabel = '→', HoverColor = C.MainColor }, function (onSelected)
            if onSelected then
                TriggerServerEvent('admin:requestPlayerData', AdminMenu.selectedPlayer.id)
            end
        end, menu_admin_player_actions)
        Items:AddButton("Téléportation", "", { RightLabel = '→', HoverColor = C.MainColor }, nil, menu_admin_player_teleport)
    end
end)

menu_admin_player_infos:SetItems(function(Items)
    if AdminMenu.selectedPlayer then
        Items:AddSeparator("[" .. AdminMenu.selectedPlayer.id .. "] " .. AdminMenu.selectedPlayer.rpname)
        Items:AddSeparator("Liquide: ~#50f41c~" .. AdminMenu.selectedPlayer.accounts[2].money .. "~s~$")
        Items:AddSeparator("Banque: ~#50f41c~" .. AdminMenu.selectedPlayer.accounts[3].money .. "~s~$")
        Items:AddSeparator("Job: ~#1862ed~" .. AdminMenu.selectedPlayer.job.label .. "~s~")
        Items:AddSeparator("Grade: ~#1862ed~" .. AdminMenu.selectedPlayer.job.grade_label .. "~s~")
        Items:AddSeparator("Salaire Automatique: ~#1862ed~" .. AdminMenu.selectedPlayer.job.grade_salary .. "~s~$")
        Items:AddSeparator("Groupe: ~#eda618~" .. AdminMenu.selectedPlayer.group .. "~s~")
        Items:AddSeparator("Discord ID: ~#eda618~" .. AdminMenu.selectedPlayer.discord_id .. "~s~")
    end
end)

menu_admin_player_actions:SetItems(function(Items)
    if AdminMenu.selectedPlayer then
        Items:AddSeparator("[" .. AdminMenu.selectedPlayer.id .. "] " .. AdminMenu.selectedPlayer.rpname)
        Items:AddLine({ C.MainColor })
        Items:AddButton("Inventaire", "", { RightLabel = '→', HoverColor = C.MainColor }, nil, menu_admin_player_actions_inventory)
        Items:AddLine({ C.MainColor })


        Items:AddList("Give", "", {"Item", "Argent", "Argent en banque"}, {}, function (onSelected, onHovered, onListChange, index)
            if onSelected then
                if index == 1 then 
                    local item = zUI.KeyboardInput("Nom de l'item", nil, "Exemple: weapon_pistol/water", 30)
                    
                    Wait(100)
                    
                    local quantity = zUI.KeyboardInput("Quantité à give", nil, "Exemple: 2", 30)

                    local item = tostring(item)
                    local quantity = tonumber(quantity)

                    if quantity and quantity > 0 then
                        TriggerServerEvent('admin:giveItem', AdminMenu.selectedPlayer.id, item, quantity)
                    else
                        print("Veuiller entrer un nombre valide")
                    end
                elseif index == 2 then                    
                    local quantity = zUI.KeyboardInput("Quantité d'argent", nil, "Exemple: 100000", 30)

                    local quantity = tonumber(quantity)

                    if quantity and quantity > 0 then
                        TriggerServerEvent('admin:giveItem', AdminMenu.selectedPlayer.id, 'money', quantity)
                    else
                        print("Veuiller entrer un nombre valide")

                    end
                elseif index == 3 then
                    local quantity = zUI.KeyboardInput("Quantité d'argent", nil, "Exemple: 100000", 30)

                    local quantity = tonumber(quantity)

                    if quantity and quantity > 0 then
                        TriggerServerEvent('admin:giveBankMoney', AdminMenu.selectedPlayer.id, quantity)
                    else
                        print("Veuiller entrer un nombre valide")
                    end
                end
            end
        end)
        Items:AddButton("Setjob", "", { HoverColor = C.MainColor }, function(onSelected, onHovered)
            if onSelected then
                local job = zUI.KeyboardInput("Nom du job", nil, "Exemple: police", 30)
                Wait(100)
                local grade = zUI.KeyboardInput("Grade", nil, "Exemple: 0", 30)

                TriggerServerEvent('admin:setJob', AdminMenu.selectedPlayer.id, job, tonumber(grade))
            end
        end)
        if C.Job2 then
            Items:AddButton("Setjob2", "", { HoverColor = C.MainColor }, function(onSelected, onHovered)
                if onSelected then
                    local job2 = zUI.KeyboardInput("Nom du gang", nil, "Exemple: ballas", 30)
                    Wait(100)
                    local grade = zUI.KeyboardInput("Grade", nil, "Exemple: 0", 30)
    
                    TriggerServerEvent('admin:setJob2', AdminMenu.selectedPlayer.id, job2, tonumber(grade))
                end
            end)
        end
        Items:AddButton("~#df0707~Kick~s~", "", { HoverColor = C.MainColor }, function(onSelected, onHovered)
            if onSelected then
                local reason = zUI.KeyboardInput("Raison du kick", nil, "Exemple: Freekill", 30)

                if not reason then return print("Veuiller rentré une raison") end

                TriggerServerEvent('admin:kickPlayer', AdminMenu.selectedPlayer.id, reason)
            end
        end)
        Items:AddButton("~#df0707~Ban~s~", "", { HoverColor = C.MainColor }, function(onSelected, onHovered)
            if onSelected then

            end
        end)
    end
end)

menu_admin_player_actions_inventory:SetItems(function(Items)
    if AdminMenu.selectedPlayer then
        Items:AddSeparator("[" .. AdminMenu.selectedPlayer.id .. "] " .. AdminMenu.selectedPlayer.rpname)
        Items:AddLine({ C.MainColor })

        if #AdminMenu.selectedPlayer.inventory < 1 then
            Items:AddSeparator(AdminMenu.selectedPlayer.rpname .. " possède aucun item.")
        else
            for _, item in pairs(AdminMenu.selectedPlayer.inventory) do 
                Items:AddList(item.label .. " [~" .. C.MainColor .. "~" .. tostring(item.count) .. "~s~]", "", {"Supprimer", "Ajouter"}, { HoverColor = C.MainColor }, function (onSelected, onHovered, onListChange, index)
                    if onSelected then
                        if index == 1 then
                            local count = zUI.KeyboardInput("Nombre à retirer", nil, "Maximum: " .. tostring(item.count), 30)

                            if tonumber(count) > item.count then
                                print("Vous ne pouvez pas lui en retirer autant")
                                return
                            end

                            TriggerServerEvent('admin:removeItem', AdminMenu.selectedPlayer.id, item.name, tonumber(count))

                            TriggerServerEvent('admin:requestPlayerData', AdminMenu.selectedPlayer.id)
                        elseif index == 2 then
                            local count = zUI.KeyboardInput("Nombre à ajouter", nil, "Exemple: 5", 30)

                            TriggerServerEvent('admin:giveItem', AdminMenu.selectedPlayer.id, item.name, tonumber(count))

                            TriggerServerEvent('admin:requestPlayerData', AdminMenu.selectedPlayer.id)
                        end
                    end
                end)
            end
        end
    end
end)

menu_admin_player_troll:SetItems(function(Items)
    if AdminMenu.selectedPlayer then
        Items:AddSeparator("[" .. AdminMenu.selectedPlayer.id .. "] " .. AdminMenu.selectedPlayer.rpname)

        if IsPedInAnyVehicle(GetPlayerPed(GetPlayerFromServerId(AdminMenu.selectedPlayer.id)), false) then
            local playerVehicle = GetVehiclePedIsIn(GetPlayerPed(GetPlayerFromServerId(AdminMenu.selectedPlayer.id)), false)
            
            if DoesEntityExist(playerVehicle) then

                Items:AddLine({ C.MainColor })

                Items:AddButton("Supprimer la voiture", '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
                    if onSelected then
                        DeleteEntity(playerVehicle)
                    end
                end)

                Items:AddList("Changer la couleur", "", AdminMenu.colorOptions, {}, function (onSelected, onHovered, onListChange, index)
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

        if not AdminMenu.selectedPlayer.freeze then
            Items:AddButton("Freeze", '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
                if onSelected then
                    FreezeEntityPosition(GetPlayerPed(GetPlayerFromServerId(AdminMenu.selectedPlayer.id)), true)
                    AdminMenu.selectedPlayer.freeze = true
                end
            end)
        else
            Items:AddButton("~#f16625~Unfreeze~s~", '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
                if onSelected then
                    FreezeEntityPosition(GetPlayerPed(GetPlayerFromServerId(AdminMenu.selectedPlayer.id)), false)
                    AdminMenu.selectedPlayer.freeze = false
                end
            end)
        end

        if not IsEntityOnFire(PlayerPedId()) then
            Items:AddButton("Bruler le joueur", '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
                if onSelected then
                    StartEntityFire(GetPlayerPed(GetPlayerFromServerId(AdminMenu.selectedPlayer.id))) 
                    AdminMenu.selectedPlayer.inFire = true
                end
            end)
        else
            Items:AddButton("~#f16625~Arrêter de le bruler~s~", '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
                if onSelected then
                    StopEntityFire(GetPlayerPed(GetPlayerFromServerId(AdminMenu.selectedPlayer.id))) 
                    AdminMenu.selectedPlayer.inFire = false
                end
            end)
        end

        if IsPedRagdoll(GetPlayerPed(GetPlayerFromServerId(AdminMenu.selectedPlayer.id))) then
            Items:AddButton("~#f16625~Le joueur est par terre...~s~", '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
                if onSelected then
                end
            end)
        else
            Items:AddButton("Faire tomber le joueur", '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
                if onSelected then
                    SetPedToRagdoll(GetPlayerPed(GetPlayerFromServerId(AdminMenu.selectedPlayer.id)), 5000, 5000, 0, false, false, false)
                end
            end)
        end

        Items:AddButton("~#ed1818~Tuer~s~", '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
            if onSelected then
                SetEntityHealth(GetPlayerPed(GetPlayerFromServerId(AdminMenu.selectedPlayer.id)), 0)
            end
        end)
    end
end)

menu_admin_player_teleport:SetItems(function(Items)
    if AdminMenu.selectedPlayer then
        Items:AddSeparator("[" .. AdminMenu.selectedPlayer.id .. "] " .. AdminMenu.selectedPlayer.rpname)

        Items:AddLine({ C.MainColor })

        Items:AddList("Téléportation Rapide", "", AdminMenu.teleportOptions, {}, function (onSelected, onHovered, onListChange, index)
            if onSelected then
                local teleportLocation = C.TeleportOptions[index] 
                
                if IsPedInAnyVehicle(GetPlayerPed(GetPlayerFromServerId(AdminMenu.selectedPlayer.id)), false) then
                    SetPedCoordsKeepVehicle(GetPlayerPed(GetPlayerFromServerId(AdminMenu.selectedPlayer.id)), teleportLocation.coords.x, teleportLocation.coords.y, teleportLocation.coords.z)
                else
                    SetEntityCoords(GetPlayerPed(GetPlayerFromServerId(AdminMenu.selectedPlayer.id)), teleportLocation.coords.x, teleportLocation.coords.y, teleportLocation.coords.z)
                end
            end
        end)

        Items:AddButton("Téléporter sur lui", '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
            if onSelected then
                local playerCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(AdminMenu.selectedPlayer.id)))
                SetEntityCoords(PlayerPedId(), playerCoords.x, playerCoords.y, playerCoords.z)
            end
        end)

        Items:AddButton("Téléporter sur moi", '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
            if onSelected then
                local playerCoords = GetEntityCoords(PlayerPedId())
                SetEntityCoords(GetPlayerPed(GetPlayerFromServerId(AdminMenu.selectedPlayer.id)), playerCoords.x, playerCoords.y, playerCoords.z)
            end
        end)
    end
end)

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

menu_admin_reports:SetItems(function(Items)
    if #AdminMenu.reportsList < 1 then
        Items:AddSeparator("Report(s): ~#f16625~" .. #AdminMenu.reportsList .. "~s~")
        Items:AddSeparator("Report(s) pris: ~#f16625~" .. AdminMenu.reportCount .. "~s~")
        Items:AddLine({ C.MainColor })
        Items:AddSeparator("Aucun report en attente.")
    else
        Items:AddSeparator("Reports: ~#f16625~" .. #AdminMenu.reportsList .. "~s~")
        Items:AddSeparator("Report(s) pris: ~#f16625~" .. AdminMenu.reportCount .. "~s~")
        Items:AddLine({ C.MainColor })
        for playerId, report in ipairs(AdminMenu.reportsList) do
            Items:AddButton("[" .. playerId .. "] " .. report.name, 'Raison: ' .. report.reason, { HoverColor = C.MainColor, RightLabel = '→'}, function(onSelected, onHovered)
                if onSelected then
                    AdminMenu.selectedReport = {report = report, playerId = playerId}
                end
            end, menu_admin_report)
        end
    end
end)

menu_admin_report:SetItems(function(Items)
    if AdminMenu.selectedReport then
        Items:AddSeparator("[" .. AdminMenu.selectedReport.playerId .. "] " .. AdminMenu.selectedReport.report.name)
        Items:AddSeparator("Raison: ~#f16625~" .. AdminMenu.selectedReport.report.reason .. "~s~")
        Items:AddLine({ C.MainColor })
        Items:AddList('Téléportation', '', {"Sur lui", "Sur moi"}, {}, function (onSelected, onHovered, onListChange, index)
            if onSelected then
                local playerPed = GetPlayerPed(GetPlayerFromServerId(AdminMenu.selectedReport.playerId))
                local playerCoords = GetEntityCoords(playerPed)
                if index == 1 then
                    SetEntityCoords(PlayerPedId(), playerCoords.x, playerCoords.y, playerCoords.z)
                elseif index == 2 then
                    SetEntityCoords(playerPed, GetEntityCoords(PlayerPedId()))
                end
            end
        end)
        Items:AddList("Téléportation Rapide", "", AdminMenu.teleportOptions, {}, function (onSelected, onHovered, onListChange, index)
            if onSelected then
                local teleportLocation = C.TeleportOptions[index] 
                
                local playerPed = GetPlayerPed(GetPlayerFromServerId(AdminMenu.selectedReport.playerId))
                
                if IsPedInAnyVehicle(playerPed, false) then
                    SetPedCoordsKeepVehicle(playerPed, teleportLocation.coords.x, teleportLocation.coords.y, teleportLocation.coords.z)
                else
                    SetEntityCoords(playerPed, teleportLocation.coords.x, teleportLocation.coords.y, teleportLocation.coords.z)
                end
            end
        end)
        Items:AddButton("~#ea0606~Supprimer le report~s~", '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
            if onSelected then
                AdminMenu:DeleteReport(AdminMenu.selectedReport.reportId)
            end
        end)
    end
end)

-- rgr