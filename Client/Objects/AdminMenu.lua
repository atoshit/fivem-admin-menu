function CreateMenuObject()
    local self = {}
    
    self.staffMode = false
    self.invincibleMode = false
    self.visibleMode = true
    self.infiniteStamina = false
    self.fastSwim = false
    self.fastRun = false
    self.highJump = false
    self.pedMode = false
    self.pedModel = nil
    self.playersList = {}
    self.filteredPlayersList = {}  
    self.searchInput = ""
    self.selectedPlayer = nil
    self.currentPlayerId = PlayerId()
    self.noclipActive = false
    self.noclipSpeed = 1.0
    self.speedStep = 0.5
    self.teleportOptions = {}
    self.colorOptions = {}
    self.quickSpawnList = {}
    self.MultiplierList = {}
    self.reportsList = {}
    self.selectedReport = nil
    self.reportCount = 0

    return self
end

---@class AdminMenu
AdminMenu = CreateMenuObject()

--- Récupère la liste des reports
function AdminMenu:FetchReportsList()
    ESX.TriggerServerCallback('admin:getReportsList', function(reports)
        self.reportsList = reports
    end)
end

--- Supprime un report
--- @param reportId integer : Index du report à supprimer
function AdminMenu:DeleteReport(reportId)
    self.selectedReport = nil
    TriggerServerEvent('admin:deleteReport', reportId)

    for i, r in ipairs(self.reportsList) do
        if r.id == reportId then
            table.remove(self.reportsList, i)
            break
        end
    end
    
    self.reportCount = self.reportCount + 1
end

--- Récupère la liste des joueurs
function AdminMenu:FetchPlayersList()
    if not self.playersList or #self.playersList == 0 then
        ESX.TriggerServerCallback('admin:getPlayersList', function(players)
            self.playersList = players
        end)
    end
end

--- Init la liste des options de téléportation
function AdminMenu:initTelportOptions()
    for _, teleport in ipairs(C.TeleportOptions) do
        table.insert(self.teleportOptions, teleport.name)
    end
end

--- Init la liste des couleurs
function AdminMenu:initColorOptions()
    for _, color in ipairs(C.ColorOptions) do
        table.insert(self.colorOptions, color.name)
    end
end

--- Init la liste des vehicules rapide
function AdminMenu:initQuickSpawnList()
    for _, vehicle in ipairs(C.QuickSpawnVehicles) do
        table.insert(self.quickSpawnList, vehicle.name)
    end
end

--- Init la liste des multiplicateurs de vitesse
function AdminMenu:initMultiplierList()
    for _, multiplier in ipairs(C.MultiplierList) do
        table.insert(self.MultiplierList, multiplier.name)
    end
end

--- Active/Désactive une fonctionnalité
---@param feature string Nom de la fonctionnalité
---@param isChecked boolean Indique si la fonctionnalité doit être activée ou désactivée
function AdminMenu:ToggleFeature(feature, isChecked)
    self[feature] = isChecked
    if feature == "invincibleMode" then
        SetEntityInvincible(self.currentEntity, isChecked)
    elseif feature == "visibleMode" then
        SetEntityVisible(self.currentEntity, isChecked)
    elseif feature == "infiniteStamina" then
        self:ToggleInfiniteStaminaThread(isChecked)
    elseif feature == "staffMode" and isChecked then
        self:FetchPlayersList()
        self:initTelportOptions()
        self:initColorOptions()
        self:initQuickSpawnList()
        self:initMultiplierList()
    elseif feature == "noclipActive" then
        self:ToggleNoClipMode(isChecked)
    elseif feature == "fastSwim" then
        SetSwimMultiplierForPlayer(self.currentPlayerId, isChecked and 1.49 or 1.0)
    elseif feature == "fastRun" then
        SetRunSprintMultiplierForPlayer(self.currentPlayerId, isChecked and 1.49 or 1.0)
    elseif feature == "highJump" then
        self:ToggleSuperJump()
    end
end

--- Gère le thread de stamina infinie
---@param enable boolean Indique si le thread doit être démarré ou arrêté
function AdminMenu:ToggleInfiniteStaminaThread(enable)
    if enable then
        if not self.infiniteStaminaThread then
            self.infiniteStaminaThread = CreateThread(function()
                while self.infiniteStamina do
                    Wait(1000)
                    RestorePlayerStamina(self.currentPlayerId, 1.0)
                end
                self.infiniteStaminaThread = nil
            end)
        end
    else
        self.infiniteStaminaThread = nil
    end
end

--- Change le modèle du péd
---@param modelName string Nom du modèle du péd à changer
function AdminMenu:ChangePedModel(modelName)
    if modelName and modelName ~= "" then
        local modelHash = GetHashKey(modelName)

        if IsModelInCdimage(modelHash) and IsModelValid(modelHash) then
            RequestModel(modelHash)
            repeat Wait(500) until HasModelLoaded(modelHash)

            SetPlayerModel(PlayerId(), modelHash)
            SetPedAsNoLongerNeeded(self.currentEntity)

            self.pedModel = modelName
            self.pedMode = true
        else
            zUI.AlertInput("Avertissement !", nil, "Le ped est invalide !")
        end
    end
