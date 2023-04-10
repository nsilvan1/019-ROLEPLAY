local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

config = {}
Proxy.addInterface("nation_concessionaria", config)

config.imgDir = "http://189.1.172.114/images/" -- DIRETORIO DAS IMAGENS DOS VEÍCULOS
--config.imgDir = "/nui/images/"
-- LISTA DOS VEÍCULOS EM DESTAQUE

config.topVehicles = {	 
	"panto"
}

config.logo = "https://cdn.discordapp.com/attachments/795622143433637889/822863052700647545/pngwing.com.png" -- LOGO DO SERVIDOR

config.defaultImg = "https://svgsilh.com/svg/160895.svg" -- IMAGEM DEFAULT (SERÁ EXIBIDA QUANDO NÃO EXISTIR A IMAGEM DE ALGUM VEÍCULO NO DIRETÓRIO ESPECIFICADO)

config.openconce_permission = nil -- permissao para abrir a concessionaria

config.updateconce_permission = "admin.permissao" -- permissao para abrir o menu de gerenciamento da conce

config.porcentagem_venda = 50 -- porcentagem de venda dos veículos possuidos

config.porcentagem_testdrive = 0.1 -- porcentagem do valor do veículo paga para a realização do test drive

config.tempo_testdrive = 30 -- tempo de duração do test drive em segundos

config.maxDistance = 300 -- distância máxima (em radius(raio)) que o player poderá ir quando estiver realizando o test drive

config.porcentagem_aluguel = 10 -- porcentagem do valor do veículo paga para alugar

-- CLASSES QUE APARECEM NO MENU DA CONCE

config.conceClasses = {
	{ class = "sedans", img = "https://img.indianautosblog.com/2018/09/25/india-bound-2019-honda-civic-images-front-three-qu-e966.jpg" },
	{ class = "suvs", img = "https://www.otokokpit.com/wp-content/uploads/2017/11/yeni-range-rover-evoque-landmark-edition-1.jpg" },
	{ class = "imports", img = "https://besthqwallpapers.com/Uploads/25-6-2019/97150/thumb2-lamborghini-gallardo-supercars-motion-blur-road-gray-gallardo.jpg" },
	{ class = "trucks", img = "https://images3.alphacoders.com/149/thumb-1920-149257.jpg" },
	{ class = "motos", img = "https://i.pinimg.com/originals/cc/92/dd/cc92dda56f23a2a41682e80e7fe0f744.jpg" },
	{ class = "outros", img = "https://besthqwallpapers.com/Uploads/13-5-2018/52433/thumb2-ford-transit-custom-sport-4k-2018-cars-motion-blur-orange-ford-transit.jpg" },
}

-- IMAGEM QUE APARECE NA SEÇÃO DE 'MEUS VEÍCULOS'

config.myVehicles_img = "https://www.itl.cat/pngfile/big/50-505834_download-nfs-hot-pursuit.jpg"

-- CLASSES DOS VEÍCULOS INSERIDAS DENTRO DAS CLASSES QUE APARECEM NA CONCE

config.availableClasses = {
	["sedans"] = {"sedan"},
	["suvs"] = {"suv"},
	["imports"] = {"classic", "sport", "super"},  
	["trucks"] = {"industrial", "utility", "commercial"},
	["motos"] = {"moto", "cycle"},
	["outros"] = {"compact", "coupé", "muscle", "off-road",  "boat",  "helicopter",  "plane",  "service", "emergency",  "military",  "train", "van"}
}

-- ÍCONES DA CONCE

config.miscIcons = {
	{ description = "Força e velocidade necessárias para aquela dose de adrenalina.", img = "https://www.flaticon.com/svg/static/icons/svg/586/586141.svg" },
	{ description = "Incríveis opções econômicas que cabem no seu bolso!", img = "https://www.flaticon.com/svg/static/icons/svg/846/846117.svg" },
	{ description = "Para você que valoriza a eficácia e praticidade.", img = "https://www.flaticon.com/svg/static/icons/svg/1535/1535519.svg" },
}

-- DESCONTOS POR PERMISSAO

config.descontos = {
	{ perm = "seemm.permissao", porcentagem =  10 },
	{ perm = "seemm.permissao", porcentagem = 10 }
}

-- cada veículo deve conter => { hash, name, price, banido, modelo, capacidade, tipo }

