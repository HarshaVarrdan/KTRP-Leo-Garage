fx_version 'bodacious'

games { 'gta5' }

shared_scripts {
    'config.lua',
}

client_scripts {
    "client/c_ped.lua",
    "client/c_menu.lua",
    "client/c_vehicle.lua",
    "client/c_functions.lua",
}
server_scripts {
    'server/s_main.lua',
    '@mysql-async/lib/MySQL.lua',
}

lua54 'yes'