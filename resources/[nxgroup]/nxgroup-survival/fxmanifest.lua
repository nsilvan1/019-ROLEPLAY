fx_version 'bodacious'
game 'gta5'
     
ui_page "front-end/index.html"

client_scripts {
	'@vrp/lib/utils.lua',
	'@PolyZone/client.lua',
	"survival_cl.lua",
	"car_funcs.lua",

}

server_scripts {
	"@vrp/lib/utils.lua",
	"server.lua"
}

files {
	"front-end/*.*",
}