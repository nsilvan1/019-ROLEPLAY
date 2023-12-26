fx_version 'adamant'
game 'gta5'

ui_page "web-side/index.html"

client_scripts {
	'@vrp/lib/utils.lua',
	"@nxgroup_inventario/config.lua",
	'config/config.lua',
	'client/*.lua'
}

server_scripts {
	'@vrp/lib/utils.lua',
	"@nxgroup_inventario/config.lua",
	'config/config.lua',
	'server/*.lua'
}

files {
	"web-side/*"
}              