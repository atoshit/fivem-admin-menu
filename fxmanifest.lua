--[[
Copyright © 2024 Atoshi

All rights reserved.

This FiveM base, "Outlaws" and all of its associated files, code, and resources are protected by copyright law. Unauthorized reproduction, distribution, or modification of this base, in whole or in part, without the express permission of the copyright holder, is strictly prohibited.

For licensing inquiries or permission requests, please contact:

https://discord.gg/fivedev

Thank you for respecting our intellectual property rights.
]]

fx_version("cerulean");
game("gta5");
lua54("yes");

author("Atoshi");
description("Administration menu using zSquad zUI libs");

ui_page("Client/Libs/zUI/web/build/index.html");

files({
    "Client/Libs/zUI/web/build/index.html",
    "Client/Libs/zUI/web/build/**/*"
});

shared_scripts({
    "@es_extended/imports.lua", 
    "Shared/*.lua"
});

server_scripts({
    "Server/*.lua"
});

client_scripts({
    "Client/Libs/zUI/config.lua",
    "Client/Libs/zUI/functions/*.lua",
    "Client/Libs/zUI/menu.lua",
    "Client/Libs/zUI/menuController.lua",
    "Client/Libs/zUI/utils/*.lua",
    "Client/Libs/zUI/items/*.lua",
    
    "Client/Objects/*.lua",
    "Client/*.lua"
});

dependencies ({
    'es_extended'
});