config.vehList = {
	
{ hash = 1897985918, name = 'imola', price = 900000, banido = false, modelo = 'Imola', capacidade = 30, tipo = 'carros' },
{ hash = -2049278303, name = 'ben17', price = 900000, banido = false, modelo = 'Ben 17', capacidade = 30, tipo = 'carros' },
{ hash = -905399718, name = 'a80', price = 900000, banido = false, modelo = 'Supra A80', capacidade = 30, tipo = 'carros' },
{ hash = 1920158251, name = '500gtrlam', price = 900000, banido = false, modelo = '500GTR Lam', capacidade = 30, tipo = 'carros' },
{ hash = 872704284, name = 'sultan2', price = 900000, banido = false, modelo = 'Sultan 2', capacidade = 30, tipo = 'carros' },
{ hash = 1044193113, name = 'thrax', price = 700000, banido = false, modelo = 'Thrax', capacidade = 30, tipo = 'carros' },
{ hash = 914654722, name = 'mesa', price = 110000, banido = false, modelo = 'Mesa', capacidade = 60, tipo = 'suv' },
{ hash = -1829436850, name = 'novak', price = 220000, banido = false, modelo = 'Novak', capacidade = 60, tipo = 'suv' },
{ hash = -808831384, name = 'baller', price = 120000, banido = false, modelo = 'Baller', capacidade = 60, tipo = 'suv' },
{ hash = 634118882, name = 'baller4', price = 150000, banido = false, modelo = 'Baller4', capacidade = 50, tipo = 'suv' },
{ hash = 850565707, name = 'bjxl', price = 130000, banido = false, modelo = 'Bjxl', capacidade = 60, tipo = 'suv' },
{ hash = -789894171, name = 'cavalcade2', price = 140000, banido = false, modelo = 'Cavalcade2', capacidade = 65, tipo = 'suv' },
{ hash = 683047626, name = 'contender', price = 250000, banido = false, modelo = 'Contender', capacidade = 70, tipo = 'suv' },
{ hash = 1177543287, name = 'dubsta', price = 150000, banido = false, modelo = 'Dubsta', capacidade = 60, tipo = 'suv' },
{ hash = -1775728740, name = 'granger', price = 150000, banido = false, modelo = 'Granger', capacidade = 70, tipo = 'suv' },
{ hash = -1543762099, name = 'gresley', price = 150000, banido = false, modelo = 'Gresley', capacidade = 60, tipo = 'suv' },
{ hash = 1269098716, name = 'landstalker', price = 150000, banido = false, modelo = 'Landstalker', capacidade = 70, tipo = 'suv' },
{ hash = -808457413, name = 'patriot', price = 140000, banido = false, modelo = 'Patriot', capacidade = 60, tipo = 'suv' },
{ hash = -420911112, name = 'patriot2', price = 200000, banido = false, modelo = 'Patriot2', capacidade = 70, tipo = 'suv' },
{ hash = 83136452, name = 'rebla', price = 210000, banido = false, modelo = 'Rebla', capacidade = 60, tipo = 'suv' },
{ hash = 2136773105, name = 'rocoto', price = 130000, banido = false, modelo = 'Rocoto', capacidade = 60, tipo = 'suv' },
{ hash = 1337041428, name = 'serrano', price = 120000, banido = false, modelo = 'Serrano', capacidade = 60, tipo = 'suv' },
{ hash = -1168952148, name = 'toros', price = 350000, banido = false, modelo = 'Toros', capacidade = 60, tipo = 'suv' },
{ hash = 1203490606, name = 'xls', price = 300000, banido = false, modelo = 'XLS', capacidade = 60, tipo = 'suv' },

-- SEDANS
{ hash = -1903012613, name = 'asterope', price = 70000, banido = false, modelo = 'Asterope', capacidade = 50, tipo = 'sedan' },
{ hash = 906642318, name = 'cog55', price = 150000, banido = false, modelo = 'Cog55', capacidade = 50, tipo = 'sedan' },
{ hash = -5153954, name = 'exemplar', price = 170000, banido = false, modelo = 'Exemplar', capacidade = 40, tipo = 'sedan' },
{ hash = -591610296, name = 'f620', price = 170000, banido = false, modelo = 'F620', capacidade = 40, tipo = 'sedan' },
{ hash = -89291282, name = 'felon2', price = 130000, banido = false, modelo = 'Felon2', capacidade = 50, tipo = 'sedan' },
{ hash = -624529134, name = 'jackal', price = 150000, banido = false, modelo = 'Jackal', capacidade = 50, tipo = 'sedan' },
{ hash = -511601230, name = 'oracle2', price = 150000, banido = false, modelo = 'Oracle2', capacidade = 50, tipo = 'sedan' },
{ hash = -14495224, name = 'regina', price = 50000, banido = false, modelo = 'Regina', capacidade = 65, tipo = 'sedan' },
{ hash = 873639469, name = 'sentinel2', price = 150000, banido = false, modelo = 'Sentinel2', capacidade = 50, tipo = 'sedan' },
{ hash = 321186144, name = 'stafford', price = 60000, banido = false, modelo = 'Stafford', capacidade = 50, tipo = 'sedan' },
{ hash = 1723137093, name = 'stratum', price = 60000, banido = false, modelo = 'Stratum', capacidade = 65, tipo = 'sedan' },
{ hash = -1961627517, name = 'stretch', price = 200000, banido = false, modelo = 'Stretch', capacidade = 50, tipo = 'sedan' },
{ hash = -1894894188, name = 'surge', price = 130000, banido = false, modelo = 'Surge', capacidade = 50, tipo = 'sedan' },
{ hash = -1008861746, name = 'tailgater', price = 100000, banido = false, modelo = 'Tailgater', capacidade = 50, tipo = 'sedan' },
{ hash = 1373123368, name = 'warrener', price = 90000, banido = false, modelo = 'Warrener', capacidade = 50, tipo = 'sedan' },
{ hash = -1930048799, name = 'windsor2', price = 180000, banido = false, modelo = 'Windsor2', capacidade = 50, tipo = 'sedan' },
{ hash = -1193103848, name = 'zion2', price = 170000, banido = false, modelo = 'Zion2', capacidade = 50, tipo = 'sedan' },

-- CARROS

{ hash = -1177863319, name = 'issi2', price = 60000, banido = false, modelo = 'Issi2', capacidade = 40, tipo = 'carros' },
{ hash = -349601129, name = 'bifta', price = 150000, banido = false, modelo = 'Bifta', capacidade = 25, tipo = 'carros' },
{ hash = -2128233223, name = 'blazer', price = 50000, banido = true, modelo = 'Blazer', capacidade = 25, tipo = 'motos' },
{ hash = 1549126457, name = 'brioso', price = 80000, banido = false, modelo = 'Brioso', capacidade = 40, tipo = 'carros' },
{ hash = -682211828, name = 'buccaneer', price = 150000, banido = false, modelo = 'Buccaneer', capacidade = 35, tipo = 'carros' },
{ hash = -1013450936, name = 'buccaneer2', price = 200000, banido = false, modelo = 'Buccaneer2', capacidade = 50, tipo = 'carros' },
{ hash = 784565758, name = 'coquette3', price = 150000, banido = false, modelo = 'Coquette3', capacidade = 40, tipo = 'carros' },
{ hash = 1279262537, name = 'deviant', price = 150000, banido = false, modelo = 'Deviant', capacidade = 50, tipo = 'carros' },
{ hash = 80636076, name = 'dominator', price = 300000, banido = false, modelo = 'Dominator', capacidade = 50, tipo = 'carros' },
{ hash = 723973206, name = 'dukes', price = 170000, banido = false, modelo = 'Dukes', capacidade = 40, tipo = 'carros' },
{ hash = -1267543371, name = 'ellie', price = 170000, banido = false, modelo = 'Ellie', capacidade = 40, tipo = 'carros' },
{ hash = -1800170043, name = 'gauntlet', price = 170000, banido = false, modelo = 'Gauntlet', capacidade = 40, tipo = 'carros' },
{ hash = 15219735, name = 'hermes', price = 200000, banido = false, modelo = 'Hermes', capacidade = 50, tipo = 'carros' },
{ hash = 37348240, name = 'hotknife', price = 200000, banido = false, modelo = 'Hotknife', capacidade = 50, tipo = 'carros' },
{ hash = -2096690334, name = 'impaler', price = 170000, banido = false, modelo = 'Impaler', capacidade = 50, tipo = 'carros' },
{ hash = -1943285540, name = 'nightshade', price = 130000, banido = false, modelo = 'Nightshade', capacidade = 40, tipo = 'carros' },
{ hash = -431692672, name = 'panto', price = 35000, banido = false, modelo = 'Panto', capacidade = 25, tipo = 'carros' },
{ hash = 1507916787, name = 'picador', price = 100000, banido = false, modelo = 'Picador', capacidade = 70, tipo = 'carros' },
{ hash = -2045594037, name = 'rebel2', price = 100000, banido = false, modelo = 'Rebel2', capacidade = 70, tipo = 'carros' },
{ hash = 841808271, name = 'rhapsody', price = 50000, banido = false, modelo = 'Rhapsody', capacidade = 40, tipo = 'carros' },
{ hash = -1532697517, name = 'riata', price = 150000, banido = false, modelo = 'Riata', capacidade = 70, tipo = 'carros' },
{ hash = -227741703, name = 'ruiner', price = 90000, banido = false, modelo = 'Ruiner', capacidade = 50, tipo = 'carros' },
{ hash = 223258115, name = 'sabregt2', price = 150000, banido = false, modelo = 'Sabregt2', capacidade = 50, tipo = 'carros' },
{ hash = -1189015600, name = 'sandking', price = 220000, banido = false, modelo = 'Sandking', capacidade = 70, tipo = 'carros' },
{ hash = 729783779, name = 'slamvan', price = 110000, banido = false, modelo = 'Slamvan', capacidade = 60, tipo = 'carros' },
{ hash = 1923400478, name = 'stalion', price = 120000, banido = false, modelo = 'Stalion', capacidade = 40, tipo = 'carros' },
{ hash = 972671128, name = 'tampa', price = 110000, banido = false, modelo = 'Tampa', capacidade = 50, tipo = 'carros' },
{ hash = 1456744817, name = 'tulip', price = 130000, banido = false, modelo = 'Tulip', capacidade = 50, tipo = 'carros' },
{ hash = -49115651, name = 'vamos', price = 120000, banido = false, modelo = 'Vamos', capacidade = 50, tipo = 'carros' },
{ hash = -825837129, name = 'vigero', price = 125000, banido = false, modelo = 'Vigero', capacidade = 50, tipo = 'carros' },
{ hash = -899509638, name = 'virgo2', price = 125000, banido = false, modelo = 'Virgo2', capacidade = 50, tipo = 'carros' },
{ hash = 1871995513, name = 'yosemite', price = 170000, banido = false, modelo = 'Yosemite', capacidade = 60, tipo = 'carros' },
{ hash = -631322662, name = 'penumbra2', price = 310000, banido = false, modelo = 'Penumbra2', capacidade = 30, tipo = 'carros' },



-- IMPORTADOS
{ hash = -1216765807, name = 'adder', price = 560000, banido = false, modelo = 'Adder', capacidade = 30, tipo = 'carros' },
{ hash = 633712403, name = 'banshee2', price = 480000, banido = false, modelo = 'Banshee2', capacidade = 30, tipo = 'carros' },
{ hash = -602287871, name = 'btype3', price = 100000, banido = false, modelo = 'Btype3', capacidade = 30, tipo = 'carros' },
{ hash = 736902334, name = 'buffalo2', price = 300000, banido = false, modelo = 'Buffalo2', capacidade = 50, tipo = 'carros' },
{ hash = -1696146015, name = 'bullet', price = 510000, banido = false, modelo = 'Bullet', capacidade = 30, tipo = 'carros' },
{ hash = 2072687711, name = 'carbonizzare', price = 490000, banido = false, modelo = 'Carbonizzare', capacidade = 30, tipo = 'carros' },
{ hash = 941800958, name = 'casco', price = 250000, banido = false, modelo = 'Casco', capacidade = 30, tipo = 'carros' },
{ hash = -1311154784, name = 'cheetah', price = 580000, banido = false, modelo = 'Cheetah', capacidade = 30, tipo = 'carros' },
{ hash = 223240013, name = 'cheetah2', price = 500000, banido = false, modelo = 'Cheetah2', capacidade = 30, tipo = 'carros' },
{ hash = -2022483795, name = 'comet3', price = 430000, banido = false, modelo = 'Comet3', capacidade = 30, tipo = 'carros' },
{ hash = 108773431, name = 'coquette', price = 200000, banido = false, modelo = 'Coquette', capacidade = 30, tipo = 'carros' },
{ hash = 196747873, name = 'elegy', price = 380000, banido = false, modelo = 'Elegy', capacidade = 50, tipo = 'carros' },
{ hash = -566387422, name = 'elegy2', price = 350000, banido = false, modelo = 'Elegy2', capacidade = 50, tipo = 'carros' },
{ hash = -2120700196, name = 'entity2', price = 640000, banido = false, modelo = 'Entity2', capacidade = 30, tipo = 'carros' },
{ hash = -1291952903, name = 'entityxf', price = 600000, banido = false, modelo = 'Entityxf', capacidade = 30, tipo = 'carros' },
{ hash = -1995326987, name = 'feltzer2', price = 350000, banido = false, modelo = 'Feltzer2', capacidade = 30, tipo = 'carros' },
{ hash = -1566741232, name = 'feltzer3', price = 250000, banido = false, modelo = 'Feltzer3', capacidade = 30, tipo = 'carros' },
{ hash = -1259134696, name = 'flashgt', price = 340000, banido = false, modelo = 'Flashgt', capacidade = 30, tipo = 'carros' },
{ hash = 1426219628, name = 'fmj', price = 610000, banido = false, modelo = 'Fmj', capacidade = 30, tipo = 'carros' },
{ hash = -1089039904, name = 'furoregt', price = 480000, banido = false, modelo = 'Furoregt', capacidade = 30, tipo = 'carros' },
{ hash = 2016857647, name = 'futo', price = 270000, banido = false, modelo = 'Futo', capacidade = 50, tipo = 'carros' },
{ hash = 1909189272, name = 'gb200', price = 320000, banido = false, modelo = 'Gb200', capacidade = 30, tipo = 'carros' },
{ hash = 1234311532, name = 'gp1', price = 560000, banido = false, modelo = 'Gp1', capacidade = 30, tipo = 'carros' },
{ hash = -1132721664, name = 'imorgon', price = 170000, banido = false, modelo = 'IMorgon', capacidade = 30, tipo = 'carros' },
{ hash = 418536135, name = 'infernus', price = 510000, banido = false, modelo = 'Infernus', capacidade = 30, tipo = 'carros' },
{ hash = -1405937764, name = 'infernus2', price = 430000, banido = false, modelo = 'Infernus2', capacidade = 30, tipo = 'carros' },
{ hash = -482719877, name = 'italigtb2', price = 610000, banido = false, modelo = 'Italigtb2', capacidade = 30, tipo = 'carros' },
{ hash = -331467772, name = 'italigto', price = 750000, banido = false, modelo = 'Italigto', capacidade = 30, tipo = 'carros' },
{ hash = -1297672541, name = 'jester', price = 410000, banido = false, modelo = 'Jester', capacidade = 30, tipo = 'carros' },
{ hash = -214906006, name = 'jester3', price = 470000, banido = false, modelo = 'Jester3', capacidade = 40, tipo = 'carros' },
{ hash = -208911803, name = 'jugular', price = 320000, banido = false, modelo = 'Jugular', capacidade = 50, tipo = 'carros' },
{ hash = -834353991, name = 'komoda', price = 470000, banido = false, modelo = 'Komoda', capacidade = 50, tipo = 'carros' },
{ hash = -1372848492, name = 'kuruma', price = 330000, banido = false, modelo = 'Kuruma', capacidade = 40, tipo = 'carros' },
{ hash = 482197771, name = 'lynx', price = 450000, banido = false, modelo = 'Lynx', capacidade = 30, tipo = 'carros' },
{ hash = -1660945322, name = 'mamba', price = 320000, banido = false, modelo = 'Mamba', capacidade = 30, tipo = 'carros' },
{ hash = -142942670, name = 'massacro', price = 450000, banido = false, modelo = 'Massacro', capacidade = 30, tipo = 'carros' },
{ hash = -433375717, name = 'monroe', price = 440000, banido = false, modelo = 'Monroe', capacidade = 30, tipo = 'carros' },
{ hash = -1620126302, name = 'neo', price = 620000, banido = false, modelo = 'NEO', capacidade = 30, tipo = 'carros' },
{ hash = -1848994066, name = 'neon', price = 320000, banido = false, modelo = 'Neon', capacidade = 30, tipo = 'carros' },
{ hash = 1093792632, name = 'nero2', price = 650000, banido = false, modelo = 'Nero2', capacidade = 30, tipo = 'carros' },
{ hash = -1461482751, name = 'ninef2', price = 440000, banido = false, modelo = 'Ninef2', capacidade = 30, tipo = 'carros' },
{ hash = 1987142870, name = 'osiris', price = 670000, banido = false, modelo = 'Osiris', capacidade = 30, tipo = 'carros' },
{ hash = -447711397, name = 'paragon', price = 400000, banido = false, modelo = 'Paragon', capacidade = 30, tipo = 'carros' },
{ hash = 867799010, name = 'pariah', price = 570000, banido = false, modelo = 'Pariah', capacidade = 30, tipo = 'carros' },
{ hash = -1758137366, name = 'penetrator', price = 420000, banido = false, modelo = 'Penetrator', capacidade = 30, tipo = 'carros' },
{ hash = -377465520, name = 'penumbra', price = 160000, banido = false, modelo = 'Penumbra', capacidade = 40, tipo = 'carros' },
{ hash = 1830407356, name = 'peyote', price = 90000, banido = false, modelo = 'Peyote', capacidade = 30, tipo = 'carros' },
{ hash = -1529242755, name = 'raiden', price = 210000, banido = false, modelo = 'Raiden', capacidade = 40, tipo = 'carros' },
{ hash = 1737773231, name = 'rapidgt2', price = 330000, banido = false, modelo = 'Rapidgt2', capacidade = 30, tipo = 'carros' },
{ hash = 2049897956, name = 'rapidgt3', price = 250000, banido = false, modelo = 'Rapidgt3', capacidade = 30, tipo = 'carros' },
{ hash = 234062309, name = 'reaper', price = 520000, banido = false, modelo = 'Reaper', capacidade = 30, tipo = 'carros' },
{ hash = 1352136073, name = 'sc1', price = 460000, banido = false, modelo = 'Sc1', capacidade = 30, tipo = 'carros' },
{ hash = 1489967196, name = 'schafter4', price = 160000, banido = false, modelo = 'Schafter4', capacidade = 40, tipo = 'carros' },
{ hash = 1922255844, name = 'schafter6', price = 160000, banido = false, modelo = 'Schafter6', capacidade = 40, tipo = 'carros' },

{ hash = -507495760, name = 'schlagen', price = 570000, banido = false, modelo = 'Schlagen', capacidade = 30, tipo = 'carros' },
{ hash = -746882698, name = 'schwarzer', price = 330000, banido = false, modelo = 'Schwarzer', capacidade = 40, tipo = 'carros' },	
{ hash = 1104234922, name = 'sentinel3', price = 300000, banido = false, modelo = 'Sentinel3', capacidade = 30, tipo = 'carros' },
{ hash = -1757836725, name = 'seven70', price = 440000, banido = false, modelo = 'Seven70', capacidade = 30, tipo = 'carros' },
{ hash = 1886268224, name = 'specter', price = 420000, banido = false, modelo = 'Specter', capacidade = 30, tipo = 'carros' },
{ hash = 1545842587, name = 'stinger', price = 150000, banido = false, modelo = 'Stinger', capacidade = 30, tipo = 'carros' },
{ hash = -2098947590, name = 'stingergt', price = 160000, banido = false, modelo = 'Stingergt', capacidade = 30, tipo = 'carros' },
{ hash = 987469656, name = 'sugoi', price = 310000, banido = false, modelo = 'Sugoi', capacidade = 40, tipo = 'carros' },
{ hash = 970598228, name = 'sultan', price = 420000, banido = false, modelo = 'Sultan', capacidade = 40, tipo = 'carros' },
{ hash = -295689028, name = 'sultanrs', price = 460000, banido = false, modelo = 'Sultan RS', capacidade = 40, tipo = 'carros' },
{ hash = 384071873, name = 'surano', price = 470000, banido = false, modelo = 'Surano', capacidade = 30, tipo = 'carros' },
{ hash = 1663218586, name = 't20', price = 670000, banido = false, modelo = 'T20', capacidade = 30, tipo = 'carros' },
{ hash = -1134706562, name = 'taipan', price = 710000, banido = false, modelo = 'Taipan', capacidade = 30, tipo = 'carros' },
{ hash = -1071380347, name = 'tampa2', price = 210000, banido = false, modelo = 'Tampa2', capacidade = 30, tipo = 'carros' },
{ hash = 272929391, name = 'tempesta', price = 530000, banido = false, modelo = 'Tempesta', capacidade = 30, tipo = 'carros' },
{ hash = 1531094468, name = 'tornado2', price = 90000, banido = false, modelo = 'Tornado2', capacidade = 30, tipo = 'carros' },
{ hash = -982130927, name = 'turismo2', price = 520000, banido = false, modelo = 'Turismo2', capacidade = 30, tipo = 'carros' },
{ hash = 408192225, name = 'turismor', price = 680000, banido = false, modelo = 'Turismor', capacidade = 30, tipo = 'carros' },
{ hash = -376434238, name = 'tyrant', price = 580000, banido = false, modelo = 'Tyrant', capacidade = 30, tipo = 'carros' },
{ hash = 2067820283, name = 'tyrus', price = 710000, banido = false, modelo = 'Tyrus', capacidade = 30, tipo = 'carros' },
{ hash = 338562499, name = 'vacca', price = 480000, banido = false, modelo = 'Vacca', capacidade = 30, tipo = 'carros' },
{ hash = -998177792, name = 'visione', price = 650000, banido = false, modelo = 'Visione', capacidade = 30, tipo = 'carros' },
{ hash = -1622444098, name = 'voltic', price = 180000, banido = false, modelo = 'Voltic', capacidade = 30, tipo = 'carros' },
{ hash = 1456336509, name = 'vstr', price = 430000, banido = false, modelo = 'V-STR', capacidade = 30, tipo = 'carros' },
{ hash = 917809321, name = 'xa21', price = 730000, banido = false, modelo = 'Xa21', capacidade = 30, tipo = 'carros' },
{ hash = -1403128555, name = 'zentorno', price = 730000, banido = false, modelo = 'Zentorno', capacidade = 30, tipo = 'carros' },
{ hash = 699456151, name = 'surfer', price = 70000, banido = false, modelo = 'Surfer', capacidade = 70, tipo = 'carros' },

-- Motos 

{ hash = -2140431165, name = 'bagger', price = 70000, banido = false, modelo = 'Bagger', capacidade = 40, tipo = 'motos' },
{ hash = -757735410, name = 'fcr2', price = 200000, banido = false, modelo = 'Fcr2', capacidade = 25, tipo = 'motos' },
{ hash = -570033273, name = 'zombieb', price = 130000, banido = false, modelo = 'Zombieb', capacidade = 25, tipo = 'motos' },
{ hash = 1672195559, name = 'akuma', price = 600000, banido = false, modelo = 'Akuma', capacidade = 25, tipo = 'motos' },
{ hash = -2115793025, name = 'avarus', price = 140000, banido = false, modelo = 'Avarus', capacidade = 25, tipo = 'motos' },
{ hash = -114291515, name = 'bati', price = 600000, banido = false, modelo = 'Bati', capacidade = 25, tipo = 'motos' },
{ hash = -891462355, name = 'bati2', price = 650000, banido = false, modelo = 'Bati2', capacidade = 25, tipo = 'motos' },
{ hash = 86520421, name = 'bf400', price = 150000, banido = false, modelo = 'Bf400', capacidade = 25, tipo = 'motos' },
{ hash = 11251904, name = 'carbonrs', price = 570000, banido = false, modelo = 'Carbonrs', capacidade = 25, tipo = 'motos' },
{ hash = 2006142190, name = 'daemon', price = 150000, banido = false, modelo = 'Daemon', capacidade = 25, tipo = 'work' },
{ hash = -1404136503, name = 'daemon2', price = 200000, banido = false, modelo = 'Daemon2', capacidade = 25, tipo = 'motos' },
{ hash = -1670998136, name = 'double', price = 570000, banido = false, modelo = 'Double', capacidade = 25, tipo = 'motos' },
{ hash = 1753414259, name = 'enduro', price = 70000, banido = false, modelo = 'Enduro', capacidade = 25, tipo = 'motos' },
{ hash = 2035069708, name = 'esskey', price = 210000, banido = false, modelo = 'Esskey', capacidade = 25, tipo = 'motos' },
{ hash = -1842748181, name = 'faggio', price = 20000, banido = false, modelo = 'Faggio', capacidade = 25, tipo = 'motos' },
{ hash = 741090084, name = 'gargoyle', price = 400000, banido = false, modelo = 'Gargoyle', capacidade = 25, tipo = 'motos' },
{ hash = 1265391242, name = 'hakuchou', price = 570000, banido = false, modelo = 'Hakuchou', capacidade = 25, tipo = 'motos' },
{ hash = -255678177, name = 'hakuchou2', price = 600000, banido = false, modelo = 'Hakuchou2', capacidade = 25, tipo = 'motos' },
{ hash = 301427732, name = 'hexer', price = 200000, banido = false, modelo = 'Hexer', capacidade = 25, tipo = 'motos' },
{ hash = 640818791, name = 'lectro', price = 600000, banido = false, modelo = 'Lectro', capacidade = 25, tipo = 'motos' },
{ hash = -1523428744, name = 'manchez', price = 150000, banido = false, modelo = 'Manchez', capacidade = 25, tipo = 'motos' },
{ hash = -1606187161, name = 'nightblade', price = 500000, banido = false, modelo = 'Nightblade', capacidade = 25, tipo = 'motos' },
{ hash = -909201658, name = 'pcj', price = 90000, banido = false, modelo = 'Pcj', capacidade = 25, tipo = 'motos' },
{ hash = 1873600305, name = 'ratbike', price = 35000, banido = false, modelo = 'Ratbike', capacidade = 25, tipo = 'motos' },
{ hash = -893578776, name = 'ruffian', price = 200000, banido = false, modelo = 'Ruffian', capacidade = 25, tipo = 'motos' },
{ hash = 743478836, name = 'sovereign', price = 300000, banido = false, modelo = 'Sovereign', capacidade = 40, tipo = 'motos' },
{ hash = -140902153, name = 'vader', price = 150000, banido = false, modelo = 'Vader', capacidade = 25, tipo = 'motos' },
{ hash = -1009268949, name = 'zombiea', price = 140000, banido = false, modelo = 'Zombiea', capacidade = 25, tipo = 'motos' },
{ hash = -618617997, name = 'wolfsbane', price = 50000, banido = false, modelo = 'Wolfsbane', capacidade = 25, tipo = 'motos' },


-- Caminhões 

{ hash = 2112052861, name = 'pounder', price = 1500000, banido = false, modelo = 'Pounder', capacidade = 500, tipo = 'carros' },
{ hash = 2053223216, name = 'benson', price = 1200000, banido = false, modelo = 'Benson', capacidade = 400, tipo = 'carros' },
{ hash = 1945374990, name = 'mule4', price = 1000000, banido = false, modelo = 'Mule4', capacidade = 300, tipo = 'carros' },
{ hash = 1945374990, name = 'mule', price = 700000, banido = false, modelo = 'Mule', capacidade = 200, tipo = 'carros' },
{ hash = -2107990196, name = 'guardian', price = 700000, banido = false, modelo = 'Guardian', capacidade = 150, tipo = 'carros' },
{ hash = -599568815, name = 'sadler', price = 90000, banido = false, modelo = 'Sadler', capacidade = 70, tipo = 'carros' },
{ hash = -1346687836, name = 'burrito', price = 350000, banido = false, modelo = 'Burrito', capacidade = 100, tipo = 'carros' },
{ hash = -1743316013, name = 'burrito3', price = 400000, banido = false, modelo = 'Burrito3', capacidade = 150, tipo = 'carros' },
{ hash = 1917016601, name = 'trash', price = 1000, banido = false, modelo = 'Caminhão', capacidade = 80, tipo = 'work' },





-- Los Santos Tuners

{ hash = -1193912403, name = 'calico', price = 410000, banido = false, modelo = 'Karin Calico GTF', capacidade = 30, tipo = 'carros' },
{ hash = -1726022652, name = 'comet6', price = 480000, banido = false, modelo = 'Pfister Comet S2', capacidade = 30, tipo = 'carros' },
{ hash = 1755697647, name = 'cypher', price = 480000, banido = false, modelo = 'Cypher', capacidade = 30, tipo = 'carros' },
{ hash = 426742808, name = 'dominator7', price = 480000, banido = false, modelo = 'Vapid Dominator ASP', capacidade = 30, tipo = 'carros' },
{ hash = 736672010, name = 'dominator8', price = 480000, banido = false, modelo = 'Vapid Dominator GTT', capacidade = 30, tipo = 'carros' },
{ hash = 2038480341, name = 'euros', price = 480000, banido = false, modelo = 'Annis Euros', capacidade = 30, tipo = 'carros' },
{ hash = -1507230520, name = 'futo2', price = 480000, banido = false, modelo = 'Karin Futo GTX', capacidade = 30, tipo = 'carros' },
{ hash = 1304459735, name = 'growler', price = 480000, banido = false, modelo = 'Pfister Growler', capacidade = 30, tipo = 'carros' },
{ hash = -1582061455, name = 'jester4', price = 480000, banido = false, modelo = 'Dinka Jester RR', capacidade = 30, tipo = 'carros' },
{ hash = 1416471345, name = 'previon', price = 480000, banido = false, modelo = 'Karin Previon', capacidade = 30, tipo = 'carros' },
{ hash = 1377217886, name = 'remus', price = 480000, banido = false, modelo = 'Annis Remus', capacidade = 30, tipo = 'carros' },
{ hash = -452604007, name = 'rt3000', price = 480000, banido = false, modelo = 'Dinka RT3000', capacidade = 30, tipo = 'carros' },
{ hash = -291021213, name = 'sultan3', price = 410000, banido = false, modelo = 'Karin Sultan RS Classic', capacidade = 30, tipo = 'carros' },
{ hash = -1244461404, name = 'tailgater2', price = 480000, banido = false, modelo = 'Obey Tailgater S', capacidade = 30, tipo = 'carros' },
{ hash = -1540373595, name = 'vectre', price = 480000, banido = false, modelo = 'Emperor Vectre', capacidade = 30, tipo = 'carros' },
{ hash = 579912970, name = 'warrener2', price = 480000, banido = false, modelo = 'Vulcar Warrener HKR', capacidade = 30, tipo = 'carros' },
{ hash = -1858654120, name = 'zr350', price = 430000, banido = false, modelo = 'Annis ZR350', capacidade = 30, tipo = 'carros' },

}


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



