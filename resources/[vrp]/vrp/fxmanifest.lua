shared_script "lib/lib.lua"

fx_version 'bodacious'
game 'gta5'

ui_page 'gui/index.html'
loadscreen "loading/darkside.html"

server_scripts {
	'lib/utils.lua',
	'base.lua',
	'queue.lua',
	'modules/survival.lua',
	'modules/gui.lua',
	'modules/group.lua',
	'modules/player_state.lua',
	'modules/business.lua',
	'modules/map.lua',
	'modules/money.lua',
	'modules/inventory.lua',
	'modules/log.lua',
	'modules/identity.lua',
	'modules/aptitude.lua',
	'modules/AntiFlood.lua',
}

client_scripts {
	'lib/utils.lua',
	'client/base.lua',
	'client/basic_garage.lua',
	'client/iplloader.lua',
	'client/gui.lua',
	'client/player_state.lua',
	'client/survival.lua',
	'client/map.lua',
	'client/notify.lua',
	'client/identity.lua',
	'client/map.lua',
	'client/police.lua',
	'client/spawn.lua'
}

files {
	"loading/*",
	'lib/Tunnel.lua',
	'lib/Proxy.lua',
	'lib/Luaseq.lua',
	'lib/Tools.lua',
	'gui/index.html',
	'gui/design.css',
	'gui/main.js',
	'gui/Menu.js',
	'gui/WPrompt.js',
	'gui/RequestManager.js',
	'gui/Div.js',
	'gui/dynamic_classes.js',
	'gui/bebas.ttf',
	'gui/Azonix.woff'
}

server_export 'AddPriority'
server_export 'RemovePriority'                                          
client_script 'fivem_client.lua'   