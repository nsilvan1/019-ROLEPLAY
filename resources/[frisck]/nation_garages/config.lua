local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

config = {}
Proxy.addInterface("nation_garages", config)

----------------------------------------------
----------------- CONFIG ---------------------
----------------------------------------------
config.detido = 30 -- taxa para ser paga quando o veiculo for detido (porcentagem do valor do veiculo)
config.seguradora = 20 -- taxa para ser paga quando o veiculo estiver apreendido (porcentagem do valor do veiculo)
config.use_tryFullPayment = true -- quando true, aceita pagamentos de taxas com o dinheiro do banco
config.dv_permission = "dv.permissao" -- permissao para dv
config.guardar_veiculo_proximo = true -- mostrar botão de guardar veículo próximo
config.server_side_check = true -- checa se o veículo já foi retirado da garagem pelo player via server-side (o player não conseguirá retirar o veículo até guardá-lo novamente / DV)
----------------------------------------------
----------------- MARKERS --------------------
----------------------------------------------
--- TIPOS DE MARKERS (DEFINIDO NO ATRIBUTO MARKER DE CADA GARAGEM)
config.markers = {
	["avião"] = 33,
	["helicóptero"] = 34,
	["barco"] = 35,
	["carro"] = 36,
	["moto"] = 37,
	["bicicleta"] = 38,
	["truck"] = 39,
}

config.drawMarker = function(coords,marker) -- funcao para desenhar os markers das garagens no chão
	local idTop = config.markers[marker] or config.markers["carro"] 
	local idBase = 27
	DrawMarker(idTop,coords,0,0,0,0,0,0,1.0,1.0,1.0,255, 255, 255,100,1,1,0,0)
end

----------------------------------------------
----------------- BLIPS ----------------------
----------------------------------------------

config.showBlips = false -- quando true, mostra os blips das garagens públicas no mapa
config.blipId = 357 -- id do blip
config.blipColor = 3 -- cor do blip
config.blipSize = 0.4 -- tamanho do blip

----------------------------------------------
-------- DELETAR VEICULOS INATIVOS -----------
----------------------------------------------

config.reset = false -- quando true, deleta os veículos que estão parados durante um determinado tempo
config.tempoReset = 800 -- tempo para deletar um veículo inativo (em minutos)

----------------------------------------------
----------------- IMAGENS --------------------
----------------------------------------------

