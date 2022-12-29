-- shared_script "@vrp/lib/lib.lua" --Para remover esta pendencia de todos scripts, execute no console o comando "uninstall"

fx_version 'adamant'
games { 'gta5' }

lua54 'yes'

shared_scripts { '@vrp/lib/utils.lua', 'config.lua' }
client_scripts { 'client.lua' }
server_scripts { 'server.lua' }

ui_page 'web/index.html'

files { 'web/**/*' }