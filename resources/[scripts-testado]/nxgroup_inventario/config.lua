config = {}

config.webhookrevistar = "https://discord.com/api/webhooks/1058406657421475970/RQaPw-i12uJzB1CTDEX4-trbOzZ074YCazEr2M3eq4bBWjHDuESMF5waZqwpYj1coNZ1"
config.webhookroubar = "https://discord.com/api/webhooks/1058406717395849316/y7qSH4j9c3bXnDhwlTXEujOjQULeSZ0CKyQUfRasdSfxB4sXSpsUOvft6CGH6a0RPQhQ"
config.webhookdropar = "https://discord.com/api/webhooks/1058406770453782642/3SjmcxiWEAUQ-Ph5-9CN57I3B-9uYYsThqMba3ia3fAPNMYMGy5uTbKC187CYtXtEMZs"
config.webhookenviar = "https://discord.com/api/webhooks/1058406840154718329/QMzlya1kveZlum0Sc6INIhZh3qByXxBjPtBDYs2QknetFaENrsz9hmg8Xx1nOA_u-LJC"
config.webhookequipar = "https://discord.com/api/webhooks/1058406911139131432/GP4FJfBA52zJGWCzVhFSKFbSGpJ7fQ8CbbfvJ-_4vTDbibzd006fXLgJth2QvExYo7uL"
config.webhookrecarregar = "https://discord.com/api/webhooks/1058406997743120456/qBXgCNpBkIC9Ihgy-lDQ8RPcINpV_nORV5z872H4jc36g0LU1pCheskMfURiPvEMJL9_"
config.webhookpegar = "https://discord.com/api/webhooks/1058407124100718642/FA73DoZYm2z6jJ96pQTIr_ESP-gD_Mhq848Q5hm_-aVi0N3vLfYDN8SWZYLeRNb1_6YU"
config.webhookbaucarro = "https://discord.com/api/webhooks/1058407181239734332/bBImpzeVMF5GDujyEKM_U-H30CPrJ0IGkSIY6PpNTcm6NCqbj20xSo7Sis1ipR_RTH2j"
config.webhookbau = "https://discord.com/api/webhooks/1058407252081528883/TkT7s4pLRF_H5ZlnaBJ4cw9L1mu5YHsquua5j8Tm2sl6b9LZOvcdrJFAA9XZZl_CnUWv"
config.webhookbaucasas = "https://discord.com/api/webhooks/1058407324462616668/rMkobtlDbUg2nM_pw6-_q64MRvc3uKhXfJBVEE8q10edU-ixKMXMzoNs5rIq84xzDhus"
config.webhookGuardarArmas = "https://discord.com/api/webhooks/1058407374844592220/NLR5ClNB3JvfrqSS4asIeWA7Z1mC6sLsSWi9AQBpVdy7Wm-I_-W8mA1zT3NUivcnM2rO"
config.webhookSpawn = "https://discord.com/api/webhooks/1058407433753600130/tQPLz4WBhzL_J1OnVN-XopBAdynD0PBCuQXocTEDFOtmCQAn8mv0UCrhYnKYJOt6jR67"
config.webhookTryDup = "https://discord.com/api/webhooks/1058407486853496862/VLqu1zwoxCw4xQi0_7X4BlFo_2RqezjOTDcjJVX0TDjRoYsf7gXFoh3Fpv8eBmtIWpOa"

--OPICIONAL DEPENDENDO DO ITEMS.LUA
config.webhookLockpick = "https://discord.com/api/webhooks/1058407547108868137/D77ucFFeJe3d4lNVbGbsCjX12Mz4nJWIN5bLCarxFzcQgiFb_o1KWYUqi4v-1TJR2KQG"

config.drawMarker = function(x,y,z)
	DrawMarker(27,x,y,z-0.97,0,0,0,0,0,0,1.0,1.0,0.5,201, 0, 0,155,0,0,0,1)
end

config.images = "https://flushrp.com/img/inv/"
config.permSpawn = "ceo.permissao" --PERMISSAO PRA ACESSO AO COMANDO /arma e /item
config.nationGarages = true
config.nyoGarages = false

--LISTA DE ARMAS QUE NAO CONSEGUE DESEQUIPAR (ITEM SOME AO DESEQUIPAR)
config.policeItems = {
	["WEAPON_COMBATPISTOL"] = true,
	["WEAPON_NIGHTSTICK"] = true,
	["WEAPON_COMBATPDW"] = true,
	["WEAPON_STUNGUN"] = true,
	["WEAPON_PUMPSHOTGUN"] = true,
	["WEAPON_CARBINERIFLE"] = true,
	["WEAPON_CARBINERIFLE_MK2"] = true,
	["WEAPON_SMG"] = true,
	["WEAPON_APPISTOL"] = true,
}

