fx_version "bodacious"
game "gta5"

ui_page "web-side/index.html"

client_scripts {
	"@vrp/lib/utils.lua",
	"client-side/*.lua",
	"config-side/*.lua",
}

server_scripts {
	"@vrp/lib/utils.lua",	
	"config-side/*.lua",
	'@vrp/modules/log.lua',
	"server-side/server.lua",
	"server-side/robbery.lua",
}              