-- RETORNA AS INFORMAÇÕES DO VEÍCULO REFERENTE À LISTA DE VEÍCULOS (VEHLIST)
config.getVehicleInfo = function(vehicle)
	for i in ipairs(config.vehList) do
		if vehicle == config.vehList[i].hash or vehicle == config.vehList[i].name then
            return config.vehList[i]
        end
    end
    return false
end

-------------------------------


 --- MYSQL---

 vRP._prepare("nation_conce/getConceVehicles","SELECT * FROM nation_concessionaria WHERE estoque > 0")

vRP._prepare("nation_conce/hasVehicle","SELECT vehicle, alugado FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")

vRP._prepare("nation_conce/hasFullVehicle","SELECT vehicle FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle AND alugado = 0")

vRP._prepare("nation_conce/hasRentedVehicle","SELECT vehicle FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle AND alugado = 1")

vRP._prepare("nation_conce/getMyVehicles", "SELECT * FROM vrp_user_vehicles WHERE user_id = @user_id AND alugado = 0")

vRP._prepare("nation_conce/deleteRentedVehicles", "DELETE FROM vrp_user_vehicles WHERE alugado = 1 AND data_alugado != @data_alugado")

vRP._prepare("nation_conce/updateUserVehicle","UPDATE vrp_user_vehicles SET alugado = 0 WHERE user_id = @user_id AND vehicle = @vehicle")