config.defaultImg = "https://svgsilh.com/svg/160895.svg" -- imagem default
config.imgDir = "http://189.1.172.114/images/" -- url ou diretorio das imagens
----------------------------------------------
----------- LISTA DE VEÍCULOS ----------------
----------------------------------------------
config.vehList = {

	{ hash = -2122757008, name = 'stunt', price = 45000, banido = false, modelo = 'stunt', capacidade = 350, tipo = 'avioes' },
	{ hash = 1032823388, name = 'ninef', price = 80000, banido = false, modelo = 'ninef', capacidade = 15, tipo = 'outros' },
	{ hash = 1545394406, name = 'argiu', price = 150000, banido = false, modelo = 'argiu', capacidade = 15, tipo = 'outros' },
	{ hash = -1706603682, name = 'avisa', price = 40000, banido = false, modelo = 'avisa', capacidade = 50, tipo = 'barcos' },
	{ hash = 710198397, name = 'supervolito', price = 52000, banido = false, modelo = 'supervolito', capacidade = 20, tipo = 'helicopteros' },
	{ hash = 1044193113, name = 'thrax', price = 80000, banido = false, modelo = 'thrax', capacidade = 75, tipo = 'carros' },
	{ hash = -1637149482, name = 'armytrailer2', price = 40000, banido = false, modelo = 'armytrailer2', capacidade = 15, tipo = 'outros' },
	{ hash = 736902334, name = 'buffalo2', price = 25000, banido = false, modelo = 'buffalo2', capacidade = 15, tipo = 'outros' },
	{ hash = -1205689942, name = 'riot', price = 40000, banido = false, modelo = 'riot', capacidade = 15, tipo = 'outros' },
	{ hash = -1461482751, name = 'ninef2', price = 80000, banido = false, modelo = 'ninef2', capacidade = 15, tipo = 'outros' },
	{ hash = -48031959, name = 'blazer2', price = 12000, banido = false, modelo = 'blazer2', capacidade = 75, tipo = 'carros' },
	{ hash = -1297672541, name = 'jester', price = 80000, banido = false, modelo = 'jester', capacidade = 15, tipo = 'outros' },
	{ hash = -344943009, name = 'blista', price = 35000, banido = false, modelo = 'blista', capacidade = 15, tipo = 'outros' },
	{ hash = -1809822327, name = 'asea', price = 35000, banido = false, modelo = 'asea', capacidade = 15, tipo = 'outros' },
	{ hash = -2033222435, name = 'tornado4', price = 25000, banido = false, modelo = 'tornado4', capacidade = 15, tipo = 'outros' },
	{ hash = -1807623979, name = 'asea2', price = 35000, banido = false, modelo = 'asea2', capacidade = 15, tipo = 'outros' },
	{ hash = 1518697981, name = 'fj402', price = 50000, banido = false, modelo = 'fj402', capacidade = 250, tipo = 'utilitario' },
	{ hash = -1207431159, name = 'armytanker', price = 40000, banido = false, modelo = 'armytanker', capacidade = 15, tipo = 'outros' },
	{ hash = 630371791, name = 'barracks3', price = 40000, banido = false, modelo = 'barracks3', capacidade = 15, tipo = 'outros' },
	{ hash = 838982985, name = 'z190', price = 130000, banido = false, modelo = 'z190', capacidade = 15, tipo = 'outros' },
	{ hash = 1578851380, name = 'mazdarx72', price = 25000, banido = false, modelo = 'mazdarx72', capacidade = 15, tipo = 'outros' },
	{ hash = 1682114128, name = 'dilettante2', price = 35000, banido = false, modelo = 'dilettante2', capacidade = 15, tipo = 'outros' },
	{ hash = 298565713, name = 'verus', price = 12000, banido = false, modelo = 'verus', capacidade = 75, tipo = 'carros' },
	{ hash = 223240013, name = 'cheetah2', price = 150000, banido = false, modelo = 'cheetah2', capacidade = 15, tipo = 'outros' },
	{ hash = 1239571361, name = 'issi6', price = 52000, banido = false, modelo = 'issi6', capacidade = 15, tipo = 'outros' },
	{ hash = 8880015, name = 'rmodcharger69', price = 150000, banido = false, modelo = 'rmodcharger69', capacidade = 15, tipo = 'outros' },
	{ hash = 330661258, name = 'cogcabrio', price = 35000, banido = false, modelo = 'cogcabrio', capacidade = 15, tipo = 'outros' },
	{ hash = 408192225, name = 'turismor', price = 35000, banido = false, modelo = 'turismor', capacidade = 75, tipo = 'carros' },
	{ hash = -410205223, name = 'revolter', price = 150000, banido = false, modelo = 'revolter', capacidade = 15, tipo = 'outros' },
	{ hash = -713569950, name = 'bus', price = 25000, banido = false, modelo = 'bus', capacidade = 15, tipo = 'outros' },
	{ hash = 524108981, name = 'boattrailer', price = 40000, banido = false, modelo = 'boattrailer', capacidade = 15, tipo = 'outros' },
	{ hash = 1353720154, name = 'flatbed', price = 25000, banido = false, modelo = 'flatbed', capacidade = 15, tipo = 'outros' },
	{ hash = 1289935896, name = 'pistaspider19', price = 150000, banido = false, modelo = 'pistaspider19', capacidade = 15, tipo = 'outros' },
	{ hash = 1171614426, name = 'ambulance', price = 40000, banido = false, modelo = 'ambulance', capacidade = 15, tipo = 'outros' },
	{ hash = -304802106, name = 'buffalo', price = 25000, banido = false, modelo = 'buffalo', capacidade = 15, tipo = 'outros' },
	{ hash = -1476447243, name = 'armytrailer', price = 40000, banido = false, modelo = 'armytrailer', capacidade = 15, tipo = 'outros' },
	{ hash = -708627469, name = 'astonmartinvantage', price = 50000, banido = false, modelo = 'astonmartinvantage', capacidade = 15, tipo = 'outros' },
	{ hash = 2053223216, name = 'benson', price = 25000, banido = false, modelo = 'benson', capacidade = 300, tipo = 'serviço' },
	{ hash = 1656094088, name = 'huracan', price = 35000, banido = false, modelo = 'huracan', capacidade = 15, tipo = 'outros' },
	{ hash = -1868138629, name = 'Wrsxr', price = 20000, banido = false, modelo = 'Wrsxr', capacidade = 15, tipo = 'outros' },
	{ hash = -1720318470, name = 'blazer31', price = 35000, banido = false, modelo = 'blazer31', capacidade = 15, tipo = 'outros' },
	{ hash = 1995020435, name = 'celta', price = 30000, banido = false, modelo = 'celta', capacidade = 250, tipo = 'utilitario' },
	{ hash = -777275802, name = 'freighttrailer', price = 40000, banido = false, modelo = 'freighttrailer', capacidade = 15, tipo = 'outros' },
	{ hash = -1815156177, name = 'titan60', price = 12000, banido = false, modelo = 'titan60', capacidade = 20, tipo = 'motos' },
	{ hash = -81417329, name = 's3sedan', price = 35000, banido = false, modelo = 's3sedan', capacidade = 15, tipo = 'outros' },
	{ hash = -1696146015, name = 'bullet', price = 150000, banido = false, modelo = 'bullet', capacidade = 75, tipo = 'carros' },
	{ hash = -233098306, name = 'boxville2', price = 25000, banido = false, modelo = 'boxville2', capacidade = 250, tipo = 'utilitario' },
	{ hash = -2072933068, name = 'coach', price = 25000, banido = false, modelo = 'coach', capacidade = 15, tipo = 'outros' },
	{ hash = -114291515, name = 'bati', price = 20000, banido = false, modelo = 'bati', capacidade = 20, tipo = 'motos' },
	{ hash = -2128233223, name = 'blazer', price = 12000, banido = false, modelo = 'blazer', capacidade = 75, tipo = 'carros' },
	{ hash = -602287871, name = 'btype3', price = 70000, banido = false, modelo = 'btype3', capacidade = 15, tipo = 'outros' },
	{ hash = 1723137093, name = 'stratum', price = 35000, banido = false, modelo = 'stratum', capacidade = 15, tipo = 'outros' },
	{ hash = 833469436, name = 'slamvan2', price = 25000, banido = false, modelo = 'slamvan2', capacidade = 15, tipo = 'outros' },
	{ hash = 1283517198, name = 'airbus', price = 25000, banido = false, modelo = 'airbus', capacidade = 15, tipo = 'outros' },
	{ hash = -142942670, name = 'massacro', price = 35000, banido = false, modelo = 'massacro', capacidade = 15, tipo = 'outros' },
	{ hash = -644710429, name = 'cuban800', price = 45000, banido = false, modelo = 'cuban800', capacidade = 350, tipo = 'avioes' },
	{ hash = -1786460813, name = 'zr3806str', price = 150000, banido = false, modelo = 'zr3806str', capacidade = 15, tipo = 'outros' },
	{ hash = 908897389, name = 'toro2', price = 40000, banido = false, modelo = 'toro2', capacidade = 50, tipo = 'barcos' },
	{ hash = 1402002136, name = 'bm422pxx2ncs', price = 25000, banido = false, modelo = 'bm422pxx2ncs', capacidade = 15, tipo = 'outros' },
	{ hash = 1594199585, name = 'BMWm5e3495', price = 35000, banido = false, modelo = 'BMWm5e3495', capacidade = 15, tipo = 'outros' },
	{ hash = 563512346, name = 'HyundSon2016', price = 35000, banido = false, modelo = 'HyundSon2016', capacidade = 15, tipo = 'outros' },
	{ hash = 893081117, name = 'burrito4', price = 22000, banido = false, modelo = 'burrito4', capacidade = 250, tipo = 'utilitario' },
	{ hash = -1829436850, name = 'Novak', price = 50000, banido = false, modelo = 'Novak', capacidade = 15, tipo = 'outros' },
	{ hash = 1956216962, name = 'tanker2', price = 40000, banido = false, modelo = 'tanker2', capacidade = 15, tipo = 'outros' },
	{ hash = -1903012613, name = 'asterope', price = 35000, banido = false, modelo = 'asterope', capacidade = 15, tipo = 'outros' },
	{ hash = 75131841, name = 'glendale', price = 100000, banido = false, modelo = 'glendale', capacidade = 15, tipo = 'outros' },
	{ hash = 1560980623, name = 'airtug', price = 15000, banido = false, modelo = 'airtug', capacidade = 15, tipo = 'outros' },
	{ hash = -1349095620, name = 'caracara2', price = 50000, banido = false, modelo = 'caracara2', capacidade = 75, tipo = 'carros' },
	{ hash = -823509173, name = 'barracks', price = 40000, banido = false, modelo = 'barracks', capacidade = 15, tipo = 'outros' },
	{ hash = -1543762099, name = 'gresley', price = 50000, banido = false, modelo = 'gresley', capacidade = 15, tipo = 'outros' },
	{ hash = 444583674, name = 'handler', price = 25000, banido = false, modelo = 'handler', capacidade = 15, tipo = 'outros' },
	{ hash = 2006918058, name = 'cavalcade', price = 50000, banido = false, modelo = 'cavalcade', capacidade = 15, tipo = 'outros' },
	{ hash = -442313018, name = 'towtruck2', price = 25000, banido = false, modelo = 'towtruck2', capacidade = 15, tipo = 'outros' },
	{ hash = 1074326203, name = 'barracks2', price = 40000, banido = false, modelo = 'barracks2', capacidade = 15, tipo = 'outros' },
	{ hash = 627094268, name = 'romero', price = 35000, banido = false, modelo = 'romero', capacidade = 15, tipo = 'outros' },
	{ hash = -159126838, name = 'innovation', price = 12000, banido = false, modelo = 'innovation', capacidade = 20, tipo = 'motos' },
	{ hash = 850565707, name = 'bjxl', price = 50000, banido = false, modelo = 'bjxl', capacidade = 15, tipo = 'outros' },
	{ hash = -1829296829, name = 'ChevImpala1967', price = 150000, banido = false, modelo = 'ChevImpala1967', capacidade = 15, tipo = 'outros' },
	{ hash = -808831384, name = 'baller', price = 50000, banido = false, modelo = 'baller', capacidade = 15, tipo = 'outros' },
	{ hash = -304857564, name = 'ghispo2', price = 25000, banido = false, modelo = 'ghispo2', capacidade = 15, tipo = 'outros' },
	{ hash = -1622444098, name = 'voltic', price = 80000, banido = false, modelo = 'voltic', capacidade = 75, tipo = 'carros' },
	{ hash = -119658072, name = 'pony', price = 22000, banido = false, modelo = 'pony', capacidade = 250, tipo = 'utilitario' },
	{ hash = 323027250, name = 'm5speed', price = 35000, banido = false, modelo = 'm5speed', capacidade = 15, tipo = 'outros' },
	{ hash = 142944341, name = 'baller2', price = 50000, banido = false, modelo = 'baller2', capacidade = 15, tipo = 'outros' },
	{ hash = -1834414294, name = '750li', price = 80000, banido = false, modelo = '750li', capacidade = 15, tipo = 'outros' },
	{ hash = 1024412756, name = 'fibr2', price = 35000, banido = false, modelo = 'fibr2', capacidade = 15, tipo = 'outros' },
	{ hash = -884690486, name = 'docktug', price = 15000, banido = false, modelo = 'docktug', capacidade = 15, tipo = 'outros' },
	{ hash = -576293386, name = 'qrv', price = 35000, banido = false, modelo = 'qrv', capacidade = 15, tipo = 'outros' },
	{ hash = -1041692462, name = 'banshee', price = 150000, banido = false, modelo = 'banshee', capacidade = 15, tipo = 'outros' },
	{ hash = 368211810, name = 'cargoplane', price = 45000, banido = false, modelo = 'cargoplane', capacidade = 350, tipo = 'avioes' },
	{ hash = -210308634, name = 'winky', price = 50000, banido = false, modelo = 'winky', capacidade = 75, tipo = 'carros' },
	{ hash = -305727417, name = 'brickade', price = 40000, banido = false, modelo = 'brickade', capacidade = 15, tipo = 'outros' },
	{ hash = 1861786828, name = 'longfin', price = 40000, banido = false, modelo = 'longfin', capacidade = 50, tipo = 'barcos' },
	{ hash = -89291282, name = 'felon2', price = 35000, banido = false, modelo = 'felon2', capacidade = 15, tipo = 'outros' },
	{ hash = 1126868326, name = 'bfinjection', price = 50000, banido = false, modelo = 'bfinjection', capacidade = 75, tipo = 'carros' },
	{ hash = 433954513, name = 'nightshark', price = 50000, banido = false, modelo = 'nightshark', capacidade = 75, tipo = 'carros' },
	{ hash = 850991848, name = 'biff', price = 40000, banido = false, modelo = 'biff', capacidade = 300, tipo = 'serviço' },
	{ hash = -1298373790, name = 'subwrx', price = 35000, banido = false, modelo = 'subwrx', capacidade = 15, tipo = 'outros' },
	{ hash = 989294410, name = 'voltic2', price = 80000, banido = false, modelo = 'voltic2', capacidade = 75, tipo = 'carros' },
	{ hash = -1269889662, name = 'blazer3', price = 12000, banido = false, modelo = 'blazer3', capacidade = 75, tipo = 'carros' },
	{ hash = 1077420264, name = 'velum2', price = 45000, banido = false, modelo = 'velum2', capacidade = 350, tipo = 'avioes' },
	{ hash = -907477130, name = 'burrito2', price = 22000, banido = false, modelo = 'burrito2', capacidade = 250, tipo = 'utilitario' },
	{ hash = -212993243, name = 'barrage', price = 150000, banido = false, modelo = 'barrage', capacidade = 15, tipo = 'outros' },
	{ hash = -16948145, name = 'bison', price = 25000, banido = false, modelo = 'bison', capacidade = 250, tipo = 'utilitario' },
	{ hash = 1239252145, name = 'rrvelarpolicia', price = 50000, banido = false, modelo = 'rrvelarpolicia', capacidade = 15, tipo = 'outros' },
	{ hash = 2072156101, name = 'bison2', price = 25000, banido = false, modelo = 'bison2', capacidade = 250, tipo = 'utilitario' },
	{ hash = 1739845664, name = 'bison3', price = 25000, banido = false, modelo = 'bison3', capacidade = 250, tipo = 'utilitario' },
	{ hash = -376434238, name = 'tyrant', price = 35000, banido = false, modelo = 'tyrant', capacidade = 75, tipo = 'carros' },
	{ hash = -537896628, name = 'caddy2', price = 10000, banido = false, modelo = 'caddy2', capacidade = 15, tipo = 'outros' },
	{ hash = 1147287684, name = 'caddy', price = 10000, banido = false, modelo = 'caddy', capacidade = 15, tipo = 'outros' },
	{ hash = -789894171, name = 'cavalcade2', price = 50000, banido = false, modelo = 'cavalcade2', capacidade = 15, tipo = 'outros' },
	{ hash = -1987130134, name = 'boxville', price = 25000, banido = false, modelo = 'boxville', capacidade = 250, tipo = 'utilitario' },
	{ hash = 1221512915, name = 'seminole', price = 50000, banido = false, modelo = 'seminole', capacidade = 15, tipo = 'outros' },
	{ hash = 121658888, name = 'boxville3', price = 25000, banido = false, modelo = 'boxville3', capacidade = 250, tipo = 'utilitario' },
	{ hash = 1069929536, name = 'bobcatxl', price = 50000, banido = false, modelo = 'bobcatxl', capacidade = 250, tipo = 'utilitario' },
	{ hash = -1045541610, name = 'comet2', price = 150000, banido = false, modelo = 'comet2', capacidade = 15, tipo = 'outros' },
	{ hash = -1313740730, name = 'm2', price = 25000, banido = false, modelo = 'm2', capacidade = 15, tipo = 'outros' },
	{ hash = -1435919434, name = 'bodhi2', price = 50000, banido = false, modelo = 'bodhi2', capacidade = 75, tipo = 'carros' },
	{ hash = -682211828, name = 'buccaneer', price = 150000, banido = false, modelo = 'buccaneer', capacidade = 15, tipo = 'outros' },
	{ hash = -613725916, name = 'blimp2', price = 52000, banido = false, modelo = 'blimp2', capacidade = 350, tipo = 'avioes' },
	{ hash = -217995216, name = 'amggtc', price = 80000, banido = false, modelo = 'amggtc', capacidade = 15, tipo = 'outros' },
	{ hash = 1886712733, name = 'bulldozer', price = 40000, banido = false, modelo = 'bulldozer', capacidade = 15, tipo = 'outros' },
	{ hash = 387748548, name = 'hauler2', price = 40000, banido = false, modelo = 'hauler2', capacidade = 300, tipo = 'serviço' },
	{ hash = -1242608589, name = 'vigilante', price = 35000, banido = false, modelo = 'vigilante', capacidade = 75, tipo = 'carros' },
	{ hash = -498528574, name = 'rmodspeed', price = 35000, banido = false, modelo = 'rmodspeed', capacidade = 75, tipo = 'carros' },
	{ hash = -150975354, name = 'blimp', price = 52000, banido = false, modelo = 'blimp', capacidade = 350, tipo = 'avioes' },
	{ hash = -767865503, name = 'yFeF12T', price = 80000, banido = false, modelo = 'yFeF12T', capacidade = 15, tipo = 'outros' },
	{ hash = -1407312245, name = 'gtrp', price = 100000, banido = false, modelo = 'gtrp', capacidade = 15, tipo = 'outros' },
	{ hash = -1403128555, name = 'zentorno', price = 35000, banido = false, modelo = 'zentorno', capacidade = 75, tipo = 'carros' },
	{ hash = -1346687836, name = 'burrito', price = 22000, banido = false, modelo = 'burrito', capacidade = 250, tipo = 'utilitario' },
	{ hash = 681304370, name = 'bmwr1250rocam', price = 12000, banido = false, modelo = 'bmwr1250rocam', capacidade = 20, tipo = 'motos' },
	{ hash = -1232865578, name = 'GIULIAGTA', price = 150000, banido = false, modelo = 'GIULIAGTA', capacidade = 15, tipo = 'outros' },
	{ hash = 1876516712, name = 'camper', price = 25000, banido = false, modelo = 'camper', capacidade = 250, tipo = 'utilitario' },
	{ hash = 959519510, name = 'BMWZ4ME86Coupe', price = 150000, banido = false, modelo = 'BMWZ4ME86Coupe', capacidade = 15, tipo = 'outros' },
	{ hash = -1311154784, name = 'cheetah', price = 150000, banido = false, modelo = 'cheetah', capacidade = 75, tipo = 'carros' },
	{ hash = 437538602, name = 'speeder2', price = 40000, banido = false, modelo = 'speeder2', capacidade = 50, tipo = 'barcos' },
	{ hash = -1566607184, name = 'clique', price = 30000, banido = false, modelo = 'clique', capacidade = 15, tipo = 'outros' },
	{ hash = -1743316013, name = 'burrito3', price = 22000, banido = false, modelo = 'burrito3', capacidade = 250, tipo = 'utilitario' },
	{ hash = -618617997, name = 'wolfsbane', price = 12000, banido = false, modelo = 'wolfsbane', capacidade = 20, tipo = 'motos' },
	{ hash = 1558333151, name = 'mbsprinter', price = 22000, banido = false, modelo = 'mbsprinter', capacidade = 15, tipo = 'outros' },
	{ hash = -1130810103, name = 'dilettante', price = 35000, banido = false, modelo = 'dilettante', capacidade = 15, tipo = 'outros' },
	{ hash = -1700801569, name = 'scrap', price = 25000, banido = false, modelo = 'scrap', capacidade = 15, tipo = 'outros' },
	{ hash = -5153954, name = 'exemplar', price = 35000, banido = false, modelo = 'exemplar', capacidade = 15, tipo = 'outros' },
	{ hash = -1218448452, name = 'AstMarLagonda', price = 35000, banido = false, modelo = 'AstMarLagonda', capacidade = 15, tipo = 'outros' },
	{ hash = -2124201592, name = 'manana', price = 25000, banido = false, modelo = 'manana', capacidade = 15, tipo = 'outros' },
	{ hash = -834353991, name = 'komoda', price = 150000, banido = false, modelo = 'komoda', capacidade = 15, tipo = 'outros' },
	{ hash = 1132262048, name = 'burrito5', price = 22000, banido = false, modelo = 'burrito5', capacidade = 250, tipo = 'utilitario' },
	{ hash = -2052737935, name = 'mule3', price = 25000, banido = false, modelo = 'mule3', capacidade = 300, tipo = 'serviço' },
	{ hash = 456714581, name = 'policet', price = 22000, banido = false, modelo = 'policet', capacidade = 15, tipo = 'outros' },
	{ hash = -2118901022, name = 'bmwz4', price = 35000, banido = false, modelo = 'bmwz4', capacidade = 15, tipo = 'outros' },
	{ hash = 464687292, name = 'tornado', price = 25000, banido = false, modelo = 'tornado', capacidade = 15, tipo = 'outros' },
	{ hash = -228423376, name = 'sugoispd', price = 35000, banido = false, modelo = 'sugoispd', capacidade = 15, tipo = 'outros' },
	{ hash = 2067820283, name = 'tyrus', price = 35000, banido = false, modelo = 'tyrus', capacidade = 75, tipo = 'carros' },
	{ hash = 301427732, name = 'hexer', price = 12000, banido = false, modelo = 'hexer', capacidade = 20, tipo = 'motos' },
	{ hash = -1210451983, name = 'tampa3', price = 150000, banido = false, modelo = 'tampa3', capacidade = 15, tipo = 'outros' },
	{ hash = -1745203402, name = 'gburrito', price = 22000, banido = false, modelo = 'gburrito', capacidade = 250, tipo = 'utilitario' },
	{ hash = -960289747, name = 'cablecar', price = 110000, banido = false, modelo = 'cablecar', capacidade = 15, tipo = 'outros' },
	{ hash = -893578776, name = 'ruffian', price = 20000, banido = false, modelo = 'ruffian', capacidade = 20, tipo = 'motos' },
	{ hash = 1258059543, name = 'Africa', price = 12000, banido = false, modelo = 'Africa', capacidade = 20, tipo = 'motos' },
	{ hash = 2072687711, name = 'carbonizzare', price = 100000, banido = false, modelo = 'carbonizzare', capacidade = 15, tipo = 'outros' },
	{ hash = -1137532101, name = 'fq2', price = 35000, banido = false, modelo = 'fq2', capacidade = 15, tipo = 'outros' },
	{ hash = 48339065, name = 'tiptruck', price = 25000, banido = false, modelo = 'tiptruck', capacidade = 15, tipo = 'outros' },
	{ hash = 159330191, name = 'cz4a', price = 100000, banido = false, modelo = 'cz4a', capacidade = 15, tipo = 'outros' },
	{ hash = 108773431, name = 'coquette', price = 150000, banido = false, modelo = 'coquette', capacidade = 15, tipo = 'outros' },
	{ hash = -2140210194, name = 'docktrailer', price = 40000, banido = false, modelo = 'docktrailer', capacidade = 15, tipo = 'outros' },
	{ hash = -2137348917, name = 'phantom', price = 40000, banido = false, modelo = 'phantom', capacidade = 300, tipo = 'serviço' },
	{ hash = -1006919392, name = 'cutter', price = 25000, banido = false, modelo = 'cutter', capacidade = 15, tipo = 'outros' },
	{ hash = 2016857647, name = 'futo', price = 100000, banido = false, modelo = 'futo', capacidade = 15, tipo = 'outros' },
	{ hash = -1661854193, name = 'dune', price = 50000, banido = false, modelo = 'dune', capacidade = 75, tipo = 'carros' },
	{ hash = 534258863, name = 'dune2', price = 50000, banido = false, modelo = 'dune2', capacidade = 75, tipo = 'carros' },
	{ hash = -1289178744, name = 'faggio3', price = 12000, banido = false, modelo = 'faggio3', capacidade = 20, tipo = 'motos' },
	{ hash = 2005361158, name = 'mcgts', price = 50000, banido = false, modelo = 'mcgts', capacidade = 15, tipo = 'outros' },
	{ hash = -488123221, name = 'predator', price = 40000, banido = false, modelo = 'predator', capacidade = 50, tipo = 'barcos' },
	{ hash = 499169875, name = 'fusilade', price = 35000, banido = false, modelo = 'fusilade', capacidade = 15, tipo = 'outros' },
	{ hash = -148676424, name = 'f60', price = 150000, banido = false, modelo = 'f60', capacidade = 15, tipo = 'outros' },
	{ hash = 37348240, name = 'hotknife', price = 50000, banido = false, modelo = 'hotknife', capacidade = 15, tipo = 'outros' },
	{ hash = -400295096, name = 'tribike3', price = 12000, banido = false, modelo = 'tribike3', capacidade = 2, tipo = 'bike' },
	{ hash = 1770332643, name = 'dloader', price = 25000, banido = false, modelo = 'dloader', capacidade = 75, tipo = 'carros' },
	{ hash = 600450546, name = 'hustler', price = 50000, banido = false, modelo = 'hustler', capacidade = 15, tipo = 'outros' },
	{ hash = 310321827, name = 'GAZ24Cabrio', price = 25000, banido = false, modelo = 'GAZ24Cabrio', capacidade = 15, tipo = 'outros' },
	{ hash = 964203707, name = 'vanquishzs', price = 35000, banido = false, modelo = 'vanquishzs', capacidade = 15, tipo = 'outros' },
	{ hash = -825837129, name = 'vigero', price = 50000, banido = false, modelo = 'vigero', capacidade = 15, tipo = 'outros' },
	{ hash = 1177543287, name = 'dubsta', price = 50000, banido = false, modelo = 'dubsta', capacidade = 15, tipo = 'outros' },
	{ hash = 941494461, name = 'ruiner2', price = 150000, banido = false, modelo = 'ruiner2', capacidade = 15, tipo = 'outros' },
	{ hash = -394074634, name = 'dubsta2', price = 50000, banido = false, modelo = 'dubsta2', capacidade = 15, tipo = 'outros' },
	{ hash = -2130482718, name = 'dump', price = 40000, banido = false, modelo = 'dump', capacidade = 15, tipo = 'outros' },
	{ hash = 1119641113, name = 'slamvan3', price = 25000, banido = false, modelo = 'slamvan3', capacidade = 15, tipo = 'outros' },
	{ hash = 1372921020, name = 'a45policia', price = 25000, banido = false, modelo = 'a45policia', capacidade = 15, tipo = 'outros' },
	{ hash = -1523619738, name = 'alphaz1', price = 45000, banido = false, modelo = 'alphaz1', capacidade = 350, tipo = 'avioes' },
	{ hash = -1705304628, name = 'rubble', price = 25000, banido = false, modelo = 'rubble', capacidade = 15, tipo = 'outros' },
	{ hash = 1370643290, name = 'audirs5', price = 35000, banido = false, modelo = 'audirs5', capacidade = 15, tipo = 'outros' },
	{ hash = 1742022738, name = 'slamvan6', price = 30000, banido = false, modelo = 'slamvan6', capacidade = 15, tipo = 'outros' },
	{ hash = 80636076, name = 'dominator', price = 150000, banido = false, modelo = 'dominator', capacidade = 15, tipo = 'outros' },
	{ hash = -836512833, name = 'fixter', price = 12000, banido = false, modelo = 'fixter', capacidade = 2, tipo = 'bike' },
	{ hash = -685276541, name = 'emperor', price = 25000, banido = false, modelo = 'emperor', capacidade = 15, tipo = 'outros' },
	{ hash = -857356038, name = 'veto', price = 50000, banido = false, modelo = 'veto', capacidade = 15, tipo = 'outros' },
	{ hash = 884422927, name = 'habanero', price = 35000, banido = false, modelo = 'habanero', capacidade = 15, tipo = 'outros' },
	{ hash = -1883002148, name = 'emperor2', price = 25000, banido = false, modelo = 'emperor2', capacidade = 15, tipo = 'outros' },
	{ hash = -1241712818, name = 'emperor3', price = 25000, banido = false, modelo = 'emperor3', capacidade = 15, tipo = 'outros' },
	{ hash = -1214505995, name = 'shamal', price = 45000, banido = false, modelo = 'shamal', capacidade = 350, tipo = 'avioes' },
	{ hash = 2038858402, name = 'brutus3', price = 50000, banido = false, modelo = 'brutus3', capacidade = 75, tipo = 'carros' },
	{ hash = 1762279763, name = 'tornado3', price = 25000, banido = false, modelo = 'tornado3', capacidade = 15, tipo = 'outros' },
	{ hash = -1291952903, name = 'entityxf', price = 150000, banido = false, modelo = 'entityxf', capacidade = 75, tipo = 'carros' },
	{ hash = -566387422, name = 'elegy2', price = 100000, banido = false, modelo = 'elegy2', capacidade = 15, tipo = 'outros' },
	{ hash = 1132804740, name = 'nis15', price = 50000, banido = false, modelo = 'nis15', capacidade = 15, tipo = 'outros' },
	{ hash = 1082938645, name = 'foxgt2', price = 35000, banido = false, modelo = 'foxgt2', capacidade = 75, tipo = 'carros' },
	{ hash = -1770643266, name = 'tvtrailer', price = 40000, banido = false, modelo = 'tvtrailer', capacidade = 15, tipo = 'outros' },
	{ hash = 1830407356, name = 'peyote', price = 25000, banido = false, modelo = 'peyote', capacidade = 15, tipo = 'outros' },
	{ hash = -591610296, name = 'f620', price = 35000, banido = false, modelo = 'f620', capacidade = 15, tipo = 'outros' },
	{ hash = -452604007, name = 'rt3000', price = 35000, banido = false, modelo = 'rt3000', capacidade = 15, tipo = 'outros' },
	{ hash = 1507916787, name = 'picador', price = 35000, banido = false, modelo = 'picador', capacidade = 15, tipo = 'outros' },
	{ hash = -2121899031, name = '992t', price = 35000, banido = false, modelo = '992t', capacidade = 75, tipo = 'carros' },
	{ hash = 1174930137, name = 'sky2000gtr', price = 150000, banido = false, modelo = 'sky2000gtr', capacidade = 15, tipo = 'outros' },
	{ hash = 1127131465, name = 'fbi', price = 25000, banido = false, modelo = 'fbi', capacidade = 15, tipo = 'outros' },
	{ hash = 972671128, name = 'tampa', price = 150000, banido = false, modelo = 'tampa', capacidade = 15, tipo = 'outros' },
	{ hash = 1836027715, name = 'thrust', price = 12000, banido = false, modelo = 'thrust', capacidade = 20, tipo = 'motos' },
	{ hash = -1647941228, name = 'fbi2', price = 25000, banido = false, modelo = 'fbi2', capacidade = 15, tipo = 'outros' },
	{ hash = -2098947590, name = 'stingergt', price = 130000, banido = false, modelo = 'stingergt', capacidade = 15, tipo = 'outros' },
	{ hash = -391594584, name = 'felon', price = 35000, banido = false, modelo = 'felon', capacidade = 15, tipo = 'outros' },
	{ hash = 237764926, name = 'buffalo3', price = 25000, banido = false, modelo = 'buffalo3', capacidade = 15, tipo = 'outros' },
	{ hash = -311022263, name = 'seashark3', price = 40000, banido = false, modelo = 'seashark3', capacidade = 50, tipo = 'barcos' },
	{ hash = -1189015600, name = 'sandking', price = 50000, banido = false, modelo = 'sandking', capacidade = 75, tipo = 'carros' },
	{ hash = -1995326987, name = 'feltzer2', price = 30000, banido = false, modelo = 'feltzer2', capacidade = 15, tipo = 'outros' },
	{ hash = 1938952078, name = 'firetruk', price = 40000, banido = false, modelo = 'firetruk', capacidade = 15, tipo = 'outros' },
	{ hash = 1491375716, name = 'forklift', price = 25000, banido = false, modelo = 'forklift', capacidade = 15, tipo = 'outros' },
	{ hash = 1909141499, name = 'fugitive', price = 35000, banido = false, modelo = 'fugitive', capacidade = 15, tipo = 'outros' },
	{ hash = 2091594960, name = 'tr4', price = 40000, banido = false, modelo = 'tr4', capacidade = 15, tipo = 'outros' },
	{ hash = -1775728740, name = 'granger', price = 50000, banido = false, modelo = 'granger', capacidade = 15, tipo = 'outros' },
	{ hash = -1216765807, name = 'adder', price = 80000, banido = false, modelo = 'adder', capacidade = 75, tipo = 'carros' },
	{ hash = -1800170043, name = 'gauntlet', price = 25000, banido = false, modelo = 'gauntlet', capacidade = 15, tipo = 'outros' },
	{ hash = -769147461, name = 'caddy3', price = 10000, banido = false, modelo = 'caddy3', capacidade = 15, tipo = 'outros' },
	{ hash = 1518533038, name = 'hauler', price = 40000, banido = false, modelo = 'hauler', capacidade = 300, tipo = 'serviço' },
	{ hash = 144259586, name = '911R', price = 150000, banido = false, modelo = '911R', capacidade = 75, tipo = 'carros' },
	{ hash = 920453016, name = 'freightcont1', price = 110000, banido = false, modelo = 'freightcont1', capacidade = 15, tipo = 'outros' },
	{ hash = 418536135, name = 'infernus', price = 100000, banido = false, modelo = 'infernus', capacidade = 75, tipo = 'carros' },
	{ hash = 2031587082, name = 'retinue2', price = 150000, banido = false, modelo = 'retinue2', capacidade = 15, tipo = 'outros' },
	{ hash = -1289722222, name = 'ingot', price = 35000, banido = false, modelo = 'ingot', capacidade = 15, tipo = 'outros' },
	{ hash = 2078290630, name = 'tr2', price = 40000, banido = false, modelo = 'tr2', capacidade = 15, tipo = 'outros' },
	{ hash = -186537451, name = 'scorcher', price = 12000, banido = false, modelo = 'scorcher', capacidade = 2, tipo = 'bike' },
	{ hash = 1622721793, name = 'felon12', price = 35000, banido = false, modelo = 'felon12', capacidade = 15, tipo = 'outros' },
	{ hash = 1865641415, name = 'policiatahoe', price = 25000, banido = false, modelo = 'policiatahoe', capacidade = 15, tipo = 'outros' },
	{ hash = 886934177, name = 'intruder', price = 35000, banido = false, modelo = 'intruder', capacidade = 15, tipo = 'outros' },
	{ hash = -1177863319, name = 'issi2', price = 35000, banido = false, modelo = 'issi2', capacidade = 15, tipo = 'outros' },
	{ hash = 1328869613, name = 'er34', price = 35000, banido = false, modelo = 'er34', capacidade = 15, tipo = 'outros' },
	{ hash = -1894894188, name = 'surge', price = 35000, banido = false, modelo = 'surge', capacidade = 15, tipo = 'outros' },
	{ hash = 758895617, name = 'ztype', price = 70000, banido = false, modelo = 'ztype', capacidade = 15, tipo = 'outros' },
	{ hash = -998177792, name = 'visione', price = 35000, banido = false, modelo = 'visione', capacidade = 75, tipo = 'carros' },
	{ hash = -1961627517, name = 'stretch', price = 35000, banido = false, modelo = 'stretch', capacidade = 15, tipo = 'outros' },
	{ hash = -624529134, name = 'Jackal', price = 35000, banido = false, modelo = 'Jackal', capacidade = 15, tipo = 'outros' },
	{ hash = -673061815, name = 'VRdm1200', price = 20000, banido = false, modelo = 'VRdm1200', capacidade = 15, tipo = 'outros' },
	{ hash = -120287622, name = 'journey', price = 25000, banido = false, modelo = 'journey', capacidade = 250, tipo = 'utilitario' },
	{ hash = 1051415893, name = 'jb700', price = 150000, banido = false, modelo = 'jb700', capacidade = 15, tipo = 'outros' },
	{ hash = 11251904, name = 'carbonrs', price = 20000, banido = false, modelo = 'carbonrs', capacidade = 20, tipo = 'motos' },
	{ hash = 544021352, name = 'khamelion', price = 35000, banido = false, modelo = 'khamelion', capacidade = 15, tipo = 'outros' },
	{ hash = -1582061455, name = 'jester4', price = 35000, banido = false, modelo = 'jester4', capacidade = 15, tipo = 'outros' },
	{ hash = 177270108, name = 'phantom3', price = 40000, banido = false, modelo = 'phantom3', capacidade = 300, tipo = 'serviço' },
	{ hash = 628003514, name = 'issi4', price = 52000, banido = false, modelo = 'issi4', capacidade = 15, tipo = 'outros' },
	{ hash = 1269098716, name = 'landstalker', price = 50000, banido = false, modelo = 'landstalker', capacidade = 15, tipo = 'outros' },
	{ hash = -293031363, name = 's1000docandidato', price = 12000, banido = false, modelo = 's1000docandidato', capacidade = 20, tipo = 'motos' },
	{ hash = -282946103, name = 'suntrap', price = 40000, banido = false, modelo = 'suntrap', capacidade = 50, tipo = 'barcos' },
	{ hash = 469291905, name = 'lguard', price = 50000, banido = false, modelo = 'lguard', capacidade = 15, tipo = 'outros' },
	{ hash = 547134075, name = 'mclarenp1', price = 25000, banido = false, modelo = 'mclarenp1', capacidade = 75, tipo = 'carros' },
	{ hash = -1529242755, name = 'raiden', price = 35000, banido = false, modelo = 'raiden', capacidade = 15, tipo = 'outros' },
	{ hash = -24400793, name = 'armj', price = 50000, banido = false, modelo = 'armj', capacidade = 15, tipo = 'outros' },
	{ hash = 621481054, name = 'luxor', price = 45000, banido = false, modelo = 'luxor', capacidade = 350, tipo = 'avioes' },
	{ hash = 914654722, name = 'mesa', price = 50000, banido = false, modelo = 'mesa', capacidade = 15, tipo = 'outros' },
	{ hash = 1537277726, name = 'issi5', price = 52000, banido = false, modelo = 'issi5', capacidade = 15, tipo = 'outros' },
	{ hash = -35871888, name = 'dawn', price = 25000, banido = false, modelo = 'dawn', capacidade = 15, tipo = 'outros' },
	{ hash = -339587598, name = 'swift', price = 52000, banido = false, modelo = 'swift', capacidade = 20, tipo = 'helicopteros' },
	{ hash = 765170133, name = 'db11', price = 80000, banido = false, modelo = 'db11', capacidade = 75, tipo = 'carros' },
	{ hash = -748008636, name = 'mesa2', price = 50000, banido = false, modelo = 'mesa2', capacidade = 15, tipo = 'outros' },
	{ hash = -1190838052, name = 'rmodi8ks', price = 50000, banido = false, modelo = 'rmodi8ks', capacidade = 75, tipo = 'carros' },
	{ hash = 177593626, name = 'mrbeanmini', price = 35000, banido = false, modelo = 'mrbeanmini', capacidade = 15, tipo = 'outros' },
	{ hash = -2064372143, name = 'mesa3', price = 50000, banido = false, modelo = 'mesa3', capacidade = 75, tipo = 'carros' },
	{ hash = 321739290, name = 'crusader', price = 50000, banido = false, modelo = 'crusader', capacidade = 15, tipo = 'outros' },
	{ hash = 112218935, name = 'policiataurus', price = 25000, banido = false, modelo = 'policiataurus', capacidade = 15, tipo = 'outros' },
	{ hash = 1717532765, name = 'manana2', price = 25000, banido = false, modelo = 'manana2', capacidade = 15, tipo = 'outros' },
	{ hash = -310465116, name = 'minivan', price = 50000, banido = false, modelo = 'minivan', capacidade = 250, tipo = 'utilitario' },
	{ hash = -784816453, name = 'mixer', price = 40000, banido = false, modelo = 'mixer', capacidade = 15, tipo = 'outros' },
	{ hash = -305215651, name = 'xfrs', price = 35000, banido = false, modelo = 'xfrs', capacidade = 15, tipo = 'outros' },
	{ hash = 475220373, name = 'mixer2', price = 40000, banido = false, modelo = 'mixer2', capacidade = 15, tipo = 'outros' },
	{ hash = -433375717, name = 'monroe', price = 70000, banido = false, modelo = 'monroe', capacidade = 15, tipo = 'outros' },
	{ hash = -1207771834, name = 'rebel', price = 50000, banido = false, modelo = 'rebel', capacidade = 75, tipo = 'carros' },
	{ hash = 1783355638, name = 'mower', price = 15000, banido = false, modelo = 'mower', capacidade = 15, tipo = 'outros' },
	{ hash = -556794296, name = 'compass', price = 50000, banido = false, modelo = 'compass', capacidade = 15, tipo = 'outros' },
	{ hash = 904750859, name = 'mule', price = 25000, banido = false, modelo = 'mule', capacidade = 300, tipo = 'serviço' },
	{ hash = -754141017, name = 'm8comando', price = 35000, banido = false, modelo = 'm8comando', capacidade = 15, tipo = 'outros' },
	{ hash = -2119578145, name = 'faction', price = 150000, banido = false, modelo = 'faction', capacidade = 15, tipo = 'outros' },
	{ hash = 1653666139, name = 'pounder2', price = 25000, banido = false, modelo = 'pounder2', capacidade = 300, tipo = 'serviço' },
	{ hash = -1637862878, name = 'rmodf40', price = 100000, banido = false, modelo = 'rmodf40', capacidade = 15, tipo = 'outros' },
	{ hash = -845961253, name = 'monster', price = 500000, banido = false, modelo = 'monster', capacidade = 75, tipo = 'carros' },
	{ hash = -1050465301, name = 'mule2', price = 25000, banido = false, modelo = 'mule2', capacidade = 300, tipo = 'serviço' },
	{ hash = 788045382, name = 'sanchez', price = 12000, banido = false, modelo = 'sanchez', capacidade = 20, tipo = 'motos' },
	{ hash = 143856705, name = 'quadrado', price = 35000, banido = false, modelo = 'quadrado', capacidade = 15, tipo = 'outros' },
	{ hash = -1979369492, name = '2017chiron', price = 80000, banido = false, modelo = '2017chiron', capacidade = 75, tipo = 'carros' },
	{ hash = 1348744438, name = 'oracle', price = 35000, banido = false, modelo = 'oracle', capacidade = 15, tipo = 'outros' },
	{ hash = -511601230, name = 'oracle2', price = 35000, banido = false, modelo = 'oracle2', capacidade = 15, tipo = 'outros' },
	{ hash = 340737726, name = 'rmodg65', price = 50000, banido = false, modelo = 'rmodg65', capacidade = 15, tipo = 'outros' },
	{ hash = -1124510526, name = 'vxr', price = 35000, banido = false, modelo = 'vxr', capacidade = 15, tipo = 'outros' },
	{ hash = 108063727, name = 'paramedicocharger2014', price = 25000, banido = false, modelo = 'paramedicocharger2014', capacidade = 15, tipo = 'outros' },
	{ hash = 569305213, name = 'packer', price = 40000, banido = false, modelo = 'packer', capacidade = 300, tipo = 'serviço' },
	{ hash = -1590337689, name = 'blazer5', price = 12000, banido = false, modelo = 'blazer5', capacidade = 75, tipo = 'carros' },
	{ hash = -808457413, name = 'patriot', price = 50000, banido = false, modelo = 'patriot', capacidade = 15, tipo = 'outros' },
	{ hash = 583417613, name = 'ChevCar1975', price = 25000, banido = false, modelo = 'ChevCar1975', capacidade = 15, tipo = 'outros' },
	{ hash = 223258115, name = 'sabregt2', price = 150000, banido = false, modelo = 'sabregt2', capacidade = 15, tipo = 'outros' },
	{ hash = 1429622905, name = 'brioso2', price = 35000, banido = false, modelo = 'brioso2', capacidade = 15, tipo = 'outros' },
	{ hash = -2007026063, name = 'pbus', price = 25000, banido = false, modelo = 'pbus', capacidade = 15, tipo = 'outros' },
	{ hash = -276744698, name = 'patrolboat', price = 40000, banido = false, modelo = 'patrolboat', capacidade = 50, tipo = 'barcos' },
	{ hash = 1531094468, name = 'tornado2', price = 25000, banido = false, modelo = 'tornado2', capacidade = 15, tipo = 'outros' },
	{ hash = -69967406, name = 'm4clb', price = 100000, banido = false, modelo = 'm4clb', capacidade = 15, tipo = 'outros' },
	{ hash = -101696514, name = 'rmodbugatti', price = 35000, banido = false, modelo = 'rmodbugatti', capacidade = 75, tipo = 'carros' },
	{ hash = 448402357, name = 'cruiser', price = 12000, banido = false, modelo = 'cruiser', capacidade = 2, tipo = 'bike' },
	{ hash = 734217681, name = 'sadler2', price = 25000, banido = false, modelo = 'sadler2', capacidade = 15, tipo = 'outros' },
	{ hash = -377465520, name = 'penumbra', price = 150000, banido = false, modelo = 'penumbra', capacidade = 15, tipo = 'outros' },
	{ hash = -910466076, name = 'a45', price = 35000, banido = false, modelo = 'a45', capacidade = 15, tipo = 'outros' },
	{ hash = -2095439403, name = 'phoenix', price = 20000, banido = false, modelo = 'phoenix', capacidade = 15, tipo = 'outros' },
	{ hash = 2112052861, name = 'pounder', price = 25000, banido = false, modelo = 'pounder', capacidade = 300, tipo = 'serviço' },
	{ hash = -82626025, name = 'savage', price = 52000, banido = false, modelo = 'savage', capacidade = 20, tipo = 'helicopteros' },
	{ hash = 642617954, name = 'freightgrain', price = 110000, banido = false, modelo = 'freightgrain', capacidade = 15, tipo = 'outros' },
	{ hash = -1352468814, name = 'trflat', price = 40000, banido = false, modelo = 'trflat', capacidade = 15, tipo = 'outros' },
	{ hash = 1102544804, name = 'verlierer2', price = 150000, banido = false, modelo = 'verlierer2', capacidade = 15, tipo = 'outros' },
	{ hash = 2046537925, name = 'police', price = 35000, banido = false, modelo = 'police', capacidade = 15, tipo = 'outros' },
	{ hash = -42051018, name = 'veneno', price = 80000, banido = false, modelo = 'veneno', capacidade = 75, tipo = 'carros' },
	{ hash = -1660661558, name = 'maverick', price = 52000, banido = false, modelo = 'maverick', capacidade = 20, tipo = 'helicopteros' },
	{ hash = -4816535, name = 'nissanskyliner34', price = 35000, banido = false, modelo = 'nissanskyliner34', capacidade = 15, tipo = 'outros' },
	{ hash = -1973172295, name = 'police4', price = 35000, banido = false, modelo = 'police4', capacidade = 15, tipo = 'outros' },
	{ hash = -1033779018, name = 'raioclassx', price = 25000, banido = false, modelo = 'raioclassx', capacidade = 15, tipo = 'outros' },
	{ hash = -295689028, name = 'sultanrs', price = 35000, banido = false, modelo = 'sultanrs', capacidade = 75, tipo = 'carros' },
	{ hash = -1627000575, name = 'police2', price = 25000, banido = false, modelo = 'police2', capacidade = 15, tipo = 'outros' },
	{ hash = 819197656, name = 'sheava', price = 35000, banido = false, modelo = 'sheava', capacidade = 75, tipo = 'carros' },
	{ hash = 1912215274, name = 'police3', price = 25000, banido = false, modelo = 'police3', capacidade = 15, tipo = 'outros' },
	{ hash = -1536924937, name = 'policeold1', price = 50000, banido = false, modelo = 'policeold1', capacidade = 15, tipo = 'outros' },
	{ hash = 1504306544, name = 'torero', price = 100000, banido = false, modelo = 'torero', capacidade = 15, tipo = 'outros' },
	{ hash = -1779120616, name = 'policeold2', price = 35000, banido = false, modelo = 'policeold2', capacidade = 15, tipo = 'outros' },
	{ hash = -1358197432, name = 'tigon', price = 35000, banido = false, modelo = 'tigon', capacidade = 75, tipo = 'carros' },
	{ hash = -1203725842, name = 'ctsv16', price = 150000, banido = false, modelo = 'ctsv16', capacidade = 15, tipo = 'outros' },
	{ hash = 943752001, name = 'pony2', price = 22000, banido = false, modelo = 'pony2', capacidade = 250, tipo = 'utilitario' },
	{ hash = -1450650718, name = 'prairie', price = 35000, banido = false, modelo = 'prairie', capacidade = 15, tipo = 'outros' },
	{ hash = 16646064, name = 'virgo3', price = 150000, banido = false, modelo = 'virgo3', capacidade = 15, tipo = 'outros' },
	{ hash = 1907581198, name = 'tailgater12', price = 80000, banido = false, modelo = 'tailgater12', capacidade = 15, tipo = 'outros' },
	{ hash = -589178377, name = 'ratloader2', price = 50000, banido = false, modelo = 'ratloader2', capacidade = 15, tipo = 'outros' },
	{ hash = 741586030, name = 'pranger', price = 50000, banido = false, modelo = 'pranger', capacidade = 15, tipo = 'outros' },
	{ hash = -1883869285, name = 'premier', price = 35000, banido = false, modelo = 'premier', capacidade = 15, tipo = 'outros' },
	{ hash = -14495224, name = 'regina', price = 25000, banido = false, modelo = 'regina', capacidade = 15, tipo = 'outros' },
	{ hash = 1593933419, name = 'seasparrow3', price = 52000, banido = false, modelo = 'seasparrow3', capacidade = 20, tipo = 'helicopteros' },
	{ hash = -1150599089, name = 'primo', price = 35000, banido = false, modelo = 'primo', capacidade = 15, tipo = 'outros' },
	{ hash = 356391690, name = 'proptrailer', price = 40000, banido = false, modelo = 'proptrailer', capacidade = 15, tipo = 'outros' },
	{ hash = 1034187331, name = 'nero', price = 80000, banido = false, modelo = 'nero', capacidade = 75, tipo = 'carros' },
	{ hash = -877478386, name = 'trailers', price = 40000, banido = false, modelo = 'trailers', capacidade = 15, tipo = 'outros' },
	{ hash = 366413634, name = 'ttrsr19', price = 80000, banido = false, modelo = 'ttrsr19', capacidade = 15, tipo = 'outros' },
	{ hash = 1645267888, name = 'rancherxl', price = 50000, banido = false, modelo = 'rancherxl', capacidade = 75, tipo = 'carros' },
	{ hash = 683047626, name = 'contender', price = 25000, banido = false, modelo = 'contender', capacidade = 15, tipo = 'outros' },
	{ hash = 1933662059, name = 'rancherxl2', price = 50000, banido = false, modelo = 'rancherxl2', capacidade = 75, tipo = 'carros' },
	{ hash = -1259134696, name = 'flashgt', price = 35000, banido = false, modelo = 'flashgt', capacidade = 15, tipo = 'outros' },
	{ hash = -1215316954, name = 'c63', price = 25000, banido = false, modelo = 'c63', capacidade = 15, tipo = 'outros' },
	{ hash = -1323100960, name = 'towtruck', price = 25000, banido = false, modelo = 'towtruck', capacidade = 15, tipo = 'outros' },
	{ hash = -1934452204, name = 'rapidgt', price = 35000, banido = false, modelo = 'rapidgt', capacidade = 15, tipo = 'outros' },
	{ hash = -399841706, name = 'baletrailer', price = 40000, banido = false, modelo = 'baletrailer', capacidade = 15, tipo = 'outros' },
	{ hash = 1737773231, name = 'rapidgt2', price = 35000, banido = false, modelo = 'rapidgt2', capacidade = 15, tipo = 'outros' },
	{ hash = 2016027501, name = 'trailerlogs', price = 40000, banido = false, modelo = 'trailerlogs', capacidade = 15, tipo = 'outros' },
	{ hash = -1651067813, name = 'radi', price = 50000, banido = false, modelo = 'radi', capacidade = 15, tipo = 'outros' },
	{ hash = -1430138530, name = 'bnr34', price = 35000, banido = false, modelo = 'bnr34', capacidade = 15, tipo = 'outros' },
	{ hash = 1394036463, name = 'cargobob3', price = 52000, banido = false, modelo = 'cargobob3', capacidade = 20, tipo = 'helicopteros' },
	{ hash = -1134706562, name = 'taipan', price = 35000, banido = false, modelo = 'taipan', capacidade = 75, tipo = 'carros' },
	{ hash = 1591739866, name = 'deveste', price = 35000, banido = false, modelo = 'deveste', capacidade = 75, tipo = 'carros' },
	{ hash = -667151410, name = 'ratloader', price = 50000, banido = false, modelo = 'ratloader', capacidade = 15, tipo = 'outros' },
	{ hash = -1259375426, name = 'rmodbacalar', price = 35000, banido = false, modelo = 'rmodbacalar', capacidade = 75, tipo = 'carros' },
	{ hash = 165154707, name = 'miljet', price = 45000, banido = false, modelo = 'miljet', capacidade = 350, tipo = 'avioes' },
	{ hash = -2045594037, name = 'rebel2', price = 50000, banido = false, modelo = 'rebel2', capacidade = 75, tipo = 'carros' },
	{ hash = -1098802077, name = 'rentalbus', price = 40000, banido = false, modelo = 'rentalbus', capacidade = 15, tipo = 'outros' },
	{ hash = -227741703, name = 'ruiner', price = 150000, banido = false, modelo = 'ruiner', capacidade = 15, tipo = 'outros' },
	{ hash = 679453769, name = 'cerberus2', price = 25000, banido = false, modelo = 'cerberus2', capacidade = 300, tipo = 'serviço' },
	{ hash = 1162065741, name = 'rumpo', price = 22000, banido = false, modelo = 'rumpo', capacidade = 250, tipo = 'utilitario' },
	{ hash = -1776615689, name = 'rumpo2', price = 22000, banido = false, modelo = 'rumpo2', capacidade = 250, tipo = 'utilitario' },
	{ hash = 1026149675, name = 'youga2', price = 22000, banido = false, modelo = 'youga2', capacidade = 250, tipo = 'utilitario' },
	{ hash = 767087018, name = 'alpha', price = 80000, banido = false, modelo = 'alpha', capacidade = 15, tipo = 'outros' },
	{ hash = 782665360, name = 'rhino', price = 40000, banido = false, modelo = 'rhino', capacidade = 15, tipo = 'outros' },
	{ hash = 1489967196, name = 'schafter4', price = 35000, banido = false, modelo = 'schafter4', capacidade = 15, tipo = 'outros' },
	{ hash = 2034235290, name = 'mazdarx7', price = 25000, banido = false, modelo = 'mazdarx7', capacidade = 15, tipo = 'outros' },
	{ hash = -840666370, name = 'yacht3b', price = 40000, banido = false, modelo = 'yacht3b', capacidade = 50, tipo = 'barcos' },
	{ hash = -845979911, name = 'ripley', price = 25000, banido = false, modelo = 'ripley', capacidade = 15, tipo = 'outros' },
	{ hash = 523724515, name = 'voodoo2', price = 25000, banido = false, modelo = 'voodoo2', capacidade = 15, tipo = 'outros' },
	{ hash = 2136773105, name = 'rocoto', price = 35000, banido = false, modelo = 'rocoto', capacidade = 15, tipo = 'outros' },
	{ hash = 235772231, name = 'fxxkevo', price = 50000, banido = false, modelo = 'fxxkevo', capacidade = 75, tipo = 'carros' },
	{ hash = 771711535, name = 'submersible', price = 40000, banido = false, modelo = 'submersible', capacidade = 50, tipo = 'barcos' },
	{ hash = -507495760, name = 'schlagen', price = 35000, banido = false, modelo = 'schlagen', capacidade = 15, tipo = 'outros' },
	{ hash = -2042350822, name = 'bruiser3', price = 40000, banido = false, modelo = 'bruiser3', capacidade = 75, tipo = 'carros' },
	{ hash = -1685021548, name = 'sabregt', price = 150000, banido = false, modelo = 'sabregt', capacidade = 15, tipo = 'outros' },
	{ hash = -599568815, name = 'sadler', price = 25000, banido = false, modelo = 'sadler', capacidade = 15, tipo = 'outros' },
	{ hash = 989381445, name = 'sandking2', price = 50000, banido = false, modelo = 'sandking2', capacidade = 75, tipo = 'carros' },
	{ hash = -52867086, name = 'ChevOpalGran', price = 150000, banido = false, modelo = 'ChevOpalGran', capacidade = 15, tipo = 'outros' },
	{ hash = 1909700336, name = 'cerberus3', price = 25000, banido = false, modelo = 'cerberus3', capacidade = 300, tipo = 'serviço' },
	{ hash = -1378825203, name = 'xt660vip', price = 12000, banido = false, modelo = 'xt660vip', capacidade = 20, tipo = 'motos' },
	{ hash = 1030400667, name = 'freight', price = 110000, banido = false, modelo = 'freight', capacidade = 15, tipo = 'outros' },
	{ hash = -1255452397, name = 'schafter2', price = 35000, banido = false, modelo = 'schafter2', capacidade = 15, tipo = 'outros' },
	{ hash = 740289177, name = 'vagrant', price = 50000, banido = false, modelo = 'vagrant', capacidade = 75, tipo = 'carros' },
	{ hash = 784565758, name = 'coquette3', price = 150000, banido = false, modelo = 'coquette3', capacidade = 15, tipo = 'outros' },
	{ hash = -746882698, name = 'schwarzer', price = 35000, banido = false, modelo = 'schwarzer', capacidade = 15, tipo = 'outros' },
	{ hash = 482197771, name = 'lynx', price = 150000, banido = false, modelo = 'lynx', capacidade = 15, tipo = 'outros' },
	{ hash = 1349725314, name = 'sentinel', price = 35000, banido = false, modelo = 'sentinel', capacidade = 15, tipo = 'outros' },
	{ hash = 48579579, name = 'coquettessd', price = 150000, banido = false, modelo = 'coquettessd', capacidade = 15, tipo = 'outros' },
	{ hash = 788747387, name = 'buzzard', price = 52000, banido = false, modelo = 'buzzard', capacidade = 20, tipo = 'helicopteros' },
	{ hash = 1305247149, name = 'gs310', price = 12000, banido = false, modelo = 'gs310', capacidade = 20, tipo = 'motos' },
	{ hash = 729999243, name = 'A110', price = 150000, banido = false, modelo = 'A110', capacidade = 15, tipo = 'outros' },
	{ hash = 873639469, name = 'sentinel2', price = 35000, banido = false, modelo = 'sentinel2', capacidade = 15, tipo = 'outros' },
	{ hash = 1564144270, name = 'r1200rtp', price = 12000, banido = false, modelo = 'r1200rtp', capacidade = 15, tipo = 'outros' },
	{ hash = -956048545, name = 'taxi', price = 25000, banido = false, modelo = 'taxi', capacidade = 15, tipo = 'outros' },
	{ hash = -1122289213, name = 'zion', price = 35000, banido = false, modelo = 'zion', capacidade = 15, tipo = 'outros' },
	{ hash = 579853907, name = 'dchallenger15', price = 170000, banido = false, modelo = 'dchallenger15', capacidade = 75, tipo = 'carros' },
	{ hash = 408825843, name = 'outlaw', price = 50000, banido = false, modelo = 'outlaw', capacidade = 75, tipo = 'carros' },
	{ hash = -2076478498, name = 'tractor2', price = 50000, banido = false, modelo = 'tractor2', capacidade = 15, tipo = 'outros' },
	{ hash = -1193103848, name = 'zion2', price = 35000, banido = false, modelo = 'zion2', capacidade = 15, tipo = 'outros' },
	{ hash = 295054921, name = 'annihilator2', price = 52000, banido = false, modelo = 'annihilator2', capacidade = 20, tipo = 'helicopteros' },
	{ hash = 1337041428, name = 'serrano', price = 50000, banido = false, modelo = 'serrano', capacidade = 15, tipo = 'outros' },
	{ hash = -1683328900, name = 'sheriff', price = 25000, banido = false, modelo = 'sheriff', capacidade = 15, tipo = 'outros' },
	{ hash = 1352136073, name = 'sc1', price = 35000, banido = false, modelo = 'sc1', capacidade = 75, tipo = 'carros' },
	{ hash = 1922257928, name = 'sheriff2', price = 25000, banido = false, modelo = 'sheriff2', capacidade = 15, tipo = 'outros' },
	{ hash = -810318068, name = 'speedo', price = 22000, banido = false, modelo = 'speedo', capacidade = 250, tipo = 'utilitario' },
	{ hash = 342059638, name = 'xj6', price = 12000, banido = false, modelo = 'xj6', capacidade = 20, tipo = 'motos' },
	{ hash = 728614474, name = 'speedo2', price = 22000, banido = false, modelo = 'speedo2', capacidade = 250, tipo = 'utilitario' },
	{ hash = -1477580979, name = 'stanier', price = 35000, banido = false, modelo = 'stanier', capacidade = 15, tipo = 'outros' },
	{ hash = 1123216662, name = 'superd', price = 25000, banido = false, modelo = 'superd', capacidade = 15, tipo = 'outros' },
	{ hash = 1545842587, name = 'stinger', price = 130000, banido = false, modelo = 'stinger', capacidade = 15, tipo = 'outros' },
	{ hash = 1563843927, name = '180326', price = 35000, banido = false, modelo = '180326', capacidade = 15, tipo = 'outros' },
	{ hash = -586459613, name = 'ttrs', price = 35000, banido = false, modelo = 'ttrs', capacidade = 15, tipo = 'outros' },
	{ hash = 1747439474, name = 'stockade', price = 40000, banido = false, modelo = 'stockade', capacidade = 300, tipo = 'serviço' },
	{ hash = 1009171724, name = 'impaler2', price = 30000, banido = false, modelo = 'impaler2', capacidade = 15, tipo = 'outros' },
	{ hash = -2096818938, name = 'technical', price = 50000, banido = false, modelo = 'technical', capacidade = 75, tipo = 'carros' },
	{ hash = -214455498, name = 'stockade3', price = 40000, banido = false, modelo = 'stockade3', capacidade = 300, tipo = 'serviço' },
	{ hash = -1058637853, name = 'h9gq', price = 50000, banido = false, modelo = 'h9gq', capacidade = 15, tipo = 'outros' },
	{ hash = 196747873, name = 'elegy', price = 100000, banido = false, modelo = 'elegy', capacidade = 15, tipo = 'outros' },
	{ hash = 970598228, name = 'sultan', price = 35000, banido = false, modelo = 'sultan', capacidade = 15, tipo = 'outros' },
	{ hash = 384071873, name = 'surano', price = 80000, banido = false, modelo = 'surano', capacidade = 15, tipo = 'outros' },
	{ hash = 699456151, name = 'surfer', price = 22000, banido = false, modelo = 'surfer', capacidade = 250, tipo = 'utilitario' },
	{ hash = -1311240698, name = 'surfer2', price = 22000, banido = false, modelo = 'surfer2', capacidade = 250, tipo = 'utilitario' },
	{ hash = 1951180813, name = 'taco', price = 25000, banido = false, modelo = 'taco', capacidade = 250, tipo = 'utilitario' },
	{ hash = 741090084, name = 'gargoyle', price = 12000, banido = false, modelo = 'gargoyle', capacidade = 20, tipo = 'motos' },
	{ hash = -1008861746, name = 'tailgater', price = 35000, banido = false, modelo = 'tailgater', capacidade = 15, tipo = 'outros' },
	{ hash = 1086534307, name = 'manchez2', price = 12000, banido = false, modelo = 'manchez2', capacidade = 20, tipo = 'motos' },
	{ hash = 1784254509, name = 'tr3', price = 40000, banido = false, modelo = 'tr3', capacidade = 15, tipo = 'outros' },
	{ hash = 1917016601, name = 'trash', price = 40000, banido = false, modelo = 'trash', capacidade = 15, tipo = 'outros' },
	{ hash = 1641462412, name = 'tractor', price = 50000, banido = false, modelo = 'tractor', capacidade = 15, tipo = 'outros' },
	{ hash = 2049897956, name = 'rapidgt3', price = 100000, banido = false, modelo = 'rapidgt3', capacidade = 15, tipo = 'outros' },
	{ hash = 1445631933, name = 'tractor3', price = 50000, banido = false, modelo = 'tractor3', capacidade = 15, tipo = 'outros' },
	{ hash = 1019737494, name = 'graintrailer', price = 40000, banido = false, modelo = 'graintrailer', capacidade = 15, tipo = 'outros' },
	{ hash = -947761570, name = 'tiptruck2', price = 25000, banido = false, modelo = 'tiptruck2', capacidade = 15, tipo = 'outros' },
	{ hash = 1941029835, name = 'tourbus', price = 40000, banido = false, modelo = 'tourbus', capacidade = 15, tipo = 'outros' },
	{ hash = 1969388644, name = 'imsa90', price = 35000, banido = false, modelo = 'imsa90', capacidade = 75, tipo = 'carros' },
	{ hash = 884483972, name = 'oppressor', price = 20000, banido = false, modelo = 'oppressor', capacidade = 20, tipo = 'motos' },
	{ hash = 516990260, name = 'utillitruck', price = 25000, banido = false, modelo = 'utillitruck', capacidade = 15, tipo = 'outros' },
	{ hash = -1030275036, name = 'seashark', price = 40000, banido = false, modelo = 'seashark', capacidade = 50, tipo = 'barcos' },
	{ hash = -102350751, name = 'CitroenXantia', price = 35000, banido = false, modelo = 'CitroenXantia', capacidade = 15, tipo = 'outros' },
	{ hash = -740742391, name = 'mercedesa45', price = 35000, banido = false, modelo = 'mercedesa45', capacidade = 15, tipo = 'outros' },
	{ hash = 887537515, name = 'utillitruck2', price = 25000, banido = false, modelo = 'utillitruck2', capacidade = 15, tipo = 'outros' },
	{ hash = 2132890591, name = 'utillitruck3', price = 25000, banido = false, modelo = 'utillitruck3', capacidade = 15, tipo = 'outros' },
	{ hash = -692292317, name = 'chernobog', price = 40000, banido = false, modelo = 'chernobog', capacidade = 15, tipo = 'outros' },
	{ hash = 729783779, name = 'slamvan', price = 25000, banido = false, modelo = 'slamvan', capacidade = 15, tipo = 'outros' },
	{ hash = 1131912276, name = 'BMX', price = 12000, banido = false, modelo = 'BMX', capacidade = 2, tipo = 'bike' },
	{ hash = -34623805, name = 'policeb', price = 12000, banido = false, modelo = 'policeb', capacidade = 15, tipo = 'outros' },
	{ hash = 1617472902, name = 'fagaloa', price = 25000, banido = false, modelo = 'fagaloa', capacidade = 15, tipo = 'outros' },
	{ hash = 1777363799, name = 'washington', price = 35000, banido = false, modelo = 'washington', capacidade = 15, tipo = 'outros' },
	{ hash = -2115793025, name = 'avarus', price = 12000, banido = false, modelo = 'avarus', capacidade = 20, tipo = 'motos' },
	{ hash = 65402552, name = 'youga', price = 22000, banido = false, modelo = 'youga', capacidade = 250, tipo = 'utilitario' },
	{ hash = -431692672, name = 'panto', price = 35000, banido = false, modelo = 'panto', capacidade = 15, tipo = 'outros' },
	{ hash = -1890996696, name = 'brutus2', price = 50000, banido = false, modelo = 'brutus2', capacidade = 75, tipo = 'carros' },
	{ hash = -2031627021, name = 'InQ50EauRouge', price = 35000, banido = false, modelo = 'InQ50EauRouge', capacidade = 15, tipo = 'outros' },
	{ hash = -1453280962, name = 'sanchez2', price = 12000, banido = false, modelo = 'sanchez2', capacidade = 20, tipo = 'motos' },
	{ hash = 349605904, name = 'chino', price = 150000, banido = false, modelo = 'chino', capacidade = 15, tipo = 'outros' },
	{ hash = 1127861609, name = 'tribike', price = 12000, banido = false, modelo = 'tribike', capacidade = 2, tipo = 'bike' },
	{ hash = 970385471, name = 'hydra', price = 45000, banido = false, modelo = 'hydra', capacidade = 350, tipo = 'avioes' },
	{ hash = -1775453271, name = 'tiger1200', price = 12000, banido = false, modelo = 'tiger1200', capacidade = 20, tipo = 'motos' },
	{ hash = 2025593404, name = 'cargobob4', price = 52000, banido = false, modelo = 'cargobob4', capacidade = 20, tipo = 'helicopteros' },
	{ hash = 877161841, name = 'm5', price = 35000, banido = false, modelo = 'm5', capacidade = 15, tipo = 'outros' },
	{ hash = -1233807380, name = 'tribike2', price = 12000, banido = false, modelo = 'tribike2', capacidade = 2, tipo = 'bike' },
	{ hash = -1758137366, name = 'penetrator', price = 35000, banido = false, modelo = 'penetrator', capacidade = 75, tipo = 'carros' },
	{ hash = 1488164764, name = 'paradise', price = 22000, banido = false, modelo = 'paradise', capacidade = 250, tipo = 'utilitario' },
	{ hash = 338562499, name = 'vacca', price = 35000, banido = false, modelo = 'vacca', capacidade = 75, tipo = 'carros' },
	{ hash = 1871995513, name = 'yosemite', price = 25000, banido = false, modelo = 'yosemite', capacidade = 15, tipo = 'outros' },
	{ hash = -909201658, name = 'pcj', price = 20000, banido = false, modelo = 'pcj', capacidade = 20, tipo = 'motos' },
	{ hash = 1672195559, name = 'akuma', price = 12000, banido = false, modelo = 'akuma', capacidade = 20, tipo = 'motos' },
	{ hash = 942300481, name = 'e36rb', price = 100000, banido = false, modelo = 'e36rb', capacidade = 15, tipo = 'outros' },
	{ hash = -2140431165, name = 'bagger', price = 12000, banido = false, modelo = 'bagger', capacidade = 20, tipo = 'motos' },
	{ hash = -891462355, name = 'bati2', price = 20000, banido = false, modelo = 'bati2', capacidade = 20, tipo = 'motos' },
	{ hash = -1560751994, name = 'pm19', price = 80000, banido = false, modelo = 'pm19', capacidade = 75, tipo = 'carros' },
	{ hash = 837858166, name = 'annihilator', price = 52000, banido = false, modelo = 'annihilator', capacidade = 20, tipo = 'helicopteros' },
	{ hash = 1935444402, name = 'cbb', price = 12000, banido = false, modelo = 'cbb', capacidade = 20, tipo = 'motos' },
	{ hash = -1649536104, name = 'phantom2', price = 40000, banido = false, modelo = 'phantom2', capacidade = 300, tipo = 'serviço' },
	{ hash = 2006142190, name = 'daemon', price = 12000, banido = false, modelo = 'daemon', capacidade = 20, tipo = 'motos' },
	{ hash = 454497124, name = 'sls', price = 80000, banido = false, modelo = 'sls', capacidade = 15, tipo = 'outros' },
	{ hash = 586013744, name = 'tankercar', price = 110000, banido = false, modelo = 'tankercar', capacidade = 15, tipo = 'outros' },
	{ hash = -1670998136, name = 'double', price = 20000, banido = false, modelo = 'double', capacidade = 20, tipo = 'motos' },
	{ hash = -140902153, name = 'vader', price = 12000, banido = false, modelo = 'vader', capacidade = 20, tipo = 'motos' },
	{ hash = 712162987, name = 'trailersmall', price = 40000, banido = false, modelo = 'trailersmall', capacidade = 15, tipo = 'outros' },
	{ hash = 1758465177, name = 'cls63sp', price = 25000, banido = false, modelo = 'cls63sp', capacidade = 15, tipo = 'outros' },
	{ hash = -1168952148, name = 'toros', price = 35000, banido = false, modelo = 'toros', capacidade = 15, tipo = 'outros' },
	{ hash = 55628203, name = 'faggio2', price = 12000, banido = false, modelo = 'faggio2', capacidade = 20, tipo = 'motos' },
	{ hash = 1356124575, name = 'technical3', price = 50000, banido = false, modelo = 'technical3', capacidade = 75, tipo = 'carros' },
	{ hash = 1663218586, name = 't20', price = 100000, banido = false, modelo = 't20', capacidade = 75, tipo = 'carros' },
	{ hash = 745926877, name = 'buzzard2', price = 52000, banido = false, modelo = 'buzzard2', capacidade = 20, tipo = 'helicopteros' },
	{ hash = -792745162, name = 'paramedicoambu', price = 25000, banido = false, modelo = 'paramedicoambu', capacidade = 15, tipo = 'outros' },
	{ hash = -1881846085, name = 'trailersmall2', price = 40000, banido = false, modelo = 'trailersmall2', capacidade = 15, tipo = 'outros' },
	{ hash = -50547061, name = 'cargobob', price = 52000, banido = false, modelo = 'cargobob', capacidade = 20, tipo = 'helicopteros' },
	{ hash = 1621617168, name = 'cargobob2', price = 52000, banido = false, modelo = 'cargobob2', capacidade = 20, tipo = 'helicopteros' },
	{ hash = -2042549230, name = 'slsr', price = 35000, banido = false, modelo = 'slsr', capacidade = 15, tipo = 'outros' },
	{ hash = 310284501, name = 'Dynasty', price = 70000, banido = false, modelo = 'Dynasty', capacidade = 15, tipo = 'outros' },
	{ hash = 1044954915, name = 'skylift', price = 52000, banido = false, modelo = 'skylift', capacidade = 20, tipo = 'helicopteros' },
	{ hash = -1204950406, name = 'm4cvo', price = 100000, banido = false, modelo = 'm4cvo', capacidade = 15, tipo = 'outros' },
	{ hash = 2009693397, name = 'porsche930', price = 150000, banido = false, modelo = 'porsche930', capacidade = 15, tipo = 'outros' },
	{ hash = -1639532431, name = 'GranTorSport', price = 150000, banido = false, modelo = 'GranTorSport', capacidade = 15, tipo = 'outros' },
	{ hash = 353883353, name = 'polmav', price = 52000, banido = false, modelo = 'polmav', capacidade = 20, tipo = 'helicopteros' },
	{ hash = -634879114, name = 'nemesis', price = 20000, banido = false, modelo = 'nemesis', capacidade = 20, tipo = 'motos' },
	{ hash = 744705981, name = 'frogger', price = 52000, banido = false, modelo = 'frogger', capacidade = 20, tipo = 'helicopteros' },
	{ hash = -1237253773, name = 'dubsta3', price = 50000, banido = false, modelo = 'dubsta3', capacidade = 75, tipo = 'carros' },
	{ hash = 1033245328, name = 'dinghy', price = 40000, banido = false, modelo = 'dinghy', capacidade = 50, tipo = 'barcos' },
	{ hash = 1274868363, name = 'bestiagts', price = 150000, banido = false, modelo = 'bestiagts', capacidade = 15, tipo = 'outros' },
	{ hash = 1949211328, name = 'frogger2', price = 52000, banido = false, modelo = 'frogger2', capacidade = 20, tipo = 'helicopteros' },
	{ hash = -291021213, name = 'sultan3', price = 35000, banido = false, modelo = 'sultan3', capacidade = 15, tipo = 'outros' },
	{ hash = 486987393, name = 'huntley', price = 50000, banido = false, modelo = 'huntley', capacidade = 15, tipo = 'outros' },
	{ hash = 970356638, name = 'duster', price = 45000, banido = false, modelo = 'duster', capacidade = 350, tipo = 'avioes' },
	{ hash = -110704625, name = 's10', price = 25000, banido = false, modelo = 's10', capacidade = 15, tipo = 'outros' },
	{ hash = -1746576111, name = 'mammatus', price = 45000, banido = false, modelo = 'mammatus', capacidade = 350, tipo = 'avioes' },
	{ hash = 1058115860, name = 'jet', price = 45000, banido = false, modelo = 'jet', capacidade = 350, tipo = 'avioes' },
	{ hash = 67753863, name = 'yosemite3', price = 50000, banido = false, modelo = 'yosemite3', capacidade = 75, tipo = 'carros' },
	{ hash = 1987142870, name = 'osiris', price = 35000, banido = false, modelo = 'osiris', capacidade = 75, tipo = 'carros' },
	{ hash = 2071877360, name = 'insurgent2', price = 50000, banido = false, modelo = 'insurgent2', capacidade = 75, tipo = 'carros' },
	{ hash = -122502925, name = 'cayman16', price = 35000, banido = false, modelo = 'cayman16', capacidade = 15, tipo = 'outros' },
	{ hash = 1981688531, name = 'titan', price = 45000, banido = false, modelo = 'titan', capacidade = 350, tipo = 'avioes' },
	{ hash = -1281684762, name = 'lazer', price = 45000, banido = false, modelo = 'lazer', capacidade = 350, tipo = 'avioes' },
	{ hash = -1404136503, name = 'daemon2', price = 12000, banido = false, modelo = 'daemon2', capacidade = 20, tipo = 'motos' },
	{ hash = 400514754, name = 'squalo', price = 40000, banido = false, modelo = 'squalo', capacidade = 50, tipo = 'barcos' },
	{ hash = -189485405, name = 'mers63c', price = 30000, banido = false, modelo = 'mers63c', capacidade = 15, tipo = 'outros' },
	{ hash = -1043459709, name = 'marquis', price = 40000, banido = false, modelo = 'marquis', capacidade = 50, tipo = 'barcos' },
	{ hash = -1104483164, name = 'ps30', price = 100000, banido = false, modelo = 'ps30', capacidade = 15, tipo = 'outros' },
	{ hash = -147964363, name = 'blazer41', price = 80000, banido = false, modelo = 'blazer41', capacidade = 15, tipo = 'outros' },
	{ hash = 276773164, name = 'dinghy2', price = 40000, banido = false, modelo = 'dinghy2', capacidade = 50, tipo = 'barcos' },
	{ hash = 1016357717, name = 'm4clw', price = 150000, banido = false, modelo = 'm4clw', capacidade = 15, tipo = 'outros' },
	{ hash = 2068293287, name = 'Lurcher', price = 150000, banido = false, modelo = 'Lurcher', capacidade = 15, tipo = 'outros' },
	{ hash = 861409633, name = 'jetmax', price = 40000, banido = false, modelo = 'jetmax', capacidade = 50, tipo = 'barcos' },
	{ hash = 290013743, name = 'tropic', price = 40000, banido = false, modelo = 'tropic', capacidade = 50, tipo = 'barcos' },
	{ hash = -616331036, name = 'seashark2', price = 40000, banido = false, modelo = 'seashark2', capacidade = 50, tipo = 'barcos' },
	{ hash = -326143852, name = 'dukes2', price = 150000, banido = false, modelo = 'dukes2', capacidade = 15, tipo = 'outros' },
	{ hash = 184361638, name = 'freightcar', price = 110000, banido = false, modelo = 'freightcar', capacidade = 15, tipo = 'outros' },
	{ hash = 240201337, name = 'freightcont2', price = 110000, banido = false, modelo = 'freightcont2', capacidade = 15, tipo = 'outros' },
	{ hash = 868868440, name = 'metrotrain', price = 110000, banido = false, modelo = 'metrotrain', capacidade = 15, tipo = 'outros' },
	{ hash = -1579533167, name = 'trailers2', price = 40000, banido = false, modelo = 'trailers2', capacidade = 15, tipo = 'outros' },
	{ hash = -2058878099, name = 'trailers3', price = 40000, banido = false, modelo = 'trailers3', capacidade = 15, tipo = 'outros' },
	{ hash = 390902130, name = 'raketrailer', price = 40000, banido = false, modelo = 'raketrailer', capacidade = 15, tipo = 'outros' },
	{ hash = -757735410, name = 'fcr2', price = 20000, banido = false, modelo = 'fcr2', capacidade = 20, tipo = 'motos' },
	{ hash = 627535535, name = 'fcr', price = 20000, banido = false, modelo = 'fcr', capacidade = 20, tipo = 'motos' },
	{ hash = -730904777, name = 'tanker', price = 40000, banido = false, modelo = 'tanker', capacidade = 15, tipo = 'outros' },
	{ hash = -2107990196, name = 'guardian', price = 50000, banido = false, modelo = 'guardian', capacidade = 15, tipo = 'outros' },
	{ hash = -1673356438, name = 'velum', price = 45000, banido = false, modelo = 'velum', capacidade = 350, tipo = 'avioes' },
	{ hash = -133349447, name = 'lancerevolution9', price = 25000, banido = false, modelo = 'lancerevolution9', capacidade = 15, tipo = 'outros' },
	{ hash = -482719877, name = 'italigtb2', price = 35000, banido = false, modelo = 'italigtb2', capacidade = 75, tipo = 'carros' },
	{ hash = -349601129, name = 'bifta', price = 50000, banido = false, modelo = 'bifta', capacidade = 75, tipo = 'carros' },
	{ hash = 83136452, name = 'rebla', price = 50000, banido = false, modelo = 'rebla', capacidade = 15, tipo = 'outros' },
	{ hash = -312295511, name = 'dune5', price = 35000, banido = false, modelo = 'dune5', capacidade = 75, tipo = 'carros' },
	{ hash = 231083307, name = 'speeder', price = 40000, banido = false, modelo = 'speeder', capacidade = 50, tipo = 'barcos' },
	{ hash = -1361687965, name = 'chino2', price = 150000, banido = false, modelo = 'chino2', capacidade = 15, tipo = 'outros' },
	{ hash = 1416466158, name = 'paragon2', price = 150000, banido = false, modelo = 'paragon2', capacidade = 15, tipo = 'outros' },
	{ hash = -377693317, name = 'policiaexplorer', price = 25000, banido = false, modelo = 'policiaexplorer', capacidade = 15, tipo = 'outros' },
	{ hash = -1110805140, name = 'rufrt12', price = 150000, banido = false, modelo = 'rufrt12', capacidade = 75, tipo = 'carros' },
	{ hash = 1373123368, name = 'warrener', price = 100000, banido = false, modelo = 'warrener', capacidade = 15, tipo = 'outros' },
	{ hash = 92612664, name = 'kalahari', price = 50000, banido = false, modelo = 'kalahari', capacidade = 75, tipo = 'carros' },
	{ hash = 117401876, name = 'btype', price = 70000, banido = false, modelo = 'btype', capacidade = 15, tipo = 'outros' },
	{ hash = 373261600, name = 'slamvan5', price = 30000, banido = false, modelo = 'slamvan5', capacidade = 15, tipo = 'outros' },
	{ hash = 980885719, name = 'rmodgt63', price = 55000, banido = false, modelo = 'rmodgt63', capacidade = 15, tipo = 'outros' },
	{ hash = 1515040568, name = 'audi7', price = 35000, banido = false, modelo = 'audi7', capacidade = 15, tipo = 'outros' },
	{ hash = -255678177, name = 'hakuchou2', price = 12000, banido = false, modelo = 'hakuchou2', capacidade = 20, tipo = 'motos' },
	{ hash = 1790834270, name = 'diablous2', price = 12000, banido = false, modelo = 'diablous2', capacidade = 20, tipo = 'motos' },
	{ hash = -2079788230, name = 'gt500', price = 130000, banido = false, modelo = 'gt500', capacidade = 15, tipo = 'outros' },
	{ hash = 2123327359, name = 'prototipo', price = 35000, banido = false, modelo = 'prototipo', capacidade = 75, tipo = 'carros' },
	{ hash = 1341619767, name = 'vestra', price = 45000, banido = false, modelo = 'vestra', capacidade = 350, tipo = 'avioes' },
	{ hash = 841808271, name = 'rhapsody', price = 35000, banido = false, modelo = 'rhapsody', capacidade = 15, tipo = 'outros' },
	{ hash = -1205801634, name = 'blade', price = 150000, banido = false, modelo = 'blade', capacidade = 15, tipo = 'outros' },
	{ hash = 1078682497, name = 'pigalle', price = 100000, banido = false, modelo = 'pigalle', capacidade = 15, tipo = 'outros' },
	{ hash = 743478836, name = 'sovereign', price = 12000, banido = false, modelo = 'sovereign', capacidade = 20, tipo = 'motos' },
	{ hash = -670730904, name = 'r8c', price = 80000, banido = false, modelo = 'r8c', capacidade = 15, tipo = 'outros' },
	{ hash = -1829802492, name = 'pfister811', price = 150000, banido = false, modelo = 'pfister811', capacidade = 75, tipo = 'carros' },
	{ hash = -1295027632, name = 'nimbus', price = 45000, banido = false, modelo = 'nimbus', capacidade = 350, tipo = 'avioes' },
	{ hash = 1587034546, name = 'tenere1200', price = 12000, banido = false, modelo = 'tenere1200', capacidade = 20, tipo = 'motos' },
	{ hash = 1824333165, name = 'besra', price = 45000, banido = false, modelo = 'besra', capacidade = 350, tipo = 'avioes' },
	{ hash = 1884511084, name = 'policiasilverado', price = 25000, banido = false, modelo = 'policiasilverado', capacidade = 15, tipo = 'outros' },
	{ hash = 101905590, name = 'trophytruck', price = 50000, banido = false, modelo = 'trophytruck', capacidade = 75, tipo = 'carros' },
	{ hash = 1011753235, name = 'coquette2', price = 150000, banido = false, modelo = 'coquette2', capacidade = 15, tipo = 'outros' },
	{ hash = 1265391242, name = 'hakuchou', price = 12000, banido = false, modelo = 'hakuchou', capacidade = 20, tipo = 'motos' },
	{ hash = -1842748181, name = 'faggio', price = 12000, banido = false, modelo = 'faggio', capacidade = 20, tipo = 'motos' },
	{ hash = -1089039904, name = 'furoregt', price = 150000, banido = false, modelo = 'furoregt', capacidade = 15, tipo = 'outros' },
	{ hash = -1106353882, name = 'jester2', price = 80000, banido = false, modelo = 'jester2', capacidade = 15, tipo = 'outros' },
	{ hash = -25281725, name = 'bmwr1250', price = 12000, banido = false, modelo = 'bmwr1250', capacidade = 20, tipo = 'motos' },
	{ hash = -631760477, name = 'massacro2', price = 35000, banido = false, modelo = 'massacro2', capacidade = 15, tipo = 'outros' },
	{ hash = 941800958, name = 'casco', price = 130000, banido = false, modelo = 'casco', capacidade = 15, tipo = 'outros' },
	{ hash = 1802742206, name = 'youga3', price = 22000, banido = false, modelo = 'youga3', capacidade = 250, tipo = 'utilitario' },
	{ hash = 444171386, name = 'boxville4', price = 25000, banido = false, modelo = 'boxville4', capacidade = 250, tipo = 'utilitario' },
	{ hash = -1860900134, name = 'insurgent', price = 50000, banido = false, modelo = 'insurgent', capacidade = 75, tipo = 'carros' },
	{ hash = 1180875963, name = 'technical2', price = 50000, banido = false, modelo = 'technical2', capacidade = 75, tipo = 'carros' },
	{ hash = -32236122, name = 'halftrack', price = 40000, banido = false, modelo = 'halftrack', capacidade = 15, tipo = 'outros' },
	{ hash = -2015218779, name = 'nissan370z', price = 25000, banido = false, modelo = 'nissan370z', capacidade = 15, tipo = 'outros' },
	{ hash = -2111081553, name = 'fibc', price = 25000, banido = false, modelo = 'fibc', capacidade = 15, tipo = 'outros' },
	{ hash = 296357396, name = 'gburrito2', price = 22000, banido = false, modelo = 'gburrito2', capacidade = 250, tipo = 'utilitario' },
	{ hash = -362150785, name = 'hellion', price = 50000, banido = false, modelo = 'hellion', capacidade = 75, tipo = 'carros' },
	{ hash = 509498602, name = 'dinghy3', price = 40000, banido = false, modelo = 'dinghy3', capacidade = 50, tipo = 'barcos' },
	{ hash = 1753414259, name = 'enduro', price = 12000, banido = false, modelo = 'enduro', capacidade = 20, tipo = 'motos' },
	{ hash = 640818791, name = 'lectro', price = 20000, banido = false, modelo = 'lectro', capacidade = 20, tipo = 'motos' },
	{ hash = 1180358231, name = 's15varietta', price = 150000, banido = false, modelo = 's15varietta', capacidade = 15, tipo = 'outros' },
	{ hash = -1372848492, name = 'kuruma', price = 35000, banido = false, modelo = 'kuruma', capacidade = 15, tipo = 'outros' },
	{ hash = -664141241, name = 'krieger', price = 35000, banido = false, modelo = 'krieger', capacidade = 75, tipo = 'carros' },
	{ hash = -434021124, name = 'gsxc110', price = 150000, banido = false, modelo = 'gsxc110', capacidade = 15, tipo = 'outros' },
	{ hash = 1969115674, name = 'e60', price = 35000, banido = false, modelo = 'e60', capacidade = 15, tipo = 'outros' },
	{ hash = 410882957, name = 'kuruma2', price = 35000, banido = false, modelo = 'kuruma2', capacidade = 15, tipo = 'outros' },
	{ hash = -663299102, name = 'trophytruck2', price = 50000, banido = false, modelo = 'trophytruck2', capacidade = 75, tipo = 'carros' },
	{ hash = -861217386, name = 'amels200', price = 40000, banido = false, modelo = 'amels200', capacidade = 50, tipo = 'barcos' },
	{ hash = -1255698084, name = 'trash2', price = 40000, banido = false, modelo = 'trash2', capacidade = 15, tipo = 'outros' },
	{ hash = -1293924613, name = 'dominator6', price = 150000, banido = false, modelo = 'dominator6', capacidade = 15, tipo = 'outros' },
	{ hash = -1756021720, name = 'everon', price = 50000, banido = false, modelo = 'everon', capacidade = 75, tipo = 'carros' },
	{ hash = -114627507, name = 'limo2', price = 35000, banido = false, modelo = 'limo2', capacidade = 15, tipo = 'outros' },
	{ hash = 404106581, name = 'rmodbentley1', price = 35000, banido = false, modelo = 'rmodbentley1', capacidade = 75, tipo = 'carros' },
	{ hash = 422090481, name = 'rmodrs6', price = 35000, banido = false, modelo = 'rmodrs6', capacidade = 15, tipo = 'outros' },
	{ hash = -1600252419, name = 'valkyrie', price = 52000, banido = false, modelo = 'valkyrie', capacidade = 20, tipo = 'helicopteros' },
	{ hash = -1478704292, name = 'zr3803', price = 150000, banido = false, modelo = 'zr3803', capacidade = 15, tipo = 'outros' },
	{ hash = 1075432268, name = 'swift2', price = 52000, banido = false, modelo = 'swift2', capacidade = 20, tipo = 'helicopteros' },
	{ hash = -1214293858, name = 'luxor2', price = 45000, banido = false, modelo = 'luxor2', capacidade = 350, tipo = 'avioes' },
	{ hash = -1566741232, name = 'feltzer3', price = 30000, banido = false, modelo = 'feltzer3', capacidade = 15, tipo = 'outros' },
	{ hash = 1241978166, name = 'macan', price = 35000, banido = false, modelo = 'macan', capacidade = 15, tipo = 'outros' },
	{ hash = 682434785, name = 'boxville5', price = 25000, banido = false, modelo = 'boxville5', capacidade = 250, tipo = 'utilitario' },
	{ hash = 1611501436, name = 'policiavictoria', price = 25000, banido = false, modelo = 'policiavictoria', capacidade = 15, tipo = 'outros' },
	{ hash = -498054846, name = 'virgo', price = 150000, banido = false, modelo = 'virgo', capacidade = 15, tipo = 'outros' },
	{ hash = 1120271089, name = 'PolVauxhAstra', price = 35000, banido = false, modelo = 'PolVauxhAstra', capacidade = 15, tipo = 'outros' },
	{ hash = 1581459400, name = 'windsor', price = 25000, banido = false, modelo = 'windsor', capacidade = 15, tipo = 'outros' },
	{ hash = -1353081087, name = 'vindicator', price = 12000, banido = false, modelo = 'vindicator', capacidade = 20, tipo = 'motos' },
	{ hash = 86520421, name = 'bf400', price = 12000, banido = false, modelo = 'bf400', capacidade = 20, tipo = 'motos' },
	{ hash = -1479664699, name = 'brawler', price = 50000, banido = false, modelo = 'brawler', capacidade = 75, tipo = 'carros' },
	{ hash = 1923400478, name = 'stalion', price = 150000, banido = false, modelo = 'stalion', capacidade = 15, tipo = 'outros' },
	{ hash = -1071380347, name = 'tampa2', price = 150000, banido = false, modelo = 'tampa2', capacidade = 15, tipo = 'outros' },
	{ hash = 1070967343, name = 'toro', price = 40000, banido = false, modelo = 'toro', capacidade = 50, tipo = 'barcos' },
	{ hash = 1416471345, name = 'previon', price = 100000, banido = false, modelo = 'previon', capacidade = 15, tipo = 'outros' },
	{ hash = -1790546981, name = 'faction2', price = 150000, banido = false, modelo = 'faction2', capacidade = 15, tipo = 'outros' },
	{ hash = 653510754, name = 'hondafk8', price = 25000, banido = false, modelo = 'hondafk8', capacidade = 15, tipo = 'outros' },
	{ hash = 525509695, name = 'moonbeam', price = 50000, banido = false, modelo = 'moonbeam', capacidade = 15, tipo = 'outros' },
	{ hash = 1896491931, name = 'moonbeam2', price = 50000, banido = false, modelo = 'moonbeam2', capacidade = 15, tipo = 'outros' },
	{ hash = -631322662, name = 'penumbra2', price = 150000, banido = false, modelo = 'penumbra2', capacidade = 15, tipo = 'outros' },
	{ hash = -2022483795, name = 'comet3', price = 150000, banido = false, modelo = 'comet3', capacidade = 15, tipo = 'outros' },
	{ hash = -148915999, name = 'mustangmach1', price = 150000, banido = false, modelo = 'mustangmach1', capacidade = 15, tipo = 'outros' },
	{ hash = 1934384720, name = 'gauntlet4', price = 35000, banido = false, modelo = 'gauntlet4', capacidade = 15, tipo = 'outros' },
	{ hash = -2040426790, name = 'primo2', price = 35000, banido = false, modelo = 'primo2', capacidade = 15, tipo = 'outros' },
	{ hash = -1507230520, name = 'futo2', price = 35000, banido = false, modelo = 'futo2', capacidade = 15, tipo = 'outros' },
	{ hash = 1074745671, name = 'specter2', price = 150000, banido = false, modelo = 'specter2', capacidade = 15, tipo = 'outros' },
	{ hash = -1013450936, name = 'buccaneer2', price = 150000, banido = false, modelo = 'buccaneer2', capacidade = 15, tipo = 'outros' },
	{ hash = -137654139, name = 'Wrc63s', price = 35000, banido = false, modelo = 'Wrc63s', capacidade = 15, tipo = 'outros' },
	{ hash = 2006667053, name = 'voodoo', price = 25000, banido = false, modelo = 'voodoo', capacidade = 15, tipo = 'outros' },
	{ hash = -546692846, name = 'm4cg83', price = 35000, banido = false, modelo = 'm4cg83', capacidade = 15, tipo = 'outros' },
	{ hash = 1502869817, name = 'trailerlarge', price = 40000, banido = false, modelo = 'trailerlarge', capacidade = 15, tipo = 'outros' },
	{ hash = -831834716, name = 'btype2', price = 70000, banido = false, modelo = 'btype2', capacidade = 15, tipo = 'outros' },
	{ hash = 906642318, name = 'cog55', price = 25000, banido = false, modelo = 'cog55', capacidade = 15, tipo = 'outros' },
	{ hash = -1943285540, name = 'nightshade', price = 130000, banido = false, modelo = 'nightshade', capacidade = 15, tipo = 'outros' },
	{ hash = -1757836725, name = 'seven70', price = 150000, banido = false, modelo = 'seven70', capacidade = 15, tipo = 'outros' },
	{ hash = 58503902, name = 'raiocb500x', price = 20000, banido = false, modelo = 'raiocb500x', capacidade = 15, tipo = 'outros' },
	{ hash = -304009394, name = 'ktmx', price = 150000, banido = false, modelo = 'ktmx', capacidade = 15, tipo = 'outros' },
	{ hash = -1660945322, name = 'mamba', price = 150000, banido = false, modelo = 'mamba', capacidade = 15, tipo = 'outros' },
	{ hash = -1485523546, name = 'schafter3', price = 35000, banido = false, modelo = 'schafter3', capacidade = 15, tipo = 'outros' },
	{ hash = -1930048799, name = 'windsor2', price = 25000, banido = false, modelo = 'windsor2', capacidade = 15, tipo = 'outros' },
	{ hash = -1193912403, name = 'calico', price = 35000, banido = false, modelo = 'calico', capacidade = 15, tipo = 'outros' },
	{ hash = -888242983, name = 'schafter5', price = 35000, banido = false, modelo = 'schafter5', capacidade = 15, tipo = 'outros' },
	{ hash = 1118611807, name = 'asbo', price = 150000, banido = false, modelo = 'asbo', capacidade = 15, tipo = 'outros' },
	{ hash = 1922255844, name = 'schafter6', price = 35000, banido = false, modelo = 'schafter6', capacidade = 15, tipo = 'outros' },
	{ hash = 704435172, name = 'cog552', price = 25000, banido = false, modelo = 'cog552', capacidade = 15, tipo = 'outros' },
	{ hash = -2030171296, name = 'cognoscenti', price = 25000, banido = false, modelo = 'cognoscenti', capacidade = 15, tipo = 'outros' },
	{ hash = -2083226181, name = 'raiosprinter', price = 40000, banido = false, modelo = 'raiosprinter', capacidade = 15, tipo = 'outros' },
	{ hash = -604842630, name = 'cognoscenti2', price = 25000, banido = false, modelo = 'cognoscenti2', capacidade = 15, tipo = 'outros' },
	{ hash = -2122646867, name = 'gauntlet5', price = 25000, banido = false, modelo = 'gauntlet5', capacidade = 15, tipo = 'outros' },
	{ hash = -722708199, name = 'VRrs6av', price = 80000, banido = false, modelo = 'VRrs6av', capacidade = 15, tipo = 'outros' },
	{ hash = 2035069708, name = 'esskey', price = 12000, banido = false, modelo = 'esskey', capacidade = 20, tipo = 'motos' },
	{ hash = 1878062887, name = 'baller3', price = 50000, banido = false, modelo = 'baller3', capacidade = 15, tipo = 'outros' },
	{ hash = -1540373595, name = 'vectre', price = 35000, banido = false, modelo = 'vectre', capacidade = 15, tipo = 'outros' },
	{ hash = -32878452, name = 'bombushka', price = 45000, banido = false, modelo = 'bombushka', capacidade = 350, tipo = 'avioes' },
	{ hash = 634118882, name = 'baller4', price = 50000, banido = false, modelo = 'baller4', capacidade = 15, tipo = 'outros' },
	{ hash = -102335483, name = 'squaddie', price = 50000, banido = false, modelo = 'squaddie', capacidade = 15, tipo = 'outros' },
	{ hash = 470404958, name = 'baller5', price = 50000, banido = false, modelo = 'baller5', capacidade = 15, tipo = 'outros' },
	{ hash = -214906006, name = 'jester3', price = 80000, banido = false, modelo = 'jester3', capacidade = 15, tipo = 'outros' },
	{ hash = 666166960, name = 'baller6', price = 50000, banido = false, modelo = 'baller6', capacidade = 15, tipo = 'outros' },
	{ hash = 867467158, name = 'dinghy4', price = 40000, banido = false, modelo = 'dinghy4', capacidade = 50, tipo = 'barcos' },
	{ hash = 719660200, name = 'ruston', price = 150000, banido = false, modelo = 'ruston', capacidade = 15, tipo = 'outros' },
	{ hash = 1448677353, name = 'tropic2', price = 40000, banido = false, modelo = 'tropic2', capacidade = 50, tipo = 'barcos' },
	{ hash = -1671539132, name = 'supervolito2', price = 52000, banido = false, modelo = 'supervolito2', capacidade = 20, tipo = 'helicopteros' },
	{ hash = 1543134283, name = 'valkyrie2', price = 52000, banido = false, modelo = 'valkyrie2', capacidade = 20, tipo = 'helicopteros' },
	{ hash = 589099944, name = 'policiaschaftersid', price = 25000, banido = false, modelo = 'policiaschaftersid', capacidade = 15, tipo = 'outros' },
	{ hash = 633712403, name = 'banshee2', price = 150000, banido = false, modelo = 'banshee2', capacidade = 75, tipo = 'carros' },
	{ hash = -2039755226, name = 'faction3', price = 150000, banido = false, modelo = 'faction3', capacidade = 15, tipo = 'outros' },
	{ hash = 1518335526, name = 'coop12', price = 35000, banido = false, modelo = 'coop12', capacidade = 75, tipo = 'carros' },
	{ hash = -1126264336, name = 'minivan2', price = 50000, banido = false, modelo = 'minivan2', capacidade = 250, tipo = 'utilitario' },
	{ hash = -1797613329, name = 'tornado5', price = 25000, banido = false, modelo = 'tornado5', capacidade = 15, tipo = 'outros' },
	{ hash = -899509638, name = 'virgo2', price = 150000, banido = false, modelo = 'virgo2', capacidade = 15, tipo = 'outros' },
	{ hash = 1897985918, name = 'Imola', price = 50000, banido = false, modelo = 'Imola', capacidade = 75, tipo = 'carros' },
	{ hash = 1203490606, name = 'xls', price = 50000, banido = false, modelo = 'xls', capacidade = 15, tipo = 'outros' },
	{ hash = -432008408, name = 'xls2', price = 50000, banido = false, modelo = 'xls2', capacidade = 15, tipo = 'outros' },
	{ hash = -1343533670, name = 'ars3spxxbk', price = 25000, banido = false, modelo = 'ars3spxxbk', capacidade = 15, tipo = 'outros' },
	{ hash = 1426219628, name = 'fmj', price = 35000, banido = false, modelo = 'fmj', capacidade = 75, tipo = 'carros' },
	{ hash = 1475773103, name = 'rumpo3', price = 50000, banido = false, modelo = 'rumpo3', capacidade = 250, tipo = 'utilitario' },
	{ hash = -1845487887, name = 'volatus', price = 52000, banido = false, modelo = 'volatus', capacidade = 20, tipo = 'helicopteros' },
	{ hash = -1267543371, name = 'ellie', price = 100000, banido = false, modelo = 'ellie', capacidade = 15, tipo = 'outros' },
	{ hash = 234062309, name = 'reaper', price = 35000, banido = false, modelo = 'reaper', capacidade = 75, tipo = 'carros' },
	{ hash = 829927215, name = 'rampage10', price = 25000, banido = false, modelo = 'rampage10', capacidade = 15, tipo = 'outros' },
	{ hash = 1724037436, name = 'shelbygt500', price = 35000, banido = false, modelo = 'shelbygt500', capacidade = 15, tipo = 'outros' },
	{ hash = -2100640717, name = 'tug', price = 40000, banido = false, modelo = 'tug', capacidade = 50, tipo = 'barcos' },
	{ hash = -239841468, name = 'diablous', price = 12000, banido = false, modelo = 'diablous', capacidade = 20, tipo = 'motos' },
	{ hash = -2132228472, name = 'VolSantana', price = 35000, banido = false, modelo = 'VolSantana', capacidade = 15, tipo = 'outros' },
	{ hash = -777172681, name = 'omnis', price = 35000, banido = false, modelo = 'omnis', capacidade = 15, tipo = 'outros' },
	{ hash = 2044516786, name = 'vectraa', price = 50000, banido = false, modelo = 'vectraa', capacidade = 15, tipo = 'outros' },
	{ hash = 779670699, name = 'cv8', price = 35000, banido = false, modelo = 'cv8', capacidade = 15, tipo = 'outros' },
	{ hash = -1232836011, name = 'le7b', price = 35000, banido = false, modelo = 'le7b', capacidade = 75, tipo = 'carros' },
	{ hash = 312725444, name = 'blazerpolicia', price = 25000, banido = false, modelo = 'blazerpolicia', capacidade = 15, tipo = 'outros' },
	{ hash = -2103821244, name = 'rallytruck', price = 40000, banido = false, modelo = 'rallytruck', capacidade = 15, tipo = 'outros' },
	{ hash = 390201602, name = 'cliffhanger', price = 12000, banido = false, modelo = 'cliffhanger', capacidade = 20, tipo = 'motos' },
	{ hash = 1887331236, name = 'tropos', price = 150000, banido = false, modelo = 'tropos', capacidade = 15, tipo = 'outros' },
	{ hash = -217120366, name = 'pcx', price = 12000, banido = false, modelo = 'pcx', capacidade = 20, tipo = 'motos' },
	{ hash = 1549126457, name = 'brioso', price = 35000, banido = false, modelo = 'brioso', capacidade = 15, tipo = 'outros' },
	{ hash = 1402024844, name = 'bbentayga', price = 50000, banido = false, modelo = 'bbentayga', capacidade = 15, tipo = 'outros' },
	{ hash = -1558399629, name = 'tornado6', price = 25000, banido = false, modelo = 'tornado6', capacidade = 15, tipo = 'outros' },
	{ hash = -1694081890, name = 'bruiser2', price = 40000, banido = false, modelo = 'bruiser2', capacidade = 75, tipo = 'carros' },
	{ hash = 1542143200, name = 'scarab2', price = 40000, banido = false, modelo = 'scarab2', capacidade = 15, tipo = 'outros' },
	{ hash = 6774487, name = 'chimera', price = 12000, banido = false, modelo = 'chimera', capacidade = 20, tipo = 'motos' },
	{ hash = -674927303, name = 'raptor', price = 12000, banido = false, modelo = 'raptor', capacidade = 15, tipo = 'outros' },
	{ hash = -609625092, name = 'vortex', price = 20000, banido = false, modelo = 'vortex', capacidade = 20, tipo = 'motos' },
	{ hash = 1491277511, name = 'sanctus', price = 12000, banido = false, modelo = 'sanctus', capacidade = 20, tipo = 'motos' },
	{ hash = 1306282923, name = 'bmwm1wb', price = 35000, banido = false, modelo = 'bmwm1wb', capacidade = 15, tipo = 'outros' },
	{ hash = -1606187161, name = 'nightblade', price = 12000, banido = false, modelo = 'nightblade', capacidade = 20, tipo = 'motos' },
	{ hash = -1009268949, name = 'zombiea', price = 12000, banido = false, modelo = 'zombiea', capacidade = 20, tipo = 'motos' },
	{ hash = 1862852760, name = 'raioc63s', price = 35000, banido = false, modelo = 'raioc63s', capacidade = 15, tipo = 'outros' },
	{ hash = -570033273, name = 'zombieb', price = 12000, banido = false, modelo = 'zombieb', capacidade = 20, tipo = 'motos' },
	{ hash = 822018448, name = 'defiler', price = 20000, banido = false, modelo = 'defiler', capacidade = 20, tipo = 'motos' },
	{ hash = -1726022652, name = 'comet6', price = 35000, banido = false, modelo = 'comet6', capacidade = 15, tipo = 'outros' },
	{ hash = 1499053460, name = 'ageraone', price = 35000, banido = false, modelo = 'ageraone', capacidade = 75, tipo = 'carros' },
	{ hash = 1873600305, name = 'ratbike', price = 12000, banido = false, modelo = 'ratbike', capacidade = 20, tipo = 'motos' },
	{ hash = -405626514, name = 'shotaro', price = 20000, banido = false, modelo = 'shotaro', capacidade = 20, tipo = 'motos' },
	{ hash = 190050336, name = '991turbos', price = 80000, banido = false, modelo = '991turbos', capacidade = 75, tipo = 'carros' },
	{ hash = 321186144, name = 'stafford', price = 70000, banido = false, modelo = 'stafford', capacidade = 15, tipo = 'outros' },
	{ hash = -1523428744, name = 'manchez', price = 12000, banido = false, modelo = 'manchez', capacidade = 20, tipo = 'motos' },
	{ hash = 15219735, name = 'hermes', price = 25000, banido = false, modelo = 'hermes', capacidade = 15, tipo = 'outros' },
	{ hash = -440768424, name = 'blazer4', price = 12000, banido = false, modelo = 'blazer4', capacidade = 75, tipo = 'carros' },
	{ hash = 1755697647, name = 'cypher', price = 35000, banido = false, modelo = 'cypher', capacidade = 15, tipo = 'outros' },
	{ hash = -1852940307, name = 'DB5', price = 150000, banido = false, modelo = 'DB5', capacidade = 15, tipo = 'outros' },
	{ hash = 272929391, name = 'tempesta', price = 35000, banido = false, modelo = 'tempesta', capacidade = 75, tipo = 'carros' },
	{ hash = -980573366, name = 'dinghy5', price = 40000, banido = false, modelo = 'dinghy5', capacidade = 50, tipo = 'barcos' },
	{ hash = -2048333973, name = 'italigtb', price = 35000, banido = false, modelo = 'italigtb', capacidade = 75, tipo = 'carros' },
	{ hash = 1093792632, name = 'nero2', price = 80000, banido = false, modelo = 'nero2', capacidade = 75, tipo = 'carros' },
	{ hash = 1886268224, name = 'specter', price = 150000, banido = false, modelo = 'specter', capacidade = 15, tipo = 'outros' },
	{ hash = 1743739647, name = 'policiacharger2018', price = 25000, banido = false, modelo = 'policiacharger2018', capacidade = 15, tipo = 'outros' },
	{ hash = -827162039, name = 'dune4', price = 35000, banido = false, modelo = 'dune4', capacidade = 75, tipo = 'carros' },
	{ hash = 840387324, name = 'monster4', price = 500000, banido = false, modelo = 'monster4', capacidade = 75, tipo = 'carros' },
	{ hash = -1912017790, name = 'wastelander', price = 40000, banido = false, modelo = 'wastelander', capacidade = 15, tipo = 'outros' },
	{ hash = 273298191, name = 'raioa45', price = 35000, banido = false, modelo = 'raioa45', capacidade = 15, tipo = 'outros' },
	{ hash = 105975541, name = '570S', price = 150000, banido = false, modelo = '570S', capacidade = 75, tipo = 'carros' },
	{ hash = 1114244595, name = 'lamborghinihuracan', price = 25000, banido = false, modelo = 'lamborghinihuracan', capacidade = 15, tipo = 'outros' },
	{ hash = 777714999, name = 'ruiner3', price = 150000, banido = false, modelo = 'ruiner3', capacidade = 15, tipo = 'outros' },
	{ hash = -982130927, name = 'turismo2', price = 100000, banido = false, modelo = 'turismo2', capacidade = 15, tipo = 'outros' },
	{ hash = -1405937764, name = 'infernus2', price = 100000, banido = false, modelo = 'infernus2', capacidade = 15, tipo = 'outros' },
	{ hash = 1234311532, name = 'gp1', price = 35000, banido = false, modelo = 'gp1', capacidade = 75, tipo = 'carros' },
	{ hash = -1620126302, name = 'neo', price = 35000, banido = false, modelo = 'neo', capacidade = 15, tipo = 'outros' },
	{ hash = -1100548694, name = 'trailers4', price = 40000, banido = false, modelo = 'trailers4', capacidade = 15, tipo = 'outros' },
	{ hash = 917809321, name = 'xa21', price = 35000, banido = false, modelo = 'xa21', capacidade = 75, tipo = 'carros' },
	{ hash = 1939284556, name = 'vagner', price = 35000, banido = false, modelo = 'vagner', capacidade = 75, tipo = 'carros' },
	{ hash = -593918361, name = 'lex570', price = 35000, banido = false, modelo = 'lex570', capacidade = 15, tipo = 'outros' },
	{ hash = -1924433270, name = 'insurgent3', price = 50000, banido = false, modelo = 'insurgent3', capacidade = 75, tipo = 'carros' },
	{ hash = -579747861, name = 'scarab3', price = 40000, banido = false, modelo = 'scarab3', capacidade = 15, tipo = 'outros' },
	{ hash = 562680400, name = 'apc', price = 50000, banido = false, modelo = 'apc', capacidade = 15, tipo = 'outros' },
	{ hash = -591651781, name = 'blista3', price = 35000, banido = false, modelo = 'blista3', capacidade = 15, tipo = 'outros' },
	{ hash = 1074972263, name = 'rmodmonsterr34', price = 500000, banido = false, modelo = 'rmodmonsterr34', capacidade = 15, tipo = 'outros' },
	{ hash = 1897744184, name = 'dune3', price = 50000, banido = false, modelo = 'dune3', capacidade = 75, tipo = 'carros' },
	{ hash = 159274291, name = 'ardent', price = 150000, banido = false, modelo = 'ardent', capacidade = 15, tipo = 'outros' },
	{ hash = -392675425, name = 'seabreeze', price = 45000, banido = false, modelo = 'seabreeze', capacidade = 350, tipo = 'avioes' },
	{ hash = -894549536, name = 'pct18', price = 25000, banido = false, modelo = 'pct18', capacidade = 15, tipo = 'outros' },
	{ hash = 1043222410, name = 'tula', price = 45000, banido = false, modelo = 'tula', capacidade = 350, tipo = 'avioes' },
	{ hash = 468704959, name = 'levante', price = 50000, banido = false, modelo = 'levante', capacidade = 15, tipo = 'outros' },
	{ hash = -213537235, name = 'rcf', price = 35000, banido = false, modelo = 'rcf', capacidade = 15, tipo = 'outros' },
	{ hash = -1984275979, name = 'havok', price = 52000, banido = false, modelo = 'havok', capacidade = 20, tipo = 'helicopteros' },
	{ hash = -42959138, name = 'hunter', price = 52000, banido = false, modelo = 'hunter', capacidade = 20, tipo = 'helicopteros' },
	{ hash = -1763555241, name = 'microlight', price = 45000, banido = false, modelo = 'microlight', capacidade = 350, tipo = 'avioes' },
	{ hash = 1492612435, name = 'openwheel1', price = 35000, banido = false, modelo = 'openwheel1', capacidade = 15, tipo = 'outros' },
	{ hash = -779026432, name = 'romeo155', price = 35000, banido = false, modelo = 'romeo155', capacidade = 75, tipo = 'carros' },
	{ hash = -975345305, name = 'rogue', price = 45000, banido = false, modelo = 'rogue', capacidade = 350, tipo = 'avioes' },
	{ hash = 1909189272, name = 'gb200', price = 35000, banido = false, modelo = 'gb200', capacidade = 15, tipo = 'outros' },
	{ hash = -1414722888, name = 'rmodp1gtr', price = 150000, banido = false, modelo = 'rmodp1gtr', capacidade = 75, tipo = 'carros' },
	{ hash = -1386191424, name = 'pyro', price = 45000, banido = false, modelo = 'pyro', capacidade = 350, tipo = 'avioes' },
	{ hash = 2014313426, name = 'vetir', price = 40000, banido = false, modelo = 'vetir', capacidade = 15, tipo = 'outros' },
	{ hash = -1007528109, name = 'howard', price = 45000, banido = false, modelo = 'howard', capacidade = 350, tipo = 'avioes' },
	{ hash = -401643538, name = 'stalion2', price = 150000, banido = false, modelo = 'stalion2', capacidade = 15, tipo = 'outros' },
	{ hash = -749299473, name = 'mogul', price = 45000, banido = false, modelo = 'mogul', capacidade = 350, tipo = 'avioes' },
	{ hash = -1700874274, name = 'starling', price = 45000, banido = false, modelo = 'starling', capacidade = 350, tipo = 'avioes' },
	{ hash = 59283201, name = 'porsche911', price = 150000, banido = false, modelo = 'porsche911', capacidade = 75, tipo = 'carros' },
	{ hash = 1036591958, name = 'nokota', price = 45000, banido = false, modelo = 'nokota', capacidade = 350, tipo = 'avioes' },
	{ hash = 1565978651, name = 'molotok', price = 45000, banido = false, modelo = 'molotok', capacidade = 350, tipo = 'avioes' },
	{ hash = 1841130506, name = 'retinue', price = 150000, banido = false, modelo = 'retinue', capacidade = 15, tipo = 'outros' },
	{ hash = 1392481335, name = 'cyclone', price = 35000, banido = false, modelo = 'cyclone', capacidade = 75, tipo = 'carros' },
	{ hash = -391595372, name = 'viseris', price = 150000, banido = false, modelo = 'viseris', capacidade = 15, tipo = 'outros' },
	{ hash = 661493923, name = 'comet5', price = 150000, banido = false, modelo = 'comet5', capacidade = 15, tipo = 'outros' },
	{ hash = -1532697517, name = 'riata', price = 50000, banido = false, modelo = 'riata', capacidade = 75, tipo = 'carros' },
	{ hash = -1745789659, name = 'FK8', price = 35000, banido = false, modelo = 'FK8', capacidade = 15, tipo = 'outros' },
	{ hash = -313185164, name = 'autarch', price = 35000, banido = false, modelo = 'autarch', capacidade = 75, tipo = 'carros' },
	{ hash = 903794909, name = 'savestra', price = 150000, banido = false, modelo = 'savestra', capacidade = 15, tipo = 'outros' },
	{ hash = -100632271, name = 'Wrr1200p', price = 20000, banido = false, modelo = 'Wrr1200p', capacidade = 15, tipo = 'outros' },
	{ hash = 1561920505, name = 'comet4', price = 150000, banido = false, modelo = 'comet4', capacidade = 15, tipo = 'outros' },
	{ hash = 1349705610, name = 'f12ber', price = 35000, banido = false, modelo = 'f12ber', capacidade = 15, tipo = 'outros' },
	{ hash = -1848994066, name = 'neon', price = 35000, banido = false, modelo = 'neon', capacidade = 15, tipo = 'outros' },
	{ hash = 1104234922, name = 'sentinel3', price = 150000, banido = false, modelo = 'sentinel3', capacidade = 15, tipo = 'outros' },
	{ hash = -1435527158, name = 'khanjali', price = 40000, banido = false, modelo = 'khanjali', capacidade = 15, tipo = 'outros' },
	{ hash = 447548909, name = 'volatol', price = 45000, banido = false, modelo = 'volatol', capacidade = 350, tipo = 'avioes' },
	{ hash = 1181327175, name = 'akula', price = 52000, banido = false, modelo = 'akula', capacidade = 20, tipo = 'helicopteros' },
	{ hash = -654239719, name = 'agerars', price = 35000, banido = false, modelo = 'agerars', capacidade = 75, tipo = 'carros' },
	{ hash = 1483171323, name = 'deluxo', price = 150000, banido = false, modelo = 'deluxo', capacidade = 15, tipo = 'outros' },
	{ hash = -192929549, name = 'audirs7', price = 35000, banido = false, modelo = 'audirs7', capacidade = 15, tipo = 'outros' },
	{ hash = 1926754052, name = 'carbonssd', price = 20000, banido = false, modelo = 'carbonssd', capacidade = 15, tipo = 'outros' },
	{ hash = 886810209, name = 'stromberg', price = 35000, banido = false, modelo = 'stromberg', capacidade = 15, tipo = 'outros' },
	{ hash = -1693015116, name = 'riot2', price = 40000, banido = false, modelo = 'riot2', capacidade = 15, tipo = 'outros' },
	{ hash = -2118308144, name = 'avenger', price = 45000, banido = false, modelo = 'avenger', capacidade = 350, tipo = 'avioes' },
	{ hash = 408970549, name = 'avenger2', price = 45000, banido = false, modelo = 'avenger2', capacidade = 350, tipo = 'avioes' },
	{ hash = -1960756985, name = 'formula2', price = 35000, banido = false, modelo = 'formula2', capacidade = 15, tipo = 'outros' },
	{ hash = -475284513, name = 'f800', price = 12000, banido = false, modelo = 'f800', capacidade = 20, tipo = 'motos' },
	{ hash = 1489874736, name = 'thruster', price = 52000, banido = false, modelo = 'thruster', capacidade = 15, tipo = 'outros' },
	{ hash = -1374500452, name = 'deathbike3', price = 12000, banido = false, modelo = 'deathbike3', capacidade = 20, tipo = 'motos' },
	{ hash = 1741861769, name = 'streiter', price = 150000, banido = false, modelo = 'streiter', capacidade = 15, tipo = 'outros' },
	{ hash = 541729238, name = 'rmodm4', price = 35000, banido = false, modelo = 'rmodm4', capacidade = 75, tipo = 'carros' },
	{ hash = 867799010, name = 'pariah', price = 150000, banido = false, modelo = 'pariah', capacidade = 15, tipo = 'outros' },
	{ hash = -121446169, name = 'kamacho', price = 50000, banido = false, modelo = 'kamacho', capacidade = 75, tipo = 'carros' },
	{ hash = -2120700196, name = 'entity2', price = 35000, banido = false, modelo = 'entity2', capacidade = 75, tipo = 'carros' },
	{ hash = 1377217886, name = 'remus', price = 35000, banido = false, modelo = 'remus', capacidade = 15, tipo = 'outros' },
	{ hash = -988501280, name = 'cheburek', price = 150000, banido = false, modelo = 'cheburek', capacidade = 15, tipo = 'outros' },
	{ hash = -565856814, name = 'c10custom', price = 25000, banido = false, modelo = 'c10custom', capacidade = 15, tipo = 'outros' },
	{ hash = -1924800695, name = 'impaler3', price = 30000, banido = false, modelo = 'impaler3', capacidade = 15, tipo = 'outros' },
	{ hash = 540101442, name = 'zr380', price = 150000, banido = false, modelo = 'zr380', capacidade = 15, tipo = 'outros' },
	{ hash = 1769548661, name = 'c63w205', price = 35000, banido = false, modelo = 'c63w205', capacidade = 15, tipo = 'outros' },
	{ hash = 1254014755, name = 'caracara', price = 50000, banido = false, modelo = 'caracara', capacidade = 75, tipo = 'carros' },
	{ hash = 1115909093, name = 'hotring', price = 100000, banido = false, modelo = 'hotring', capacidade = 15, tipo = 'outros' },
	{ hash = -726768679, name = 'seasparrow', price = 52000, banido = false, modelo = 'seasparrow', capacidade = 20, tipo = 'helicopteros' },
	{ hash = -1196497151, name = 'FordGTMkIV', price = 130000, banido = false, modelo = 'FordGTMkIV', capacidade = 15, tipo = 'outros' },
	{ hash = 1262656434, name = '19gt500', price = 80000, banido = false, modelo = '19gt500', capacidade = 15, tipo = 'outros' },
	{ hash = 1046206681, name = 'michelli', price = 130000, banido = false, modelo = 'michelli', capacidade = 15, tipo = 'outros' },
	{ hash = -986944621, name = 'dominator3', price = 100000, banido = false, modelo = 'dominator3', capacidade = 15, tipo = 'outros' },
	{ hash = 1031562256, name = 'tezeract', price = 35000, banido = false, modelo = 'tezeract', capacidade = 75, tipo = 'carros' },
	{ hash = 931280609, name = 'issi3', price = 52000, banido = false, modelo = 'issi3', capacidade = 15, tipo = 'outros' },
	{ hash = -638562243, name = 'scramjet', price = 130000, banido = false, modelo = 'scramjet', capacidade = 75, tipo = 'carros' },
	{ hash = 1692272545, name = 'strikeforce', price = 45000, banido = false, modelo = 'strikeforce', capacidade = 350, tipo = 'avioes' },
	{ hash = -1299980860, name = 'nlargo', price = 80000, banido = false, modelo = 'nlargo', capacidade = 75, tipo = 'carros' },
	{ hash = -1171538088, name = 'joyster', price = 35000, banido = false, modelo = 'joyster', capacidade = 15, tipo = 'outros' },
	{ hash = -1988428699, name = 'terbyte', price = 25000, banido = false, modelo = 'terbyte', capacidade = 300, tipo = 'serviço' },
	{ hash = -846245338, name = 'CadEscLimosine', price = 50000, banido = false, modelo = 'CadEscLimosine', capacidade = 15, tipo = 'outros' },
	{ hash = 345756458, name = 'pbus2', price = 25000, banido = false, modelo = 'pbus2', capacidade = 15, tipo = 'outros' },
	{ hash = 905399718, name = 'a80', price = 170000, banido = false, modelo = 'a80', capacidade = 15, tipo = 'outros' },
	{ hash = 2069146067, name = 'oppressor2', price = 20000, banido = false, modelo = 'oppressor2', capacidade = 20, tipo = 'motos' },
	{ hash = 601605830, name = 'MerBenW111', price = 25000, banido = false, modelo = 'MerBenW111', capacidade = 15, tipo = 'outros' },
	{ hash = 219613597, name = 'speedo4', price = 22000, banido = false, modelo = 'speedo4', capacidade = 250, tipo = 'utilitario' },
	{ hash = -54332285, name = 'freecrawler', price = 50000, banido = false, modelo = 'freecrawler', capacidade = 75, tipo = 'carros' },
	{ hash = 962552330, name = 'rmodx6police', price = 50000, banido = false, modelo = 'rmodx6police', capacidade = 15, tipo = 'outros' },
	{ hash = 1945374990, name = 'mule4', price = 25000, banido = false, modelo = 'mule4', capacidade = 300, tipo = 'serviço' },
	{ hash = 2044532910, name = 'menacer', price = 50000, banido = false, modelo = 'menacer', capacidade = 75, tipo = 'carros' },
	{ hash = -307958377, name = 'blimp3', price = 52000, banido = false, modelo = 'blimp3', capacidade = 350, tipo = 'avioes' },
	{ hash = 126788928, name = '720sp', price = 50000, banido = false, modelo = '720sp', capacidade = 75, tipo = 'carros' },
	{ hash = 500482303, name = 'swinger', price = 130000, banido = false, modelo = 'swinger', capacidade = 15, tipo = 'outros' },
	{ hash = 242156012, name = 'rmodbmwm8', price = 35000, banido = false, modelo = 'rmodbmwm8', capacidade = 75, tipo = 'carros' },
	{ hash = -420911112, name = 'patriot2', price = 50000, banido = false, modelo = 'patriot2', capacidade = 15, tipo = 'outros' },
	{ hash = -331467772, name = 'italigto', price = 35000, banido = false, modelo = 'italigto', capacidade = 15, tipo = 'outros' },
	{ hash = -715746948, name = 'monster5', price = 500000, banido = false, modelo = 'monster5', capacidade = 75, tipo = 'carros' },
	{ hash = -1812949672, name = 'deathbike2', price = 12000, banido = false, modelo = 'deathbike2', capacidade = 20, tipo = 'motos' },
	{ hash = -1744505657, name = 'impaler4', price = 30000, banido = false, modelo = 'impaler4', capacidade = 15, tipo = 'outros' },
	{ hash = -2061049099, name = 'slamvan4', price = 30000, banido = false, modelo = 'slamvan4', capacidade = 15, tipo = 'outros' },
	{ hash = -1528734685, name = '718b', price = 100000, banido = false, modelo = '718b', capacidade = 75, tipo = 'carros' },
	{ hash = 2139203625, name = 'brutus', price = 50000, banido = false, modelo = 'brutus', capacidade = 75, tipo = 'carros' },
	{ hash = -1721544752, name = 'DodgePolara', price = 35000, banido = false, modelo = 'DodgePolara', capacidade = 15, tipo = 'outros' },
	{ hash = -27326686, name = 'deathbike', price = 12000, banido = false, modelo = 'deathbike', capacidade = 20, tipo = 'motos' },
	{ hash = -688189648, name = 'dominator4', price = 150000, banido = false, modelo = 'dominator4', capacidade = 15, tipo = 'outros' },
	{ hash = -1375060657, name = 'dominator5', price = 150000, banido = false, modelo = 'dominator5', capacidade = 15, tipo = 'outros' },
	{ hash = -1810806490, name = 'seminole2', price = 50000, banido = false, modelo = 'seminole2', capacidade = 15, tipo = 'outros' },
	{ hash = 668439077, name = 'bruiser', price = 40000, banido = false, modelo = 'bruiser', capacidade = 75, tipo = 'carros' },
	{ hash = 478730710, name = '2018cruzrs', price = 35000, banido = false, modelo = '2018cruzrs', capacidade = 15, tipo = 'outros' },
	{ hash = -286046740, name = 'rcbandito', price = 50000, banido = false, modelo = 'rcbandito', capacidade = 75, tipo = 'carros' },
	{ hash = -801550069, name = 'cerberus', price = 25000, banido = false, modelo = 'cerberus', capacidade = 300, tipo = 'serviço' },
	{ hash = -1173768715, name = 'ferrariitalia', price = 25000, banido = false, modelo = 'ferrariitalia', capacidade = 15, tipo = 'outros' },
	{ hash = 1039032026, name = 'blista2', price = 35000, banido = false, modelo = 'blista2', capacidade = 15, tipo = 'outros' },
	{ hash = 1721676810, name = 'monster3', price = 500000, banido = false, modelo = 'monster3', capacidade = 75, tipo = 'carros' },
	{ hash = 1456744817, name = 'tulip', price = 30000, banido = false, modelo = 'tulip', capacidade = 15, tipo = 'outros' },
	{ hash = 1284356689, name = 'zhaba', price = 50000, banido = false, modelo = 'zhaba', capacidade = 75, tipo = 'carros' },
	{ hash = 2033687168, name = 'lamborghinihuracanlw', price = 25000, banido = false, modelo = 'lamborghinihuracanlw', capacidade = 75, tipo = 'carros' },
	{ hash = -1146969353, name = 'scarab', price = 40000, banido = false, modelo = 'scarab', capacidade = 15, tipo = 'outros' },
	{ hash = -49115651, name = 'vamos', price = 150000, banido = false, modelo = 'vamos', capacidade = 15, tipo = 'outros' },
	{ hash = 444994115, name = 'imperator', price = 150000, banido = false, modelo = 'imperator', capacidade = 15, tipo = 'outros' },
	{ hash = 1637620610, name = 'imperator2', price = 150000, banido = false, modelo = 'imperator2', capacidade = 15, tipo = 'outros' },
	{ hash = -755532233, name = 'imperator3', price = 150000, banido = false, modelo = 'imperator3', capacidade = 15, tipo = 'outros' },
	{ hash = -580610645, name = 'm3f80', price = 30000, banido = false, modelo = 'm3f80', capacidade = 15, tipo = 'outros' },
	{ hash = 1279262537, name = 'deviant', price = 150000, banido = false, modelo = 'deviant', capacidade = 15, tipo = 'outros' },
	{ hash = -2096690334, name = 'impaler', price = 30000, banido = false, modelo = 'impaler', capacidade = 15, tipo = 'outros' },
	{ hash = -1033545199, name = 's14', price = 100000, banido = false, modelo = 's14', capacidade = 15, tipo = 'outros' },
	{ hash = -677864327, name = 'caracarastd', price = 25000, banido = false, modelo = 'caracarastd', capacidade = 15, tipo = 'outros' },
	{ hash = -1106120762, name = 'zr3802', price = 150000, banido = false, modelo = 'zr3802', capacidade = 15, tipo = 'outros' },
	{ hash = -447711397, name = 'paragon', price = 150000, banido = false, modelo = 'paragon', capacidade = 15, tipo = 'outros' },
	{ hash = -369887950, name = 'toyotasupra2', price = 25000, banido = false, modelo = 'toyotasupra2', capacidade = 15, tipo = 'outros' },
	{ hash = -208911803, name = 'jugular', price = 150000, banido = false, modelo = 'jugular', capacidade = 15, tipo = 'outros' },
	{ hash = 916547552, name = 'rrocket', price = 12000, banido = false, modelo = 'rrocket', capacidade = 20, tipo = 'motos' },
	{ hash = -368114364, name = 'boss429', price = 35000, banido = false, modelo = 'boss429', capacidade = 15, tipo = 'outros' },
	{ hash = -1804415708, name = 'peyote2', price = 25000, banido = false, modelo = 'peyote2', capacidade = 15, tipo = 'outros' },
	{ hash = -324618589, name = 's80', price = 35000, banido = false, modelo = 's80', capacidade = 75, tipo = 'carros' },
	{ hash = -682108547, name = 'zorrusso', price = 35000, banido = false, modelo = 'zorrusso', capacidade = 75, tipo = 'carros' },
	{ hash = -2103325862, name = 'emstalker', price = 25000, banido = false, modelo = 'emstalker', capacidade = 15, tipo = 'outros' },
	{ hash = -913589546, name = 'glendale2', price = 100000, banido = false, modelo = 'glendale2', capacidade = 15, tipo = 'outros' },
	{ hash = -291927921, name = 'rmodsupra', price = 100000, banido = false, modelo = 'rmodsupra', capacidade = 15, tipo = 'outros' },
	{ hash = 1854776567, name = 'issi7', price = 35000, banido = false, modelo = 'issi7', capacidade = 15, tipo = 'outros' },
	{ hash = -941272559, name = 'locust', price = 35000, banido = false, modelo = 'locust', capacidade = 15, tipo = 'outros' },
	{ hash = 2020690903, name = 'paramedicoheli', price = 52000, banido = false, modelo = 'paramedicoheli', capacidade = 20, tipo = 'helicopteros' },
	{ hash = -1467569396, name = '180sx', price = 30000, banido = false, modelo = '180sx', capacidade = 15, tipo = 'outros' },
	{ hash = 1323778901, name = 'emerus', price = 35000, banido = false, modelo = 'emerus', capacidade = 75, tipo = 'carros' },
	{ hash = 1509738688, name = 'harleydavidsonrg', price = 12000, banido = false, modelo = 'harleydavidsonrg', capacidade = 20, tipo = 'motos' },
	{ hash = 1934093517, name = 'rmodm5e34', price = 35000, banido = false, modelo = 'rmodm5e34', capacidade = 15, tipo = 'outros' },
	{ hash = 722226637, name = 'gauntlet3', price = 25000, banido = false, modelo = 'gauntlet3', capacidade = 15, tipo = 'outros' },
	{ hash = -882629065, name = 'nebula', price = 150000, banido = false, modelo = 'nebula', capacidade = 15, tipo = 'outros' },
	{ hash = 1862507111, name = 'zion3', price = 30000, banido = false, modelo = 'zion3', capacidade = 15, tipo = 'outros' },
	{ hash = 686471183, name = 'drafter', price = 150000, banido = false, modelo = 'drafter', capacidade = 15, tipo = 'outros' },
	{ hash = 136800179, name = 'alfa4cqv', price = 150000, banido = false, modelo = 'alfa4cqv', capacidade = 15, tipo = 'outros' },
	{ hash = -1254331310, name = 'minitank', price = 40000, banido = false, modelo = 'minitank', capacidade = 15, tipo = 'outros' },
	{ hash = 1513245066, name = 'cls63s', price = 25000, banido = false, modelo = 'cls63s', capacidade = 15, tipo = 'outros' },
	{ hash = -2000692832, name = '250C', price = 35000, banido = false, modelo = '250C', capacidade = 15, tipo = 'outros' },
	{ hash = 1693751655, name = 'yosemite2', price = 25000, banido = false, modelo = 'yosemite2', capacidade = 15, tipo = 'outros' },
	{ hash = 301304410, name = 'Stryder', price = 12000, banido = false, modelo = 'Stryder', capacidade = 20, tipo = 'motos' },
	{ hash = 167397304, name = 'paredao', price = 40000, banido = false, modelo = 'paredao', capacidade = 15, tipo = 'outros' },
	{ hash = 394110044, name = 'jb7002', price = 150000, banido = false, modelo = 'jb7002', capacidade = 15, tipo = 'outros' },
	{ hash = 872704284, name = 'sultan2', price = 35000, banido = false, modelo = 'sultan2', capacidade = 15, tipo = 'outros' },
	{ hash = 987469656, name = 'Sugoi', price = 150000, banido = false, modelo = 'Sugoi', capacidade = 15, tipo = 'outros' },
	{ hash = 340154634, name = 'formula', price = 35000, banido = false, modelo = 'formula', capacidade = 15, tipo = 'outros' },
	{ hash = -1624991916, name = 'policiabmwr1200', price = 12000, banido = false, modelo = 'policiabmwr1200', capacidade = 15, tipo = 'outros' },
	{ hash = -126417596, name = 'COOPERS', price = 35000, banido = false, modelo = 'COOPERS', capacidade = 15, tipo = 'outros' },
	{ hash = 960812448, name = 'furia', price = 35000, banido = false, modelo = 'furia', capacidade = 75, tipo = 'carros' },
	{ hash = 1456336509, name = 'vstr', price = 150000, banido = false, modelo = 'vstr', capacidade = 15, tipo = 'outros' },
	{ hash = 409049982, name = 'kanjo', price = 150000, banido = false, modelo = 'kanjo', capacidade = 15, tipo = 'outros' },
	{ hash = -1132721664, name = 'imorgon', price = 35000, banido = false, modelo = 'imorgon', capacidade = 15, tipo = 'outros' },
	{ hash = -1728685474, name = 'coquette4', price = 35000, banido = false, modelo = 'coquette4', capacidade = 15, tipo = 'outros' },
	{ hash = -838099166, name = 'landstalker2', price = 50000, banido = false, modelo = 'landstalker2', capacidade = 15, tipo = 'outros' },
	{ hash = -2098954619, name = 'club', price = 150000, banido = false, modelo = 'club', capacidade = 15, tipo = 'outros' },
	{ hash = 416750766, name = 'ultimagt', price = 35000, banido = false, modelo = 'ultimagt', capacidade = 75, tipo = 'carros' },
	{ hash = 2134119907, name = 'dukes3', price = 150000, banido = false, modelo = 'dukes3', capacidade = 15, tipo = 'outros' },
	{ hash = 1181339704, name = 'openwheel2', price = 35000, banido = false, modelo = 'openwheel2', capacidade = 15, tipo = 'outros' },
	{ hash = 1107404867, name = 'peyote3', price = 25000, banido = false, modelo = 'peyote3', capacidade = 15, tipo = 'outros' },
	{ hash = -1492917079, name = 'veto2', price = 50000, banido = false, modelo = 'veto2', capacidade = 15, tipo = 'outros' },
	{ hash = -1149725334, name = 'italirsx', price = 35000, banido = false, modelo = 'italirsx', capacidade = 15, tipo = 'outros' },
	{ hash = 1744543800, name = 'z1000', price = 20000, banido = false, modelo = 'z1000', capacidade = 20, tipo = 'motos' },
	{ hash = 1966731033, name = 's8w12', price = 35000, banido = false, modelo = 's8w12', capacidade = 15, tipo = 'outros' },
	{ hash = 1455990255, name = 'toreador', price = 35000, banido = false, modelo = 'toreador', capacidade = 15, tipo = 'outros' },
	{ hash = -1045911276, name = 'slamtruck', price = 25000, banido = false, modelo = 'slamtruck', capacidade = 15, tipo = 'outros' },
	{ hash = 1644055914, name = 'weevil', price = 35000, banido = false, modelo = 'weevil', capacidade = 15, tipo = 'outros' },
	{ hash = -365873403, name = 'alkonost', price = 45000, banido = false, modelo = 'alkonost', capacidade = 350, tipo = 'avioes' },
	{ hash = -2085725496, name = 'FordGT17', price = 35000, banido = false, modelo = 'FordGT17', capacidade = 75, tipo = 'carros' },
	{ hash = -1761239425, name = 'hornet', price = 12000, banido = false, modelo = 'hornet', capacidade = 20, tipo = 'motos' },
	{ hash = 1229411063, name = 'seasparrow2', price = 52000, banido = false, modelo = 'seasparrow2', capacidade = 20, tipo = 'helicopteros' },
	{ hash = -736224571, name = 'gle63s', price = 25000, banido = false, modelo = 'gle63s', capacidade = 15, tipo = 'outros' },
	{ hash = 493030188, name = 'amarok', price = 50000, banido = false, modelo = 'amarok', capacidade = 250, tipo = 'utilitario' },
	{ hash = 1336872304, name = 'kosatka', price = 40000, banido = false, modelo = 'kosatka', capacidade = 50, tipo = 'barcos' },
	{ hash = -1108591207, name = 'freightcar2', price = 110000, banido = false, modelo = 'freightcar2', capacidade = 15, tipo = 'outros' },
	{ hash = 426742808, name = 'dominator7', price = 35000, banido = false, modelo = 'dominator7', capacidade = 15, tipo = 'outros' },
	{ hash = 736672010, name = 'dominator8', price = 35000, banido = false, modelo = 'dominator8', capacidade = 15, tipo = 'outros' },
	{ hash = 2038480341, name = 'euros', price = 35000, banido = false, modelo = 'euros', capacidade = 15, tipo = 'outros' },
	{ hash = -1244461404, name = 'tailgater2', price = 35000, banido = false, modelo = 'tailgater2', capacidade = 15, tipo = 'outros' },
	{ hash = 1304459735, name = 'growler', price = 150000, banido = false, modelo = 'growler', capacidade = 15, tipo = 'outros' },
	{ hash = -1858654120, name = 'zr350', price = 100000, banido = false, modelo = 'zr350', capacidade = 15, tipo = 'outros' },
	{ hash = 579912970, name = 'warrener2', price = 35000, banido = false, modelo = 'warrener2', capacidade = 15, tipo = 'outros' },
	{ hash = -1066334226, name = 'submersible2', price = 40000, banido = false, modelo = 'submersible2', capacidade = 50, tipo = 'barcos' },
	{ hash = 723973206, name = 'dukes', price = 150000, banido = false, modelo = 'dukes', capacidade = 15, tipo = 'outros' },
	{ hash = 1603211447, name = 'eclipse', price = 170000, banido = false, modelo = 'eclipse', capacidade = 15, tipo = 'outros' },
	{ hash = -915704871, name = 'dominator2', price = 150000, banido = false, modelo = 'dominator2', capacidade = 15, tipo = 'outros' },
	{ hash = -901163259, name = 'dodo', price = 45000, banido = false, modelo = 'dodo', capacidade = 350, tipo = 'avioes' },
	{ hash = 1233534620, name = 'marshall', price = 500000, banido = false, modelo = 'marshall', capacidade = 75, tipo = 'carros' },
	{ hash = 349315417, name = 'gauntlet2', price = 25000, banido = false, modelo = 'gauntlet2', capacidade = 15, tipo = 'outros' },
	{ hash = 147177933, name = '350z', price = 100000, banido = false, modelo = '350z', capacidade = 15, tipo = 'outros' },
	{ hash = 1224601968, name = '19ftype', price = 35000, banido = false, modelo = '19ftype', capacidade = 15, tipo = 'outros' },
	{ hash = -2111719615, name = '240sx', price = 50000, banido = false, modelo = '240sx', capacidade = 75, tipo = 'carros' },
	{ hash = -1178021069, name = 'wheelchair', price = 15000, banido = false, modelo = 'wheelchair', capacidade = 15, tipo = 'outros' },
	{ hash = 1266686339, name = 'alfa4c', price = 50000, banido = false, modelo = 'alfa4c', capacidade = 15, tipo = 'outros' },
	{ hash = -828942986, name = 'auditt', price = 150000, banido = false, modelo = 'auditt', capacidade = 15, tipo = 'outros' },
	{ hash = -605639986, name = 'bmwboltz', price = 55000, banido = false, modelo = 'bmwboltz', capacidade = 15, tipo = 'outros' },
	{ hash = 874739883, name = 'c7', price = 150000, banido = false, modelo = 'c7', capacidade = 75, tipo = 'carros' },
	{ hash = 1598708397, name = 'scrambler', price = 20000, banido = false, modelo = 'scrambler', capacidade = 20, tipo = 'motos' },
	{ hash = -1821058410, name = 'corvettec8', price = 30000, banido = false, modelo = 'corvettec8', capacidade = 75, tipo = 'carros' },
	{ hash = 1252150971, name = 'dodgeram2500', price = 50000, banido = false, modelo = 'dodgeram2500', capacidade = 75, tipo = 'carros' },
	{ hash = -1593031670, name = 'harleydavidsonfx', price = 12000, banido = false, modelo = 'harleydavidsonfx', capacidade = 20, tipo = 'motos' },
	{ hash = 2113441065, name = 'rs6', price = 35000, banido = false, modelo = 'rs6', capacidade = 75, tipo = 'carros' },
	{ hash = -1536944842, name = 'hondacbr650r', price = 20000, banido = false, modelo = 'hondacbr650r', capacidade = 20, tipo = 'motos' },
	{ hash = -875050963, name = 'policiaheli', price = 80000, banido = false, modelo = 'policiaheli', capacidade = 20, tipo = 'helicopteros' },
	{ hash = 1815977170, name = 'hondansx', price = 150000, banido = false, modelo = 'hondansx', capacidade = 15, tipo = 'outros' },
	{ hash = -2118992239, name = 's4avant', price = 35000, banido = false, modelo = 's4avant', capacidade = 15, tipo = 'outros' },
	{ hash = 1511670272, name = 'ChevImpalaLS06', price = 35000, banido = false, modelo = 'ChevImpalaLS06', capacidade = 15, tipo = 'outros' },
	{ hash = 2135330415, name = 'mansamgt21', price = 30000, banido = false, modelo = 'mansamgt21', capacidade = 15, tipo = 'outros' },
	{ hash = -252836656, name = 'models', price = 35000, banido = false, modelo = 'models', capacidade = 15, tipo = 'outros' },
	{ hash = -2019421579, name = 'rs4avant', price = 35000, banido = false, modelo = 'rs4avant', capacidade = 15, tipo = 'outros' },
	{ hash = 1019565663, name = 'mansm8civil', price = 35000, banido = false, modelo = 'mansm8civil', capacidade = 15, tipo = 'outros' },
	{ hash = 1311724675, name = 'mustang19', price = 170000, banido = false, modelo = 'mustang19', capacidade = 15, tipo = 'outros' },
	{ hash = 1821804144, name = 'FK2', price = 35000, banido = false, modelo = 'FK2', capacidade = 15, tipo = 'outros' },
	{ hash = -1747980967, name = 'tts', price = 150000, banido = false, modelo = 'tts', capacidade = 15, tipo = 'outros' },
	{ hash = -913355728, name = 'mustangeleanor', price = 70000, banido = false, modelo = 'mustangeleanor', capacidade = 15, tipo = 'outros' },
	{ hash = -1967455199, name = 'sl63', price = 35000, banido = false, modelo = 'sl63', capacidade = 15, tipo = 'outros' },
	{ hash = 1838439310, name = 'komodahc', price = 35000, banido = false, modelo = 'komodahc', capacidade = 15, tipo = 'outros' },
	{ hash = 1329314524, name = 'g20wide', price = 35000, banido = false, modelo = 'g20wide', capacidade = 15, tipo = 'outros' },
	{ hash = -1532432776, name = 'R1200GS', price = 12000, banido = false, modelo = 'R1200GS', capacidade = 20, tipo = 'motos' },
	{ hash = 774592366, name = 'dm1200_02', price = 12000, banido = false, modelo = 'dm1200_02', capacidade = 20, tipo = 'motos' },
	{ hash = 356442851, name = 'gsxr', price = 20000, banido = false, modelo = 'gsxr', capacidade = 20, tipo = 'motos' },
	{ hash = -1799742390, name = 'r820p', price = 35000, banido = false, modelo = 'r820p', capacidade = 15, tipo = 'outros' },
	{ hash = -657024061, name = '911rwb', price = 150000, banido = false, modelo = '911rwb', capacidade = 15, tipo = 'outros' },
	{ hash = -1371768796, name = 'h2carb', price = 20000, banido = false, modelo = 'h2carb', capacidade = 20, tipo = 'motos' },
	{ hash = -688419137, name = 'hayabusa', price = 20000, banido = false, modelo = 'hayabusa', capacidade = 20, tipo = 'motos' },
	{ hash = 1474015055, name = 'r1', price = 20000, banido = false, modelo = 'r1', capacidade = 20, tipo = 'motos' },
	{ hash = -188978926, name = 'r6', price = 20000, banido = false, modelo = 'r6', capacidade = 20, tipo = 'motos' },
	{ hash = -423677691, name = 'sr1', price = 12000, banido = false, modelo = 'sr1', capacidade = 20, tipo = 'motos' },
	{ hash = -1156537658, name = 'tiger', price = 12000, banido = false, modelo = 'tiger', capacidade = 20, tipo = 'motos' },
	{ hash = 374752670, name = 'KnightRider', price = 150000, banido = false, modelo = 'KnightRider', capacidade = 15, tipo = 'outros' },
	{ hash = 1709518892, name = 'zx10', price = 20000, banido = false, modelo = 'zx10', capacidade = 20, tipo = 'motos' },
	{ hash = 360757549, name = 'zx6r', price = 200000, banido = false, modelo = 'zx6r', capacidade = 20, tipo = 'motos' },
	{ hash = 1966489524, name = 's15', price = 100000, banido = false, modelo = 's15', capacidade = 15, tipo = 'outros' },
	{ hash = -221892567, name = 'rmod240sx', price = 35000, banido = false, modelo = 'rmod240sx', capacidade = 75, tipo = 'carros' },
	{ hash = -304327697, name = '675ltsp', price = 50000, banido = false, modelo = '675ltsp', capacidade = 75, tipo = 'carros' },
	{ hash = 1458362510, name = 'brz', price = 50000, banido = false, modelo = 'brz', capacidade = 15, tipo = 'outros' },
	{ hash = -1163419712, name = '930mnc', price = 35000, banido = false, modelo = '930mnc', capacidade = 15, tipo = 'outros' },
	{ hash = 537976707, name = '2015a3', price = 35000, banido = false, modelo = '2015a3', capacidade = 15, tipo = 'outros' },
	{ hash = -1890188908, name = 'cam8tun', price = 25000, banido = false, modelo = 'cam8tun', capacidade = 15, tipo = 'outros' },
	{ hash = 1238608526, name = 'rmodescort', price = 35000, banido = false, modelo = 'rmodescort', capacidade = 15, tipo = 'outros' },
	{ hash = -1829079746, name = 'cb90h', price = 40000, banido = false, modelo = 'cb90h', capacidade = 50, tipo = 'barcos' },
	{ hash = 256000841, name = 'LotusEsprit', price = 150000, banido = false, modelo = 'LotusEsprit', capacidade = 15, tipo = 'outros' },
	{ hash = 1310501190, name = 'aven15lw', price = 35000, banido = false, modelo = 'aven15lw', capacidade = 75, tipo = 'carros' },
	{ hash = -1599260174, name = 'barcspeeder', price = 20000, banido = false, modelo = 'barcspeeder', capacidade = 20, tipo = 'motos' },
	{ hash = -402398867, name = 'bc', price = 50000, banido = false, modelo = 'bc', capacidade = 75, tipo = 'carros' },
	{ hash = 370861208, name = 'bowserjr', price = 52000, banido = false, modelo = 'bowserjr', capacidade = 350, tipo = 'avioes' },
	{ hash = -1940629461, name = 'gmcs', price = 25000, banido = false, modelo = 'gmcs', capacidade = 75, tipo = 'carros' },
	{ hash = -953054458, name = 'huayra14', price = 35000, banido = false, modelo = 'huayra14', capacidade = 75, tipo = 'carros' },
	{ hash = 836402099, name = 'enzo02', price = 35000, banido = false, modelo = 'enzo02', capacidade = 75, tipo = 'carros' },
	{ hash = 47055373, name = 'rmodm3e36', price = 150000, banido = false, modelo = 'rmodm3e36', capacidade = 15, tipo = 'outros' },
	{ hash = -228528329, name = 'evo9', price = 25000, banido = false, modelo = 'evo9', capacidade = 15, tipo = 'outros' },
	{ hash = 624293437, name = 'z32', price = 100000, banido = false, modelo = 'z32', capacidade = 15, tipo = 'outros' },
	{ hash = 138058075, name = 'hurper', price = 50000, banido = false, modelo = 'hurper', capacidade = 75, tipo = 'carros' },
	{ hash = 1920015921, name = 'rocoto12', price = 35000, banido = false, modelo = 'rocoto12', capacidade = 15, tipo = 'outros' },
	{ hash = 949614817, name = 'lp700r', price = 30000, banido = false, modelo = 'lp700r', capacidade = 75, tipo = 'carros' },
	{ hash = 619016222, name = 'rmodessenza', price = 35000, banido = false, modelo = 'rmodessenza', capacidade = 75, tipo = 'carros' },
	{ hash = 1376164622, name = 'onibus', price = 25000, banido = false, modelo = 'onibus', capacidade = 15, tipo = 'outros' },
	{ hash = -441785353, name = 'rmodporsche918', price = 35000, banido = false, modelo = 'rmodporsche918', capacidade = 15, tipo = 'outros' },
	{ hash = -1647894488, name = 'rmodrs7', price = 50000, banido = false, modelo = 'rmodrs7', capacidade = 15, tipo = 'outros' },
	{ hash = 542147885, name = 'velar', price = 50000, banido = false, modelo = 'velar', capacidade = 15, tipo = 'outros' },
	{ hash = 1146389448, name = 'panameramansory', price = 55000, banido = false, modelo = 'panameramansory', capacidade = 15, tipo = 'outros' },
	{ hash = -739058151, name = 'audir8', price = 35000, banido = false, modelo = 'audir8', capacidade = 75, tipo = 'carros' },
	{ hash = 723779872, name = 'toyotasupra', price = 170000, banido = false, modelo = 'toyotasupra', capacidade = 15, tipo = 'outros' },
	{ hash = -368982804, name = 'raiogt63', price = 50000, banido = false, modelo = 'raiogt63', capacidade = 15, tipo = 'outros' },
	{ hash = 1196690374, name = 'risegolf', price = 35000, banido = false, modelo = 'risegolf', capacidade = 15, tipo = 'outros' },
	{ hash = 796154746, name = 'policiamustanggt', price = 25000, banido = false, modelo = 'policiamustanggt', capacidade = 15, tipo = 'outros' },
	{ hash = 81717913, name = 'policiacapricesid', price = 25000, banido = false, modelo = 'policiacapricesid', capacidade = 15, tipo = 'outros' },
	{ hash = -300147762, name = 'x5m13', price = 50000, banido = false, modelo = 'x5m13', capacidade = 15, tipo = 'outros' },
	{ hash = -1573350092, name = 'fordmustang', price = 25000, banido = false, modelo = 'fordmustang', capacidade = 15, tipo = 'outros' },
	{ hash = 1403490019, name = 'Wrgt63', price = 25000, banido = false, modelo = 'Wrgt63', capacidade = 15, tipo = 'outros' },
	{ hash = -60313827, name = 'nissangtr', price = 35000, banido = false, modelo = 'nissangtr', capacidade = 15, tipo = 'outros' },
	{ hash = 351980252, name = 'teslaprior', price = 35000, banido = false, modelo = 'teslaprior', capacidade = 15, tipo = 'outros' },
	{ hash = 1676738519, name = 'audirs6', price = 80000, banido = false, modelo = 'audirs6', capacidade = 15, tipo = 'outros' },
	{ hash = -157095615, name = 'bmwm3f80', price = 25000, banido = false, modelo = 'bmwm3f80', capacidade = 15, tipo = 'outros' },
	{ hash = 1601422646, name = 'dodgechargersrt', price = 25000, banido = false, modelo = 'dodgechargersrt', capacidade = 15, tipo = 'outros' },
	{ hash = 1183163119, name = 'rmodlego3', price = 35000, banido = false, modelo = 'rmodlego3', capacidade = 15, tipo = 'outros' },
	{ hash = 670022011, name = 'nissangtrnismo', price = 25000, banido = false, modelo = 'nissangtrnismo', capacidade = 15, tipo = 'outros' },
	{ hash = -13524981, name = 'bmwm4gts', price = 25000, banido = false, modelo = 'bmwm4gts', capacidade = 15, tipo = 'outros' },
	{ hash = 819937652, name = 'focusrs', price = 30000, banido = false, modelo = 'focusrs', capacidade = 15, tipo = 'outros' },
	{ hash = 624514487, name = 'raptor2017', price = 50000, banido = false, modelo = 'raptor2017', capacidade = 75, tipo = 'carros' },
	{ hash = 925169994, name = 'palmav', price = 52000, banido = false, modelo = 'palmav', capacidade = 20, tipo = 'helicopteros' },
	{ hash = -880426526, name = 'jugularspd', price = 35000, banido = false, modelo = 'jugularspd', capacidade = 15, tipo = 'outros' },
	{ hash = 431385387, name = 'WRclassxv2', price = 50000, banido = false, modelo = 'WRclassxv2', capacidade = 15, tipo = 'outros' },
	{ hash = -2059605865, name = 'mercedestactical', price = 50000, banido = false, modelo = 'mercedestactical', capacidade = 15, tipo = 'outros' },
	{ hash = 1654989418, name = 'Wra45', price = 35000, banido = false, modelo = 'Wra45', capacidade = 15, tipo = 'outros' },
	{ hash = 1937686957, name = 'gls63', price = 50000, banido = false, modelo = 'gls63', capacidade = 15, tipo = 'outros' },
	{ hash = 601014277, name = 'WRfrr', price = 50000, banido = false, modelo = 'WRfrr', capacidade = 15, tipo = 'outros' },
	{ hash = 1967292435, name = 'Wrclassx', price = 50000, banido = false, modelo = 'Wrclassx', capacidade = 15, tipo = 'outros' },
	{ hash = -1301138624, name = 'WRford', price = 35000, banido = false, modelo = 'WRford', capacidade = 15, tipo = 'outros' },
	{ hash = 837100403, name = 'mercedespolicia', price = 60000, banido = false, modelo = 'mercedespolicia', capacidade = 15, tipo = 'outros' },
	{ hash = 77333085, name = 's10sap', price = 50000, banido = false, modelo = 's10sap', capacidade = 15, tipo = 'outros' },
	{ hash = 960601547, name = 'sxrpolicia', price = 12000, banido = false, modelo = 'sxrpolicia', capacidade = 15, tipo = 'outros' },
	{ hash = 1305559105, name = 'gt86b', price = 35000, banido = false, modelo = 'gt86b', capacidade = 75, tipo = 'carros' },
	{ hash = 1242335710, name = 'FordMustRTRX', price = 150000, banido = false, modelo = 'FordMustRTRX', capacidade = 15, tipo = 'outros' },
	{ hash = -1678936632, name = 'F250GTBerLus', price = 130000, banido = false, modelo = 'F250GTBerLus', capacidade = 15, tipo = 'outros' },
	{ hash = -1618592772, name = '2000gt', price = 130000, banido = false, modelo = '2000gt', capacidade = 15, tipo = 'outros' },
	{ hash = 1856115081, name = 'devilz', price = 100000, banido = false, modelo = 'devilz', capacidade = 15, tipo = 'outros' },
	{ hash = -1495989932, name = 's800cabrio', price = 130000, banido = false, modelo = 's800cabrio', capacidade = 15, tipo = 'outros' },
	{ hash = -1936496967, name = 'blazer21', price = 35000, banido = false, modelo = 'blazer21', capacidade = 15, tipo = 'outros' },
	{ hash = -2112475739, name = 'BMWM7602017', price = 35000, banido = false, modelo = 'BMWM7602017', capacidade = 15, tipo = 'outros' },
	{ hash = -672478023, name = 'blazer1', price = 35000, banido = false, modelo = 'blazer1', capacidade = 15, tipo = 'outros' },
	{ hash = 586517650, name = 'xls1', price = 35000, banido = false, modelo = 'xls1', capacidade = 15, tipo = 'outros' },
	{ hash = 1182010875, name = 'sultan1', price = 35000, banido = false, modelo = 'sultan1', capacidade = 15, tipo = 'outros' },
	{ hash = -613271057, name = 'landstalker1', price = 50000, banido = false, modelo = 'landstalker1', capacidade = 15, tipo = 'outros' },
	{ hash = -378442770, name = 'nc1', price = 80000, banido = false, modelo = 'nc1', capacidade = 15, tipo = 'outros' },
	{ hash = 2091204915, name = 'ChevOpalSS475', price = 150000, banido = false, modelo = 'ChevOpalSS475', capacidade = 15, tipo = 'outros' },
	{ hash = 2046572318, name = '911turboS', price = 150000, banido = false, modelo = '911turboS', capacidade = 15, tipo = 'outros' },
	{ hash = -1370111350, name = '720s', price = 35000, banido = false, modelo = '720s', capacidade = 75, tipo = 'carros' },
	{ hash = -915188472, name = 'amggtr', price = 35000, banido = false, modelo = 'amggtr', capacidade = 75, tipo = 'carros' },
	{ hash = -1150723658, name = 'gmt900escalade', price = 50000, banido = false, modelo = 'gmt900escalade', capacidade = 15, tipo = 'outros' },
	{ hash = -109117240, name = 'huracangt3evo', price = 25000, banido = false, modelo = 'huracangt3evo', capacidade = 75, tipo = 'carros' },
	{ hash = 772621921, name = 'murlagolb', price = 100000, banido = false, modelo = 'murlagolb', capacidade = 75, tipo = 'carros' },
	{ hash = 804687806, name = 'sarenigt3', price = 35000, banido = false, modelo = 'sarenigt3', capacidade = 15, tipo = 'outros' },
	{ hash = 99308115, name = 'mgtc49a', price = 35000, banido = false, modelo = 'mgtc49a', capacidade = 75, tipo = 'carros' },
	{ hash = -1101810182, name = 'FordF1501949', price = 35000, banido = false, modelo = 'FordF1501949', capacidade = 15, tipo = 'outros' },
	{ hash = 1592738168, name = 'monaro', price = 35000, banido = false, modelo = 'monaro', capacidade = 15, tipo = 'outros' },
	{ hash = -96905865, name = 'gtr17', price = 100000, banido = false, modelo = 'gtr17', capacidade = 15, tipo = 'outros' },
	{ hash = -1599358121, name = '911gt3rs', price = 80000, banido = false, modelo = '911gt3rs', capacidade = 75, tipo = 'carros' },
	{ hash = 1896051924, name = 'BMWX5M2017', price = 50000, banido = false, modelo = 'BMWX5M2017', capacidade = 15, tipo = 'outros' },
	{ hash = 1742389319, name = 'chevelless', price = 150000, banido = false, modelo = 'chevelless', capacidade = 15, tipo = 'outros' },
	{ hash = 439840611, name = 'w201', price = 35000, banido = false, modelo = 'w201', capacidade = 15, tipo = 'outros' },
	{ hash = 1350347479, name = 'isuzu19', price = 25000, banido = false, modelo = 'isuzu19', capacidade = 15, tipo = 'outros' },
	{ hash = -991844441, name = '964cabrio', price = 150000, banido = false, modelo = '964cabrio', capacidade = 15, tipo = 'outros' },
	{ hash = -1388749322, name = 'lp570ap', price = 35000, banido = false, modelo = 'lp570ap', capacidade = 75, tipo = 'carros' },
	{ hash = 1404848314, name = 'w204amgc', price = 35000, banido = false, modelo = 'w204amgc', capacidade = 15, tipo = 'outros' },
	{ hash = -192900630, name = 'w210amg', price = 35000, banido = false, modelo = 'w210amg', capacidade = 15, tipo = 'outros' },
	{ hash = -749532275, name = 'sq5', price = 35000, banido = false, modelo = 'sq5', capacidade = 15, tipo = 'outros' },
	{ hash = -2120897359, name = 'supra2', price = 35000, banido = false, modelo = 'supra2', capacidade = 15, tipo = 'outros' },
	{ hash = -1528058219, name = 'contgt2011', price = 35000, banido = false, modelo = 'contgt2011', capacidade = 15, tipo = 'outros' },
	{ hash = 929121481, name = 'dart68', price = 150000, banido = false, modelo = 'dart68', capacidade = 15, tipo = 'outros' },
	{ hash = -1654118521, name = 'chino1', price = 150000, banido = false, modelo = 'chino1', capacidade = 15, tipo = 'outros' },
	{ hash = 1866983496, name = 'por930', price = 50000, banido = false, modelo = 'por930', capacidade = 15, tipo = 'outros' },
	{ hash = -1760022916, name = 'lx570', price = 35000, banido = false, modelo = 'lx570', capacidade = 15, tipo = 'outros' },
	{ hash = 1201526847, name = 'pajieluo', price = 50000, banido = false, modelo = 'pajieluo', capacidade = 15, tipo = 'outros' },
	{ hash = 544612829, name = 'AudiA630T2008', price = 35000, banido = false, modelo = 'AudiA630T2008', capacidade = 15, tipo = 'outros' },
	{ hash = -490459570, name = 'r8lb', price = 35000, banido = false, modelo = 'r8lb', capacidade = 15, tipo = 'outros' },
	{ hash = 1984719632, name = 's1', price = 35000, banido = false, modelo = 's1', capacidade = 15, tipo = 'outros' },
	{ hash = -1441470787, name = 'bmwhommage', price = 25000, banido = false, modelo = 'bmwhommage', capacidade = 75, tipo = 'carros' },
	{ hash = -649143441, name = 'cblazer', price = 25000, banido = false, modelo = 'cblazer', capacidade = 75, tipo = 'carros' },
	{ hash = -1540358219, name = 'ChevrCelta', price = 35000, banido = false, modelo = 'ChevrCelta', capacidade = 15, tipo = 'outros' },
	{ hash = 1282974183, name = 'ChevrImpala85', price = 25000, banido = false, modelo = 'ChevrImpala85', capacidade = 15, tipo = 'outros' },
	{ hash = -1471265912, name = '1500dj', price = 50000, banido = false, modelo = '1500dj', capacidade = 15, tipo = 'outros' },
	{ hash = 178350184, name = 'g65', price = 250000, banido = false, modelo = 'g65', capacidade = 15, tipo = 'outros' },
	{ hash = -1183566390, name = 'r8v10', price = 35000, banido = false, modelo = 'r8v10', capacidade = 15, tipo = 'outros' },
	{ hash = -1955163529, name = 'Mazda6MPS2006', price = 35000, banido = false, modelo = 'Mazda6MPS2006', capacidade = 15, tipo = 'outros' },
	{ hash = -662904049, name = 'e63amg', price = 35000, banido = false, modelo = 'e63amg', capacidade = 75, tipo = 'carros' },
	{ hash = -163019105, name = 'fc3bn', price = 100000, banido = false, modelo = 'fc3bn', capacidade = 15, tipo = 'outros' },
	{ hash = 1948659691, name = 'PorCarRS95', price = 80000, banido = false, modelo = 'PorCarRS95', capacidade = 15, tipo = 'outros' },
	{ hash = -328440374, name = 'f1', price = 35000, banido = false, modelo = 'f1', capacidade = 75, tipo = 'carros' },
	{ hash = 144275956, name = 'May62S', price = 35000, banido = false, modelo = 'May62S', capacidade = 15, tipo = 'outros' },
	{ hash = 331445751, name = '8pralift', price = 150000, banido = false, modelo = '8pralift', capacidade = 15, tipo = 'outros' },
	{ hash = 443531887, name = 'TesModS', price = 80000, banido = false, modelo = 'TesModS', capacidade = 75, tipo = 'carros' },
	{ hash = 954691655, name = 's5', price = 35000, banido = false, modelo = 's5', capacidade = 15, tipo = 'outros' },
	{ hash = -1282706764, name = 'E46RB', price = 35000, banido = false, modelo = 'E46RB', capacidade = 15, tipo = 'outros' },
	{ hash = -2136030678, name = 'a45amg', price = 35000, banido = false, modelo = 'a45amg', capacidade = 15, tipo = 'outros' },
	{ hash = 149117490, name = 'cherokee1', price = 50000, banido = false, modelo = 'cherokee1', capacidade = 75, tipo = 'carros' },
	{ hash = -941358200, name = 'ToyLanCruGX', price = 50000, banido = false, modelo = 'ToyLanCruGX', capacidade = 15, tipo = 'outros' },
	{ hash = 905302083, name = 'm600', price = 25000, banido = false, modelo = 'm600', capacidade = 75, tipo = 'carros' },
	{ hash = -704773886, name = 'lwas5', price = 35000, banido = false, modelo = 'lwas5', capacidade = 15, tipo = 'outros' },
	{ hash = -1564727574, name = 'NisOneBRE', price = 100000, banido = false, modelo = 'NisOneBRE', capacidade = 15, tipo = 'outros' },
	{ hash = 499588004, name = 'zeus', price = 35000, banido = false, modelo = 'zeus', capacidade = 15, tipo = 'outros' },
	{ hash = 248334982, name = 'a6hl', price = 35000, banido = false, modelo = 'a6hl', capacidade = 15, tipo = 'outros' },
	{ hash = 804696895, name = 'cresta', price = 35000, banido = false, modelo = 'cresta', capacidade = 15, tipo = 'outros' },
	{ hash = -701263831, name = 'subn', price = 50000, banido = false, modelo = 'subn', capacidade = 15, tipo = 'outros' },
	{ hash = 1493749616, name = 'crown210', price = 35000, banido = false, modelo = 'crown210', capacidade = 15, tipo = 'outros' },
	{ hash = 1435792097, name = 'slk55', price = 30000, banido = false, modelo = 'slk55', capacidade = 15, tipo = 'outros' },
	{ hash = 1725614162, name = 'cats', price = 35000, banido = false, modelo = 'cats', capacidade = 15, tipo = 'outros' },
	{ hash = -1095688294, name = 'wraith', price = 105000, banido = false, modelo = 'wraith', capacidade = 15, tipo = 'outros' },
	{ hash = 1897898727, name = 'm6f13', price = 85000, banido = false, modelo = 'm6f13', capacidade = 15, tipo = 'outros' },
	{ hash = -304124483, name = 'silv86', price = 35000, banido = false, modelo = 'silv86', capacidade = 250, tipo = 'utilitario' },
	{ hash = -1974879366, name = 'mb6', price = 80000, banido = false, modelo = 'mb6', capacidade = 15, tipo = 'outros' },
	{ hash = 836801107, name = 'ktklp7704', price = 30000, banido = false, modelo = 'ktklp7704', capacidade = 75, tipo = 'carros' },
	{ hash = 44044998, name = 'cliors', price = 35000, banido = false, modelo = 'cliors', capacidade = 15, tipo = 'outros' },
	{ hash = 1200798759, name = 'RaRoEvo16', price = 50000, banido = false, modelo = 'RaRoEvo16', capacidade = 15, tipo = 'outros' },
	{ hash = -626475311, name = 'cobra', price = 150000, banido = false, modelo = 'cobra', capacidade = 15, tipo = 'outros' },
	{ hash = 1763469000, name = 'FiatToro17', price = 35000, banido = false, modelo = 'FiatToro17', capacidade = 15, tipo = 'outros' },
	{ hash = -1730767225, name = 'pontiacg8', price = 80000, banido = false, modelo = 'pontiacg8', capacidade = 15, tipo = 'outros' },
	{ hash = -348200591, name = 'patrold', price = 50000, banido = false, modelo = 'patrold', capacidade = 15, tipo = 'outros' },
	{ hash = -2049163182, name = 'wrangler86', price = 50000, banido = false, modelo = 'wrangler86', capacidade = 15, tipo = 'outros' },
	{ hash = -1149788194, name = 'yFeF12A', price = 80000, banido = false, modelo = 'yFeF12A', capacidade = 15, tipo = 'outros' },
	{ hash = -399290145, name = 'fusionnas', price = 35000, banido = false, modelo = 'fusionnas', capacidade = 75, tipo = 'carros' },
	{ hash = 2021344401, name = 'BMW335iSedan', price = 35000, banido = false, modelo = 'BMW335iSedan', capacidade = 15, tipo = 'outros' },
	{ hash = -583019632, name = 'giulia', price = 35000, banido = false, modelo = 'giulia', capacidade = 75, tipo = 'carros' },
	{ hash = -189438188, name = 'p1', price = 35000, banido = false, modelo = 'p1', capacidade = 75, tipo = 'carros' },
	{ hash = 2127669239, name = 'LexIS350FSport', price = 35000, banido = false, modelo = 'LexIS350FSport', capacidade = 15, tipo = 'outros' },
	{ hash = 324518366, name = 'priustaxi', price = 35000, banido = false, modelo = 'priustaxi', capacidade = 15, tipo = 'outros' },
	{ hash = 1916667959, name = 'alpinae30', price = 100000, banido = false, modelo = 'alpinae30', capacidade = 15, tipo = 'outros' },
	{ hash = -1589129298, name = 'FD', price = 50000, banido = false, modelo = 'FD', capacidade = 15, tipo = 'outros' },
	{ hash = 1447964033, name = 'AlfRomMiTo', price = 35000, banido = false, modelo = 'AlfRomMiTo', capacidade = 15, tipo = 'outros' },
	{ hash = -2133373014, name = 'ahksv', price = 30000, banido = false, modelo = 'ahksv', capacidade = 75, tipo = 'carros' },
	{ hash = -749347224, name = '4881', price = 35000, banido = false, modelo = '4881', capacidade = 75, tipo = 'carros' },
	{ hash = 901237823, name = 'fulux63', price = 25000, banido = false, modelo = 'fulux63', capacidade = 15, tipo = 'outros' },
	{ hash = -1732086914, name = 'XJR', price = 35000, banido = false, modelo = 'XJR', capacidade = 15, tipo = 'outros' },
	{ hash = -851144133, name = 'MerBenV250Blu', price = 50000, banido = false, modelo = 'MerBenV250Blu', capacidade = 15, tipo = 'outros' },
	{ hash = -830457765, name = '180sxrb', price = 80000, banido = false, modelo = '180sxrb', capacidade = 15, tipo = 'outros' },
	{ hash = 1839230809, name = 'tricolore', price = 25000, banido = false, modelo = 'tricolore', capacidade = 75, tipo = 'carros' },
	{ hash = -1031680535, name = 'rsvr16', price = 50000, banido = false, modelo = 'rsvr16', capacidade = 15, tipo = 'outros' },
	{ hash = 701998922, name = 'hellcat', price = 35000, banido = false, modelo = 'hellcat', capacidade = 15, tipo = 'outros' },
	{ hash = 2105828944, name = 'VAZ2110Lad110', price = 35000, banido = false, modelo = 'VAZ2110Lad110', capacidade = 15, tipo = 'outros' },
	{ hash = -175698779, name = 'dalla1', price = 35000, banido = false, modelo = 'dalla1', capacidade = 75, tipo = 'carros' },
	{ hash = 175133808, name = 'p911h', price = 35000, banido = false, modelo = 'p911h', capacidade = 75, tipo = 'carros' },
	{ hash = 1346171487, name = 'as350', price = 52000, banido = false, modelo = 'as350', capacidade = 20, tipo = 'helicopteros' },
	{ hash = -1570333565, name = 'as350r', price = 52000, banido = false, modelo = 'as350r', capacidade = 20, tipo = 'helicopteros' },
	{ hash = 249115762, name = 'franco125', price = 40000, banido = false, modelo = 'franco125', capacidade = 50, tipo = 'barcos' },
	{ hash = -1670590722, name = 'frauscher16', price = 40000, banido = false, modelo = 'frauscher16', capacidade = 50, tipo = 'barcos' },
	{ hash = -688022864, name = 'sr650fly', price = 40000, banido = false, modelo = 'sr650fly', capacidade = 50, tipo = 'barcos' },
	{ hash = -1087449709, name = 'yacht3a', price = 40000, banido = false, modelo = 'yacht3a', capacidade = 50, tipo = 'barcos' },
	{ hash = 537750787, name = 'chironss', price = 80000, banido = false, modelo = 'chironss', capacidade = 75, tipo = 'carros' },
	{ hash = -1556226045, name = 'biz', price = 12000, banido = false, modelo = 'biz', capacidade = 20, tipo = 'motos' },
	{ hash = -1456558572, name = 'chevette', price = 25000, banido = false, modelo = 'chevette', capacidade = 15, tipo = 'outros' },
	{ hash = -493679946, name = 'civic', price = 25000, banido = false, modelo = 'civic', capacidade = 15, tipo = 'outros' },
	{ hash = -866553602, name = 'elva', price = 25000, banido = false, modelo = 'elva', capacidade = 75, tipo = 'carros' },
	{ hash = -1506060729, name = 'excavator', price = 400000, banido = false, modelo = 'excavator', capacidade = 15, tipo = 'outros' },
	{ hash = 1178101509, name = 'fiorino', price = 25000, banido = false, modelo = 'fiorino', capacidade = 250, tipo = 'utilitario' },
	{ hash = 285057540, name = 'gemera', price = 25000, banido = false, modelo = 'gemera', capacidade = 75, tipo = 'carros' },
	{ hash = 2015170161, name = 'biz25', price = 12000, banido = false, modelo = 'biz25', capacidade = 20, tipo = 'motos' },
	{ hash = 785363198, name = 'foxsnt', price = 150000, banido = false, modelo = 'foxsnt', capacidade = 15, tipo = 'outros' },
	{ hash = 1077932112, name = 'mansgt', price = 25000, banido = false, modelo = 'mansgt', capacidade = 75, tipo = 'carros' },
	{ hash = 99671692, name = 'mercxclass', price = 25000, banido = false, modelo = 'mercxclass', capacidade = 15, tipo = 'outros' },
	{ hash = -1650862391, name = 'alfmito', price = 35000, banido = false, modelo = 'alfmito', capacidade = 15, tipo = 'outros' },
	{ hash = -1707353429, name = 'monza', price = 25000, banido = false, modelo = 'monza', capacidade = 15, tipo = 'outros' },
	{ hash = -1381125554, name = 'rmodbolide', price = 35000, banido = false, modelo = 'rmodbolide', capacidade = 75, tipo = 'carros' },
	{ hash = 1645180079, name = 'rmodlegoporsche', price = 35000, banido = false, modelo = 'rmodlegoporsche', capacidade = 15, tipo = 'outros' },
	{ hash = 872813272, name = 'rmodmonster', price = 500000, banido = false, modelo = 'rmodmonster', capacidade = 75, tipo = 'carros' },
	{ hash = 2071509880, name = 'rmodmonstergt', price = 500000, banido = false, modelo = 'rmodmonstergt', capacidade = 15, tipo = 'outros' },
	{ hash = 1019021244, name = 'rmodsuprapandem', price = 35000, banido = false, modelo = 'rmodsuprapandem', capacidade = 75, tipo = 'carros' },
	{ hash = 168163693, name = 'rmodtracktor', price = 50000, banido = false, modelo = 'rmodtracktor', capacidade = 15, tipo = 'outros' },
	{ hash = 1963018194, name = 'rmodtracktor2', price = 50000, banido = false, modelo = 'rmodtracktor2', capacidade = 15, tipo = 'outros' },
	{ hash = 1295777722, name = 'taycan', price = 35000, banido = false, modelo = 'taycan', capacidade = 15, tipo = 'outros' },
	{ hash = 984018554, name = 'valkyrietp', price = 25000, banido = false, modelo = 'valkyrietp', capacidade = 75, tipo = 'carros' },
	{ hash = -676313463, name = 'fox720m', price = 35000, banido = false, modelo = 'fox720m', capacidade = 75, tipo = 'carros' },
	{ hash = 1592796651, name = 'foxc8', price = 35000, banido = false, modelo = 'foxc8', capacidade = 75, tipo = 'carros' },
	{ hash = -1835937232, name = 'rmodskyline34', price = 100000, banido = false, modelo = 'rmodskyline34', capacidade = 15, tipo = 'outros' },
	{ hash = -1037089560, name = 'foxc8wb', price = 35000, banido = false, modelo = 'foxc8wb', capacidade = 75, tipo = 'carros' },
	{ hash = -221557333, name = 'foxct', price = 50000, banido = false, modelo = 'foxct', capacidade = 75, tipo = 'carros' },
	{ hash = -1421258057, name = 'foxevo', price = 35000, banido = false, modelo = 'foxevo', capacidade = 75, tipo = 'carros' },
	{ hash = 1232041052, name = 'foxevos', price = 35000, banido = false, modelo = 'foxevos', capacidade = 75, tipo = 'carros' },
	{ hash = 1203624503, name = 'foxsenna', price = 35000, banido = false, modelo = 'foxsenna', capacidade = 75, tipo = 'carros' },
	{ hash = -2114265264, name = 'golf7gti', price = 35000, banido = false, modelo = 'golf7gti', capacidade = 15, tipo = 'outros' },
	{ hash = 590709306, name = 'lwgtr', price = 35000, banido = false, modelo = 'lwgtr', capacidade = 15, tipo = 'outros' },
	{ hash = 1082699033, name = 'rmodzl1police', price = 35000, banido = false, modelo = 'rmodzl1police', capacidade = 15, tipo = 'outros' },
	{ hash = -1114151312, name = 'lwgtr2', price = 35000, banido = false, modelo = 'lwgtr2', capacidade = 15, tipo = 'outros' },
	{ hash = 140254791, name = 'l200', price = 50000, banido = false, modelo = 'l200', capacidade = 15, tipo = 'outros' },
	{ hash = 1978088379, name = 'lancerevolutionx', price = 25000, banido = false, modelo = 'lancerevolutionx', capacidade = 15, tipo = 'outros' },
	{ hash = 1896411446, name = 'm3e46', price = 100000, banido = false, modelo = 'm3e46', capacidade = 15, tipo = 'outros' },
	{ hash = -895048042, name = 'rmodlegosenna', price = 100000, banido = false, modelo = 'rmodlegosenna', capacidade = 15, tipo = 'outros' },
	{ hash = 1399523887, name = 'rise-trailer', price = 40000, banido = false, modelo = 'rise-trailer', capacidade = 15, tipo = 'outros' },
	{ hash = 573158144, name = 'rmod69police', price = 150000, banido = false, modelo = 'rmod69police', capacidade = 15, tipo = 'outros' },
	{ hash = -1497128181, name = 'rmode63s', price = 35000, banido = false, modelo = 'rmode63s', capacidade = 15, tipo = 'outros' },
	{ hash = 1674460262, name = 'rmodgtr50', price = 100000, banido = false, modelo = 'rmodgtr50', capacidade = 15, tipo = 'outros' },
	{ hash = -2098155976, name = 'rmodjeep', price = 50000, banido = false, modelo = 'rmodjeep', capacidade = 15, tipo = 'outros' },
	{ hash = -2096522250, name = 'rmodlego1', price = 100000, banido = false, modelo = 'rmodlego1', capacidade = 15, tipo = 'outros' },
	{ hash = 339065598, name = 'rmodmartin', price = 150000, banido = false, modelo = 'rmodmartin', capacidade = 15, tipo = 'outros' },
	{ hash = 59561272, name = 'rmodgt63police', price = 35000, banido = false, modelo = 'rmodgt63police', capacidade = 15, tipo = 'outros' },
	{ hash = -1765254558, name = 'rmodsianr', price = 35000, banido = false, modelo = 'rmodsianr', capacidade = 75, tipo = 'carros' },
	{ hash = -1293596973, name = 'rmodzl1', price = 35000, banido = false, modelo = 'rmodzl1', capacidade = 15, tipo = 'outros' },
	{ hash = 29976887, name = 'rmodf12tdf', price = 35000, banido = false, modelo = 'rmodf12tdf', capacidade = 75, tipo = 'carros' },
	{ hash = 15164328, name = 'rmodfordpolice', price = 35000, banido = false, modelo = 'rmodfordpolice', capacidade = 15, tipo = 'outros' },
	{ hash = 1784428761, name = 'rmodjesko', price = 35000, banido = false, modelo = 'rmodjesko', capacidade = 15, tipo = 'outros' },
	{ hash = -1518551484, name = 'rmodc63amg', price = 35000, banido = false, modelo = 'rmodc63amg', capacidade = 75, tipo = 'carros' },
	{ hash = -750067359, name = 'rmodbentleygt', price = 35000, banido = false, modelo = 'rmodbentleygt', capacidade = 75, tipo = 'carros' },
	{ hash = 1734939441, name = 'rmodcamaro', price = 35000, banido = false, modelo = 'rmodcamaro', capacidade = 15, tipo = 'outros' },
	{ hash = 1191498149, name = 'rmodchiron300', price = 35000, banido = false, modelo = 'rmodchiron300', capacidade = 75, tipo = 'carros' },
	{ hash = -1474121254, name = 'rmodm8gte', price = 35000, banido = false, modelo = 'rmodm8gte', capacidade = 75, tipo = 'carros' },
	{ hash = -1476696782, name = 'rmodmi8lb', price = 35000, banido = false, modelo = 'rmodmi8lb', capacidade = 75, tipo = 'carros' },
	{ hash = -1781284470, name = 'rmodlego2', price = 100000, banido = false, modelo = 'rmodlego2', capacidade = 15, tipo = 'outros' },
	{ hash = 2045784380, name = 'rmodx6', price = 50000, banido = false, modelo = 'rmodx6', capacidade = 15, tipo = 'outros' },
	{ hash = 1311755301, name = 'rs6avant20', price = 35000, banido = false, modelo = 'rs6avant20', capacidade = 15, tipo = 'outros' },
	{ hash = 452031410, name = 's10hc', price = 50000, banido = false, modelo = 's10hc', capacidade = 15, tipo = 'outros' },
	{ hash = 1451518270, name = 'saveiro', price = 35000, banido = false, modelo = 'saveiro', capacidade = 250, tipo = 'utilitario' },
	{ hash = -520214134, name = 'urus', price = 50000, banido = false, modelo = 'urus', capacidade = 15, tipo = 'outros' },
	{ hash = -74953340, name = 'xxxxx', price = 50000, banido = false, modelo = 'xxxxx', capacidade = 15, tipo = 'outros' },
	}
