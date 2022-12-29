fx_version "bodacious"
game "gta5"

ui_page 'nui/index.html'

client_scripts {
	"@vrp/lib/utils.lua",
	"client.lua",
	"cfg.lua",
}
server_scripts {
	"@vrp/lib/utils.lua",	
	"server.lua",
	"cfg.lua",
}

files {
    'nui/index.html',
    'nui/style.css',
    'nui/script.js',
 
}              