vRP.prepare("nation_conce/addUserVehicle",[[
	INSERT IGNORE INTO vrp_user_vehicles(user_id,vehicle,detido,time,engine,body,fuel,ipva) 
	VALUES(@user_id,@vehicle,@detido,@time,@engine,@body,@fuel,@ipva);
]])

vRP.prepare("nation_conce/addUserRentedVehicle",[[
	INSERT IGNORE INTO vrp_user_vehicles(user_id,vehicle,detido,time,engine,body,fuel,ipva,alugado,data_alugado) 
	VALUES(@user_id,@vehicle,@detido,@time,@engine,@body,@fuel,@ipva,1,@data_alugado);
]])

vRP._prepare("nation_conce/removeUserVehicle","DELETE FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")

-----------

function getConceList(cb)
	Citizen.CreateThread(function()
		local vehicles = vRP.query("nation_conce/getConceVehicles") or {}
		cb(vehicles)
	end)
end


function getTopList()
	getConceList(function(list)
		local vehicleList = {}
		for k,v in ipairs(list) do
			local vehInfo = config.getVehicleInfo(v.vehicle)
			if vehInfo then
				vehicleList[#vehicleList+1] = { 
					vehicle = v.vehicle, price = vehInfo.price
				}
			end
		end
		if #vehicleList >= 5 then
			table.sort(vehicleList, function(a, b) return a.price > b.price end)
			for i = 1, 5 do
				local veh = vehicleList[i]
				config.topVehicles[i] = veh.vehicle 
			end
		end
	end)
