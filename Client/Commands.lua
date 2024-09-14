RegisterCommand(C.NoclipCommand, function(source, args, raw)
    local playerData = ESX.GetPlayerData()

    if playerData['group'] ~= 'user' then
        if AdminMenu.staffMode then
            AdminMenu.noclipActive = not AdminMenu.noclipActive
            AdminMenu:ToggleFeature('noclipActive', AdminMenu.noclipActive)
        else
            zUI.AlertInput("Avertissement !", nil, "Merci de ne pas utiliser le noclip quand votre mode staff n'est pas activé.")
        end
    end
end)

RegisterKeyMapping(C.NoclipCommand, "Activer/Desactiver le NoClip", "keyboard", C.NoclipKey);

RegisterCommand('admin:menu', function()
    ESX.TriggerServerCallback('admin:checkPermissions', function(isStaff)
        if isStaff then
            AdminMenu:FetchReportsList()
            menu_admin:SetVisible(not menu_admin:IsVisible())
        end  
    end)
end)

RegisterKeyMapping('admin:menu', 'Menu Administration', 'keyboard', 'F9')