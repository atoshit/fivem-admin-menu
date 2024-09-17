C = {}

local OpenMenuKey <const> = 'F9'
local NoclipCommand <const> = 'noclip'
local NoclipKey <const> = 'F10'
local MainColor <const> = '#faad2c' -- https://htmlcolorcodes.com/fr/
local Job2 <const> = false
local MenuBanner <const> = nil -- or 'banner url'

local Logs <const> = {
    Staff = 'https://discord.com/api/webhooks/1283215053734281227/c91BS_PfC-u52Vop_vmP2-WalQegWDQK2plzSz8QVwKfJgni7aj6Ik5kQfNI2SsAlunF'
}

local TeleportOptions <const> = {
    { name = "PDP", coords = vector3(425.1, -979.5, 30.7) },       
    { name = "Hôpital", coords = vector3(339.9, -1394.3, 32.5) },   
    { name = "Parking", coords = vector3(215.8, -810.1, 30.7) },   
}

local ColorOptions <const> = {
    { name = "Rouge", primary = {255, 0, 0}, secondary = {255, 0, 0} },
    { name = "Orange", primary = {255, 115, 0}, secondary = {255, 115, 0} },
    { name = "Vert", primary = {60, 179, 113}, secondary = {60, 179, 113} },
    { name = "Noir", primary = {0, 0, 0}, secondary = {0, 0, 0} },
    { name = "Blanc", primary = {255, 255, 255}, secondary = {255, 255, 255} },
    { name = "Violet", primary = {82, 61, 255}, secondary = {82, 61, 255} },
    { name = "Jaune", primary = {255, 215, 0}, secondary = {255, 215, 0} },
    { name = "Marron", primary = {84, 70, 54}, secondary = {84, 70, 54} },
    { name = "Rose", primary = {238, 130, 238}, secondary = {238, 130, 238} },
    { name = "Bleu", primary = {0, 0, 255}, secondary = {0, 0, 255} },
    { name = "Bleu Clair", primary = {84, 212, 255}, secondary = {84, 212, 255} }
}

local QuickSpawnVehicles <const> = {
    { name = "Blista", model = "blista" },
    { name = "BMX", model = "bmx" },
    { name = "Sanchez", model = "sanchez" }
}

local MultiplierList <const> = {
    { name = "Par défaut", 0.0 },
    { name = "X16", value = 16.0 },
    { name = "X32", value = 32.0 },
    { name = "X64", value = 64.0 },
    { name = "X128", value = 128.0 },
    { name = "X256", value = 256.0 },
    { name = "X1024", value = 1024.0 }
}

local WeatherList <const> = {
    { name = "Soleil", value = "CLEAR" },
    { name = "Nuageux", value = "CLOUDS" },
    { name = "Pluie", value = "RAIN" },
    { name = "Brouillard", value = "FOGGY" },
    { name = "Neige", value = "SNOW" }
}

local TimeOptions <const> = {
    { name = "Matin", value = 6 },
    { name = "Midi", value = 12 },
    { name = "Soir", value = 18 },
    { name = "Nuit", value = 0 }
}

local groupPermissions = {
    ["admin"] = {
        Self = {
            Noclip = true,
            Invincible = true,
            Visible = true,
            InfiniteStamina = true,
            FastSwim = true,
            FastRun = true,
            HighJump = true,
            Heal = true,
            Armor = true,
            Ped = true
        },
    }
}

C.OpenMenuKey = OpenMenuKey
C.NoclipCommand = NoclipCommand
C.NoclipKey = NoclipKey
C.MainColor = MainColor
C.Job2 = Job2
C.MenuBanner = MenuBanner
C.Logs = Logs
C.TeleportOptions = TeleportOptions
C.ColorOptions = ColorOptions
C.QuickSpawnVehicles = QuickSpawnVehicles 
C.MultiplierList = MultiplierList
C.WeatherList = WeatherList
C.TimeOptions = TimeOptions