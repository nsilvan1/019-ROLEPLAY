shared_script "@ThnAC/natives.lua"
fx_version 'bodacious'
game 'gta5'
--#-------------------------------#--
--#--------[ CLIENT SIDE ]--------#--
client_scripts {
	'@vrp/lib/utils.lua',
	'/maconha/client.lua',
	'/cocaina/client.lua',
	'/lavagem/client.lua',

	'/meta/client.lua'
}
--#-------------------------------#--

--#-------------------------------#--
--#--------[ SERVER SIDE ]--------#--
server_scripts {
	'@vrp/lib/utils.lua',
	'/maconha/server.lua',
	'/cocaina/server.lua',
	'/lavagem/server.lua',

	'/meta/server.lua'
}
--#-------------------------------#--