--NOME DO BAU, X, Y, Z, PESO, PERMISSAO PRA ABRIR, WEBHOOK PRA GERAR LOG INDIVIDUAL 
config.chest = {

	["Admin"] = { "Admin", 215.55,-921.09,60.71,30000,"admin.permissao","https://discord.com/api/webhooks/1053467343830925574/znBHu3JG2qQ_xzog6-Tl2I83ZgOgygWtUDgAFuWkPVnxE1TlkE3u7nkZ70wTe84E7LRo" },
	["Policia"] = { "Policia", -1089.22, -820.7, 11.04,30000,"policia.permissao","https://discord.com/api/webhooks/1053467727546826783/6woecqYeRoh1AdUH-EARYzxWqDNqWHOmtuyoCyvJuwtS_hssIcJtneVD_NAbps8KEX9z" },
	["Mecanico"] = { "Mecanico", 814.55,-908.63,25.26,30000,"mecanico.permissao","https://discord.com/api/webhooks/1053471234375024732/yWuGGC2wkXAUCSdhV0fkYO29pwKrALNMUohy8-1tzTatYYe1D1GYOLpBPGusD68q6nb_" },
	["Hospital"] = { "Hospital", 306.46,-601.7,43.29,30000,"paramedico.permissao","https://discord.com/api/webhooks/974875252981121064/LgdY-W7rU1FsBFaQsg2iWvNmxa0jHLmLexKNeZt5CGVp3OdKIXxWHYuCFN912G5i_ECK" },

	
	["Vanilla"] = { "Vanilla", 94.1,-1290.96,29.27,3000,"vanilla.permissao","https://discord.com/api/webhooks/1053471537753247834/mnxqVw8jPgytaVtKco2vFTAZFqp0Derh2quPrakVkrod5sOhZF2HEoOClobZESrVqNM3" },
	["Bahamas"] = { "Bahamas", -1386.74,-608.53,30.32,3000,"bahamas.permissao","https://discord.com/api/webhooks/974874799778193478/cmzXZkHomdkwVjNsQlq3hKV7XTMX-9XlygyMT6Obj0CLKiCjTK9_Z_ifC_ezc5mM0pj1" },
	-- ["Tequilala"] = { "Tequilala", 2557.31,-769.1,85.34,3000,"tequilala.permissao","https://discord.com/api/webhooks/1053473736784875570/MMnfy-bULfbM2J-T10YjT8F2YbLHiLQue2KcheITE2sDFbynLJfeHfV4W3LesVNcvkgN" },
	
	["Groove"] = { "Groove", 1527.1,-640.93,138.41,3000,"groove.permissao","https://discord.com/api/webhooks/1053476188678520833/q4p1v97uRtY6Gs6i476XGlfw9pkROY_QNWGbGr2VTfT8ZDLgpyjU7I-ec56ZOg2iV4l-" },
	["Vagos"] = { "Vagos", 353.15,-2055.32,22.25,3000,"vagos.permissao","https://discord.com/api/webhooks/977798576308617228/1vDrG-kE2ok31JAlAG7F9xqDtHHLgHtUcyxDPjKUGLWcRmUFfA45ekRVtrXqdL6w-gw3" },
	["Ballas"] = { "Ballas", 106.38,-1981.22,20.97,3000,"ballas.permissao","https://discord.com/api/webhooks/1053477032694132736/s7DeJg9UOBNVrmGL_Alobn7X2j3MYwsMHeO9_gBaXC97o7jWG_6lfhhXkkAZwGEM_Ev3" },
	["Bloods"] = { "Bloods", 66.02,621.89,201.37,3000,"bloods.permissao","https://discord.com/api/webhooks/1053477668248625254/KjVDHOPFKNefARO0YgP_2yQvkgLl6qoJXDysjo7Y55_gvCnzKS2nuJ90oQPW5aIBel7N" },

	["Motoclub"] = { "Motoclub", 977.17,-104.02,74.85,3000,"motoclub.permissao","https://discord.com/api/webhooks/1053477878488121474/KkbC7ADQSHUSUtUnFIwY2ZdqqS59ONo4OFLwM1DnPIgTRpydyxGS4Qztag-_naR3EOly" },
	["Hells"] = { "Hells", 474.7,-1308.45,29.21,3000,"hells.permissao","https://discord.com/api/webhooks/1053478055911370762/aL0AUAz1tz5N15iIWR3KiREkDZYYF-nI5oBEb_mpBKhozqze1eSJJ4zgkoxs2KZgR35N" },

	["Bratva"] = { "Bratva", -1875.56,2062.39,145.58,3000,"bratva.permissao","https://discord.com/api/webhooks/974875649808408586/Hs1wseCf3cHfxhk_tH5t-7Rbm2j9LzjFOBXTrxzEilQh0xGKCn-pkik1s3HIfQ_cdrFC" },

	["Crips"] = { "Crips", -1460.86,-45.08,58.41,3000,"crips.permissao","https://discord.com/api/webhooks/1053493116365181050/b2xPyHPYEJD2HG0q6d8_4Giisb3uNHERsHy6yYNgG7WCuguB7bQlJFnec3iKeQYiF986" },
	["Mafia"] = { "Mafia", -1476.72,-38.18,54.61,3000,"mafia.permissao","https://discord.com/api/webhooks/1053461939549905017/F8EyFFwOGbMkWFqXyTu5kjdqe_9RrPLQ8CPvP9Zw6RNzFWBzEMTUt-70EUWvCfa1rPvJ" },

	["Triade"] = { "Triade", 575.42,-3121.91,18.77,3000,"triade.permissao","https://discord.com/api/webhooks/1053496692030308402/kdvVzFGLCOmKaAIOUvE1bPJDV0iPc24uGyDHVp4se7gKNomBkzr0MRgKa186GowbeBpc" },


	
}

