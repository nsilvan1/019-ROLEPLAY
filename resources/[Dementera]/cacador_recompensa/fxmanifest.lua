fx_version "adamant"
game "gta5"

lua54 'yes'
ui_page "nui/index.html"
escrow_ignore {
    "config.lua",
    "exports.lua",
}

client_scripts {
    '@vrp/lib/utils.lua', 
    "client.lua",
    "config.lua"
}

server_scripts {
    '@vrp/lib/utils.lua', 
    "server.lua",
    "exports.lua",
    "config.lua"
}

files {
	"nui/*"
}
