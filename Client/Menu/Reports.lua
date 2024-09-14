menu_admin_reports = zUI.CreateSubMenu(menu_admin, "", "Gestion des reports")
local menu_admin_report = zUI.CreateSubMenu(menu_admin_reports, "", "Gestion du report(s)")

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
                    AdminMenu.teleportCache[AdminMenu.selectedReport.playerId] = GetEntityCoords(playerPed)
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
        Items:AddButton('Renvoyer à sa position', '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
            if onSelected then
                local returnPosition = AdminMenu.teleportCache[AdminMenu.selectedReport.playerId]
                if returnPosition then
                    SetEntityCoords(GetPlayerPed(GetPlayerFromServerId(AdminMenu.selectedReport.playerId)), returnPosition.x, returnPosition.y, returnPosition.z)
                    AdminMenu.teleportCache[AdminMenu.selectedReport.playerId] = nil
                else
                    print("Aucune position enregistrée")
                end
            end
        end)
        Items:AddButton("~#cf8a0a~Kick~s~", '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
            if onSelected then
                local reason = zUI.KeyboardInput("Raison du kick", nil, "Exemple: Freekill", 30)

                if not reason then return print("Veuiller rentré une raison") end

                TriggerServerEvent('admin:kickPlayer', AdminMenu.selectedReport.playerId, reason)
            end
        end)
        Items:AddButton("~#ea0606~Fermer le report~s~", '', { HoverColor = C.MainColor }, function(onSelected, onHovered)
            if onSelected then
                AdminMenu:DeleteReport(AdminMenu.selectedReport.reportId)
            end
        end)
    end
end)