--[[
Copyright © 2024 Atoshi

All rights reserved.

This FiveM base, "Outlaws" and all of its associated files, code, and resources are protected by copyright law. Unauthorized reproduction, distribution, or modification of this base, in whole or in part, without the express permission of the copyright holder, is strictly prohibited.

For licensing inquiries or permission requests, please contact:

https://discord.gg/fivedev

Thank you for respecting our intellectual property rights.
]]

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
            menu_admin:SetVisible(not menu_admin:IsVisible())
        end  
    end)
end)

RegisterKeyMapping('admin:menu', 'Menu Administration', 'keyboard', 'F9')