config.shopList = {
		{ 25.68,-1346.6,29.5,"departamentStore" },
		{ 2556.47,382.05,108.63,"departamentStore" },
		{ 1163.55,-323.02,69.21,"departamentStore" },
		{ -707.31,-913.75,19.22,"departamentStore" },
		{ -47.72,-1757.23,29.43,"departamentStore" },
		{ 373.89,326.86,103.57,"departamentStore" },
		{ -3242.95,1001.28,12.84,"departamentStore" },
		{ 1729.3,6415.48,35.04,"departamentStore" },
		{ 548.0,2670.35,42.16,"departamentStore" },
		{ 1960.69,3741.34,32.35,"departamentStore" },
		{ 2677.92,3280.85,55.25,"departamentStore" },
		{ 1698.5,4924.09,42.07,"departamentStore" },
		{ -1820.82,793.21,138.12,"departamentStore" },
		{ 1393.21,3605.26,34.99,"departamentStore" },
		{ -2967.78,390.92,15.05,"departamentStore" },
		{ -3040.14,585.44,7.91,"departamentStore" },
		{ 1135.56,-982.24,46.42,"departamentStore" },
		{ 1166.0,2709.45,38.16,"departamentStore" },
		{ -1487.21,-378.99,40.17,"departamentStore" },
		{ -1222.76,-907.21,12.33,"departamentStore" },
		{ 1692.62,3759.50,34.70,"ammunationStore" },
		{ 252.89,-49.25,69.94,"ammunationStore" },
		{ 843.28,-1034.02,28.19,"ammunationStore" },
		{ -331.35,6083.45,31.45,"ammunationStore" },
		{ -663.15,-934.92,21.82,"ammunationStore" },
		{ -1305.18,-393.48,36.69,"ammunationStore" },
		{ -1118.80,2698.22,18.55,"ammunationStore" },
		{ 2568.83,293.89,108.73,"ammunationStore" },
		{ -3172.68,1087.10,20.83,"ammunationStore" },
		{ 21.32,-1106.44,29.79,"ammunationStore" },
		{ 811.19,-2157.67,29.61,"ammunationStore" },
		{ 811.19,-2157.67,29.61,"ammunationStore" },
	
		{ 1275.44,-1710.81,54.78,"ilegalStore" },
		{ 1272.36,-1711.73,54.78,"ilegalStore2" },

	

		{ -1519.03,115.47,50.06,"gunsCraft" },  --BRATVA(PLAYBOY)


		{ 964.54,-1841.23,31.27,"gunsCraft" },  --Bratva
		{ -1870.5,2061.56,135.44,"gunsCraft" }, --CRIPS(VINICULA)
		{ 1402.33,1139.85,109.75,"gunsCraft" }, --BRATVA(FAZENDA)
		
		{ -875.68,-1458.65,7.53,"ammoCraft" },  --YAKUZA (YAKUZA)
		{ 568.09,-3126.8,18.77,"ammoCraft" },   --AZTECAS (DOCAS)
		{ -2678.49,1330.4,140.89,"ammoCraft" }, --COSANOSTRA (MONTANHAS)
	
		{ -621.45,-231.87,38.06,"joalheriaStore" },
		{ -1371.69,-626.51,30.82,"bebidasStore" },
		{ 2885.11,4387.0,50.74,"departamentStoreGrao" }, -- venda de grão 
		{ 1551.22,3798.98,34.41,"departamentStorePesca" }, -- venda de peixe 
}
	
config.itemShops = {
		["departamentStore"] = {
			["perm"] = nil,
			["cash"] = "limpo",
			["list"] = {
				["celular"] = 10000,
				["repairkit"] = 15000,
				["radio"] = 5000,
				["mochila"] = 15000,
				["roupas"] = 5000,
				-- ["alianca"] = 20000,
				["energetico"] = 7000,
				["isca"] = 200,
			}
		},
		["departamentStorePesca"] = {
			["perm"] = nil,
			["method"]= "Sell",
			["cash"] = "limpo",
			["list"] = {
				["lambari"] = 400,
				["dourado"] = 450,
				["corvina"] = 470,
				["salmao"] = 500,
				["pacu"] = 550,
				["pintado"] = 570,
				["pirarucu"] = 600,
				["tilapia"] = 650,
				["tucunare"] = 700,
				["isca"] = 100,
			}
		},
		["departamentStoreGrao"] = {
			["perm"] = nil,
			["method"]= "Sell",
			["cash"] = "limpo",
			["list"] = {
				["graos"] = 350,
			}
		},
		["bebidasStore"] = {
			["perm"] = nil,
			["cash"] = "limpo",
			["list"] = {
				["energetico"] = 7000,
				["whisky"] = 5000,
				["tequila"] = 5000,
				["conhaque"] = 5000,
				["absinto"] = 5000,
				["vodka"] = 5000,
			}
		},
		["bebidasStore2"] = {
			["perm"] = nil,
			["cash"] = "limpo",
			["list"] = {
	
			}
		},
		["joalheriaStore"] = {
			["perm"] = nil,
			["cash"] = "limpo",
			["list"] = {
			}
		},
		["joalheriaStore2"] = {
			["perm"] = nil,
			["cash"] = "limpo",
			["list"] = {
				["ouro2"] = 400,
				["ferro2"] = 300,
				["bronze2"] = 350,
				["topazio2"] = 300,
				["ruby2"] = 300,
				["safira2"] = 300,
				["ouro"] = 300,
				["ferro"] = 300,
				["bronze"] = 300,
				["topazio"] = 300,
				["ruby"] = 300,
				["safira"] = 300,
			}
		},
		["ammunationStore"] = {
			["perm"] = nil,
			["cash"] = "limpo",
			["list"] = {
				["wbody|WEAPON_KNIFE"] = 50000,
				["wbody|WEAPON_KNUCKLE"] = 50000,
				["wbody|WEAPON_SWITCHBLADE"] = 50000,
				["wbody|WEAPON_POOLCUE"] = 50000,
				["wbody|WEAPON_WRENCH"] = 50000,
				["wbody|WEAPON_BAT"] = 50000,
				["wbody|GADGET_PARACHUTE"] = 10000,
				-- ["modificacaodearma"] = 25000,
			}
		},
		["ammunationStore2"] = {
			["perm"] = nil,
			["cash"] = "limpo",
			["list"] = {
				["wbody|WEAPON_KNIFE"] = 0,
				["wbody|GADGET_PARACHUTE"] = 0,
				-- ["modificacaodearma"] = 0,
			}
		},
		["ilegalStore"] = {
			["perm"] = "ilegal.permissao",
			["cash"] = "sujo",
			["list"] = {
				["polvora"] = 250,
				["molas"] = 5000,
				["gatilho"] = 5000,
				["placa-metal"] = 10000,
			}
		},
		["ilegalStore2"] = {
			["perm"] = nil,
			["cash"] = "limpo",
			["list"] = {
				["algema"] = 5000,
				["capuz"] = 3000,
				["modificacaodearma"] = 20000,

			}
		},
		["gunsCraft"] = {
			["perm"] = "armas.permissao",
			["list"] = {
				["wbody|WEAPON_SNSPISTOL"] = {
					["pecadearma"] = 75,
					["placa-metal"] = 1,
					["molas"] = 1,
					["gatilho"] = 1,
				},
				["wbody|WEAPON_PISTOL_MK2"] = {
					["pecadearma"] = 100,
					["placa-metal"] = 2,
					["molas"] = 2,
					["gatilho"] = 1,
				},
				["wbody|WEAPON_MACHINEPISTOL"] = {
					["pecadearma"] = 250,
					["placa-metal"] = 6,
					["molas"] = 3,
					["gatilho"] = 1,
				},
				["wbody|WEAPON_SPECIALCARBINE_MK2"] = {
					["pecadearma"] = 400,
					["placa-metal"] = 10,
					["molas"] = 6,
					["gatilho"] = 1,
				},
				["wbody|WEAPON_ASSAULTRIFLE"] = {
					["pecadearma"] = 400,
					["placa-metal"] = 10,
					["molas"] = 6,
					["gatilho"] = 1,
				},
			}
		},
		["gunsCraft2"] = {
			["perm"] = "ilegal.permissao",
			["cash"] = "limpo",
			["list"] = {	
			}
		},
		["ammoCraft"] = {
			["perm"] = "ilegal.permissao",
			["list"] = {
				["wammo|WEAPON_SNSPISTOL"] = {
					["capsulas"] = 1,
					["polvora"] = 1,
				},
				["wammo|WEAPON_PISTOL_MK2"] = {
					["capsulas"] = 2,
					["polvora"] = 2,
				},
				["wammo|WEAPON_MACHINEPISTOL"] = {
					["capsulas"] = 3,
					["polvora"] = 2,
				},
				["wammo|WEAPON_SPECIALCARBINE_MK2"] = {
					["capsulas"] = 3,
					["polvora"] = 3,
				},
				["wammo|WEAPON_ASSAULTRIFLE"] = {
					["capsulas"] = 3,
					["polvora"] = 3,
				},
			}
		},
		["ammoCraft2"] = {
			["perm"] = "ilegal.permissao",
			["cash"] = "limpo",
			["list"] = {
				
			}
		},
}

