fx_version "bodacious"
game "gta5" 

author 'Elite Store'
description 'Elite Homes'
version 'v1.5'

lua54 'yes'

escrow_ignore {
	'config.lua',
}


ui_page_preload "yes"

ui_page "nui/index.html"


client_scripts {
	'@vrp/lib/utils.lua',
	'client.lua',
	'config.lua'
}

server_scripts {
	'@vrp/lib/utils.lua',
	'server.lua',
	'config.lua'
}

files {
	"nui/*"
}              