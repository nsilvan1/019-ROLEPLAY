shared_script "@ThnAC/natives.lua"
fx_version 'bodacious'
game 'gta5'

ui_page '/taxis/html/ui.html'

files {
	"nui/ui.html",
	"nui/ui.js",
	"nui/ui.css"
}  

client_scripts {
	'@vrp/lib/utils.lua',
	'/lixeiro/client.lua',
	'/mecanico/client.lua',
	'/minerador/client.lua',
	'/motorista/client.lua',
	'/taxis/client.lua',
	'/taxista/client.lua',
	'/hospital/client.lua',
	'/farms/client.lua',
	'/legacyfuel/config.lua',
	'/legacyfuel/client.lua',
	'/realista/config.lua',
	'/realista/client.lua',
	'/login/client.lua',
	-- '/lux_vehcontrol/client.lua',
	-- '/animacoes/client.lua',
	'/leiteirocoleta/client.lua',
	'/leiteiroentrega/client.lua',
	'/lenhador/client.lua',
	'/pescador/client.lua',
	'/desmanche_itens/client.lua',
	'/emp_paramedico/client.lua',
	'/emprego_colheita/client.lua'
	

}

server_scripts {
	'@vrp/lib/utils.lua',
	'/lixeiro/server.lua',
	'/mecanico/server.lua',
	'/minerador/server.lua',
	'/motorista/server.lua',
	'/taxis/server.lua',
	'/taxista/server.lua',
	'/hospital/server.lua',
	'/farms/server.lua',
	'/legacyfuel/server.lua',
	'/realista/config.lua',
	-- '/lux_vehcontrol/server.lua',
	-- '/animacoes/server.lua',
	'/leiteirocoleta/server.lua',
	'/leiteiroentrega/server.lua',
	'/lenhador/server.lua',
	'/pescador/server.lua',
	'/desmanche_itens/server.lua',
	'/emp_paramedico/server.lua',
	'/emprego_colheita/server.lua'
}