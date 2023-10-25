-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
emP = Tunnel.getInterface("farm_coleta")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local blips = false
local servico = false
local selecionado = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- COORDENADAS
-----------------------------------------------------------------------------------------------------------------------------------------
local Coordenadas = {

	{122.89,-1909.93,21.32}, -- lsd 

	-- {125.79, -1956.84, 20.74}, --  GOOVE
	-- {580.58, -3112.87, 6.07}, -- Cartel Galpão
	-- {-2425.99, 1793.88, 185.49}, --Laranjas

	-- {975.73,-140.24,74.88}, -- The Lost
    -- {511.4,-1335.76,29.73}, -- hells
	-- armas
	{-1916.85, 2084.02,140.39},-- Bratva
	{503.59,-3121.4,9.8}, -- mafia


	-- {95.55, -1294.31, 29.27}, -- Vanilla
	-- {674.88, -314.07, 60.73}, -- Verdes
	-- {1486.89,1132.03,114.34}, -- Vermelhos
	-- {562.79,-3121.29,18.77}, -- Azuis	
	-- {-1386.78,-589.49,30.32}, -- Roxos
	-- {-1066.61,-243.73,44.03}, -- Anonymous
	-- {-1066.61,-243.73,44.03}, -- Cartel
	-- {-1066.61,-243.73,44.03}, -- Merryweather
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INICIO/FIM
-----------------------------------------------------------------------------------------------------------------------------------------
local inicio = 0
local fim = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCALIZACAO 
-----------------------------------------------------------------------------------------------------------------------------------------
local locs = {

	--- Thelost
	[1] = { ['x'] = 1355.12, ['y'] = -1690.60, ['z'] = 60.49 },--1355.12,-1690.60,60.49
	[2] = { ['x'] = 970.78, ['y'] = -199.50, ['z'] = 73.20 }, -- 970.78,-199.50,73.20
	[3] = { ['x'] = 1212.98, ['y'] = -552.92, ['z'] = 69.17 }, -- 1212.98,-552.92,69.17
	[4] = { ['x'] = -3093.80, ['y'] = 349.27, ['z'] = 7.54 }, -- -3093.80,349.27,7.54
	[5] = { ['x'] = -1097.43, ['y'] = -1672.99, ['z'] = 8.39 }, -- -1097.43,-1672.99,8.39
	[6] = { ['x'] = -1613.24, ['y'] = -1028.10, ['z'] = 13.15 }, ---295.06,-2604.96,6.19
	[7] = { ['x'] = 196.5, ['y'] = -1690.99, ['z'] = 29.62 }, -- 196.5,-1690.99,29.62
	[8] = { ['x'] = 818.28, ['y'] = -1375.55, ['z'] = 26.32 }, -- 818.28,-1375.55,26.32
	[9] = { ['x'] = -688.73, ['y'] = -141.88, ['z'] = 37.84 }, -- -688.73,-141.88,37.84
	[10] = { ['x'] = 359.69, ['y'] = 356.52, ['z'] = 104.33 }, -- 359.69,356.52,104.33
	[11] = { ['x'] = 675.21, ['y'] = -2725.68, ['z'] = 7.18 }, -- 675.21,-2725.68,7.18

	--- Cartel
	[12] = { ['x'] = 191.43, ['y'] = -2226.55, ['z'] = 6.97 }, --191.43,-2226.55,6.97
	[13] = { ['x'] = -903.51, ['y'] = -1005.46, ['z'] = 2.15 }, ---1642.75,-1046.89,13.30
	[14] = { ['x'] = -3105, ['y'] = 246.82, ['z'] = 12.5 }, -- -3105.25,246.82,12.5
	[15] = { ['x'] = 1160.70, ['y'] = -311.57, ['z'] = 69.27 }, --1160.70,-311.57,69.27
	[16] = { ['x'] = 1086.49, ['y'] = -2400.11, ['z'] = 30.57 }, -- 1086.49,-24.14,30.58 
	[17] = { ['x'] = -429.16, ['y'] = -1728.11, ['z'] = 19.78 }, ---429.16,-1728.11,19.78
	[18] = { ['x'] = 1082.59, ['y'] = -787.55, ['z'] = 58.33 },-- 1082.59,-787.55,58.33
	[19] = { ['x'] = -430.94, ['y'] = 289.01, ['z'] = 86.06 }, ---430.94,289.01,86.06
	[20] = { ['x'] = -328.41, ['y'] = -2700.41, ['z'] = 7.54 },-- -328.41,-2700.41,7.54
	[21] = { ['x'] = -1244.10, ['y'] = -1240.34, ['z'] = 11.02 },-- -1244.10,-1240.34,11.02
	[22] = { ['x'] = 66.81, ['y'] = -253.46, ['z'] = 52.35 },-- 66.81,-253.46,52.35

	--- Bahamas
	[23] = { ['x'] = 1236.91, ['y'] = -3008.62, ['z'] = 9.31 },-- 1214.11,-1643.89,48.64
	[24] = { ['x'] = -1102.15, ['y'] = -1492.6, ['z'] = 4.89 },-- -1102.15,-1492.6,4.89
	[25] = { ['x'] = -1829.21, ['y'] = 801.0, ['z'] = 138.42 },-- -1829.21,801.0,138.42
	[26] = { ['x'] = -3049.84, ['y'] = 474.72, ['z'] = 6.78 },-- -3049.84,474.72,6.78
	[27] = { ['x'] = 1250.56, ['y'] = -1966.17, ['z'] = 44.32 },-- 1250.56,-1966.17,44.32
	[28] = { ['x'] = 997.08, ['y'] = -729.59, ['z'] = 57.82 },-- 997.08,-729.59,57.82
	[29] = { ['x'] = -43.59, ['y'] = -2520.00, ['z'] = 7.39 },-- -43.59,-2520.00,7.39
	[30] = { ['x'] = -1161.52, ['y'] = -1099.59, ['z'] = 2.20 },-- -1161.52,-1099.59,2.20
	[31] = { ['x'] = 1224.74, ['y'] = 2728.44, ['z'] = 38.00 },-- 380.13,356.97,102.57
	[32] = { ['x'] = 844.31, ['y'] = -2118.34, ['z'] = 30.52 },-- 844.31,-2118.34,30.52
	[33] = { ['x'] = 167.72, ['y'] = -2222.32, ['z'] = 7.23 },-- 167.72,-2222.32,7.23

	--- Vanilla
	[34] = { ['x'] = 1236.91, ['y'] = -3008.62, ['z'] = 9.31 },-- 1214.11,-1643.89,48.64
	[35] = { ['x'] = -1102.15, ['y'] = -1492.6, ['z'] = 4.89 },-- -1102.15,-1492.6,4.89
	[36] = { ['x'] = -1829.21, ['y'] = 801.0, ['z'] = 138.42 },-- -1829.21,801.0,138.42
	[37] = { ['x'] = -3049.84, ['y'] = 474.72, ['z'] = 6.78 },-- -3049.84,474.72,6.78
	[38] = { ['x'] = 1250.56, ['y'] = -1966.17, ['z'] = 44.32 },-- 1250.56,-1966.17,44.32
	[39] = { ['x'] = 997.08, ['y'] = -729.59, ['z'] = 57.82 },-- 997.08,-729.59,57.82
	[40] = { ['x'] = -43.59, ['y'] = -2520.00, ['z'] = 7.39 },-- -43.59,-2520.00,7.39
	[41] = { ['x'] = -1161.52, ['y'] = -1099.59, ['z'] = 2.20 },-- -1161.52,-1099.59,2.20
	[42] = { ['x'] = 1224.74, ['y'] = 2728.44, ['z'] = 38.00 },-- 380.13,356.97,102.57
	[43] = { ['x'] = 844.31, ['y'] = -2118.34, ['z'] = 30.52 },-- 844.31,-2118.34,30.52
	[44] = { ['x'] = 167.72, ['y'] = -2222.32, ['z'] = 7.23 },-- 167.72,-2222.32,7.23

	--- Verdes
	[45] = { ['x'] = 1236.91, ['y'] = -3008.62, ['z'] = 9.31 },-- 1214.11,-1643.89,48.64
	[46] = { ['x'] = -1102.15, ['y'] = -1492.6, ['z'] = 4.89 },-- -1102.15,-1492.6,4.89
	[47] = { ['x'] = -1829.21, ['y'] = 801.0, ['z'] = 138.42 },-- -1829.21,801.0,138.42
	[48] = { ['x'] = -3049.84, ['y'] = 474.72, ['z'] = 6.78 },-- -3049.84,474.72,6.78
	[49] = { ['x'] = 1250.56, ['y'] = -1966.17, ['z'] = 44.32 },-- 1250.56,-1966.17,44.32
	[50] = { ['x'] = 997.08, ['y'] = -729.59, ['z'] = 57.82 },-- 997.08,-729.59,57.82
	[51] = { ['x'] = -43.59, ['y'] = -2520.00, ['z'] = 7.39 },-- -43.59,-2520.00,7.39
	[52] = { ['x'] = -1161.52, ['y'] = -1099.59, ['z'] = 2.20 },-- -1161.52,-1099.59,2.20
	[53] = { ['x'] = 1224.74, ['y'] = 2728.44, ['z'] = 38.00 },-- 380.13,356.97,102.57
	[54] = { ['x'] = 844.31, ['y'] = -2118.34, ['z'] = 30.52 },-- 844.31,-2118.34,30.52
	[55] = { ['x'] = 167.72, ['y'] = -2222.32, ['z'] = 7.23 },-- 167.72,-2222.32,7.23

	--- Vermelhos
	[56] = { ['x'] = -716.71, ['y'] = -371.86, ['z'] = 34.78 }, 
    [57] = { ['x'] = -880.98, ['y'] = -182.65, ['z'] = 37.84 }, 
    [58] = { ['x'] = -229.34, ['y'] = -78.79, ['z'] = 49.8 }, 
    [59] = { ['x'] = 773.66, ['y'] = -150.35, ['z'] = 75.63 }, 
    [60] = { ['x'] = 1178.91, ['y'] = -1463.69, ['z'] = 34.91 }, 
    [61] = { ['x'] = 1041.14, ['y'] = -2115.86, ['z'] = 32.88 }, 
    [62] = { ['x'] = 764.65, ['y'] = -1722.99, ['z'] = 30.53 }, 
    [63] = { ['x'] = 520.81, ['y'] = -1653.01, ['z'] = 29.3 }, 
    [64] = { ['x'] = -321.03, ['y'] = -1401.03, ['z'] = 31.77 }, 
    [65] = { ['x'] = -703.6, ['y'] = -1179.9, ['z'] = 10.62 }, 
    [66] = { ['x'] = -1200.45, ['y'] = -1162.81, ['z'] = 7.7 }, 

    --- Azuis
	[67] = { ['x'] = 1236.91, ['y'] = -3008.62, ['z'] = 9.31 },-- 1214.11,-1643.89,48.64
	[68] = { ['x'] = -1102.15, ['y'] = -1492.6, ['z'] = 4.89 },-- -1102.15,-1492.6,4.89
	[69] = { ['x'] = -1829.21, ['y'] = 801.0, ['z'] = 138.42 },-- -1829.21,801.0,138.42
	[70] = { ['x'] = -3049.84, ['y'] = 474.72, ['z'] = 6.78 },-- -3049.84,474.72,6.78
	[71] = { ['x'] = 1250.56, ['y'] = -1966.17, ['z'] = 44.32 },-- 1250.56,-1966.17,44.32
	[72] = { ['x'] = 997.08, ['y'] = -729.59, ['z'] = 57.82 },-- 997.08,-729.59,57.82
	[73] = { ['x'] = -43.59, ['y'] = -2520.00, ['z'] = 7.39 },-- -43.59,-2520.00,7.39
	[74] = { ['x'] = -1161.52, ['y'] = -1099.59, ['z'] = 2.20 },-- -1161.52,-1099.59,2.20
	[75] = { ['x'] = 1224.74, ['y'] = 2728.44, ['z'] = 38.00 },-- 380.13,356.97,102.57
	[76] = { ['x'] = 844.31, ['y'] = -2118.34, ['z'] = 30.52 },-- 844.31,-2118.34,30.52
	[77] = { ['x'] = 167.72, ['y'] = -2222.32, ['z'] = 7.23 },-- 167.72,-2222.32,7.23

	---  Bratva
	[78] = {['x'] = -162.43, ['y'] = 6189.51, ['z'] = 31.44},
	[79] = {['x'] = -2218.6, ['y'] = 4229.55, ['z'] = 47.4},
	[80] = {['x'] = -3147.19, ['y'] = 1121.29, ['z'] = 20.87},
	[81] = {['x'] = -1936.51, ['y'] = 580.61, ['z'] = 119.49},
	[82] = {['x'] = -904.67, ['y'] = 780.17, ['z'] = 186.45},
	[83] = {['x'] = 655.45, ['y'] = 588.7, ['z'] = 129.06},
	[84] = {['x'] = 756.31, ['y'] = -557.79, ['z'] = 33.65},
	[85] = {['x'] = 767.04, ['y'] = -1895.48, ['z'] = 29.09},
	[86] = {['x'] = 262.08, ['y'] = -1822.19, ['z'] = 26.88},
	[87] = {['x'] = -289.11, ['y'] = -1080.96, ['z'] = 23.03},
	[88] = {['x'] = -1378.03, ['y'] = -361.05, ['z'] = 36.62},

	    --- Laranjas
	[89] = { ['x'] = 1236.91, ['y'] = -3008.62, ['z'] = 9.31 },-- 1214.11,-1643.89,48.64
	[90] = { ['x'] = -1102.15, ['y'] = -1492.6, ['z'] = 4.89 },-- -1102.15,-1492.6,4.89
	[91] = { ['x'] = -1829.21, ['y'] = 801.0, ['z'] = 138.42 },-- -1829.21,801.0,138.42
	[92] = { ['x'] = -3049.84, ['y'] = 474.72, ['z'] = 6.78 },-- -3049.84,474.72,6.78
	[93] = { ['x'] = 1250.56, ['y'] = -1966.17, ['z'] = 44.32 },-- 1250.56,-1966.17,44.32
	[94] = { ['x'] = 997.08, ['y'] = -729.59, ['z'] = 57.82 },-- 997.08,-729.59,57.82
	[95] = { ['x'] = -43.59, ['y'] = -2520.00, ['z'] = 7.39 },-- -43.59,-2520.00,7.39
	[96] = { ['x'] = -1161.52, ['y'] = -1099.59, ['z'] = 2.20 },-- -1161.52,-1099.59,2.20
	[97] = { ['x'] = 1224.74, ['y'] = 2728.44, ['z'] = 38.00 },-- 380.13,356.97,102.57
	[98] = { ['x'] = 844.31, ['y'] = -2118.34, ['z'] = 30.52 },-- 844.31,-2118.34,30.52
	[99] = { ['x'] = 167.72, ['y'] = -2222.32, ['z'] = 7.23 },-- 167.72,-2222.32,7.23

		--- Roxos
	[100] = { ['x'] = 1236.91, ['y'] = -3008.62, ['z'] = 9.31 },-- 1214.11,-1643.89,48.64
	[101] = { ['x'] = -1102.15, ['y'] = -1492.6, ['z'] = 4.89 },-- -1102.15,-1492.6,4.89
	[102] = { ['x'] = -1829.21, ['y'] = 801.0, ['z'] = 138.42 },-- -1829.21,801.0,138.42
	[103] = { ['x'] = -3049.84, ['y'] = 474.72, ['z'] = 6.78 },-- -3049.84,474.72,6.78
	[104] = { ['x'] = 1250.56, ['y'] = -1966.17, ['z'] = 44.32 },-- 1250.56,-1966.17,44.32
	[105] = { ['x'] = 997.08, ['y'] = -729.59, ['z'] = 57.82 },-- 997.08,-729.59,57.82
	[106] = { ['x'] = -43.59, ['y'] = -2520.00, ['z'] = 7.39 },-- -43.59,-2520.00,7.39
	[107] = { ['x'] = -1161.52, ['y'] = -1099.59, ['z'] = 2.20 },-- -1161.52,-1099.59,2.20
	[108] = { ['x'] = 1224.74, ['y'] = 2728.44, ['z'] = 38.00 },-- 380.13,356.97,102.57
	[109] = { ['x'] = 844.31, ['y'] = -2118.34, ['z'] = 30.52 },-- 844.31,-2118.34,30.52
	[110] = { ['x'] = 167.72, ['y'] = -2222.32, ['z'] = 7.23 },-- 167.72,-2222.32,7.23

	--- Anonymous
	[111] = { ['x'] = -716.71, ['y'] = -371.86, ['z'] = 34.78 }, 
    [112] = { ['x'] = -880.98, ['y'] = -182.65, ['z'] = 37.84 }, 
    [113] = { ['x'] = -229.34, ['y'] = -78.79, ['z'] = 49.8 }, 
    [114] = { ['x'] = 773.66, ['y'] = -150.35, ['z'] = 75.63 }, 
    [115] = { ['x'] = 1178.91, ['y'] = -1463.69, ['z'] = 34.91 }, 
    [116] = { ['x'] = 1041.14, ['y'] = -2115.86, ['z'] = 32.88 }, 
    [117] = { ['x'] = 764.65, ['y'] = -1722.99, ['z'] = 30.53 }, 
    [118] = { ['x'] = 520.81, ['y'] = -1653.01, ['z'] = 29.3 }, 
    [119] = { ['x'] = -321.03, ['y'] = -1401.03, ['z'] = 31.77 }, 
    [120] = { ['x'] = -703.6, ['y'] = -1179.9, ['z'] = 10.62 }, 
    [121] = { ['x'] = -1200.45, ['y'] = -1162.81, ['z'] = 7.7 }, 

	
	-- --- Cartel
	-- [123] = { ['x'] = -716.71, ['y'] = -371.86, ['z'] = 34.78 }, 
    -- [124] = { ['x'] = -880.98, ['y'] = -182.65, ['z'] = 37.84 }, 
    -- [125] = { ['x'] = -229.34, ['y'] = -78.79, ['z'] = 49.8 }, 
    -- [126] = { ['x'] = 773.66, ['y'] = -150.35, ['z'] = 75.63 }, 
    -- [127] = { ['x'] = 1178.91, ['y'] = -1463.69, ['z'] = 34.91 }, 
    -- [128] = { ['x'] = 1041.14, ['y'] = -2115.86, ['z'] = 32.88 }, 
    -- [129] = { ['x'] = 764.65, ['y'] = -1722.99, ['z'] = 30.53 }, 
    -- [130] = { ['x'] = 520.81, ['y'] = -1653.01, ['z'] = 29.3 }, 
    -- [131] = { ['x'] = -321.03, ['y'] = -1401.03, ['z'] = 31.77 }, 
    -- [132} = { ['x'] = -703.6, ['y'] = -1179.9, ['z'] = 10.62 }, 
    -- [133] = { ['x'] = -1200.45, ['y'] = -1162.81, ['z'] = 7.7 }, 


	
	-- --- Merryweather
	-- [134] = { ['x'] = -716.71, ['y'] = -371.86, ['z'] = 34.78 }, 
    -- [135] = { ['x'] = -880.98, ['y'] = -182.65, ['z'] = 37.84 }, 
    -- [136] = { ['x'] = -229.34, ['y'] = -78.79, ['z'] = 49.8 }, 
    -- [137] = { ['x'] = 773.66, ['y'] = -150.35, ['z'] = 75.63 }, 
    -- [138] = { ['x'] = 1178.91, ['y'] = -1463.69, ['z'] = 34.91 }, 
    -- [139] = { ['x'] = 1041.14, ['y'] = -2115.86, ['z'] = 32.88 }, 
    -- [140] = { ['x'] = 764.65, ['y'] = -1722.99, ['z'] = 30.53 }, 
    -- [141] = { ['x'] = 520.81, ['y'] = -1653.01, ['z'] = 29.3 }, 
    -- [142] = { ['x'] = -321.03, ['y'] = -1401.03, ['z'] = 31.77 }, 
    -- [143] = { ['x'] = -703.6, ['y'] = -1179.9, ['z'] = 10.62 }, 
    -- [144] = { ['x'] = -1200.45, ['y'] = -1162.81, ['z'] = 7.7 }, 

}
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCAL PARA INICIAR COLETA
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	while true do
		local RusherOtimizar = 1000
		if not servico then
			for _,mark in pairs(Coordenadas) do
				local x,y,z = table.unpack(mark)
				local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),x,y,z,true)
				if distance <= 30.0 then
					RusherOtimizar = 5
					-- DrawMarker(21,x,y,z,0,0,0,0,0,0,0.5,0.5,0.5,255,255,255,30,0,0,0,1)
					if distance <= 1.2 then
						RusherOtimizar = 1
						drawTxt("PRESSIONE  ~b~E~w~  PARA INICIAR COLETA",4,0.5,0.93,0.35,255,255,255,200)
						if IsControlJustPressed(0,38) and emP.checkPermission() then -- Ok
							if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),122.89,-1909.93,21.32,true) <= 1.2 then -- Vagos
								servico = true	
								inicio = 1
								fim = 33					
								selecionado = inicio
								CriandoBlip(locs,selecionado)
								TriggerEvent("Notify","importante","Você iniciou o serviço.") --ok

							elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),580.58, -3112.87, 6.07,true) <= 1.2 then -- Cartel
								servico = true						
								inicio = 1
								fim = 33						
								selecionado = inicio
								CriandoBlip(locs,selecionado)
								TriggerEvent("Notify","importante","Você iniciou o serviço.")
							elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),-2425.99, 1793.88, 185.49,true) <= 1.2 then -- laranjas
								servico = true							
								inicio = 55
								fim = 77					
								selecionado = inicio
								CriandoBlip(locs,selecionado)
								TriggerEvent("Notify","importante","Você iniciou o serviço.")
							elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),975.73,-140.24,74.88,true) <= 1.2 then -- TheLost
 								servico = true							
								inicio = 1
								fim = 33						
								selecionado = inicio
								CriandoBlip(locs,selecionado)
								TriggerEvent("Notify","importante","Você iniciou o serviço.")
							elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),-1937.18, 2051.24, 140.84,true) <= 1.2 then -- TheLost
								servico = true							
							   inicio = 1
							   fim = 33						
							   selecionado = inicio
							   CriandoBlip(locs,selecionado)
							   TriggerEvent("Notify","importante","Você iniciou o serviço.")
							elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),-1916.85,2084.02,140.39,true) <= 1.2 then -- bratva
								servico = true
								inicio = 78
								fim = 88
								selecionado = inicio
								CriandoBlip(locs,selecionado)
								TriggerEvent("Notify","importante","Você iniciou o serviço.")
							elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),503.59,-3121.4,9.8,true) <= 1.2 then -- mafia
								servico = true							
								inicio = 33
								fim = 55					
								selecionado = inicio
								CriandoBlip(locs,selecionado)
								TriggerEvent("Notify","importante","Você iniciou o serviço.")
							-- elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),562.79,-3121.29,18.77,true) <= 1.2 then -- vermelhos
							-- 	servico = true							
							-- 	inicio = 55
							-- 	fim = 77					
							-- 	selecionado = inicio
							-- 	CriandoBlip(locs,selecionado)
							-- 	TriggerEvent("Notify","importante","Você iniciou o serviço.")
							-- elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),2331.77, 2571.25, 46.69,true) <= 1.2 then -- azuis
							-- 	servico = true							
							-- 	inicio = 55
							-- 	fim = 77					
							-- 	selecionado = inicio
							-- 	CriandoBlip(locs,selecionado)
							-- 	TriggerEvent("Notify","importante","Você iniciou o serviço.")
							-- elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),1074.1,-2009.94,32.09,true) <= 1.2 then -- bratva
							-- 	servico = true							
							-- 	inicio = 55
							-- 	fim = 77					
							-- 	selecionado = inicio
							-- 	CriandoBlip(locs,selecionado)
							-- 	TriggerEvent("Notify","importante","Você iniciou o serviço.")	
							
							-- elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),-1066.61,-243.73,44.03,true) <= 1.2 then -- roxos
							-- 	servico = true							
							-- 	inicio = 55
							-- 	fim = 77					
							-- 	selecionado = inicio
							-- 	CriandoBlip(locs,selecionado)
							-- 	TriggerEvent("Notify","importante","Você iniciou o serviço.")
							-- elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),-1386.78,-589.49,30.32,true) <= 1.2 then -- anonymous
							-- 	servico = true							
							-- 	inicio = 55
							-- 	fim = 77					
							-- 	selecionado = inicio
							-- 	CriandoBlip(locs,selecionado)
							-- 	TriggerEvent("Notify","importante","Você iniciou o serviço.")
							-- elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),-1386.78,-589.49,30.32,true) <= 1.2 then -- cartel
							-- 	servico = true							
							-- 	inicio = 55
							-- 	fim = 77					
							-- 	selecionado = inicio
							-- 	CriandoBlip(locs,selecionado)
							-- 	TriggerEvent("Notify","importante","Você iniciou o serviço.")
							-- elseif GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()),-1386.78,-589.49,30.32,true) <= 1.2 then -- merryweather
							-- 	servico = true							
							-- 	inicio = 55
							-- 	fim = 77					
							-- 	selecionado = inicio
							-- 	CriandoBlip(locs,selecionado)
							-- 	TriggerEvent("Notify","importante","Você iniciou o serviço.")		
							end				
						end
					end
				end
			end
		end
		Citizen.Wait(RusherOtimizar)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COLETA DE COMPONENTES
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 1000
		if servico then
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
			local distance = GetDistanceBetweenCoords(locs[selecionado].x,locs[selecionado].y,cdz,x,y,z,true)
            
            
            if distance <= 100.0 then
                timeDistance = 5
                DrawMarker(21,locs[selecionado].x,locs[selecionado].y,locs[selecionado].z,0,0,0,0,0,0,0.5,0.5,0.5,255,255,255,150,1,0,0,1)
                if distance <= 1.6 then
                    timeDistance = 4
                    drawTxt("PRESSIONE ~b~E~w~  PARA COLETAR",4,0.5,0.93,0.35,255,255,255,200)
                    if IsControlJustPressed(0,38) and not IsPedInAnyVehicle(ped) then
                        if emP.checkPayment() then
                            TriggerEvent('progress',1000,'PEGANDO')
							TriggerEvent('cancelando',true)
							vRP._playAnim(false,{{"pickup_object","pickup_low"}},true)
							Citizen.Wait(1000)
							vRP._stopAnim(false)
							TriggerEvent('cancelando',false)
							RemoveBlip(blips)
							selecionado = selecionado + 1
							if selecionado > fim then
								selecionado = inicio
							end
                            CriandoBlip(locs,selecionado)

                        end
                    end
                end
            end
		
        end
        Citizen.Wait(timeDistance)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CANCELAR
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if servico then
			drawTxt("~y~PRESSIONE ~r~F7 ~w~PARA FINALIZAR A COLETA",4,0.300,0.945,0.35,255,255,255,200)	
			if IsControlJustPressed(0,168) then
				servico = false
				RemoveBlip(blips)
				TriggerEvent("Notify","aviso","Você largou o serviço.")
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÕES
-----------------------------------------------------------------------------------------------------------------------------------------
function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function CriandoBlip(locs,selecionado)
	blips = AddBlipForCoord(locs[selecionado].x,locs[selecionado].y,locs[selecionado].z)
	SetBlipSprite(blips,1)
	SetBlipColour(blips,5)
	SetBlipScale(blips,0.4)
	SetBlipAsShortRange(blips,false)
	SetBlipRoute(blips,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Coleta de Componentes")
	EndTextCommandSetBlipName(blips)
end

local pedlist = {
	{ ['x'] = -1916.85, ['y'] = 2084.02, ['z'] = 140.39, ['h'] = 230.25, ['hash'] = 0xA8C22996, ['hash2'] = "csb_chin_goon" },
	{ ['x'] = 503.59, ['y'] = -3121.4, ['z'] = 9.8, ['h'] = 184.20, ['hash'] = 0x062547E7, ['hash2'] = "cs_floyd" },
		
}

CreateThread(function()
	for k,v in pairs(pedlist) do
		RequestModel(GetHashKey(v.hash2))
		while not HasModelLoaded(GetHashKey(v.hash2)) do Wait(100) end
		ped = CreatePed(4,v.hash,v.x,v.y,v.z-1,v.h,false,true)
		peds = ped
		FreezeEntityPosition(ped,true)
		SetEntityInvincible(ped,true)
		SetBlockingOfNonTemporaryEvents(ped,true)
	end
end)