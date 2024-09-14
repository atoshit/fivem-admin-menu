reportsList = {} 

RegisterCommand("report", function(source, args)
    if source == 0 then
        print("La commande doit être exécutée en jeu")
        return
    end

    local reason = table.concat(args, " ") 

    local report = {
        name = GetPlayerName(source),
        reason = reason 
    }

    reportsList[source] = report
    local playerObj = ESX.GetPlayerFromId(source)
    playerObj.showNotification("Votre report a bien été envoyé")
end)