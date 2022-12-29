fx_version 'bodacious'
game 'gta5'

this_is_a_map 'yes'

ui_page "front-end/index.html"

client_scripts {
	'@vrp/lib/utils.lua',
	'@PolyZone/client.lua',
	"client/*.lua",
}

server_scripts {	
	"@vrp/lib/utils.lua",
	"server/*.lua",
}

files {
	"front-end/*.*",
	'front-end/all.min.css',
	'front-end/all.min.js',
	'front-end/sounds/alarm.ogg',
	'front-end/sounds/love.ogg',
	'front-end/sounds/mochila.ogg',
	'front-end/sounds/love2.ogg',
	'front-end/sounds/bong.ogg',
	'front-end/sounds/belt.ogg',
	'front-end/sounds/coins.ogg',
	'front-end/sounds/cuff.ogg',
	'front-end/sounds/heartbeat.ogg',
	'front-end/sounds/jaildoor.ogg',
	'front-end/sounds/lock.ogg',
	'front-end/sounds/saw.ogg',
	'front-end/sounds/jaildoor.ogg',
	'front-end/sounds/message.ogg',
	'front-end/sounds/unbelt.ogg',
	'front-end/sounds/uncuff.ogg',
	'front-end/sounds/enterexithouse.ogg',
	'front-end/sounds/elevator-bell.ogg',
	'front-end/sounds/on.ogg',
	'front-end/sounds/off.ogg',
	'front-end/sounds/ban.ogg'
}
