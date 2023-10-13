fx_version "bodacious"
game "gta5"

ui_page_preload "yes"
ui_page "character-nui/index.html"

client_scripts {
	"@vrp/lib/utils.lua",
	"client/*"
}

server_scripts {
	"@vrp/lib/utils.lua",
	"server.lua"
}

files {
	"character-nui/*",
	"character-nui/**/*"
}