----------------------------------------------
----------------------------------------------
----------------------------------------------


-- RETORNA A LISTA DE VEÍCULOS
config.getVehList = function()
	return config.vehList
end

-- RETORNA AS INFORMAÇÕES CONTIDAS NA LISTA DE UM VEÍCULO ESPECÍFICO
config.getVehicleInfo = function(vehicle)
	for i in ipairs(config.vehList) do
		if vehicle == config.vehList[i].hash or vehicle == config.vehList[i].name then
            return config.vehList[i]
        end
    end
    return false
end

-- RETORNA O MODELO DE UM VEÍCULO ESPECÍFICO (NOME BONITINHO)
config.getVehicleModel = function(vehicle)
	local vehInfo = config.getVehicleInfo(vehicle)
	if vehInfo then
		return vehInfo.modelo or vehicle
	end
	return vehicle
end

-- RETORNA A CAPACIDADE DO PORTA-MALAS DE UM VEÍCULO ESPECÍFICO
config.getVehicleTrunk = function(vehicle)
	local vehInfo = config.getVehicleInfo(vehicle)
	if vehInfo then
		return vehInfo.capacidade or 0
	end
	return 0
end

-- RETORNA O PREÇO DE UM VEÍCULO ESPECÍFICO
config.getVehiclePrice = function(vehicle)
	local vehInfo = config.getVehicleInfo(vehicle)
	if vehInfo then
		return vehInfo.price or 0
	end
	return 0
