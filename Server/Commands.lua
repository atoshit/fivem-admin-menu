reportsList = {} 

RegisterCommand("report", function(source, args)
    if source == 0 then
        print("La commande doit être exécutée en jeu")
        return
    end

    local reason = table.concat(args, " ")
    local playerObj = ESX.GetPlayerFromId(source)

    if not reason or reason == "" then
        playerObj.showNotification("Merci de spécifier une raison")
        return
    end

    local report = {
        name = GetPlayerName(source),
        reason = reason
    }

    if reportsList[source] then
        playerObj.showNotification("Vous avez déjà un report en cours de traitement.")
    else
        reportsList[source] = report
        local playerObj = ESX.GetPlayerFromId(source)
        playerObj.showNotification("Votre report à bien été envoyé !")
        TriggerEvent("admin:sendAdminNotification")
    end
end)