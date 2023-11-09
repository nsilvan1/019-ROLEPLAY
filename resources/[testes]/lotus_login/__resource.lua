resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page_preload "yes"
ui_page "nui/index.html"

client_scripts {
	"@vrp/lib/utils.lua",
	"client.lua",
}

server_scripts {
	"@vrp/lib/utils.lua",
	"server.lua",
}

files {
	"nui/index.html",
	"nui/script.js",
	"nui/images/*.svg",
	"nui/images/*.png",
	"nui/style.css"
}                            