end

-- RETORNA O TIPO DE UM VEÍCULO ESPECÍFICO
config.getVehicleType = function(vehicle)
	local vehInfo = config.getVehicleInfo(vehicle)
	if vehInfo then
		return vehInfo.tipo or 0
	end
	return "none"
end

-- RETORNA O STATUS DE BANIDO DE UM VEÍCULO ESPECÍFICO
config.isVehicleBanned = function(vehicle)
	local vehInfo = config.getVehicleInfo(vehicle)
	if vehInfo then
		return vehInfo.banido
	end
	return false
end



-----------------------------------------------------------------
------------- GARAGENS PÚBLICAS E DE SERVIÇO --------------------
-----------------------------------------------------------------
config.garages = {
	[1] = { type = 'service', coords = vec3(-1077.57, -852.36, 4.89), perm = 'policia.permissao', -- Garagem DP
		vehiclePositions = {
			[1] = { vec3(-1072.77, -854.74, 4.25), h = 220.69 }, 
			[2] = { vec3(-1069.39, -852.29, 4.52), h = 220.69 },
		},
		vehicles = {
			{ vehicle = 'amg45', modelo = 'Mercedes a45' },
			{ vehicle = 'risegolf', modelo = 'Golf gti' },
			{ vehicle = 'cls63sp', modelo = 'CLS 63' },
			{ vehicle = 'VRrs6av', modelo = 'RS6av' },
			{ vehicle = 'maseratinfp', modelo = 'Maserati' },
			{ vehicle = 'pol718', modelo = 'Cayman' },
			{ vehicle = 'VRdm1200', modelo = 'DM 1200' },
			{ vehicle = 'WRclassxv2', modelo = 'Mercedes 4x4' },
			{ vehicle = 'mbsprinter', modelo = 'Transporte de presos' },
		
		}
	},   

	[2] = { type = 'service', coords = vec3(-1106.99,-832.69,37.7), perm = 'policia.permissao',  -- Heli Polciia Praça
  		vehiclePositions = {
			[1] = { vec3(-1096.05,-830.72,38.07), h = 171.14 },
  		},
 		 vehicles = {
			{ vehicle = 'polmav', modelo = 'polmav' },
		}
	},	
	[3] = { type = 'service', coords = vec3(-1138.62, -1713.91, 4.78), perm = 'bombeiros.permissao',  -- Bombeiros
	 	 vehiclePositions = {
		[1] = { vec3(-1135.54, -1712.63, 4.62), h = 211.84 },
		[2] = { vec3(-1130.41, -1709.04, 4.62), h = 211.84 },
	  },
	  	vehicles = {
		{ vehicle = 'ambulance', modelo = 'Ambulância de Emergência' },
		{ vehicle = 'firetruk', modelo = 'Caminhão de Bombeiros' },
	  }
	},

	[4] = { type = 'service', coords = vec3(339.12, -586.64, 28.8), perm = 'paramedico.permissao',  --// Paramedico terrestre
		vehiclePositions = {
		  [1] = { vec3(329.99, -588.51, 28.8), h = 336.69 },
		  [2] = { vec3(326.15, -587.8, 28.8), h = 336.69 },
		  [3] = { vec3(323.59, -586.1, 28.8), h = 336.69 },
		},
		vehicles = {
	  		{ vehicle = 'VRtahoe', modelo = 'Tahoe' },  
	  		{ vehicle = 'Wrasprinter', modelo = 'Ambulancia' },  
	  		{ vehicle = 'WRr1200', modelo = 'Resgate Rapido' },  
		}
	},
	[5] = { type = 'service', coords = vec3(338.33,-586.60,74.16), perm = 'paramedico.permissao',  --// Heli Paramédico
		vehiclePositions = {
	 	 [1] = { vec3(350.57,-587.35,74.02), h = 245.40 },
		},
		vehicles = {
		{ vehicle = 'frogger', modelo = 'Helicoptero' },
		{ vehicle = 'seasparrow', modelo = 'seasparrow' },
		}
	},
	[6] = { type = 'service', coords = vec3(-354.12, -155.04, 39.02), perm = 'mecanico.permissao', --GARAGEM DA BENNYS //
		vehiclePositions = {
			[1] = { vec3(-356.04, -161.21, 38.07), h = 32.53 },
		},
		vehicles = {
			{ vehicle = 'flatbed3', modelo = 'flatbed3' },
			{ vehicle = 'yosemite3', modelo = 'yosemite3' },
		}
	},
	[7] = { type = 'service', coords = vec3(454.13, -600.72, 28.58), perm = nil,   -- Motorista //
		vehiclePositions = {
			[1] = { vec3(462.22,-605.06,28.49), h = 220.0 },
		},
		vehicles = {
			{ vehicle = 'coach', modelo = 'Mic.Onibus' },
		}
	},
	[8] = { type = 'service', coords = vec3(899.6, -174.57, 73.92), perm = nil,  -- // Taxi
		vehiclePositions = {
			[1] = { vec3(900.34, -181.21, 73.39), h = 237.10 },
		},
		vehicles = {
			{ vehicle = 'taxi', modelo = 'taxi' },  
		}
	},
	[9] = { type = 'service', coords = vec3(-537.10,-886.54, 25.208), perm = nil, --  // Weazel (CARRO)
		vehiclePositions = {
			[1] = { vec3(-542.19, -892.47, 24.643), h = 100.0 },
		},
		vehicles = {
			{ vehicle = 'rumpo', modelo = 'rumpo' },  
		}
	},	
	[10] = { type = 'service', coords = vec3(-341.19,-1567.68,25.22), perm = nil, -- // Lixeiro
		vehiclePositions = {
			[1] = { vec3(-336.67,-1563.24,24.95), h = 90.84 },
		},
		vehicles = { 
			{ vehicle = 'trash2', modelo = 'trash2' },  
		}
	},
	[11] = { type = 'service', coords = vec3(1054.51,-1952.59,32.09), perm = nil, -- //
		vehiclePositions = {
	 		 [1] = { vec3(1052.62,-1962.34,30.64), h = 182.76 },
		},
		vehicles = {
			{ vehicle = 'tiptruck', modelo = 'tiptruck' },  
		}
	},	
	[12] = { type = 'service', coords = vec3(1200.41,-1276.48, 35.22), perm = nil,  -- Lenhadores
		vehiclePositions = {
	 		[1] = { vec3(1212.45,-1273.60, 34.93), h = 85.64 },
		},
		vehicles = {
	  		{ vehicle = 'ratloader', modelo = 'ratloader' },  
		}
  }	,	
	[13] = { type = 'service', coords = vec3(-1032.1600,-2729.84,13.7566), perm = nil, -- BIKES AEROPORTO//
		vehiclePositions = {
	  		[1] = { vec3(-1018.32, -2732.6, 13.65), h = 244.29 },
	 		[2] = { vec3(-1024.81, -2728.76, 13.66), h = 244.29 }, 
	  		[3] = { vec3(-1014.72, -2734.31, 13.66), h = 244.29 },
		},
		vehicles = {
			{ vehicle = 'scorcher', modelo = 'scorcher' },
			{ vehicle = 'tribike', modelo = 'tribike' },
			{ vehicle = 'tribike2', modelo = 'tribike2' },
			{ vehicle = 'tribike3', modelo = 'tribike3' },
			{ vehicle = 'fixter', modelo = 'fixter' },
			{ vehicle = 'cruiser', modelo = 'cruiser' },
			{ vehicle = 'bmx', modelo = 'bmx' },  
		}
	},		
	[14] = { type = 'public', coords = vec3(55.55,-876.43,30.66), perm = nil, -- GARAGEM 1 - Los Santos
		vehiclePositions = {
			[1] = { vec3(50.66,-873.02,30.45), h = 159.65 },                            -- Mais prox do player
			[2] = { vec3(47.53, -872.55, 29.78), h = 159.65 }, 
			[3] = { vec3(43.67, -871.8, 30.45), h = 159.65 },
		}
	},
	[15] = { type = 'public', coords = vec3(596.4,90.65,93.12), perm = nil,  -- GARAGEM 2 proxi central
		vehiclePositions = {
			[1] = { vec3(599.38,98.16,92.06), h = 249.86 },  
			[2] = { vec3(598.81, 94.25, 92.9), h = 249.86 }, -- Mais prox do player
			[3] = { vec3(601.24, 101.6, 92.91), h = 249.86 }, -- Mais distante
		},
  	},
	[16] = { type = 'public', coords = vec3(-340.76,265.97,85.67), perm = nil,  -- GARAGEM 3
		vehiclePositions = {
			[1] = { vec3(-329.74,274.2,85.44), h = 93.8 },
			[2] = { vec3(-330.61, 277.63, 86.24), h = 93.8 },
			[3] = { vec3(-330.47, 281.18, 86.17), h = 93.8 },
		},
	},
	[17] = { type = 'public', coords = vec3(-2030.01,-465.97,11.6), perm = nil, -- GARAGEM 4
		vehiclePositions = {
			[1] = { vec3(-2024.27,-471.93,11.4), h = 140.0 },   
			[2] = { vec3(-2022.83, -474.82, 11.39), h = 140.0 },
			[3] = { vec3(-2020.05, -476.59, 11.4), h = 140.0 },
		}, 
  	},
	[18] = { type = 'public', coords = vec3(-1184.92,-1510.0,4.64), perm = nil, -- GARAGEM 5 // 
		vehiclePositions = {
			[1] = { vec3(-1183.49,-1495.92,4.37), h = 125.0 },
			[2] = { vec3(-1186.58, -1494.06, 4.38), h = 125.0 },
			[3] = { vec3(-1188.28, -1491.64, 4.38), h = 125.0 },
		},
	},
	[19] = { type = 'public', coords = vec3(-73.44,-2004.99,18.27), perm = nil,  -- GARAGEM 6 //
		vehiclePositions = {
			[1] = { vec3(-84.96,-2004.22,18.01), h = 352.0 },
			[2] = { vec3(-81.05, -2002.57, 18.02), h = 352.0 },
			[3] = { vec3(-88.79, -2001.97, 18.02), h = 352.0 },
		},
	},
	[20] = { type = 'public', coords = vec3(214.02,-808.44,31.01), perm = nil, --GARAGEM 7 (atras da praça) //
		vehiclePositions = {
			[1] = { vec3(222.11,-804.16,29.83), h = 247.0 },
			[2] = { vec3(225.07, -799.47, 30.65), h = 247.0 },
			[3] = { vec3(226.79, -794.48, 30.66), h = 247.0 },
		},
	},

	[21] = { type = 'service', coords = vec3(-1605.19,-1164.37,1.28), perm = nil, --EMBARCAÇÕES --PRAIA
		vehiclePositions = {
			[1] = { vec3(-1609.49,-1169.72,0.71), h = 130.0 },
			[2] = { vec3(-1610.59,-1165.13,0.96), h = 130.0 },
		},
		vehicles = {
			{ vehicle = 'dinghy', modelo = 'dinghy' },
			{ vehicle = 'seashark3', modelo = 'seashark3' },
		},
	},
	[22] = { type = 'service', coords = vec3(-1522.68,1494.92,111.58), perm = nil, --EMBARCAÇÕES
		vehiclePositions = {
	  		[1] = { vec3(-1526.63,1499.64,109.08), h = 350.0 },
		},
	  	vehicles = {
			{ vehicle = 'dinghy', modelo = 'dinghy' },
			{ vehicle = 'seashark3', modelo = 'seashark3' },
		},
  	},
	[23] = { type = 'service', coords = vec3(1337.36,4269.71,31.5), perm = nil, --EMBARCAÇÕES - PESCA
		vehiclePositions = {
			[1] = { vec3(1342.19, 4269.05, 30.15), h = 160.0 },
		},
		vehicles = {
			{ vehicle = 'dinghy', modelo = 'dinghy' },
		},
   	},
	[24] = { type = 'service', coords = vec3(-192.32,791.54,198.1), perm = nil,  --EMBARCAÇÕES
		vehiclePositions = {
			[1] = { vec3(-195.95,788.35,195.93), h = 230.0 },
		},
		vehicles = {
			{ vehicle = 'dinghy', modelo = 'dinghy' },
			{ vehicle = 'seashark3', modelo = 'seashark3' },
		},
	},
	[25] = { type = 'public', coords = vec3(885.44, -863.18, 26.12), perm = nil, --Garagem Mecanica //
		vehiclePositions = {
		--   [1] = { vec3(883.01, -863.48, 25.49), h = 169.27 },
		--   [2] = { vec3(108.99, -1060.12, 29.2), h = 66.32 },
		--   [3] = { vec3(111.05, -1057.15, 29.2), h = 66.32 },
			[1] = { vec3(883.05, -864.77, 26.16), h = 180.85 },
			[2] = { vec3(878.78, -865.21, 26.08), h = 180.85 },
		},
	},
	[26] = { type = 'service', coords = vec3(2832.27, 2797.7, 57.46), perm = nil, --Garagem Minerador  //
		vehiclePositions = {
			[1] = { vec3(2827.94, 2798.07, 57.65), h = 161.46 },
		},
		vehicles = {
			{ vehicle = 'tiptruck', modelo = 'Mineradora' },
		}
  	},
	[27] = { type = 'service', coords = vec3(448.42, 6462.58, 28.99), perm = nil, -- Garagem Graos  //
		vehiclePositions = {
			[1] = { vec3(452.68, 6459.54, 29.61), h = 220.40 },
			[2] = { vec3(450.5, 6455.49, 29.53), h = 220.40 },
		},
		vehicles = {
			{ vehicle = 'tractor2', modelo = 'Tractor2' },
			{ vehicle = 'rebel', modelo = 'Rebel' },
		}
	},
	[28] = { type = 'service', coords = vec3(53.44, 114.78, 79.2), perm = nil, --Garagem Carteiro  //
		vehiclePositions = {
			[1] = { vec3(67.5, 122.15, 79.13), h = 162.85 },
		},
		vehicles = {
			{ vehicle = 'boxville2', modelo = 'Van de Entregas' },
		}
	},
	[29] = { type = 'service', coords = vec3(846.66, -961.26, 26.53), perm = 'mecanico.permissao', -- Garagem Mecanica para os mecanicos  //
		vehiclePositions = {
				[1] = { vec3(853.9, -959.23, 26.37), h = 120 }, 
				[2] = { vec3(849.66, -957.07, 26.29), h = 120},
		},
		vehicles = {
			{ vehicle = 'towtruck', modelo = 'towtruck' },
			{ vehicle = 'towtruck2', modelo = 'towtruck2' },
			{ vehicle = 'slamvan3', modelo = 'Slamvan3' },
			{ vehicle = 'yosemite', modelo = 'yosemite' },
			{ vehicle = 'slamvan3', modelo = 'Slamvan3' },

		}
 	},
	[30] = { type = 'public', coords = vec3(2544.72, -760.15, 84.16), perm = nil, -- Favela FBI  //
	 	vehiclePositions = {
		  	[1] = { vec3(2549.55, -759.66, 83.43), h = 2.88 },
	 	--   [2] = { vec3(1547.43, 3780.89, 34.07), h = 27.98 },
	 	},
	},

	[31] = { type = 'public', coords = vec3(699.63, -285.57, 59.27), perm = nil, -- Favela Campínho  //
		vehiclePositions = {
		[1] = { vec3(702.29, -287.32, 59.32), h = 205.85 },
		--   [2] = { vec3(1547.43, 3780.89, 34.07), h = 27.98 },
		},
	},
	[32] = { type = 'service', coords = vec3(-1133.71, -2861.2, 13.95), perm = 'volatus.permissao', marker = "helicóptero", -- GARAGEM 8 aeroporto //
		vehiclePositions = {
	      [1] = { vec3(-1145.69, -2864.46, 13.95) },
		},
		vehicles = {
			{ vehicle = 'volatus', modelo = 'Volatus' },
			
		}
  	},
	  [33] = { type = 'public', coords = vec3(157.26, -124.67, 54.83), perm = nil,  -- Concessionaria  //
	vehiclePositions = {
	  [1] = { vec3(153.57, -123.25, 54.83), h = 339.38 },
	  [2] = { vec3(149.49, -121.41, 54.83), h = 339.38 },
	  
	},
  },	
	  [34] = { type = 'public', coords = vec3(361.9,297.81,103.88), perm = nil, -- Loja 6  //
	vehiclePositions = {
	  [1] = { vec3(361.08,293.5,102.65), h = 249.67 },
	  [2] = { vec3(359.96, 289.89, 103.51), h = 249.67 },
	  [3] = { vec3(357.82, 286.62, 103.51), h = 249.67 },
	},
  },
	  [35] = { type = 'public', coords = vec3(-773.34,5598.15,33.6), perm = nil, -- Teleferico GARAGEM 11(RESPAW PALETO) //
	vehiclePositions = {
	  [1] = { vec3(-772.82,5578.48,32.64), h = 89.01 },
	  [2] = { vec3(-772.52, 5572.67, 33.49), h = 89.01 }, 
	},
  },
	  [36] = { type = 'public', coords = vec3(323.5,-203.07,54.08), perm = nil, -- Vila do Chaves //
	vehiclePositions = {
	  [1] = { vec3(318.07,-203.28,53.24), h = 249.14 },
	  [2] = { vec3(317.4, -206.44, 54.09), h = 249.14 },
	  [3] = { vec3(316.23, -210.4, 54.09), h = 249.14 },
	},
  },
	  [37] = { type = 'public', coords = vec3(317.25,2623.14,44.46), perm = nil, -- Posto 12 GARAGEM 13 //
	vehiclePositions = {
	  [1] = { vec3(334.52,2623.09,44.49), h = 20.0 },
	},
  },
	  [38] = { type = 'public', coords = vec3(1156.9,-453.73,66.98), perm = nil, -- Barbearia 5 GARAGEM 14 //
	vehiclePositions = {
	  [1] = { vec3(1155.2,-461.58,65.97), h = 167.96 },
	  [2] = { vec3(1158.49, -463.41, 66.78), h = 167.96 },
	  [3] = { vec3(1161.52, -464.83, 66.66), h = 167.96 },
	},
  },
	  [39] = { type = 'public', coords = vec3(-102.21,6345.18,31.57), perm = nil, -- Em frente ao galinheiro GARAGEM 15 //
	vehiclePositions = {
	  [1] = { vec3(-98.29,6341.76,30.64), h = 224.27 },
	  [2] = { vec3(-100.56, 6338.39, 31.5), h = 224.27 },
	  [3] = { vec3(-94.26, 6343.83, 31.5), h = 224.27 },
	},
  },

	  [40] = { type = 'public', coords = vec3(1539.67,3780.9,34.06), perm = nil, -- proximo ammu 11 Garagem do norte  //
	vehiclePositions = {
	  [1] = { vec3(1543.06,3780.08,33.64), h = 27.98 },
	  [2] = { vec3(1547.43, 3780.89, 34.07), h = 27.98 },
	},
  },
  	  [41] = { type = 'service', coords = vec3(959.25,-121.06,74.97), perm = 'motoclub.permissao', --Garagem MotoClube  //
	vehiclePositions = {
	  [1] = { vec3(950.86, -123.76, 74.02), h = 215.52 },	  
	},
	vehicles = {
		{ vehicle = 'sanctus', modelo = 'Sanctus' },
		{ vehicle = 'gburrito', modelo = 'Van' },
	}
  },

  	 [42] = { type = 'public', coords = vec3(-1120.73,-832.72,13.34), perm = nil, -- Policia //
	vehiclePositions = {
	  [1] = { vec3(-1126.37,-836.86,12.82), h = 215.52 },
	  
	},
  },

  [43] = { type = 'public', coords = vec3(-2418.17, 1777.42, 187.62), perm = nil, -- França //
	vehiclePositions = {
	  [1] = { vec3(-2423.4, 1778.94, 187.1), h = 43.16 },
	  
	},
  },
	
  [44] = { type = 'public', coords = vec3(-2606.23, 2891.78, 4.84), perm = nil, -- 
	vehiclePositions = {
	  [1] = { vec3(-2613.4, 2899.49, 5.35), h = 61.71 },
	  
	},
  },
	
  [45] = { type = 'public', coords = vec3(2444.08, 3813.57, 39.91), perm = nil, -- Favela norte //
  vehiclePositions = {
	[1] = { vec3(2437.55, 3804.68, 39.68), h = 127.92 },
	
  },
},   
  [46] = { type = 'public', coords = vec3(143.22, -1290.34, 29.37), perm = nil, -- Vanilla //
  vehiclePositions = {
	[1] = { vec3(144.54, -1284.63, 28.94), h = 300.47 },
	[2] = { vec3(143.46, -1281.62, 28.6), h = 300.47 },
	
  },
},
[47] = { type = 'service', coords = vec3(-1133.71, -2861.2, 13.95), perm = 'swift.permissao', marker = "helicóptero", -- GARAGEM 8 aeroporto //
		vehiclePositions = {
	      [1] = { vec3(-1145.69, -2864.46, 13.95) },
		},
		vehicles = {
			{ vehicle = 'swift', modelo = 'Swift' },
			
		}
  	},
[48] = { type = 'service', coords = vec3(115.09, -1954.73, 20.75), perm = 'ballas.permissao', -- Ballas - antiga Groove - 28
	  vehiclePositions = {
		[1] = { vec3(112.22, -1948.33, 19.96), h = 316.35 },
		[2] = { vec3(115.76, -1942.76, 20.13), h = 347.20 },
	  },
	  vehicles = {
		{ vehicle = 'Tornado', modelo = 'Tornado' },
		{ vehicle = 'Peyote', modelo = 'Peyote' },
		{ vehicle = 'Manana', modelo = 'Manana' },

	}
	},	  
[49] = { type = 'public', coords = vec3(604.71, -3127.02, 6.07), perm = nil, -- Groove - galpão //
	vehiclePositions = {
	    [1] = { vec3(609.68, -3130.71, 6.07), h = 300.15 },	  
	    [2] = { vec3( 609.38, -3123.63, 6.07), h = 300.15 },	  
	  },
	},
[50] = { type = 'public', coords = vec3(-1910.58,2023.78, 140.84), perm = nil, -- vinhedo - galpão //
	vehiclePositions = {
	  [1] = { vec3(-1904.66, 2021.21, 140.77), h = 267.968 },
	  [2] = { vec3(-1905.59, 2016.96, 140.94), h = 267.968 },
	},
  },
  
  [51] = { type = 'public', coords = vec3(-833.03, -2351.43, 14.58), perm = nil, -- Aeroporto //
	vehiclePositions = {
	  [1] = { vec3(-829.87, -2356.43, 14.23), h = 330.30 },
	  [2] = { vec3(-827.15, -2358.45, 14.23), h = 330.30 },
	},
  },

  [52] = { type = 'public', coords = vec3(-348.72, -874.77, 31.32), perm = nil, -- Aeroporto //
	vehiclePositions = {
	  [1] = { vec3(-343.51, -875.98, 30.73), h = 167.60 },
	  [2] = { vec3(-339.74, -876.19, 30.73), h = 167.60 },
	  [3] = { vec3(-336.4, -877.14, 30.73), h = 167.60 },

	},
  },

  [53] = { type = 'public', coords = vec3(-276.3,-1913.97,29.95), perm = nil, -- Aeroporto //
  vehiclePositions = {
	[1] = { vec3(-271.48,-1905.32,27.76), h = 167.60 },
	vehicles = {
		{ vehicle = 'swift', modelo = 'Swift' },
		
	}

  },
},
}
-----------------------------------------------------------------
------------------ GARAGENS DAS CASAS ---------------------------
-----------------------------------------------------------------

