menu_admin = zUI.CreateMenu("", "Menu Administration", nil, nil, C.MenuBanner)

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
        Items:AddButton("Gestion du temps", "", { RightLabel = '→', LeftBadge = "NEW_STAR", HoverColor = C.MainColor }, nil, menu_admin_server)
    end
end)

