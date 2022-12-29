fx_version 'bodacious'
game 'gta5'

author 'EGGabriel'
contact 'E-mail: ps.eggabriel@gmail.com'
version '2.0.0'

ui_page "nui/index.html"

client_script{
	"@vrp/lib/utils.lua",
	"client.lua",
	"config.lua",
}

server_script {
  "@vrp/lib/utils.lua",
  "server.lua",
  "blips.lua",
  "config.lua",
  "itens.lua",
}

files {
	"nui/index.html",
	"nui/jquery.js",
	"nui/css.css",
}              