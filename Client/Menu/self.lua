menu_admin_self = zUI.CreateSubMenu(menu_admin, "", "Options Personnel")

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