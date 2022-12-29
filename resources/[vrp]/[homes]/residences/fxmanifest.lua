shared_script "@vrp/lib/lib.lua" --Para remover esta pendencia de todos scripts, execute no console o comando "uninstall"


fx_version "bodacious"
game "gta5"


client_scripts {
	"@vrp/lib/utils.lua",
	"client-side/*.lua",
	"config-side/*.lua",
}

server_scripts {
	"@vrp/lib/utils.lua",
	"config-side/*.lua",
	"server-side/prepares.lua",
	"server-side/server.lua",
	"server-side/wayHomes.lua",
	"server-side/robbery.lua",
}              