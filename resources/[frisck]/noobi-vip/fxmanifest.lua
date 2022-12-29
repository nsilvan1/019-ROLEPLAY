fx_version 'adamant'
game 'gta5'

author 'Noobi Dev'
contact 'Discord: discord.gg/cgyvmNW'
version '1.0.0'

ui_page 'nui/darkside.html'

client_scripts {
	"@vrp/lib/utils.lua",
	'config.lua',
	"hansolo/*.lua"
}

server_scripts {
	"@vrp/lib/utils.lua",
	'config.lua',
	"skywalker.lua"
}

files {
	'nui/*.html',
	'nui/*.js',
    'nui/*.css',
	'nui/**/*'
}
