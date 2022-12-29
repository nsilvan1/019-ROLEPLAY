config = {}
config.no_repair = false
config.showDebug = false -- mostrar modificacoes cada vez q um veiculo é spawnado
config.prices = {

---------tipos de cor-----------

	["colortypes"] = {
		["cromado"] = 2000,  -- + o preco da cor normal
		["metálico"] = 2000,
		["fosco"] = 0,
		["metal"] = 0 
	},

----------cor secundária custom--------
	["cor-secundaria"] = {
		startprice = 3000,
	},	
----------cor primaria custom--------
	["cor-primaria"] = {
		startprice = 3000,
	},
----------cor secundária--------
	["secundaria"] = {
		startprice = 1000,
	},	
----------cor primaria--------
	["primaria"] = {
		startprice = 2000,
	},
----------Perolado--------
	["perolado"] = {
		startprice = 3000,
	},
----------Cor da roda--------
	["wheelcolor"] = {
		startprice = 1000,
	},
----------Neon--------
	["neon"] = {
		startprice = 13000,
	},
----------Pneu custom--------
	["custom"] = {
		startprice = 1000,
	},
----------Pneu a prova de balas--------
	--["bulletproof"] = {
	--	startprice = 240000,
	--},
----------Placa--------
	["placa"] = {
		startprice = 1000,
		increaseby = 0
	},
----------Vidro--------
	["vidro"] = {
		startprice = 3000,
		increaseby = 0
	},
----------Liveries--------
	[48] = {
		startprice = 5000,
		increaseby = 0
	},
	
----------Windows--------
	[46] = {
		startprice = 3000,
		increaseby = 0
	},
	
----------Tank--------
	[45] = {
		startprice = 20000,
		increaseby = 20000
	},
	
----------Trim--------
	[44] = {
		startprice = 1000,
		increaseby = 0
	},
	
----------Aerials--------
	[43] = {
		startprice = 2000,
		increaseby = 0
	},

----------Arch cover--------
	[42] = {
		startprice = 2000,
		increaseby = 0
	},

----------Struts--------
	[41] = {
		startprice = 5000,
		increaseby = 0
	},
	
----------Air filter--------
	[40] = {
		startprice = 2000,
		increaseby = 0
	},
	
----------Engine block--------
	[39] = {
		startprice = 2000,
		increaseby = 0
	},

----------Hydraulics--------
	[38] = {
		startprice = 5000,
		increaseby = 0
	},
	
----------Trunk--------
	[37] = {
		startprice = 4000,
		increaseby = 0
	},

----------Speakers--------
	[36] = {
		startprice = 5000,
		increaseby = 0
	},

----------Plaques--------
	[35] = {
		startprice = 2000,
		increaseby = 0
	},
	
----------Shift leavers--------
	[34] = {
		startprice = 3000,
		increaseby = 0
	},
	
----------Steeringwheel--------
	[33] = {
		startprice = 3000,
		increaseby = 0
	},
	
----------Seats--------
	[32] = {
		startprice = 4000,
		increaseby = 0
	},
	
----------Door speaker--------
	[31] = {
		startprice = 5000,
		increaseby = 0
	},

----------Dial--------
	[30] = {
		startprice = 4000,
		increaseby = 0
	},
----------Dashboard--------
	[29] = {
		startprice = 4000,
		increaseby = 0
	},
	
----------Ornaments--------
	[28] = {
		startprice = 4000,
		increaseby = 0
	},
	
----------Trim--------
	[27] = {
		startprice = 4000,
		increaseby = 0
	},
	
----------Vanity plates--------
	[26] = {
		startprice = 3000,
		increaseby = 0
	},
	
----------Plate holder--------
	[25] = {
		startprice = 3000,
		increaseby = 0
	},
---------Back Wheels---------
	[24] = {
		startprice = 5000,
		increaseby = 0
	},
---------Front Wheels---------
	[23] = {
		startprice = 5000,
		increaseby = 0
	},
---------Headlights---------
	[22] = {
		startprice = 15000,
	},
	
----------Turbo---------
	[18] = {
		startprice = 20000,
	},
	
-----------Armor-------------
	[16] = {
		startprice = 20000,
		increaseby = 20000
	},

---------Suspension-----------
	[15] = {
		startprice = 5000,
		increaseby = 5000
	},
-----------Horn----------
    [14] = {
        startprice = 2000,
		increaseby = 0
    },
-----------Transmission-------------
    [13] = {
        startprice = 30000,
		increaseby = 10000
	},
	
-----------Brakes-------------
	[12] = {
        startprice = 10000,
		increaseby = 10000
	},
	
------------Engine----------
	[11] = {
        startprice = 10000,
		increaseby = 10000
	},
    ---------Roof----------
	[10] = {
		startprice = 2000,
		increaseby = 0
	},
	
------------Fenders---------
	[8] = {
		startprice = 4000,
		increaseby = 0
	},
	
------------Hood----------
	[7] = {
		startprice = 4000,
		increaseby = 0
	},
	
----------Grille----------
	[6] = {
		startprice = 4000,
		increaseby = 0
	},
	
----------Roll cage----------
	[5] = {
		startprice = 4000,
		increaseby = 0
	},
	
----------Exhaust----------
	[4] = {
		startprice = 4000,
		increaseby = 0
	},
	
----------Skirts----------
	[3] = {
		startprice = 5000,
		increaseby = 0
	},
	
-----------Rear bumpers----------
	[2] = {
		startprice = 5000,
		increaseby = 0
	},
	
----------Front bumpers----------
	[1] = {
		startprice = 5000,
		increaseby = 0
	},
	
----------Spoiler----------
	[0] = {
		startprice = 5000,
		increaseby = 0
	},
}


config.locais = {
	[1] = vec3(823.14, -884.57, 25.35),
	[2] = vec3(839.25, -885.53, 25.32),
	[3] = vec3(831.44, -885.56, 25.32)
	-- [4] = vec3(-320.99, -128.98, 39.02),
	-- [5] = vec3(-319.45, -124.19, 39.02),
	-- [6] = vec3(-317.53, -118.69, 39.02),
	-- [7] = vec3(-315.87, -113.84, 39.02),
	-- [8] = vec3(-313.85, -107.97, 39.02),
	-- [9] = vec3(-311.6, -102.97, 39.02),
	-- [10] = vec3(-338.22, -94.64, 39.03),
	-- [11] = vec3(-351.79, -90.37, 39.02),
	-- [12] = vec3(-365.94, -85.35, 39.02),
	-- [13] = vec3(-341.79, -142.72, 60.61),
	-- [14] = vec3(-1281.16, -3397.6, 13.95)


}

config.permissao = 	"mecanico.permissao"

config.use_vehlist = true

config.use_modelname = false

config.logo = "https://cdn.discordapp.com/attachments/759977459629686814/826782898275352606/Sem_Titulo-2.png"