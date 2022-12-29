fx_version 'adamant'
game {'gta5'}

client_scripts {
	"@vrp/lib/utils.lua",
	"client.lua"
}

files {
	"front-end/*",
	"front-end/**/*",
	"front-end/**/**/*",
}

ui_page {
	"front-end/index.html"
}


exports {
    'showHud'
}                            