fx_version 'cerulean'
games { 'gta5' }

client_scripts {
	'@vrp/lib/utils.lua',
	'src/client/garage_set.lua',

	'src/client/client.lua',
}

server_scripts {
	'@vrp/lib/utils.lua',
	'src/server/server.lua'
}

shared_script 'cfg/config.lua'

files {
	'html/**'
}

ui_page 'html/index.html'              