end


-- NOMES DAS CLASSES DOS VEÍCULOS

config.vehicleClasses = {
	[0] = "compact",  
	[1] = "sedan",  
	[2] = "suv",  
	[3] = "coupé",  
	[4] = "muscle",  
	[5] = "classic",  
	[6] = "sport",  
	[7] = "super",  
	[8] = "moto",  
	[9] = "off-road",  
	[10] = "industrial",  
	[11] = "utility",
	[12] = "van",
	[13] = "cycle",  
	[14] = "boat",  
	[15] = "helicopter",  
	[16] = "plane",  
	[17] = "service", 
	[18] = "emergency",  
	[19] = "military",  
	[20] = "commercial",  
	[21] = "train" 
}


-- FUNCÃO DE COMPRA DO VEÍCULO

config.tryBuyVehicle = function(source, user_id, vehicle, color, price, mods)
	if source and user_id and vehicle and color and price and mods then
		local data = vRP.query("nation_conce/hasVehicle", {user_id = user_id, vehicle = vehicle})
		local hasVehicle = #data > 0
		local isRented = data[1] and data[1].alugado > 0
		if hasVehicle and not isRented then
			return false, "veículo já possuído"
		end
		if vRP.tryFullPayment(user_id,price) then
			Citizen.CreateThread(function()
				if isRented then
					vRP.execute("nation_conce/updateUserVehicle", {
						user_id = user_id, vehicle = vehicle
					})
				else 
					vRP.execute("nation_conce/addUserVehicle", {
						user_id = user_id, vehicle = vehicle, detido = 0, time = 0, engine = 1000, body = 1000, fuel = 100, ipva = os.time()
					})
				end
				mods.customPcolor = color
				vRP.setSData("custom:u"..user_id.."veh_"..vehicle,json.encode(mods))
			end)
			return true, "sucesso!"
		else
			return false, "falha no pagamento"
		end
	end
	return false, "erro inesperado"
