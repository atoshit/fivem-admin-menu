reportsList = {} 

RegisterCommand("report", function(source, args)
    if source == 0 then
        print("La commande doit être exécutée en jeu")
        return
    end

    local playerId = source
    local reason = table.concat(args, " ") 

    local report = {
        name = GetPlayerName(playerId),
        reason = reason 
    }

    reportsList[playerId] = report
end)