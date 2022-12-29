shared_script "@ThnAC/natives.lua"

ui_page ""

files {
	"nui/*"
}

client_scripts {
	"@vrp/lib/utils.lua",
	"client/*",
	"config.lua"
}

server_scripts {
	"@vrp/lib/utils.lua",
	"server/*",
}