config.itemlist = {
	["kevlar"] = { index = "kevlar", nome = "Kevlar", type = "usar", peso = 1 },
	["c4"] = { index = "c4", nome = "C4", type = "usar", peso = 1 },
	["serra"] = { index = "serra", nome = "Serra", type = "usar", peso = 1 },
	["ziper"] = { index = "ziper", nome = "Ziper", type = "usar", peso = 1 },
	["furadeira"] = { index = "furadeira", nome = "Furadeira", type = "usar", peso = 1 },
	["sacodelixo"] = { index = "sacodelixo", nome = "Saco de lixo", type = "usar", peso = 1 },
	["telefonedescartavel"] = { index = "telefonedescartavel", nome = "telefonedescartavel", type = "usar", peso = 1 },
	["relogioroubado"] = { index = "relogioroubado", nome = "Relógio Roubado", type = "usar", peso = 4.2 },
	["pulseiraroubada"] = { index = "pulseiraroubada", nome = "Pulseira Roubada", type = "usar", peso = 1 },
	["anelroubado"] = { index = "anelroubado", nome = "Anel Roubado", type = "usar", peso = 1 },
	["colarroubado"] = { index = "colarroubado", nome = "Colar Roubado", type = "usar", peso = 1 },
	["brincoroubado"] = { index = "brincoroubado", nome = "Brinco Roubado", type = "usar", peso = 1 },
	["carteiraroubada"] = { index = "carteiraroubada", nome = "Carteira Roubada", type = "usar", peso = 1 },
	["tabletroubado"] = { index = "tabletroubado", nome = "Tablet Roubado", type = "usar", peso = 1 },
	["sapatosroubado"] = { index = "sapatosroubado", nome = "Sapatos Roubado", type = "usar", peso = 1 },
	["sacoplastico"] = { index = "sacoplastico", nome = "Saco de Plastico", type = "usar", peso = 1 },
	["plastico"] = { index = "plastico", nome = "Plastico", type = "usar", peso = 1 },
	["jogodepneu"] = { index = "jogodepneu", nome = "Jogo de Pneu", type = "usar", peso = 1 },
	["encomenda"] = { index = "encomenda", nome = "Encomenda", type = "usar", peso = 1 },
	["aco"] = { index = "aco", nome = "Aço", type = "usar", peso = 0.3 },
	["pizza"] = { index = "pizza", nome = "Pizza", type = "usar", peso = 0.5 },
	["lanche"] = { index = "lanche", nome = "Lanche", type = "usar", peso = 0.5 },
	["sanduiche"] = { index = "sanduiche", nome = "Sanduiche", type = "usar", peso = 0.5 },
	["tomate"] = { index = "tomate", nome = "Tomate", type = "usar", peso = 0.5 },
	["taco"] = { index = "taco", nome = "Taco", type = "usar", peso = 0.5 },
	["hamburguer"] = { index = "hamburguer", nome = "Hamburguer", type = "usar", peso = 0.5 },
	["chocolate"] = { index = "chocolate", nome = "Chocolate", type = "usar", peso = 0.5 },
	["laranja"] = { index = "laranja", nome = "Laranja", type = "usar", peso = 0.5 },
	["agua"] = { index = "agua", nome = "Agua", type = "usar", peso = 0.5 },
	["coca"] = { index = "coca", nome = "Coca Cola", type = "usar", peso = 0.5 },
	["cafe"] = { index = "cafe", nome = "Café", type = "usar", peso = 1 },
	["toddynho"] = { index = "toddynho", nome = "Toddynho", type = "usar", peso = 0.5 },
	["garrafavazia"] = { index = "garrafavazia", nome = "Garrafa Vazia", type = "usar", peso = 0.5 },
	["energetico"] = { index = "energetico", nome = "Energético", type = "usar", peso = 1 },
	["diamante"] = { index = "diamante", nome = "Min. Diamante", type = "usar", peso = 1 },
	["identidade"] = { index = "identidade", nome = "Identidade", type = "usar", peso = 1 },
	["colete"] = { index = "colete", nome = "Colete Balístico", type = "usar", peso = 1 },
	["kitdemergulho"] = { index = "kitdemergulho", nome = "Kit de Mergulho", type = "usar", peso = 1 },
	["binoculos"] = { index = "binoculos", nome = "Binoculos", type = "usar", peso = 1 },
	["tiocoin"] = { index = "tiocoin", nome = "Tio Coin", type = "usar", peso = 0.1 },
	["folhadecoca"] = { index = "folhadecoca", nome = "folhadecoca", type = "usar", peso = 0.1 },
	["pastadecoca"] = { index = "pastadecoca", nome = "pastadecoca", type = "usar", peso = 0.1 },
	["acidobateria"] = { index = "acidobateria", nome = "Acido de Bateria", type = "usar", peso = 0.1 },
	["anfetamina"] = { index = "anfetamina", nome = "Anfetamina", type = "usar", peso = 0.1 },
	["dinheiroimpresso"] = { index = "dinheiroimpresso", nome = "Dinheiro Impresso", type = "usar", peso = 0.1 },
	["rodacarro"] = { index = "rodacarro", nome = "Roda de Carro", type = "usar", peso = 1 },
	["portacarro"] = { index = "portacarro", nome = "Porta de Carro", type = "usar", peso = 5 },
	["rodamoto"] = { index = "rodamoto", nome = "Roda de Moto", type = "usar", peso = 1 },
	["corda"] = { index = "corda", nome = "Corda", type = "usar", peso = 1 },
	["ouro"] = { index = "ouro", nome = "Min. Ouro", type = "usar", peso = 1 },
	["bronze"] = { index = "bronze", nome = "Min. Bronze", type = "usar", peso = 1 },
	["ferro"] = { index = "ferro", nome = "Min. Ferro", type = "usar", peso = 1 },
	["rubi"] = { index = "rubi", nome = "Min. Rubi", type = "usar", peso = 1 },
	["esmeralda"] = { index = "esmeralda", nome = "Min. Esmeralda", type = "usar", peso = 1 },
	["safira"] = { index = "safira", nome = "Min. Safira", type = "usar", peso = 1 },
	["topazio"] = { index = "topazio", nome = "Min. Topazio", type = "usar", peso = 1 },
	["ametista"] = { index = "ametista", nome = "Min. Ametista", type = "usar", peso = 1 },
	["diamante2"] = { index = "diamante2", nome = "Diamante", type = "usar", peso = 1 },
	["ouro2"] = { index = "ouro2", nome = "Ouro", type = "usar", peso = 1 },
	["bronze2"] = { index = "bronze2", nome = "Bronze", type = "usar", peso = 1 },
	["ferro2"] = { index = "ferro2", nome = "Ferro", type = "usar", peso = 1 },
	["rubi2"] = { index = "rubi2", nome = "Rubi", type = "usar", peso = 1 },
	["esmeralda2"] = { index = "esmeralda2", nome = "Esmeralda", type = "usar", peso = 1 },
	["safira2"] = { index = "safira2", nome = "Safira", type = "usar", peso = 1 },
	["topazio2"] = { index = "topazio2", nome = "Topazio", type = "usar", peso = 1 },
	["ametista2"] = { index = "ametista2", nome = "Ametista", type = "usar", peso = 1 },
	["biscoito"] = { index = "biscoito", nome = "Biscoito", type = "usar", peso = 1 },
	["relogio"] = { index = "relogio", nome = "Relógio", type = "usar", peso = 2 },
	
	["bandagem"] = { index = "bandagem", nome = "Bandagem", type = "usar", peso = 1 },
	["vibrador"] = { index = "vibrador", nome = "Vibrador", type = "usar", peso = 1 },
	["camisinha"] = { index = "camisinha", nome = "Camisinha", type = "usar", peso = 1 },
	["cintaralho"] = { index = "cintaralho", nome = "Cintaralho", type = "usar", peso = 1 },
	["pluganal"] = { index = "pluganal", nome = "Plug Anal", type = "usar", peso = 1 },
	["papel"] = { index = "papel", nome = "Papel", type = "usar", peso = 1 },
	["caneta"] = { index = "caneta", nome = "Caneta", type = "usar", peso = 1 },
	["r-bandagem"] = { index = "r-bandagem", nome = "Receita Bandagem", type = "usar", peso = 1 },
	["dorfrex"] = { index = "dorfrex", nome = "Dorfrex", type = "usar", peso = 1 },
	["r-dorfrex"] = { index = "r-dorfrex", nome = "Receita Dorfrex", type = "usar", peso = 1 },
	["perola"] = { index = "perola", nome = "Perola", type = "usar", peso = 1 },
	["garrafadeleite"] = { index = "garrafadeleite", nome = "Garrafa de Leite", type = "usar", peso = 1 },
	["roupas"] = { index = "roupas", nome = "Roupas", type = "usar", peso = 5 },
	["skate"] = { index = "skate", nome = "Skate", type = "usar", peso = 10  },
	["celular"] = { index = "celular", nome = "Celular", type = "usar", peso = 1 },
	["radio"] = { index = "radio", nome = "Radio", type = "usar", peso = 1 },
	["mochila"] = { index = "mochila", nome = "Mochila", type = "usar", peso = 1 },
	["mascara"] = { index = "mascara", nome = "Mascara", type = "usar", peso = 1 },
	["oculos"] = { index = "oculos", nome = "Óculos", type = "usar", peso = 1 },
	["militec"] = { index = "militec", nome = "Militec", type = "usar", peso = 1 },
	["repairkit"] = { index = "repairkit", nome = "Kit de Reparos", type = "usar", peso = 5 },
	["pecadearma"] = { index = "pecadearma", nome = "Peça De Arma", type = "usar", peso = 0.1 },
	["pecadefuzil"] = { index = "pecadefuzil", nome = "Peça De Fuzil", type = "usar", peso = 0.2 },
	["fio"] = { index = "fio", nome = "Fio", type = "usar", peso = 0.3 },
	["aluminio"] = { index = "aluminio", nome = "Aluminio", type = "usar", peso = 0.3 },
	["cobre"] = { index = "cobre", nome = "Cobre", type = "usar", peso = 0.3 },
	["modificacaodearma"] = { index = "modificacaodearma", nome = "Modificação De Arma", type = "usar", peso = 1 },
	["alianca"] = { index = "alianca", nome = "Aliança", type = "usar", peso = 1 },
	["isca"] = { index = "isca", nome = "Isca", type = "usar", peso = 1 },
	["pacu"] = { index = "pacu", nome = "Pacu", type = "usar", peso = 1 },
	["pirarucu"] = { index = "pirarucu", nome = "Pirarucu", type = "usar", peso = 1 },
	["dourado"] = { index = "dourado", nome = "Dourado", type = "usar", peso = 1 },
	["salmao"] = { index = "salmao", nome = "Salmao", type = "usar", peso = 1 },
	["corvina"] = { index = "corvina", nome = "Corvina", type = "usar", peso = 1 },
	["pintado"] = { index = "pintado", nome = "Pintado", type = "usar", peso = 1 },
	["tilapia"] = { index = "tilapia", nome = "Tilapia", type = "usar", peso = 1 },
	["tucunare"] = { index = "tucunare", nome = "Tucunare", type = "usar", peso = 1 },
	["lambari"] = { index = "lambari", nome = "Lambari", type = "usar", peso = 1 },
	["dinheiro-sujo"] = { index = "dinheiro-sujo", nome = "Dinheiro Sujo", type = "usar", peso = 0 },
	["algema"] = { index = "algema", nome = "Algema", type = "usar", peso = 1 },
	["lockpick"] = { index = "lockpick", nome = "Lockpick", type = "usar", peso = 1 },
	["masterpick"] = { index = "masterpick", nome = "Masterpick", type = "usar", peso = 1 },
	["capuz"] = { index = "capuz", nome = "Capuz", type = "usar", peso = 1 },
	["placa"] = { index = "placa", nome = "Placa", type = "usar", peso = 1 },
	["pendrive"] = { index = "pendrive", nome = "Pendrive", type = "usar", peso = 1 },
	["ticket"] = { index = "ticket", nome = "Ticket", type = "usar", peso = 1 },
	["cerveja"] = { index = "cerveja", nome = "Cerveja", type = "usar", peso = 1 },
	["whisky"] = { index = "whisky", nome = "Whisky", type = "usar", peso = 1 },
	["tequila"] = { index = "tequila", nome = "Tequila", type = "usar", peso = 1 },
	["conhaque"] = { index = "conhaque", nome = "Conhaque", type = "usar", peso = 1 },
	["absinto"] = { index = "absinto", nome = "Absinto", type = "usar", peso = 1 },
	["vodka"] = { index = "vodka", nome = "Vodka", type = "usar", peso = 1 },
	["paracetamil"] = { index = "paracetamil", nome = "Paracetamil", type = "usar", peso = 1 },
	["voltarom"] = { index = "voltarom", nome = "Voltarom", type = "usar", peso = 1 },
	["trandrylux"] = { index = "trandrylux", nome = "Trandrylux", type = "usar", peso = 1 },
	["buscopom"] = { index = "buscopom", nome = "Buscopom", type = "usar", peso = 1 },
	["lancaperfume"] = { index = "lancaperfume", nome = "Lança Perfume", type = "usar", peso = 0.3 },
	["meta-alta"] = { index = "meta-alta", nome = "Meta HQ", type = "usar", peso = 0.3 },
	["metanfetamina"] = { index = "metanfetamina", nome = "Metanfetamina", type = "usar", peso = 0.3 },
	["composito-alta"] = { index = "composito-alta", nome = "Compósito HQ", type = "usar", peso = 0.3 },
	["nitrato-amonia"] = { index = "nitrato-amonia", nome = "Nitrato de Amônia", type = "usar", peso = 0.3 },
	["fungos"] = { index = "fungos", nome = "Fungos", type = "usar", peso = 0.3  },
	["acido-lisergico"] = { index = "acido-lisergico", nome = "Acido Lisergico", type = "usar", peso = 0.3  },
	["lsd"] = { index = "lsd", nome = "LSD", type = "usar", peso = 0.3  },
	["coca-alta"] = { index = "coca-alta", nome = "Cocaína HQ", type = "usar", peso = 0.3 },
	["cocaina"] = { index = "cocaina", nome = "Cocaína", type = "usar", peso = 0.3 },
	["pasta-alta"] = { index = "pasta-alta", nome = "Pasta Base HQ", type = "usar", peso = 0.3 },
	["folhas-coca"] = { index = "folhas-coca", nome = "Folhas de Coca", type = "usar", peso = 0.3 },
	["maconha-alta"] = { index = "maconha-alta", nome = "Maconha HQ", type = "usar", peso = 0.3 },
	["maconha"] = { index = "maconha", nome = "Maconha", type = "usar", peso = 0.3 },
	["adubo"] = { index = "adubo", nome = "Adubo", type = "usar", peso = 0.3 },
	["fertilizante"] = { index = "fertilizante", nome = "Fertilizante", type = "usar", peso = 0.3 },
	["maconha-dichavada"] = { index = "maconha-dichavada", nome = "Maconha Dichavada", type = "usar", peso = 0.3 },
	["canabis-alta"] = { index = "canabis-alta", nome = "Cannabis HQ", type = "usar", peso = 0.3 },
	["molas"] = { index = "molas", nome = "Molas", type = "usar", peso = 0.1 },
	["placa-metal"] = { index = "placa-metal", nome = "Placa de Metal", type = "usar", peso = 1 },
	["gatilho"] = { index = "gatilho", nome = "Gatilho", type = "usar", peso = 0.5 },
	["capsulas"] = { index = "capsulas", nome = "Capsulas", type = "usar", peso = 0.1 },
	["polvora"] = { index = "polvora", nome = "Polvora", type = "usar", peso = 0.1 },
	["graos"] = { index = "graos", nome = "Graos", type = "usar", peso = 0.8 },
	["graosimpuros"] = { index = "graosimpuros", nome = "Graos Impuros", type = "usar", peso = 0.8 },
	["wbody|GADGET_PARACHUTE"] = { index = "paraquedas", nome = "Paraquedas", type = "equipar", peso = 5 },
	["wbody|WEAPON_STICKYBOMB"] = { index = "bombaadesiva", nome = "Bomba Adesiva", type = "equipar", peso = 5 },
	["wbody|WEAPON_GRENADE"] = { index = "granada", nome = "Granada", type = "equipar", peso = 5 },
	["wbody|WEAPON_PETROLCAN"] = { index = "gasolina", nome = "Galão de Gasolina", type = "equipar", peso = 5 },
	["wbody|WEAPON_FLARE"] = { index = "sinalizador", nome = "Sinalizador", type = "equipar", peso = 5 },
	["wbody|WEAPON_FIREEXTINGUISHER"] = { index = "extintor", nome = "Extintor", type = "equipar", peso = 5 },
	["wbody|WEAPON_KNIFE"] = { index = "faca", nome = "Faca", type = "equipar", peso = 5 },
	["wbody|WEAPON_DAGGER"] = { index = "adaga", nome = "Adaga", type = "equipar", peso = 5 },
	["wbody|WEAPON_KNUCKLE"] = { index = "ingles", nome = "Soco-Inglês", type = "equipar", peso = 5 },
	["wbody|WEAPON_MACHETE"] = { index = "machete", nome = "Machete", type = "equipar", peso = 5 },
	["wbody|WEAPON_SWITCHBLADE"] = { index = "canivete", nome = "Canivete", type = "equipar", peso = 5 },
	["wbody|WEAPON_WRENCH"] = { index = "grifo", nome = "Chave de Grifo", type = "equipar", peso = 5 },
	["wbody|WEAPON_HAMMER"] = { index = "martelo", nome = "Martelo", type = "equipar", peso = 5 },
	["wbody|WEAPON_GOLFCLUB"] = { index = "golf", nome = "Taco de Golf", type = "equipar", peso = 5 },
	["wbody|WEAPON_CROWBAR"] = { index = "cabra", nome = "Pé de Cabra", type = "equipar", peso = 5 },
	["wbody|WEAPON_HATCHET"] = { index = "machado", nome = "Machado", type = "equipar", peso = 5 },
	["wbody|WEAPON_FLASHLIGHT"] = { index = "lanterna", nome = "Lanterna", type = "equipar", peso = 5 },
	["wbody|WEAPON_BAT"] = { index = "beisebol", nome = "Taco de Beisebol", type = "equipar", peso = 5 },
	["wbody|WEAPON_BOTTLE"] = { index = "garrafa", nome = "Garrafa", type = "equipar", peso = 5 },
	["wbody|WEAPON_BATTLEAXE"] = { index = "batalha", nome = "Machado de Batalha", type = "equipar", peso = 5 },
	["wbody|WEAPON_POOLCUE"] = { index = "sinuca", nome = "Taco de Sinuca", type = "equipar", peso = 5 },
	["wbody|WEAPON_STONE_HATCHET"] = { index = "pedra", nome = "Machado de Pedra", type = "equipar", peso = 5 },
	["wbody|WEAPON_NIGHTSTICK"] = { index = "cassetete", nome = "Cassetete", type = "equipar", peso = 5 },
	["wbody|WEAPON_APPISTOL"] = { index = "appistol", nome = "AP Pistol", type = "equipar", peso = 5 },
	["wbody|WEAPON_COMBATPISTOL"] = { index = "glock", nome = "Glock 19", type = "equipar", peso = 5 },
	["wbody|WEAPON_PISTOL_MK2"] = { index = "fiveseven", nome = "Five Seven", type = "equipar", peso = 5 },
	["wbody|WEAPON_PISTOL"] = { index = "m19", nome = "M19", type = "equipar", peso = 5 },
	["wbody|WEAPON_SNSPISTOL"] = { index = "pistolhk", nome = "Pistol HK", type = "equipar", peso = 5 },
	["wbody|WEAPON_STUNGUN"] = { index = "taser", nome = "Taser", type = "equipar", peso = 5 },
	["wbody|WEAPON_RAYPISTOL"] = { index = "raypistol", nome = "Ray Pistol", type = "equipar", peso = 5 },
	["wbody|WEAPON_HEAVYSNIPER"] = { index = "sniper2", nome = "Sniper2", type = "equipar", peso = 5  },
	["wbody|WEAPON_HEAVYSNIPER_MK2"] = { index = "snipermk2", nome = "SniperMK2", type = "equipar", peso = 5  },
	["wbody|WEAPON_ASSAULTRIFLE"] = { index = "ak47", nome = "AK-47", type = "equipar", peso = 5 },
	["wbody|WEAPON_MICROSMG"] = { index = "usi", nome = "USI", type = "equipar", peso = 5 },
	["wbody|WEAPON_SMG"] = { index = "mp5", nome = "MP5", type = "equipar", peso = 5 },
	["wbody|WEAPON_MACHINEPISTOL"] = { index = "tec9", nome = "Tec-9", type = "equipar", peso = 5 },
	["wbody|WEAPON_PUMPSHOTGUN_MK2"] = { index = "remington", nome = "Remington 870", type = "equipar", peso = 5 },
	["wbody|WEAPON_MUSKET"] = { index = "winchester22", nome = "Winchester 22", type = "equipar", peso = 5 },
	["wbody|WEAPON_REVOLVER"] = { index = "magnun", nome = "Magnun", type = "equipar", peso = 5 },
	["wbody|WEAPON_REVOLVER_MK2"] = { index = "magnunmk2", nome = "Magnun MK2", type = "equipar", peso = 5 },
	["wbody|WEAPON_ASSAULTSMG"] = { index = "mtar21", nome = "MTar-21", type = "equipar", peso = 5 },
	["wbody|WEAPON_GUSENBERG"] = { index = "tompsom", nome = "Tompsom", type = "equipar", peso = 5 },
	["wbody|WEAPON_ASSAULTRIFLE_MK2"] = { index = "akmk2", nome = "AK-47 MK2", type = "equipar", peso = 5 },
	["wbody|WEAPON_SPECIALCARBINE"] = { index = "m4spec", nome = "M4 SPEC", type = "equipar", peso = 5 },
	["wbody|WEAPON_SPECIALCARBINE_MK2"] = { index = "m4specmk2", nome = "M4 SPEC MK2", type = "equipar", peso = 5 },
	["wbody|WEAPON_CARBINERIFLE"] = { index = "m4a4", nome = "M4A4", type = "equipar", peso = 5 },
	["wbody|WEAPON_CARBINERIFLE_MK2"] = { index = "m4a4mk2", nome = "M4A4-Mk2", type = "equipar", peso = 5 },
	["wbody|WEAPON_SNIPERRIFLE"] = { index = "sniper", nome = "Sniper", type = "equipar", peso = 5 },
	["wbody|WEAPON_RPG"] = { index = "rpg", nome = "RPG", type = "equipar", peso = 5 },
	["wbody|WEAPON_MINIGUN"] = { index = "minigun", nome = "Minigun", type = "equipar", peso = 5 },
	["wbody|WEAPON_FIREWORK"] = { index = "firework", nome = "FireWork", type = "equipar", peso = 5 },
	["wbody|WEAPON_SNOWBALL"] = { index = "snowball", nome = "Snowball", type = "equipar", peso = 5 },
	["wbody|WEAPON_COMBATPDW"] = { index = "sigsauer", nome = "Sig Sauer", type = "equipar", peso = 5 },
	["wammo|WEAPON_SNOWBALL"] = { index = "m-snowball", nome = "M.Snowball", type = "equipar", peso = 0.1 },
	["wammo|WEAPON_FLARE"] = { index = "m-sinalizador", nome = "M.Sinalizador", type = "recarregar", peso = 0.1 },
	["wammo|WEAPON_COMBATPDW"] = { index = "m-sigsauer", nome = "M.Sig Sauer", type = "recarregar", peso = 0.1 },
	["wammo|WEAPON_FIREEXTINGUISHER"] = { index = "m-extintor", nome = "M.Extintor", type = "recarregar", peso = 0.1 },
	["wammo|WEAPON_COMBATPISTOL"] = { index = "m-glock", nome = "M.Glock 19", type = "recarregar", peso = 0.1 },
	["wammo|WEAPON_PISTOL_MK2"] = { index = "m-fiveseven", nome = "M.Five Seven", type = "recarregar", peso = 0.1 },
	["wammo|WEAPON_PISTOL"] = { index = "m-m19", nome = "M. M19", type = "recarregar", peso = 0.1 },
	["wammo|WEAPON_SNSPISTOL"] = { index = "m-pistolhk", nome = "M.Pistol HK", type = "recarregar", peso = 0.1 },
	["wammo|WEAPON_ASSAULTRIFLE"] = { index = "m-ak47", nome = "M.AK47", type = "recarregar", peso = 0.1 },
	["wammo|WEAPON_CARBINERIFLE"] = { index = "m-m4a4", nome = "M.M4A4", type = "recarregar", peso = 0.1 },
	["wammo|WEAPON_CARBINERIFLE_MK2"] = { index = "m-m4a4mk2", nome = "M.M4A4 Mk2", type = "recarregar", peso = 0.1 },
	["wammo|WEAPON_SPECIALCARBINE"] = { index = "m-m4spec", nome = "M.M4 Spec", type = "recarregar", peso = 0.1 },
	["wammo|WEAPON_SPECIALCARBINE_MK2"] = { index = "m-m4spec-mk2", nome = "M.M4 Spec MK2", type = "recarregar", peso = 0.1 },
	["wammo|WEAPON_STUNGUN"] = { index = "m-taser", nome = "M.Taser", type = "recarregar", peso = 0.1 },
	["wammo|WEAPON_SMG"] = { index = "m-mp5", nome = "M.MP5", type = "recarregar", peso = 0.1 },
	["wammo|WEAPON_MICROSMG"] = { index = "m-uzi", nome = "M.UZI", type = "recarregar", peso = 0.1 },
	["wammo|WEAPON_MACHINEPISTOL"] = { index = "m-tec9", nome = "M.TEC-9", type = "recarregar", peso = 0.1 },
	["wammo|WEAPON_PUMPSHOTGUN_MK2"] = { index = "m-remington", nome = "M.Remington 870", type = "recarregar", peso = 0.1 },
	["wammo|WEAPON_MUSKET"] = { index = "m-winchester22", nome = "M.Winchester 22", type = "recarregar", peso = 0.1 },
	["wammo|WEAPON_REVOLVER"] = { index = "m-magnun", nome = "M.Magnun", type = "recarregar", peso = 0.1 },
	["wammo|WEAPON_REVOLVER_MK2"] = { index = "m-magnunmk2", nome = "M.MagnunMK2", type = "recarregar", peso = 0.1 },
	["wammo|WEAPON_ASSAULTSMG"] = { index = "m-mtar21", nome = "M.MTar-21", type = "recarregar", peso = 0.1 },
	["wammo|WEAPON_GUSENBERG"] = { index = "m-tompsom", nome = "M.Tompsom", type = "recarregar", peso = 0.1 },
	["wammo|WEAPON_ASSAULTRIFLE_MK2"] = { index = "m-akmk2", nome = "M.AK-47 MK2", type = "recarregar", peso = 0.1 },
	["wammo|WEAPON_SNIPERRIFLE"] = { index = "m-sniper", nome = "M.SNIPER", type = "recarregar", peso = 0.1 },
	["wammo|WEAPON_RPG"] = { index = "m-rpg", nome = "M.RPG", type = "recarregar", peso = 0.1 },
	["wammo|WEAPON_FIREWORK"] = { index = "m-firework", nome = "M.FireWork", type = "recarregar", peso = 0.1 },
	["wammo|WEAPON_PETROLCAN"] = { index = "combustivel", nome = "Combustível", type = "recarregar", peso = 0.1 },
	["wammo|WEAPON_STICKYBOMB"] = { index = "m-bombaadesiva", nome = "M.Bomba Adesiva", type = "equipar", peso = 0.1 },
}

return config