end

--- Réinitialise le modèle du péd du joueur
function AdminMenu:RevertToPlayerModel()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        if not skin then return print("Impossible de récupérer le skin du joueur") end
        
        TriggerEvent('skinchanger:loadDefaultModel', skin.sex == 0, function()
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
                TriggerEvent('esx:restoreLoadout')
                self.pedMode = false
                self.pedModel = nil
                self.currentEntity = PlayerPedId()
            end)
        end)
    end)
end

--- Donne de l'armure au joueur
---@param amount number Quantité d'armure à ajouter
function AdminMenu:GiveArmor(amount)
    local currentArmor = GetPedArmour(self.currentEntity)
    SetPedArmour(self.currentEntity, math.min(currentArmor + amount, 100))
end

--- Soigne le joueur
function AdminMenu:Heal()
    SetEntityHealth(self.currentEntity, GetEntityMaxHealth(self.currentEntity))
end

--- Calcule la direction de la caméra
function AdminMenu:GetCamDirection()
    local rot = GetGameplayCamRot(2)
    local pitch, yaw = math.rad(rot.x), math.rad(rot.z)
    return vector3(-math.sin(yaw) * math.cos(pitch), math.cos(yaw) * math.cos(pitch), math.sin(pitch))
end

--- Trouve le sol ou le toit à partir des coordonnées
---@param coords vector3 Coordonnées de départ
function AdminMenu:FindGroundOrRoof(coords)
    local _, hit, endCoords = GetShapeTestResult(StartShapeTestRay(coords.x, coords.y, coords.z + 1.0, coords.x, coords.y, coords.z - 1000.0, 1, PlayerPedId(), 0))
    return hit and endCoords or coords
end

--- Gère le mode noclip
---@param enable boolean Indique si le mode noclip doit être activé ou désactivé
function AdminMenu:ToggleNoClipMode(enable)
    local ped = PlayerPedId()
    local pedCoords = GetEntityCoords(ped, true)
    local inVehicle = IsPedInAnyVehicle(ped, false)
    local entity = inVehicle and GetVehiclePedIsIn(ped, false) or ped
    
    if enable then
        SetEntityInvincible(entity, true)
        SetEntityVisible(entity, true, false)
        SetEntityAlpha(entity, 150, false)
        SetEntityCollision(entity, false, false)
        FreezeEntityPosition(entity, true)

        if inVehicle then
            SetEntityAlpha(entity, 150, false)
            SetEntityLocallyInvisible(entity)
        end
    else
        local coords = self:FindGroundOrRoof(inVehicle and GetEntityCoords(entity, true) or pedCoords)
        SetEntityCoordsNoOffset(entity, coords, true, true, true)
        ResetEntityAlpha(entity)
        SetEntityInvincible(entity, false)
        SetEntityVisible(entity, true, false)
        SetEntityCollision(entity, true, true)
        FreezeEntityPosition(entity, false)

        if inVehicle then
            SetEntityLocallyVisible(entity)
        end
    end

    CreateThread(function()
        while self.noclipActive do
            local forward = self:GetCamDirection()
            local entityCoords = GetEntityCoords(entity, true)

            if IsControlJustPressed(0, 14) then 
                self.noclipSpeed = math.max(self.noclipSpeed - self.speedStep, 0.1)
            elseif IsControlJustPressed(0, 15) then 
                self.noclipSpeed = self.noclipSpeed + self.speedStep 
            end

            local move = vector3(0, 0, 0)
            if IsControlPressed(0, 32) then move = forward end
            if IsControlPressed(0, 33) then move = -forward end

            if IsControlPressed(0, 34) then
                SetEntityHeading(entity, GetEntityHeading(entity) + 2.0)
            elseif IsControlPressed(0, 9) then
                SetEntityHeading(entity, GetEntityHeading(entity) - 2.0)
            end

            if move ~= vector3(0, 0, 0) then
                SetEntityCoordsNoOffset(entity, entityCoords + move * self.noclipSpeed, true, true, true)
            end

            Wait(0)
        end
    end)
end

--- Faire apparaitre un véhicuke à une position
---@param modelName string : Modèle du véhicule
---@param coords vector3 : Coordonnées du véhicule
---@param heading heading : Sens de l'apparition du véhicule
function AdminMenu:SpawnVehicle(modelName, coords, heading)
    if modelName and modelName ~= "" then
        local modelHash = GetHashKey(modelName)

        if IsModelInCdimage(modelHash) and IsModelValid(modelHash) then
            RequestModel(modelHash)
            repeat Wait(500) until HasModelLoaded(modelHash)

            return CreateVehicle(modelHash, coords.x, coords.y, coords.z, heading, true, false)
        else
            zUI.AlertInput("Avertissement !", nil, "Le véhicule est invalide !")
        end
    end
end

--- Active le super saut
function AdminMenu:ToggleSuperJump()
    CreateThread(function()
        while self.highJump do
            Wait(0)
            SetSuperJumpThisFrame(self.currentPlayerId) -- Active le super saut lorsque le joueur saute
        end
    end)
end