end




-- FUNÇÃO DE VENDA DO VEÍCULO

config.trySellVehicle = function(source, user_id, vehicle, price)
	if source and user_id and vehicle and price then
		local hasVehicle = #vRP.query("nation_conce/hasFullVehicle", {user_id = user_id, vehicle = vehicle}) > 0
		if hasVehicle then
			Citizen.CreateThread(function()
				vRP.execute("nation_conce/removeUserVehicle", {user_id = user_id, vehicle = vehicle})
				vRP.giveMoney(user_id,parseInt(price))
			end)
			return true, "sucesso!"
		else
			return false, "veículo alugado ou já vendido"
		end
	end
	return false, "erro inesperado"
end



-- VERIFICAÇÃO DE TEST DRIVE

config.tryTestDrive = function(source, user_id, info)
	if source and user_id and info then
		local price = parseInt(info.price * (config.porcentagem_testdrive / 100))
		return true, "deseja pagar <b>$ "..vRP.format(price).."</b> para realizar o test drive em um(a) <b>"..info.modelo.."</b> ?"
	end
	return false, "erro inesperado"
end



-- VERIFICAÇÃO DO PAGAMENTO DO TEST DRIVE

config.payTest = function(source,user_id, info)
	if source and user_id and info then
		local price = parseInt(info.price * (config.porcentagem_testdrive / 100))
		if vRP.tryFullPayment(user_id, price) then
			return true, "sucesso!", price
		else
			return false, "falha no pagamento"
		end
	end
	return false, "erro inesperado"
