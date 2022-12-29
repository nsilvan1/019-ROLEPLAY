shared_script "@ThnAC/natives.lua"
resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page "nui/index.html"

files {
	"nui/*"
}

client_scripts {
	"@vrp/lib/utils.lua",
	"client/*",
	"config.lua"
}

server_scripts {
	"@vrp/lib/utils.lua",
	"server/*"
}

client_script "@ThnAC/stopper.lua"