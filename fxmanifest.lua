fx_version("cerulean");
game("gta5");
lua54("yes");

author("zSquad");
description("zSquad Administration Menu");

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
    "Client/*.lua",
    "Client/Menu/*.lua"
});

dependencies ({
    'es_extended'
});