fx_version 'adamant'
game "gta5"

lua54 'yes'

ui_page "interface/index.html"

client_scripts {
	"@vrp/lib/utils.lua",
	"utils/lib.lua*",
	"config/config.lua",
	"client/*"
}

server_scripts {
	"@vrp/lib/utils.lua",
	"utils/lib.lua*",
	"config/config.lua",
	"server/*"
}

files {
	"interface/*",
	"interface/**/*"
}