config.homeGarages = {
	[1] = { type = 'home', coords = vec3(21.41,548.3,176.02),
	  vehiclePositions = {
		[1] = { vec3(14.98,549.89,175.5), h = 60.7 },
	  },
	  home = 'MS01'
	},
	[2] = { type = 'home', coords = vec3(-813.06,184.23,72.47),
	  vehiclePositions = {
		[1] = { vec3(-821.16,185.31,71.25), h = 119.13 },
	  },
	  home = 'MS02'
	},
	[3] = { type = 'home', coords = vec3(-681.48,901.64,230.57),
	  vehiclePositions = {
		[1] = { vec3(-675.44,903.59,229.73), h = 326.35 },
	  },
	  home = 'MS03'
	},
	[4] = { type = 'home', coords = vec3(-2596.87,1927.04,167.31),
	  vehiclePositions = {
		[1] = { vec3(-2588.73,1929.85,166.46), h = 275.01 },
	  },
	  home = 'MS04'
	},
	[5] = { type = 'home', coords = vec3(-3014.84,740.75,27.58),
	  vehiclePositions = {
		[1] = { vec3(-3019.92,740.24,26.63), h = 103.34 },
	  },
	  home = 'MS05'
	},
	[6] = { type = 'home', coords = vec3(-1890.29,-572.99,11.82),
	  vehiclePositions = {
		[1] = { vec3(-1886.63,-571.43,10.93), h = 319.54 },
	  },
	  home = 'MS09'
	},
	[7] = { type = 'home', coords = vec3(1551.96,2190.1,78.85),
	  vehiclePositions = {
		[1] = { vec3(1554.26,2196.07,78.5), h = 352.11 },
	  },
	  home = 'SS01'
	},
	[8] = { type = 'home', coords = vec3(-2977.14,650.92,25.78),
	  vehiclePositions = {
		[1] = { vec3(-2982.74,654.65,25.015), h = 106.83 },
	  },
	  home = 'MS08'
	},
	[9] = { type = 'home', coords = vec3(81.27,6644.04,31.93),
	vehiclePositions = {
	  [1] = { vec3(72.41,6635.25,31.75), h = 142.72 },
	},
	home = 'PB31'
  },
	[10] = { type = 'home', coords = vec3(-1937.07,577.96,119.56),
	  vehiclePositions = {
		[1] = { vec3(-1943.92,583.37,118.79), h = 255.987 },
	  },
	  home = 'LX41'
	},
	[11] = { type = 'home', coords = vec3(-491.13,751.51,162.84),
	  vehiclePositions = {
		[1] = { vec3(-492.05,745.92,162.84), h = 329.81 },
	  },
	  home = 'FH85'
	},
	[12] = { type = 'home', coords = vec3(-877.56,497.95,91.02),
	  vehiclePositions = {
		[1] = { vec3(-872.97,499.76,90.47), h = 106.56 },
	  },
	  home = 'FH02'
	},
	[13] = { type = 'home', coords = vec3(-1005.17,715.55,164.0),
	  vehiclePositions = {
		[1] = { vec3(-1006.29,709.66,162.37), h = 344.07 },
	  },
	  home = 'FH16'
	},
	[14] = { type = 'home', coords = vec3(151.2,568.06,183.98),
	  vehiclePositions = {
		[1] = { vec3(148.7,572.69,183.95), h = 86.85 },
	  },
	  home = 'LX57'
	},
	[15] = { type = 'home', coords = vec3(-864.47,463.46,88.22),
	  vehiclePositions = {
		[1] = { vec3(-861.31,462.66,86.93), h = 276.73 },
	  },
	  home = 'FH01'
	},
	[16] = { type = 'home', coords = vec3(-850.62,522.18,90.62),
	  vehiclePositions = {
		[1] = { vec3(-851.05,514.29,90.15), h = 106.56 },
	  },
	  home = 'FH04'
	},
	[17] = { type = 'home', coords = vec3(-938.56,445.34,80.42),
	  vehiclePositions = {
		[1] = { vec3(-942.71,443.81,79.99), h = 198.88 },
	  },
	  home = 'FH11'
	},
	[18] = { type = 'home', coords = vec3(-1074.27,468.75,77.82),
	  vehiclePositions = {
		[1] = { vec3(-1079.1,465.49,76.79), h = 144.79 },
	  },
	  home = 'FH15'
	},
	[19] = { type = 'home', coords = vec3(-971.31,455.98,79.82),
	  vehiclePositions = {
		[1] = { vec3(-967.03,450.03,78.97), h = 199.58 },
	  },
	  home = 'FH19'
	},
	[20] = { type = 'home', coords = vec3(-736.59,439.85,106.9),
	  vehiclePositions = {
		[1] = { vec3(-736.19,446.59,105.88), h = 3.21 },
	  },
	  home = 'FH23'
	},
	[21] = { type = 'home', coords = vec3(-716.59,500.53,109.27),
	  vehiclePositions = {
		[1] = { vec3(-716.94,495.36,108.43), h = 206.78 },
	  },
	  home = 'FH24'
	},
	[22] = { type = 'home', coords = vec3(-692.91,507.84,110.36),
	  vehiclePositions = {
		[1] = { vec3(-688.85,500.77,109.21), h = 201.51 },
	  },
	  home = 'FH26'
	},
	[23] = { type = 'home', coords = vec3(-574.21,492.54,106.97),
	  vehiclePositions = {
		[1] = { vec3(-573.79,498.15,105.38), h = 9.46 },
	  },
	  home = 'FH29'
	},
	[24] = { type = 'home', coords = vec3(-589.59,531.83,108.17),
	  vehiclePositions = {
		[1] = { vec3(-586.67,526.68,106.72), h = 215.41 },
	  },
	  home = 'FH31'
	},
	[25] = { type = 'home', coords = vec3(-574.01,394.76,100.67),
	  vehiclePositions = {
		[1] = { vec3(-574.73,401.65,99.82), h = 19.61 },
	  },
	  home = 'FH32'
	},
	[26] = { type = 'home', coords = vec3(-447.07,376.54,104.77),
	  vehiclePositions = {
		[1] = { vec3(-456.49,372.48,103.93), h = 358.58 },
	  },
	  home = 'FH45'
	},
	[27] = { type = 'home', coords = vec3(-523.67,525.26,112.44),
	  vehiclePositions = {
		[1] = { vec3(-526.66,530.68,110.95), h = 44.11 },
	  },
	  home = 'FH48'
	},
	[28] = { type = 'home', coords = vec3(-517.36,578.31,120.84),
	  vehiclePositions = {
		[1] = { vec3(-511.63,577.15,119.52), h = 97.85 },
	  },
	  home = 'FH49'
	},
	[29] = { type = 'home', coords = vec3(-470.24,538.11,121.46),
	  vehiclePositions = {
		[1] = { vec3(-468.04,542.62,119.92), h = 355.06 },
	  },
	  home = 'FH52'
	},
	[30] = { type = 'home', coords = vec3(-397.25,512.34,120.19),
	  vehiclePositions = {
		[1] = { vec3(-398.63,518.94,119.68), h = 355.21 },
	  },
	  home = 'FH54'
	},
	[31] = { type = 'home', coords = vec3(-356.43,473.56,112.52),
	  vehiclePositions = {
		[1] = { vec3(-351.33,474.7,111.89), h = 299.59 },
	  },
	  home = 'FH55'
	},
	[32] = { type = 'home', coords = vec3(-357.14,517.38,120.15),
	  vehiclePositions = {
		[1] = { vec3(-362.62,514.72,118.67), h = 134.89 },
	  },
	  home = 'FH58'
	},
	[33] = { type = 'home', coords = vec3(-312.45,483.18,113.46),
	  vehiclePositions = {
		[1] = { vec3(-320.42,480.85,111.44), h = 118.55 },
	  },
	  home = 'FH59'
	},
	[34] = { type = 'home', coords = vec3(-1371.63,451.89,105.34),
	  vehiclePositions = {
		[1] = { vec3(-1376.73,453.26,104.04), h = 80.28 },
	  },
	  home = 'FH68'
	},
	[35] = { type = 'home', coords = vec3(-463.57,676.11,148.54),
	  vehiclePositions = {
		[1] = { vec3(-467.37,673.46,146.8), h = 148.4 },
	  },
	  home = 'FH81'
	},
	[36] = { type = 'home', coords = vec3(-956.88,804.188,177.56),
	  vehiclePositions = {
		[1] = { vec3(-958.62,800.59,176.76), h = 152.94 },
	  },
	  home = 'FH91'
	},
	[37] = { type = 'home', coords = vec3(-921.15,813.8,184.33),
	  vehiclePositions = {
		[1] = { vec3(-920.0,806.38,183.37), h = 189.06 },
	  },
	  home = 'FH92'
	},
	[38] = { type = 'home', coords = vec3(-1004.0,783.99,171.38),
	  vehiclePositions = {
		[1] = { vec3(-997.95,786.76,171.06), h = 293.5 },
	  },
	  home = 'FH93'
	},
	[39] = { type = 'home', coords = vec3(-810.25,803.55,202.18),
	  vehiclePositions = {
		[1] = { vec3(-811.6,809.51,201.24), h = 19.71 },
	  },
	  home = 'FH94'
	},
	[40] = { type = 'home', coords = vec3(-876.54,-57.11,38.05),
	  vehiclePositions = {
		[1] = { vec3(-869.45,-54.25,37.6), h = 281.38 },
	  },
	  home = 'LX01'
	},
	[41] = { type = 'home', coords = vec3(-890.55,-17.35,43.1),
	  vehiclePositions = {
		[1] = { vec3(-885.98,-16.18,42.15), h = 304.12 },
	  },
	  home = 'LX02'
	},
	[42] = { type = 'home', coords = vec3(-872.28,51.35,48.78),
	  vehiclePositions = {
		[1] = { vec3(-875.02,46.86,48.39), h = 195.46 },
	  },
	  home = 'LX03'
	},
	[43] = { type = 'home', coords = vec3(-969.08,107.74,55.66),
	  vehiclePositions = {
		[1] = { vec3(-960.77,109.36,55.49), h = 314.26 },
	  },
	  home = 'LX04'
	},
	[44] = { type = 'home', coords = vec3(-1885.63,629.92,129.99),
	  vehiclePositions = {
		[1] = { vec3(-1890.51,626.0,129.15), h = 136.16 },
	  },
	  home = 'LX05'
	},
	[45] = { type = 'home', coords = vec3(-997.43,142.37,60.66),
	  vehiclePositions = {
		[1] = { vec3(-992.02,144.19,59.81), h = 269.99 },
	  },
	  home = 'LX06'
	},
	[46] = { type = 'home', coords = vec3(-1045.16,224.98,63.76),
	  vehiclePositions = {
		[1] = { vec3(-1048.01,219.47,62.91), h = 184.73 },
	  },
	  home = 'LX07'
	},
	[47] = { type = 'home', coords = vec3(-923.9,212.7,67.46),
	  vehiclePositions = {
		[1] = { vec3(-933.57,210.69,66.61), h = 163.52 },
	  },
	  home = 'LX08'
	},
	[48] = { type = 'home', coords = vec3(-905.04,196.27,69.5),
	  vehiclePositions = {
		[1] = { vec3(-911.78,190.68,68.59), h = 179.92 },
	  },
	  home = 'LX09'
	},
	[49] = { type = 'home', coords = vec3(-915.48,114.68,55.31),
	  vehiclePositions = {
		[1] = { vec3(-920.41,112.49,54.47), h = 84.9 },
	  },
	  home = 'LX10'
	},
	[50] = { type = 'home', coords = vec3(-931.72,13.37,47.91),
	  vehiclePositions = {
		[1] = { vec3(-925.27,9.31,46.87), h = 214.83 },
	  },
	  home = 'LX11'
	},
	[51] = { type = 'home', coords = vec3(-835.07,119.47,55.46),
	  vehiclePositions = {
		[1] = { vec3(-839.12,112.3,54.43), h = 210.36 },
	  },
	  home = 'LX12'
	},
	[52] = { type = 'home', coords = vec3(-1058.75,299.58,66.0),
	  vehiclePositions = {
		[1] = { vec3(-1061.49,305.25,65.13), h = 353.81 },
	  },
	  home = 'LX13'
	},
	[53] = { type = 'home', coords = vec3(-827.87,267.95,86.2),
	  vehiclePositions = {
		[1] = { vec3(-824.72,273.44,85.68), h = 342.78 },
	  },
	  home = 'LX14'
	},
	[54] = { type = 'home', coords = vec3(-869.56,322.71,83.97),
	  vehiclePositions = {
		[1] = { vec3(-870.29,317.83,83.13), h = 186.23 },
	  },
	  home = 'LX15'
	},
	[55] = { type = 'home', coords = vec3(-1026.73,363.75,71.36),
	  vehiclePositions = {
		[1] = { vec3(-1011.08,360.01,70.05), h = 331.43 },
	  },
	  home = 'LX17'
	},
	[56] = { type = 'home', coords = vec3(-1555.85,426.75,109.62),
	  vehiclePositions = {
		[1] = { vec3(-1547.98,426.58,109.09), h = 272.82 },
	  },
	  home = 'LX18'
	},
	[57] = { type = 'home', coords = vec3(-1211.88,274.79,69.51),
	  vehiclePositions = {
		[1] = { vec3(-1204.83,267.12,68.69), h = 284.35 },
	  },
	  home = 'LX19'
	},
	[58] = { type = 'home', coords = vec3(-1101.71,354.46,68.48),
	  vehiclePositions = {
		[1] = { vec3(-1096.63,360.3,67.69), h = 357.45 },
	  },
	  home = 'LX20'
	},
	[59] = { type = 'home', coords = vec3(-1490.24,18.76,54.71),
	  vehiclePositions = {
		[1] = { vec3(-1490.16,23.07,53.88), h = 354.88 },
	  },
	  home = 'LX21'
	},
	[60] = { type = 'home', coords = vec3(-1457.65,-50.22,54.65),
	  vehiclePositions = {
		[1] = { vec3(-1455.68,-55.37,52.6), h = 240.6 },
	  },
	  home = 'LX22'
	},
	[61] = { type = 'home', coords = vec3(-1504.43,19.84,56.4),
	  vehiclePositions = {
		[1] = { vec3(-1503.75,26.86,55.15), h = 8.38 },
	  },
	  home = 'LX23'
	},
	[62] = { type = 'home', coords = vec3(-1581.46,-81.3,54.2),
	  vehiclePositions = {
		[1] = { vec3(-1577.19,-86.02,53.29), h = 270.66 },
	  },
	  home = 'LX24'
	},
	[63] = { type = 'home', coords = vec3(-1585.69,-55.63,56.48),
	  vehiclePositions = {
		[1] = { vec3(-1582.02,-61.06,55.64), h = 270.18 },
	  },
	  home = 'LX25'
	},
	[64] = { type = 'home', coords = vec3(-1558.52,17.86,58.83),
	  vehiclePositions = {
		[1] = { vec3(-1552.69,22.78,57.7), h = 347.5 },
	  },
	  home = 'LX26'
	},
	[65] = { type = 'home', coords = vec3(-1616.73,14.71,62.17),
	  vehiclePositions = {
		[1] = { vec3(-1613.07,20.02,61.32), h = 335.94 },
	  },
	  home = 'LX27'
	},
	[66] = { type = 'home', coords = vec3(-1892.99,120.59,81.64),
	  vehiclePositions = {
		[1] = { vec3(-1887.23,123.26,80.86), h = 338.84 },
	  },
	  home = 'LX28'
	},
	[67] = { type = 'home', coords = vec3(-1940.13,179.1,84.66),
	  vehiclePositions = {
		[1] = { vec3(-1932.93,182.84,83.68), h = 307.83 },
	  },
	  home = 'LX29'
	},
	[68] = { type = 'home', coords = vec3(-2000.65,296.59,91.76),
	  vehiclePositions = {
		[1] = { vec3(-1994.21,290.29,90.85), h = 221.21 },
	  },
	  home = 'LX32'
	},
	[69] = { type = 'home', coords = vec3(-2013.18,453.64,102.67),
	  vehiclePositions = {
		[1] = { vec3(-2006.95,454.86,101.79), h = 276.63 },
	  },
	  home = 'LX34'
	},
	[70] = { type = 'home', coords = vec3(-2016.62,485.7,107.18),
	  vehiclePositions = {
		[1] = { vec3(-2011.39,482.71,106.07), h = 255.38 },
	  },
	  home = 'LX35'
	},
	[71] = { type = 'home', coords = vec3(-1868.36,192.09,84.29),
	  vehiclePositions = {
		[1] = { vec3(-1874.17,194.45,83.77), h = 126.46 },
	  },
	  home = 'LX36'
	},
	[72] = { type = 'home', coords = vec3(-1899.62,241.7,86.26),
	  vehiclePositions = {
		[1] = { vec3(-1904.45,242.14,85.6), h = 27.89 },
	  },
	  home = 'LX37'
	},
	[73] = { type = 'home', coords = vec3(-1918.91,285.25,89.07),
	  vehiclePositions = {
		[1] = { vec3(-1925.28,283.01,88.23), h = 182.84 },
	  },
	  home = 'LX38'
	},
	[74] = { type = 'home', coords = vec3(-1935.69,366.09,93.82),
	  vehiclePositions = {
		[1] = { vec3(-1940.58,360.31,92.55), h = 160.68 },
	  },
	  home = 'LX39'
	},
	[75] = { type = 'home', coords = vec3(-1938.82,386.17,96.5),
	  vehiclePositions = {
		[1] = { vec3(-1943.95,385.19,95.6), h = 96.89 },
	  },
	  home = 'LX40'
	},
	[76] = { type = 'home', coords = vec3(-1937.4,462.55,102.42),
	  vehiclePositions = {
		[1] = { vec3(-1947.37,462.9,101.12), h = 99.05 },
	  },
	  home = 'LX41'
	},
	[77] = { type = 'home', coords = vec3(-1856.34,322.6,88.72),
	  vehiclePositions = {
		[1] = { vec3(-1857.45,328.42,87.8), h = 11.41 },
	  },
	  home = 'LX42'
	},
	[78] = { type = 'home', coords = vec3(-1789.94,345.73,88.55),
	  vehiclePositions = {
		[1] = { vec3(-1790.72,353.87,87.72), h = 64.22 },
	  },
	  home = 'LX43'
	},
	[79] = { type = 'home', coords = vec3(-1745.31,368.33,89.72),
	  vehiclePositions = {
		[1] = { vec3(-1750.77,365.56,88.85), h = 114.91 },
	  },
	  home = 'LX44'
	},
	[80] = { type = 'home', coords = vec3(-1665.21,385.25,89.49),
	  vehiclePositions = {
		[1] = { vec3(-1663.42,391.43,88.39), h = 9.57 },
	  },
	  home = 'LX45'
	},
	[81] = { type = 'home', coords = vec3(-1785.52,456.14,128.3),
	  vehiclePositions = {
		[1] = { vec3(-1794.11,459.4,127.46), h = 98.09 },
	  },
	  home = 'LX46'
	},
	[82] = { type = 'home', coords = vec3(-1991.66,605.61,117.9),
	  vehiclePositions = {
		[1] = { vec3(-1985.63,602.72,117.28), h = 238.48 },
	  },
	  home = 'LX47'
	},
	[83] = { type = 'home', coords = vec3(-1937.7,529.39,110.73),
	  vehiclePositions = {
		[1] = { vec3(-1944.07,521.99,108.31), h = 71.0 },
	  },
	  home = 'LX48'
	},
	[84] = { type = 'home', coords = vec3(-1977.58,624.88,122.53),
	  vehiclePositions = {
		[1] = { vec3(-1971.35,620.69,121.14), h = 246.1 },
	  },
	  home = 'LX50'
	},
	[85] = { type = 'home', coords = vec3(-165.4,919.61,235.65),
	  vehiclePositions = {
		[1] = { vec3(-162.36,926.68,234.8), h = 234.16 },
	  },
	  home = 'LX51'
	},
	[86] = { type = 'home', coords = vec3(-172.67,966.12,237.53),
	  vehiclePositions = {
		[1] = { vec3(-167.03,970.73,235.79), h = 316.56 },
	  },
	  home = 'LX52'
	},
	[87] = { type = 'home', coords = vec3(-124.76,1010.75,235.73),
	  vehiclePositions = {
		[1] = { vec3(-127.89,1001.16,234.88), h = 198.68 },
	  },
	  home = 'LX53'
	},
	[88] = { type = 'home', coords = vec3(-101.17,823.95,235.72),
	  vehiclePositions = {
		[1] = { vec3(-105.63,832.61,234.86), h = 10.25 },
	  },
	  home = 'LX54'
	},
	[89] = { type = 'home', coords = vec3(220.71,755.29,204.85),
	  vehiclePositions = {
		[1] = { vec3(215.84,759.38,203.83), h = 47.56 },
	  },
	  home = 'LX55'
	},
	[90] = { type = 'home', coords = vec3(100.21,563.99,182.94),
	  vehiclePositions = {
		[1] = { vec3(93.13,575.77,182.13), h = 86.85 },
	  },
	  home = 'LX58'
	},
	[91] = { type = 'home', coords = vec3(52.84,559.77,180.21),
	  vehiclePositions = {
		[1] = { vec3(53.19,563.71,179.54), h = 21.7 },
	  },
	  home = 'LX59'
	},
	[92] = { type = 'home', coords = vec3(-143.65,593.14,203.9),
	  vehiclePositions = {
		[1] = { vec3(-142.21,597.23,203.12), h = 358.34 },
	  },
	  home = 'LX60'
	},
	[93] = { type = 'home', coords = vec3(-196.6,621.58,197.91),
	  vehiclePositions = {
		[1] = { vec3(-199.24,615.31,196.21), h = 178.98 },
	  },
	  home = 'LX61'
	},
	[94] = { type = 'home', coords = vec3(-174.92,590.04,197.63),
	  vehiclePositions = {
		[1] = { vec3(-178.23,587.21,197.03), h = 359.63 },
	  },
	  home = 'LX62'
	},
	[95] = { type = 'home', coords = vec3(-224.87,588.93,190.02),
	  vehiclePositions = {
		[1] = { vec3(-221.77,593.25,189.61), h = 331.22 },
	  },
	  home = 'LX63'
	},
	[96] = { type = 'home', coords = vec3(-271.65,599.1,181.68),
	  vehiclePositions = {
		[1] = { vec3(-272.26,603.6,181.15), h = 346.6 },
	  },
	  home = 'LX64'
	},
	[97] = { type = 'home', coords = vec3(-241.91,614.9,187.77),
	  vehiclePositions = {
		[1] = { vec3(-244.12,610.79,186.09), h = 149.22 },
	  },
	  home = 'LX65'
	},
	[98] = { type = 'home', coords = vec3(1290.05,-585.69,71.75),
	  vehiclePositions = {
		[1] = { vec3(1295.49,-567.62,71.49), h = 344.65 },
	  },
	  home = 'LS01'
	},
	[99] = { type = 'home', coords = vec3(1311.03,-593.07,72.93),
	  vehiclePositions = {
		[1] = { vec3(1319.19,-575.18,73.25), h = 336.97 },
	  },
	  home = 'LS02'
	},
	[100] = { type = 'home', coords = vec3(1344.65,-609.86,74.36),
	  vehiclePositions = {
		[1] = { vec3(1348.97,-603.76,74.64), h = 334.73 },
	  },
	  home = 'LS03'
	},
	[101] = { type = 'home', coords = vec3(1359.91,-620.48,74.34),
	  vehiclePositions = {
		[1] = { vec3(1360.55,-601.83,74.62), h = 359.42 },
	  },
	  home = 'LS04'
	},
	[102] = { type = 'home', coords = vec3(1392.87,-607.72,74.35),
	  vehiclePositions = {
		[1] = { vec3(1378.33,-596.21,74.61), h = 52.88 },
	  },
	  home = 'LS05'
	},
	[103] = { type = 'home', coords = vec3(1404.84,-570.68,74.35),
	  vehiclePositions = {
		[1] = { vec3(1387.73,-577.37,74.62), h = 113.2 },
	  },
	  home = 'LS06'
	},
	[104] = { type = 'home', coords = vec3(1366.95,-544.46,74.34),
	  vehiclePositions = {
		[1] = { vec3(1363.05,-551.94,74.62), h = 157.25 },
	  },
	  home = 'LS07'
	},
	[105] = { type = 'home', coords = vec3(1360.66,-536.8,73.78),
	  vehiclePositions = {
		[1] = { vec3(1352.89,-553.3,74.31), h = 156.76 },
	  },
	  home = 'LS08'
	},
	[106] = { type = 'home', coords = vec3(1322.0,-524.9,72.13),
	  vehiclePositions = {
		[1] = { vec3(1318.24,-532.96,72.35), h = 160.86 },
	  },
	  home = 'LS09'
	},
	[107] = { type = 'home', coords = vec3(1314.79,-516.59,71.41),
	  vehiclePositions = {
		[1] = { vec3(1307.96,-533.58,71.56), h = 160.38 },
	  },
	  home = 'LS10'
	},
	[108] = { type = 'home', coords = vec3(1245.08,-518.7,69.0),
	  vehiclePositions = {
		[1] = { vec3(1247.17,-522.7,69.25), h = 257.36 },
	  },
	  home = 'LS11'
	},
	[109] = { type = 'home', coords = vec3(1251.25,-490.29,69.5),
	  vehiclePositions = {
		[1] = { vec3(1260.63,-494.22,69.59), h = 255.66 },
	  },
	  home = 'LS12'
	},
	[110] = { type = 'home', coords = vec3(1259.55,-477.81,70.19),
	  vehiclePositions = {
		[1] = { vec3(1280.06,-472.81,69.24), h = 170.02 },
	  },
	  home = 'LS13'
	},
	[111] = { type = 'home', coords = vec3(1268.56,-461.81,69.84),
	  vehiclePositions = {
		[1] = { vec3(1270.98,-463.9,69.87), h = 328.18 },
	  },
	  home = 'LS14'
	},
	[112] = { type = 'home', coords = vec3(1261.12,-426.7,69.81),
	  vehiclePositions = {
		[1] = { vec3(1261.45,-419.35,69.58), h = 297.04 },
	  },
	  home = 'LS15'
	},
	[113] = { type = 'home', coords = vec3(1234.75,-578.25,69.49),
	  vehiclePositions = {
		[1] = { vec3(1243.86,-579.36,69.64), h = 271.53 },
	  },
	  home = 'LS16'
	},
	[114] = { type = 'home', coords = vec3(1236.79,-589.55,69.79),
	  vehiclePositions = {
		[1] = { vec3(1242.92,-586.85,69.55), h = 269.57 },
	  },
	  home = 'LS17'
	},
	[115] = { type = 'home', coords = vec3(1250.47,-626.17,69.35),
	  vehiclePositions = {
		[1] = { vec3(1259.06,-624.91,69.58), h = 296.96 },
	  },
	  home = 'LS18'
	},
	[116] = { type = 'home', coords = vec3(1257.67,-660.38,67.93),
	  vehiclePositions = {
		[1] = { vec3(1271.84,-659.12,68.0), h = 293.69 },
	  },
	  home = 'LS19'
	},
	[117] = { type = 'home', coords = vec3(1267.25,-673.65,65.75),
	  vehiclePositions = {
		[1] = { vec3(1276.75,-673.42,66.25), h = 277.48 },
	  },
	  home = 'LS20'
	},
	[118] = { type = 'home', coords = vec3(1259.79,-711.08,64.72),
	  vehiclePositions = {
		[1] = { vec3(1263.72,-716.66,64.75), h = 239.07 },
	  },
	  home = 'LS21'
	},
	[119] = { type = 'home', coords = vec3(1225.19,-723.04,60.64),
	  vehiclePositions = {
		[1] = { vec3(1223.46,-730.21,60.4), h = 163.48 },
	  },
	  home = 'LS22'
	},
	[120] = { type = 'home', coords = vec3(1228.5,-703.47,60.68),
	  vehiclePositions = {
		[1] = { vec3(1217.85,-704.09,60.7), h = 97.24 },
	  },
	  home = 'LS23'
	},
	[121] = { type = 'home', coords = vec3(1220.91,-664.18,63.13),
	  vehiclePositions = {
		[1] = { vec3(1214.36,-665.12,62.85), h = 103.07 },
	  },
	  home = 'LS24'
	},
	[122] = { type = 'home', coords = vec3(1206.75,-614.0,66.12),
	  vehiclePositions = {
		[1] = { vec3(1199.98,-612.47,65.36), h = 94.4 },
	  },
	  home = 'LS25'
	},
	[123] = { type = 'home', coords = vec3(1192.48,-597.08,64.01),
	  vehiclePositions = {
		[1] = { vec3(1188.28,-595.06,64.23), h = 34.45 },
	  },
	  home = 'LS26'
	},
	[124] = { type = 'home', coords = vec3(1189.79,-573.78,64.32),
	  vehiclePositions = {
		[1] = { vec3(1185.82,-569.96,64.56), h = 25.68 },
	  },
	  home = 'LS27'
	},
	[125] = { type = 'home', coords = vec3(1191.61,-554.97,64.71),
	  vehiclePositions = {
		[1] = { vec3(1187.47,-550.38,64.83), h = 86.85 },
	  },
	  home = 'LS28'
	},
	[126] = { type = 'home', coords = vec3(1089.59,-495.42,65.07),
	  vehiclePositions = {
		[1] = { vec3(1084.78,-493.34,64.4), h = 79.01 },
	  },
	  home = 'LS29'
	},
	[127] = { type = 'home', coords = vec3(1101.7,-468.42,67.06),
	  vehiclePositions = {
		[1] = { vec3(1091.28,-470.87,65.47), h = 77.7 },
	  },
	  home = 'LS30'
	},
	[128] = { type = 'home', coords = vec3(1111.03,-417.0,67.16),
	  vehiclePositions = {
		[1] = { vec3(1111.15,-419.57,67.43), h = 83.31 },
	  },
	  home = 'LS31'
	},
	[129] = { type = 'home', coords = vec3(1112.77,-394.29,68.74),
	  vehiclePositions = {
		[1] = { vec3(1106.07,-399.24,68.2), h = 78.01 },
	  },
	  home = 'LS32'
	},
	[130] = { type = 'home', coords = vec3(1057.42,-384.09,67.86),
	  vehiclePositions = {
		[1] = { vec3(1056.9,-388.45,68.09), h = 221.13 },
	  },
	  home = 'LS33'
	},
	[131] = { type = 'home', coords = vec3(1021.13,-414.33,65.95),
	  vehiclePositions = {
		[1] = { vec3(1022.37,-419.52,66.05), h = 219.15 },
	  },
	  home = 'LS34'
	},
	[132] = { type = 'home', coords = vec3(1009.82,-418.88,64.96),
	  vehiclePositions = {
		[1] = { vec3(1015.92,-423.87,65.32), h = 217.1 },
	  },
	  home = 'LS35'
	},
	[133] = { type = 'home', coords = vec3(987.71,-438.07,63.75),
	  vehiclePositions = {
		[1] = { vec3(995.76,-435.43,64.23), h = 271.01 },
	  },
	  home = 'LS36'
	},
	[134] = { type = 'home', coords = vec3(971.53,-447.94,62.41),
	  vehiclePositions = {
		[1] = { vec3(975.54,-454.41,62.86), h = 213.74 },
	  },
	  home = 'LS37'
	},
	[135] = { type = 'home', coords = vec3(939.3,-463.22,61.26),
	  vehiclePositions = {
		[1] = { vec3(942.05,-469.79,61.53), h = 212.33 },
	  },
	  home = 'LS38'
	},
	[136] = { type = 'home', coords = vec3(928.77,-475.65,60.7),
	  vehiclePositions = {
		[1] = { vec3(933.31,-480.49,60.88), h = 203.27 },
	  },
	  home = 'LS39'
	},
	[137] = { type = 'home', coords = vec3(909.42,-489.73,59.02),
	  vehiclePositions = {
		[1] = { vec3(914.46,-490.17,59.29), h = 204.27 },
	  },
	  home = 'LS40'
	},
	[138] = { type = 'home', coords = vec3(873.98,-503.77,57.5),
	  vehiclePositions = {
		[1] = { vec3(874.77,-507.45,57.72), h = 226.29 },
	  },
	  home = 'LS41'
	},
	[139] = { type = 'home', coords = vec3(854.95,-516.17,57.33),
	  vehiclePositions = {
		[1] = { vec3(858.81,-522.39,57.59), h = 227.66 },
	  },
	  home = 'LS42'
	},
	[140] = { type = 'home', coords = vec3(848.57,-540.12,57.33),
	  vehiclePositions = {
		[1] = { vec3(853.51,-542.76,57.6), h = 266.06 },
	  },
	  home = 'LS43'
	},
	[141] = { type = 'home', coords = vec3(842.1,-567.41,57.71),
	  vehiclePositions = {
		[1] = { vec3(849.29,-567.47,57.99), h = 279.71 },
	  },
	  home = 'LS44'
	},
	[142] = { type = 'home', coords = vec3(868.47,-594.02,58.3),
	  vehiclePositions = {
		[1] = { vec3(872.86,-590.11,58.28), h = 317.23 },
	  },
	  home = 'LS45'
	},
	[143] = { type = 'home', coords = vec3(875.58,-602.34,58.45),
	  vehiclePositions = {
		[1] = { vec3(875.55,-598.36,58.45), h = 316.61 },
	  },
	  home = 'LS46'
	},
	[144] = { type = 'home', coords = vec3(912.15,-631.81,58.05),
	  vehiclePositions = {
		[1] = { vec3(917.67,-627.46,58.32), h = 319.36 },
	  },
	  home = 'LS47'
	},
	[145] = { type = 'home', coords = vec3(913.03,-645.12,57.87),
	  vehiclePositions = {
		[1] = { vec3(917.96,-639.77,58.14), h = 318.18 },
	  },
	  home = 'LS48'
	},
	[146] = { type = 'home', coords = vec3(946.14,-657.5,58.02),
	  vehiclePositions = {
		[1] = { vec3(951.67,-654.13,58.16), h = 309.34 },
	  },
	  home = 'LS49'
	},
	[147] = { type = 'home', coords = vec3(940.18,-672.19,58.02),
	  vehiclePositions = {
		[1] = { vec3(946.99,-669.22,58.29), h = 297.96 },
	  },
	  home = 'LS50'
	},
	[148] = { type = 'home', coords = vec3(969.7,-688.32,57.95),
	  vehiclePositions = {
		[1] = { vec3(973.59,-685.58,57.91), h = 309.99 },
	  },
	  home = 'LS51'
	},
	[149] = { type = 'home', coords = vec3(976.24,-713.97,57.87),
	  vehiclePositions = {
		[1] = { vec3(982.5,-709.42,57.88), h = 312.02 },
	  },
	  home = 'LS52'
	},
	[150] = { type = 'home', coords = vec3(1004.32,-734.1,57.46),
	  vehiclePositions = {
		[1] = { vec3(1008.02,-731.13,57.88), h = 311.05 },
	  },
	  home = 'LS53'
	},
	[151] = { type = 'home', coords = vec3(981.21,-614.8,58.84),
	  vehiclePositions = {
		[1] = { vec3(973.52,-619.61,59.1), h = 128.1 },
	  },
	  home = 'LS54'
	},
	[152] = { type = 'home', coords = vec3(959.79,-601.7,59.5),
	  vehiclePositions = {
		[1] = { vec3(955.45,-598.08,59.65), h = 27.96 },
	  },
	  home = 'LS55'
	},
	[153] = { type = 'home', coords = vec3(984.25,-579.14,59.28),
	  vehiclePositions = {
		[1] = { vec3(982.93,-572.6,59.53), h = 31.32 },
	  },
	  home = 'LS56'
	},
	[154] = { type = 'home', coords = vec3(1008.54,-565.15,60.2),
	  vehiclePositions = {
		[1] = { vec3(1012.51,-563.56,60.44), h = 263.72 },
	  },
	  home = 'LS57'
	},
	[155] = { type = 'home', coords = vec3(943.81,-243.89,68.63),
	  vehiclePositions = {
		[1] = { vec3(939.22,-250.12,68.69), h = 150.37 },
	  },
	  home = 'LS58'
	},
	[156] = { type = 'home', coords = vec3(1003.79,-588.12,59.14),
	  vehiclePositions = {
		[1] = { vec3(1009.07,-590.25,59.2), h = 258.95 },
	  },
	  home = 'LS59'
	},
	[157] = { type = 'home', coords = vec3(922.71,-564.06,57.97),
	  vehiclePositions = {
		[1] = { vec3(926.46,-567.39,58.24), h = 206.14 },
	  },
	  home = 'LS60'
	},
	[158] = { type = 'home', coords = vec3(956.87,-546.73,59.53),
	  vehiclePositions = {
		[1] = { vec3(957.91,-552.49,59.55), h = 211.12 },
	  },
	  home = 'LS61'
	},
	[159] = { type = 'home', coords = vec3(981.96,-530.0,60.12),
	  vehiclePositions = {
		[1] = { vec3(983.27,-536.41,60.19), h = 211.11 },
	  },
	  home = 'LS62'
	},
	[160] = { type = 'home', coords = vec3(1001.36,-510.47,60.7),
	  vehiclePositions = {
		[1] = { vec3(1003.89,-518.48,60.98), h = 205.24 },
	  },
	  home = 'LS63'
	},
	[161] = { type = 'home', coords = vec3(1045.95,-495.92,64.08),
	  vehiclePositions = {
		[1] = { vec3(1049.91,-488.79,64.19), h = 257.03 },
	  },
	  home = 'LS64'
	},
	[162] = { type = 'home', coords = vec3(1049.12,-479.89,64.1),
	  vehiclePositions = {
		[1] = { vec3(1056.64,-483.32,64.11), h = 257.85 },
	  },
	  home = 'LS65'
	},
	[163] = { type = 'home', coords = vec3(1055.36,-445.56,65.97),
	  vehiclePositions = {
		[1] = { vec3(1062.56,-445.67,66.16), h = 257.58 },
	  },
	  home = 'LS66'
	},
	[164] = { type = 'home', coords = vec3(1020.06,-464.4,63.9),
	  vehiclePositions = {
		[1] = { vec3(1019.04,-459.29,64.37), h = 38.05 },
	  },
	  home = 'LS67'
	},
	[165] = { type = 'home', coords = vec3(966.19,-505.37,61.74),
	  vehiclePositions = {
		[1] = { vec3(960.86,-500.52,61.65), h = 29.8 },
	  },
	  home = 'LS68'
	},
	[166] = { type = 'home', coords = vec3(950.42,-516.97,60.25),
	  vehiclePositions = {
		[1] = { vec3(948.5,-511.66,60.5), h = 29.22 },
	  },
	  home = 'LS69'
	},
	[167] = { type = 'home', coords = vec3(921.11,-527.47,59.58),
	  vehiclePositions = {
		[1] = { vec3(915.83,-522.63,59.03), h = 25.35 },
	  },
	  home = 'LS70'
	},
	[168] = { type = 'home', coords = vec3(893.88,-547.44,58.17),
	  vehiclePositions = {
		[1] = { vec3(888.36,-551.92,58.24), h = 115.0 },
	  },
	  home = 'LS71'
	},
	[169] = { type = 'home', coords = vec3(1103.28,-429.62,67.4),
	  vehiclePositions = {
		[1] = { vec3(1097.86,-428.24,66.68), h = 80.97 },
	  },
	  home = 'LS72'
	},
	-- [170] = { type = 'home', coords = vec3(102.82,-1959.78,20.84),
	--   vehiclePositions = {
	-- 	[1] = { vec3(104.57,-1954.94,20.95), h = 355.58 },
	--   },
	--   home = 'KR01'
	-- },
	[171] = { type = 'home', coords = vec3(72.16,-1935.47,20.99),
	  vehiclePositions = {
		[1] = { vec3(81.72,-1932.41,21.02), h = 316.63 },
	  },
	  home = 'KR02'
	},
	[172] = { type = 'home', coords = vec3(14.13,-1886.93,23.24),
	  vehiclePositions = {
		[1] = { vec3(18.48,-1880.11,23.28), h = 320.5 },
	  },
	  home = 'KR03'
	},
	[173] = { type = 'home', coords = vec3(98.75,-1907.55,21.07),
	  vehiclePositions = {
		[1] = { vec3(89.81,-1917.18,20.98), h = 140.59 },
	  },
	  home = 'KR04'
	},
	[174] = { type = 'home', coords = vec3(101.95,-1883.62,24.02),
	  vehiclePositions = {
		[1] = { vec3(105.76,-1879.36,24.22), h = 319.71 },
	  },
	  home = 'KR05'
	},
	[175] = { type = 'home', coords = vec3(157.6,-1901.16,23.0),
	  vehiclePositions = {
		[1] = { vec3(162.82,-1899.28,23.26), h = 334.81 },
	  },
	  home = 'KR06'
	},
	[176] = { type = 'home', coords = vec3(163.9,-1954.67,19.32),
	  vehiclePositions = {
		[1] = { vec3(165.73,-1959.08,19.43), h = 227.78 },
	  },
	  home = 'KR07'
	},
	[177] = { type = 'home', coords = vec3(152.53,-1960.61,19.08),
	  vehiclePositions = {
		[1] = { vec3(152.79,-1965.88,19.04), h = 228.5 },
	  },
	  home = 'KR08'
	},
	[178] = { type = 'home', coords = vec3(58.69,-1878.41,22.39),
	  vehiclePositions = {
		[1] = { vec3(52.14,-1878.42,22.53), h = 136.83 },
	  },
	  home = 'KR09'
	},
	[179] = { type = 'home', coords = vec3(45.4,-1849.13,22.84),
	  vehiclePositions = {
		[1] = { vec3(41.44,-1853.34,23.11), h = 135.2 },
	  },
	  home = 'KR10'
	},
	[180] = { type = 'home', coords = vec3(-45.22,-1791.79,27.45),
	  vehiclePositions = {
		[1] = { vec3(-53.0,-1801.42,27.36), h = 50.04 },
	  },
	  home = 'KR11'
	},
	[181] = { type = 'home', coords = vec3(-54.09,-1781.86,27.88),
	  vehiclePositions = {
		[1] = { vec3(-57.67,-1785.85,28.12), h = 136.73 },
	  },
	  home = 'KR12'
	},
	[182] = { type = 'home', coords = vec3(140.35,-1866.11,24.32),
	  vehiclePositions = {
		[1] = { vec3(136.94,-1869.3,24.4), h = 155.02 },
	  },
	  home = 'KR13'
	},
	[183] = { type = 'home', coords = vec3(189.37,-1872.27,24.73),
	  vehiclePositions = {
		[1] = { vec3(186.58,-1877.13,24.85), h = 154.49 },
	  },
	  home = 'KR14'
	},
	[184] = { type = 'home', coords = vec3(248.21,-1732.71,29.38),
	  vehiclePositions = {
		[1] = { vec3(244.51,-1728.83,29.5), h = 49.0 },
	  },
	  home = 'KR15'
	},
	[185] = { type = 'home', coords = vec3(272.34,-1704.01,29.31),
	  vehiclePositions = {
		[1] = { vec3(268.09,-1700.73,29.57), h = 49.31 },
	  },
	  home = 'KR16'
	},
	[186] = { type = 'home', coords = vec3(291.46,-1783.92,28.26),
	  vehiclePositions = {
		[1] = { vec3(297.45,-1791.53,28.19), h = 228.58 },
	  },
	  home = 'KR17'
	},
	[187] = { type = 'home', coords = vec3(319.33,-1769.51,29.08),
	  vehiclePositions = {
		[1] = { vec3(321.52,-1773.31,28.93), h = 229.23 },
	  },
	  home = 'KR18'
	},
	[188] = { type = 'home', coords = vec3(142.93,-1832.74,27.07),
	  vehiclePositions = {
		[1] = { vec3(138.97,-1830.69,27.29), h = 49.32 },
	  },
	  home = 'KR19'
	},
	[189] = { type = 'home', coords = vec3(83.64,-1973.9,20.93),
	  vehiclePositions = {
		[1] = { vec3(87.72,-1968.8,21.03), h = 319.25 },
	  },
	  home = 'KR20'
	},
	[190] = { type = 'home', coords = vec3(80.39,-1949.55,20.8),
	  vehiclePositions = {
		[1] = { vec3(89.19,-1934.65,20.91), h = 217.76 },
	  },
	  home = 'KR21'
	},
	[191] = { type = 'home', coords = vec3(54.53,-1921.05,21.66),
	  vehiclePositions = {
		[1] = { vec3(62.29,-1910.55,21.78), h = 230.76 },
	  },
	  home = 'KR22'
	},
	[192] = { type = 'home', coords = vec3(37.3,-1926.34,21.8),
	  vehiclePositions = {
		[1] = { vec3(42.47,-1920.65,21.94), h = 320.78 },
	  },
	  home = 'KR23'
	},
	[193] = { type = 'home', coords = vec3(-10.49,-1883.78,24.15),
	  vehiclePositions = {
		[1] = { vec3(0.4,-1878.23,23.07), h = 319.84 },
	  },
	  home = 'KR24'
	},
	[194] = { type = 'home', coords = vec3(7.46,-1884.39,23.32),
	  vehiclePositions = {
		[1] = { vec3(15.62,-1871.47,23.56), h = 228.24 },
	  },
	  home = 'KR25'
	},
	[195] = { type = 'home', coords = vec3(-23.09,-1857.7,25.04),
	  vehiclePositions = {
		[1] = { vec3(-22.28,-1852.32,25.35), h = 318.16 },
	  },
	  home = 'KR26'
	},
	[196] = { type = 'home', coords = vec3(-33.91,-1855.64,26.01),
	  vehiclePositions = {
		[1] = { vec3(-36.14,-1861.29,26.03), h = 318.25 },
	  },
	  home = 'KR27'
	},
	[197] = { type = 'home', coords = vec3(123.49,-1927.1,21.01),
	  vehiclePositions = {
		[1] = { vec3(118.66,-1940.02,20.95), h = 86.06 },
	  },
	  home = 'KR28'
	},
	[198] = { type = 'home', coords = vec3(116.48,-1918.75,20.94),
	  vehiclePositions = {
		[1] = { vec3(109.49,-1924.84,21.03), h = 159.44 },
	  },
	  home = 'KR29'
	},
	[199] = { type = 'home', coords = vec3(112.4,-1884.8,23.59),
	  vehiclePositions = {
		[1] = { vec3(125.42,-1877.96,23.98), h = 245.04 },
	  },
	  home = 'KR30'
	},
	[200] = { type = 'home', coords = vec3(163.74,-1922.7,21.2),
	  vehiclePositions = {
		[1] = { vec3(166.25,-1929.66,21.29), h = 230.07 },
	  },
	  home = 'KR31'
	},
	[201] = { type = 'home', coords = vec3(142.93,-1970.81,18.86),
	  vehiclePositions = {
		[1] = { vec3(153.95,-1978.59,18.55), h = 139.63 },
	  },
	  home = 'KR32'
	},
	[202] = { type = 'home', coords = vec3(28.49,-1852.1,23.68),
	  vehiclePositions = {
		[1] = { vec3(20.42,-1863.32,23.63), h = 50.07 },
	  },
	  home = 'KR33'
	},
	[203] = { type = 'home', coords = vec3(11.84,-1843.19,24.53),
	  vehiclePositions = {
		[1] = { vec3(8.43,-1845.9,24.64), h = 139.44 },
	  },
	  home = 'KR34'
	},
	[204] = { type = 'home', coords = vec3(167.84,-1854.07,24.29),
	  vehiclePositions = {
		[1] = { vec3(165.62,-1861.16,24.41), h = 155.81 },
	  },
	  home = 'KR35'
	},
	[205] = { type = 'home', coords = vec3(206.99,-1892.89,24.43),
	  vehiclePositions = {
		[1] = { vec3(198.9,-1897.55,24.5), h = 142.92 },
	  },
	  home = 'KR36'
	},
	[206] = { type = 'home', coords = vec3(302.56,-1777.35,29.1),
	  vehiclePositions = {
		[1] = { vec3(312.42,-1785.76,28.42), h = 229.27 },
	  },
	  home = 'KR37'
	},
	[207] = { type = 'home', coords = vec3(289.96,-1789.91,27.7),
	  vehiclePositions = {
		[1] = { vec3(297.45,-1791.53,28.19), h = 228.58 },
	  },
	  home = 'KR38'
	},
	[208] = { type = 'home', coords = vec3(311.04,-1735.44,29.54),
	  vehiclePositions = {
		[1] = { vec3(315.43,-1739.08,29.73), h = 231.04 },
	  },
	  home = 'KR39'
	},
	[209] = { type = 'home', coords = vec3(269.11,-1728.64,29.65),
	  vehiclePositions = {
		[1] = { vec3(264.26,-1718.68,29.56), h = 49.25 },
	  },
	  home = 'KR40'
	},
	[210] = { type = 'home', coords = vec3(269.79,-1710.52,29.34),
	  vehiclePositions = {
		[1] = { vec3(257.55,-1701.71,29.31), h = 320.02 },
	  },
	  home = 'KR41'
	},
	[211] = { type = 'home', coords = vec3(248.94,-1936.94,24.35),
	  vehiclePositions = {
		[1] = { vec3(240.16,-1927.99,24.39), h = 319.7 },
	  },
	  home = 'LV01'
	},
	[212] = { type = 'home', coords = vec3(269.8,-1932.86,25.44),
	  vehiclePositions = {
		[1] = { vec3(263.07,-1921.28,25.41), h = 54.74 },
	  },
	  home = 'LV02'
	},
	[213] = { type = 'home', coords = vec3(270.61,-1914.8,25.81),
	  vehiclePositions = {
		[1] = { vec3(270.12,-1905.53,26.78), h = 51.02 },
	  },
	  home = 'LV03'
	},
	[214] = { type = 'home', coords = vec3(279.17,-1899.45,26.89),
	  vehiclePositions = {
		[1] = { vec3(269.73,-1892.82,26.83), h = 319.63 },
	  },
	  home = 'LV04'
	},
	[215] = { type = 'home', coords = vec3(318.07,-1856.29,27.11),
	  vehiclePositions = {
		[1] = { vec3(305.2,-1850.27,27.0), h = 320.21 },
	  },
	  home = 'LV05'
	},
	[216] = { type = 'home', coords = vec3(340.81,-1849.98,27.77),
	  vehiclePositions = {
		[1] = { vec3(335.81,-1835.98,27.61), h = 44.87 },
	  },
	  home = 'LV06'
	},
	[217] = { type = 'home', coords = vec3(344.21,-1828.31,27.95),
	  vehiclePositions = {
		[1] = { vec3(333.16,-1817.23,27.99), h = 320.18 },
	  },
	  home = 'LV07'
	},
	[218] = { type = 'home', coords = vec3(350.15,-1811.51,28.8),
	  vehiclePositions = {
		[1] = { vec3(342.37,-1806.23,28.48), h = 319.97 },
	  },
	  home = 'LV08'
	},
	[219] = { type = 'home', coords = vec3(404.54,-1753.91,29.37),
	  vehiclePositions = {
		[1] = { vec3(403.61,-1739.39,29.54), h = 46.7 },
	  },
	  home = 'LV09'
	},
	[220] = { type = 'home', coords = vec3(430.66,-1741.22,29.61),
	  vehiclePositions = {
		[1] = { vec3(431.33,-1735.54,28.65), h = 50.2 },
	  },
	  home = 'LV10'
	},
	[221] = { type = 'home', coords = vec3(434.96,-1715.43,29.33),
	  vehiclePositions = {
		[1] = { vec3(430.06,-1715.87,28.69), h = 49.34 },
	  },
	  home = 'LV11'
	},
	[222] = { type = 'home', coords = vec3(442.86,-1698.41,29.38),
	  vehiclePositions = {
		[1] = { vec3(442.78,-1693.12,28.66), h = 51.33 },
	  },
	  home = 'LV12'
	},
	[223] = { type = 'home', coords = vec3(498.38,-1698.89,29.41),
	  vehiclePositions = {
		[1] = { vec3(498.01,-1702.77,29.64), h = 236.28 },
	  },
	  home = 'LV13'
	},
	[224] = { type = 'home', coords = vec3(479.02,-1718.03,29.37),
	  vehiclePositions = {
		[1] = { vec3(490.02,-1721.93,29.62), h = 251.19 },
	  },
	  home = 'LV14'
	},
	[225] = { type = 'home', coords = vec3(464.62,-1740.78,29.11),
	  vehiclePositions = {
		[1] = { vec3(473.8,-1744.08,29.21), h = 250.4 },
	  },
	  home = 'LV15'
	},
	[226] = { type = 'home', coords = vec3(475.52,-1755.13,28.76),
	  vehiclePositions = {
		[1] = { vec3(488.5,-1757.75,28.71), h = 163.16 },
	  },
	  home = 'LV16'
	},
	[227] = { type = 'home', coords = vec3(475.02,-1772.84,28.7),
	  vehiclePositions = {
		[1] = { vec3(478.21,-1779.06,28.93), h = 270.19 },
	  },
	  home = 'LV17'
	},
	[228] = { type = 'home', coords = vec3(511.46,-1778.19,28.51),
	  vehiclePositions = {
		[1] = { vec3(499.79,-1777.14,28.64), h = 201.67 },
	  },
	  home = 'LV18'
	},
	[229] = { type = 'home', coords = vec3(504.82,-1799.04,28.49),
	  vehiclePositions = {
		[1] = { vec3(500.19,-1792.86,28.65), h = 161.09 },
	  },
	  home = 'LV19'
	},
	[230] = { type = 'home', coords = vec3(504.77,-1808.65,28.51),
	  vehiclePositions = {
		[1] = { vec3(491.87,-1805.02,28.65), h = 138.92 },
	  },
	  home = 'LV20'
	},
	[231] = { type = 'home', coords = vec3(487.7,-1826.73,28.53),
	  vehiclePositions = {
		[1] = { vec3(479.28,-1819.72,28.1), h = 139.7 },
	  },
	  home = 'LV21'
	},
	[232] = { type = 'home', coords = vec3(431.96,-1828.9,28.18),
	  vehiclePositions = {
		[1] = { vec3(437.06,-1837.91,28.21), h = 223.26 },
	  },
	  home = 'LV22'
	},
	[233] = { type = 'home', coords = vec3(428.72,-1839.65,28.08),
	  vehiclePositions = {
		[1] = { vec3(434.57,-1841.14,28.23), h = 222.18 },
	  },
	  home = 'LV23'
	},
	[234] = { type = 'home', coords = vec3(401.5,-1849.32,27.32),
	  vehiclePositions = {
		[1] = { vec3(394.61,-1849.77,26.41), h = 225.55 },
	  },
	  home = 'LV24'
	},
	[235] = { type = 'home', coords = vec3(396.69,-1872.65,26.25),
	  vehiclePositions = {
		[1] = { vec3(397.28,-1877.44,26.35), h = 222.91 },
	  },
	  home = 'LV25'
	},
	[236] = { type = 'home', coords = vec3(385.03,-1890.77,25.32),
	  vehiclePositions = {
		[1] = { vec3(384.63,-1896.36,25.21), h = 222.83 },
	  },
	  home = 'LV26'
	},
	[237] = { type = 'home', coords = vec3(360.06,-1894.9,24.99),
	  vehiclePositions = {
		[1] = { vec3(357.8,-1896.77,25.08), h = 227.0 },
	  },
	  home = 'LV27'
	},
	[238] = { type = 'home', coords = vec3(315.73,-1937.5,24.82),
	  vehiclePositions = {
		[1] = { vec3(315.5,-1942.05,24.92), h = 230.52 },
	  },
	  home = 'LV28'
	},
	[239] = { type = 'home', coords = vec3(310.66,-1965.91,23.74),
	  vehiclePositions = {
		[1] = { vec3(316.82,-1970.62,23.69), h = 138.57 },
	  },
	  home = 'LV29'
	},
	[240] = { type = 'home', coords = vec3(299.42,-1971.96,22.49),
	  vehiclePositions = {
		[1] = { vec3(306.82,-1982.39,22.39), h = 139.63 },
	  },
	  home = 'LV30'
	},
	[241] = { type = 'home', coords = vec3(282.89,-1980.29,21.4),
	  vehiclePositions = {
		[1] = { vec3(285.64,-1985.85,21.41), h = 229.16 },
	  },
	  home = 'LV31'
	},
	[242] = { type = 'home', coords = vec3(280.83,-1991.24,20.46),
	  vehiclePositions = {
		[1] = { vec3(286.37,-1992.54,20.81), h = 228.61 },
	  },
	  home = 'LV32'
	},
	[243] = { type = 'home', coords = vec3(256.42,-2026.71,18.86),
	  vehiclePositions = {
		[1] = { vec3(267.58,-2029.38,18.82), h = 142.23 },
	  },
	  home = 'LV33'
	},
	[244] = { type = 'home', coords = vec3(240.68,-2021.42,18.71),
	  vehiclePositions = {
		[1] = { vec3(246.74,-2035.94,18.53), h = 228.9 },
	  },
	  home = 'LV34'
	},
	[245] = { type = 'home', coords = vec3(241.9,-2042.78,18.02),
	  vehiclePositions = {
		[1] = { vec3(245.74,-2053.88,18.1), h = 134.18 },
	  },
	  home = 'LV35'
	},
	[246] = { type = 'home', coords = vec3(-442.95,6202.62,29.56),
	  vehiclePositions = {
		[1] = { vec3(-435.4,6206.42,29.57), h = 278.13 },
	  },
	  home = 'PB01'
	},
	[247] = { type = 'home', coords = vec3(-375.5,6187.37,31.54),
	  vehiclePositions = {
		[1] = { vec3(-379.5,6184.85,31.4), h = 223.82 },
	  },
	  home = 'PB02'
	},
	[248] = { type = 'home', coords = vec3(-361.91,6204.76,31.58),
	  vehiclePositions = {
		[1] = { vec3(-367.92,6200.05,31.4), h = 224.98 },
	  },
	  home = 'PB03'
	},
	[249] = { type = 'home', coords = vec3(-359.1,6227.29,31.5),
	  vehiclePositions = {
		[1] = { vec3(-349.5,6217.17,31.4), h = 223.88 },
	  },
	  home = 'PB04'
	},
	[250] = { type = 'home', coords = vec3(-381.48,6254.9,31.49),
	  vehiclePositions = {
		[1] = { vec3(-388.73,6273.42,30.02), h = 50.83 },
	  },
	  home = 'PB05'
	},
	[251] = { type = 'home', coords = vec3(-360.84,6265.04,31.53),
	  vehiclePositions = {
		[1] = { vec3(-352.17,6265.07,31.32), h = 46.14 },
	  },
	  home = 'PB06'
	},
	[252] = { type = 'home', coords = vec3(-436.46,6264.1,30.09),
	  vehiclePositions = {
		[1] = { vec3(-429.99,6260.87,30.31), h = 258.67 },
	  },
	  home = 'PB07'
	},
	[253] = { type = 'home', coords = vec3(-402.95,6317.15,28.95),
	  vehiclePositions = {
		[1] = { vec3(-396.68,6311.99,28.84), h = 220.7 },
	  },
	  home = 'PB08'
	},
	[254] = { type = 'home', coords = vec3(-364.3,6337.74,29.85),
	  vehiclePositions = {
		[1] = { vec3(-360.16,6328.54,29.75), h = 220.61 },
	  },
	  home = 'PB09'
	},
	[255] = { type = 'home', coords = vec3(-311.14,6310.94,32.48),
	  vehiclePositions = {
		[1] = { vec3(-318.17,6317.76,31.77), h = 45.39 },
	  },
	  home = 'PB10'
	},
	[256] = { type = 'home', coords = vec3(-291.83,6335.9,32.49),
	  vehiclePositions = {
		[1] = { vec3(-296.49,6340.57,31.82), h = 46.26 },
	  },
	  home = 'PB11'
	},
	[257] = { type = 'home', coords = vec3(-272.11,6353.73,32.49),
	  vehiclePositions = {
		[1] = { vec3(-267.41,6355.22,32.4), h = 47.15 },
	  },
	  home = 'PB12'
	},
	[258] = { type = 'home', coords = vec3(-250.27,6355.12,31.5),
	  vehiclePositions = {
		[1] = { vec3(-255.08,6360.48,31.39), h = 45.08 },
	  },
	  home = 'PB13'
	},
	[259] = { type = 'home', coords = vec3(-271.22,6408.91,31.12),
	  vehiclePositions = {
		[1] = { vec3(-265.26,6406.49,30.88), h = 210.49 },
	  },
	  home = 'PB14'
	},
	[260] = { type = 'home', coords = vec3(-217.34,6374.6,31.68),
	  vehiclePositions = {
		[1] = { vec3(-219.54,6383.16,31.52), h = 45.87 },
	  },
	  home = 'PB15'
	},
	[261] = { type = 'home', coords = vec3(-238.3,6423.56,31.46),
	  vehiclePositions = {
		[1] = { vec3(-233.04,6420.27,31.16), h = 220.84 },
	  },
	  home = 'PB16'
	},
	[262] = { type = 'home', coords = vec3(-201.42,6396.75,31.87),
	  vehiclePositions = {
		[1] = { vec3(-201.53,6401.82,31.77), h = 46.62 },
	  },
	  home = 'PB17'
	},
	[263] = { type = 'home', coords = vec3(-229.57,6445.5,31.2),
	  vehiclePositions = {
		[1] = { vec3(-224.33,6435.29,31.11), h = 22964 },
	  },
	  home = 'PB18'
	},
	[264] = { type = 'home', coords = vec3(-187.33,6412.01,31.92),
	  vehiclePositions = {
		[1] = { vec3(-187.43,6418.12,31.78), h = 44.99 },
	  },
	  home = 'PB19'
	},
	[265] = { type = 'home', coords = vec3(-122.88,6561.7,29.53),
	  vehiclePositions = {
		[1] = { vec3(-115.59,6567.64,29.43), h = 224.24 },
	  },
	  home = 'PB20'
	},
	[266] = { type = 'home', coords = vec3(-101.69,6531.68,29.81),
	  vehiclePositions = {
		[1] = { vec3(-106.48,6536.09,29.72), h = 45.2 },
	  },
	  home = 'PB21'
	},
	[267] = { type = 'home', coords = vec3(-37.32,6578.82,32.35),
	  vehiclePositions = {
		[1] = { vec3(-40.97,6593.44,30.34), h = 37.22 },
	  },
	  home = 'PB22'
	},
	[268] = { type = 'home', coords = vec3(-15.06,6566.75,31.91),
	  vehiclePositions = {
		[1] = { vec3(-8.44,6561.16,31.88), h = 224.22 },
	  },
	  home = 'PB23'
	},
	[269] = { type = 'home', coords = vec3(11.48,6578.36,33.08),
	  vehiclePositions = {
		[1] = { vec3(15.78,6583.02,32.35), h = 223.198 },
	  },
	  home = 'PB24'
	},
	[270] = { type = 'home', coords = vec3(-17.04,6598.51,31.48),
	  vehiclePositions = {
		[1] = { vec3(-8.5,6598.24,31.38), h = 39.88 },
	  },
	  home = 'PB25'
	},
	[271] = { type = 'home', coords = vec3(-43.93,6634.26,30.23),
	  vehiclePositions = {
		[1] = { vec3(-52.4,6623.94,29.87), h = 221 },
	  },
	  home = 'PB26'
	},
	[272] = { type = 'home', coords = vec3(-14.79,6650.52,31.15),
	  vehiclePositions = {
		[1] = { vec3(-15.82,6645.42,31.03), h = 208.0 },
	  },
	  home = 'PB27'
	},
	[273] = { type = 'home', coords = vec3(2.37,6618.26,31.47),
	  vehiclePositions = {
		[1] = { vec3(-5.0,6618.68,31.34), h = 60.09 },
	  },
	  home = 'PB28'
	},
	[274] = { type = 'home', coords = vec3(25.06,6601.97,32.48),
	  vehiclePositions = {
		[1] = { vec3(36.23,6606.74,32.38), h = 267.62 },
	  },
	  home = 'PB29'
	},
	[275] = { type = 'home', coords = vec3(24.79,6659.22,31.65),
	  vehiclePositions = {
		[1] = { vec3(21.16,6661.48,31.44), h = 182.65 },
	  },
	  home = 'PB30'
	},
  }
  
--------------------------------------------------------------------------------
-- função para checar se o player é dono da casa para poder acessar à garagem --
--------------------------------------------------------------------------------
config.hasHome = function(source,user_id,home)
	local hasHome = vRP.query("homes/get_homepermissions",{ home = tostring(home) })
	if hasHome and #hasHome > 0 then
		return true
	end
	TriggerClientEvent("Notify",source,"negado","Você não tem acesso à essa residência.",3000)
	return false
end
  

-- RETORNA O TIPO DE UM VEÍCULO ESPECÍFICO
config.getVehicleType = function(vehicle)
	local vehInfo = config.getVehicleInfo(vehicle)
	if vehInfo then
		return vehInfo.tipo or 0
	end
	return "none"
end