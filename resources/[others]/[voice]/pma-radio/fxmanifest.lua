games { 'gta5' }

fx_version 'adamant'
author 'AvarianKnight / Dom Ressler#3102'
description 'pma-voice editado por Dom Ressler#3102'


ui_page 'html/ui.html'
files {
	'html/ui.html',
	'html/gurgle.png',
	'html/pricedown.ttf',
	'html/cursor.png',
	'html/background.png',
	'html/backgroundwhite.png',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js'
}

client_scripts {
	'@vrp/lib/Utils.lua',
	'client/main.lua'
}

server_scripts {
    '@vrp/lib/Utils.lua',
	'server.lua'
}              