reportsList = {} 

RegisterCommand("report", function(source, args)
    if source == 0 then
        print("La commande doit être exécutée en jeu")
        return
    end

    local playerId = source
    local reason = table.concat(args, " ") 

    if reason == "" then
        print("Veuiller entrer une raison")
        return
    end

    if reportsList[playerId] then
        local xPLayer = ESX.GetPlayerFromId(playerId)
        xPLayer.showNotification("Vous avez déjà un report en attente de traitement")
    else
        xPLayer.showNotification("Le report à bien été envoyé")
        local report = {
            name = GetPlayerName(playerId),
            reason = reason 
        }
    
        reportsList[playerId] = report
    end
end)