end


-- DEVOLVER O DINHEIRO CASO NÃO DÊ PARA FAZER O TEST

config.chargeBack = function(source,user_id, price)
	if source and user_id and price then
		vRP.giveMoney(user_id,price)
		TriggerClientEvent("Notify",source,"aviso", "Você recebeu seus <b>$ "..vRP.format(price).."</b> de volta.", 3000)
	end
end



-- VERIFICAÇÃO DE ALUGUEL DO VEÍCULO

config.tryRentVehicle = function(source, user_id, info)
	if source and user_id and info then
		local hasVehicle = #vRP.query("nation_conce/hasVehicle", {user_id = user_id, vehicle = info.name}) > 0
		if hasVehicle then
			return false, "veículo já possuído"
		end
		local price = parseInt(info.price * (config.porcentagem_aluguel / 100))
		return true, "deseja pagar <b>$ "..vRP.format(price).."</b> para alugar um(a) <b>"..info.modelo.."</b> por 1 dia?"
	end
	return false, "erro inesperado"
end




-- VERIFICAÇÃO DO PAGAMENTO DO ALUGUEL DO VEÍCULO

config.tryPayRent = function(source,user_id, info)
	if source and user_id and info then
		local price = parseInt(info.price * (config.porcentagem_aluguel / 100))
		if vRP.tryFullPayment(user_id, price) then
			Citizen.CreateThread(function()
				vRP.execute("nation_conce/addUserRentedVehicle", {
					user_id = user_id, vehicle = info.name, detido = 0, time = 0, engine = 1000, body = 1000, fuel = 100, ipva = os.time(), data_alugado = os.date("%d/%m/%Y")
				})
			end)
			return true, "sucesso!"
		else
			return false, "falha no pagamento"
		end
	end
	return false, "erro inesperado"
end

getTopList() -- pega os veículos mais caros da conce e coloca na lista de destaque


-- LOCAIS DAS CONCESSIONARIAS E REALIZAÇÃO DE TESTES

config.locais = {
	{ 
		conce = vec3(-40.08,-1097.21,26.42), 
		test_locais = {
			{ coords = vec3(-11.25,-1080.46,26.68), h = 129.4 },
			{ coords = vec3(-14.11,-1079.84,26.67), h = 122.02 },
			{ coords = vec3(-16.43,-1078.62,26.67), h = 126.74 },
			{ coords = vec3(-8.45,-1081.58,26.67), h = 117.45 },
		}
	},
	{ 
		conce = vec3(-1123.49,-1708.12,4.45),
		test_locais = {
			{ coords = vec3(-1177.30,-1743.51,4.04), h = 204.54 },
			{ coords = vec3(-1173.95,-1741.34,4.05), h = 212.41 },
			{ coords = vec3(-1171.41,-1739.55,4.07), h = 210.01 },
		} 
	},
}

