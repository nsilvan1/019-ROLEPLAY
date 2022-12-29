local cfg = {}

cfg.groups = {
	["CEO"] = {
		_config = {
			title = "C.E.O"
		},
		"ceo.permissao",
		"admin.permissao",
		"mod.permissao",
		"suporte.permissao",
		"ac.permissao",
		"player.blips",
		"player.spec",
		"player.noclip",
		"player.secret",
		"player.teleport",
		"player.wall",
		"mqcu.permissao",
		"player.som",
		"dv.permissao",
		"instagram.permissao",
	}, 
	["PaisanaCeo"] = {
		_config = {
			title = "PaisanaCeo",
			gtype = "ceo"
		},
		"paisanaoceo.permissao",
		"paisanapoderes.permissao"
	},
	["Admin"] = {
		_config = {
			title = "Administrador(a)"
		},
		"admin.permissao",
		"mod.permissao",
		"suporte.permissao",
		"player.blips",
		"player.spec",
		"player.noclip",
		"player.secret",
		"player.wall",
		"player.teleport",
		"mqcu.permissao",
		"ac.permissao",
		"player.som",
		"dv.permissao",
		"instagram.permissao",
	},
	["Mod"] = {
		_config = {
			title = "Moderador(a)"
		},
		"mod.permissao",
		"suporte.permissao",
		"player.blips",
		"player.spec",
		"player.noclip",
		"player.secret",
		"player.wall",
		"player.teleport",
		"mqcu.permissao",
		"ac.permissao",
		"player.som",
		"dv.permissao",
		"instagram.permissao",
	},
	["Suporte"] = {
		_config = {
			title = "Suporte"
		},
		"suporte.permissao",
		"player.teleport",
		"player.noclip",
		"mqcu.permissao",
		"ac.permissao",
		"player.som",
	},

	["paintball"] = {
		_config = {
			title = "paintball",
		},
		"mqcu.permissao",
		"paintball.permissao",
		"player.blips",
		"player.spec",
		"player.noclip",
		"player.secret",
		"player.teleport",
	},
-----------------------------------------------------------------------------
--[	Setagens Vips ]----------------------------------------------------------
-----------------------------------------------------------------------------
	["VipBronze"] = {
		_config = {
			title = "Bronze",
			gtype = "vip"
		},
		"bronze.permissao",
		"mochila.permissao"
	},	
	["VipPrata"] = {
		_config = {
			title = "Prata",
			gtype = "vip"
		},
		"prata.permissao",
		"mochila.permissao"
	},	
	["VipOuro"] = {
		_config = {
			title = "Ouro",
			gtype = "vip34"
		},
		"ouro.permissao",
		"mochila.permissao"
	},

	["VipDiamante"] = {
		_config = {
			title = "Diamante",
			gtype = "vip44"
		},
		"player.som",
		"naopagaipva.permissao",
		"diamante4.permissao",
		"mochila.permissao"
	},

	["VipEsmeranda"] = {
		_config = {
			title = "Esmeralda",
			gtype = "vip"
		},
		"player.som",
		"naopagaipva.permissao",
		"esmeralda.permissao",
		"mochila.permissao"
	},
	
	["VipAztlan"] = {
		_config = {
			title = "Aztlan",
			gtype = "vipz"
		},
		"player.som",
		"naopagaipva.permissao",
		"aztlan.permissao",
		"instagram.permissao",
		"mochila.permissao"
	},
	["VipAztlan2"] = {
		_config = {
			title = "Aztlan2",
			gtype = "vip62"
		},
		"player.som",
		"naopagaipva.permissao",
		"instagram.permissao",
		"aztlan2.permissao",
		"mochila.permissao"
	},
	["booster"] = {
		_config = {
			title = "Booster",
		},
		"booster.permissao"
	},

	["som"] = {
		_config = {
			title = "Som",
		},
		"player.som",
	},
	["instagram"] = {
		_config = {
			title = "Instagram",
		},
		"instagram.permissao",
	},
	["estagiario"] = {
		_config = {
			title = "estagiario",
		},
		"estagiario.permissao",
	},
	["funcionario"] = {
		_config = {
			title = "funcionario",
		},
		"funcionario.permissao",
	},
	["gerente"] = {
		_config = {
			title = "gerente",
		},
		"gerente.permissao",
	},
	["patrao"] = {
		_config = {
			title = "patrao",
		},
		"patrao.permissao",
	},
-----------------------------------------------------------------------------
--[	Departamento Médico ]----------------------------------------------------
-----------------------------------------------------------------------------
	["diretor"] = {
		_config = {
			title = "Hospital Diretor",
			gtype = "job"
		},
		"diretor.permissao",
		"polpar.permissao",
		"player.blips",
		"paramedico.permissao",
	}, 
	["paisana-diretor"] = {
		_config = {
			title = "Paisana Diretor",
			gtype = "job"
		},
		"paisana-diretor.permissao",
		"polpar.permissao",
		"player.blips",
	}, 
	["especialista"] = {
		_config = {
			title = "Especialista",
			gtype = "job"
		},
		"especialista.permissao",
		"paramedico.permissao",
		"polpar.permissao",
		"player.blips",
	}, 
	["paisana-especialista"] = {
		_config = {
			title = "Paisana Especialista",
			gtype = "job"
		},
		"paisana-especialista.permissao",
		"polpar.permissao",
		"player.blips",
	}, 
	["psicologo"] = {
		_config = {
			title = "Psicologo",
			gtype = "job"
		},
		"psicologo.permissao",
		"paramedico.permissao",
		"polpar.permissao",
		"player.blips",
	}, 
	["paisana-psicologo"] = {
		_config = {
			title = "Paisana Psicologo",
			gtype = "job"
		},
		"paisana-psicologo.permissao",
		"polpar.permissao",
		"player.blips",
	}, 
	["medico"] = {
		_config = {
			title = "Medico",
			gtype = "job"
		},
		"medico.permissao",
		"paramedico.permissao",
		"polpar.permissao",
		"player.blips",
	}, 
	["paisana-medico"] = {
		_config = {
			title = "Paisana Medico",
			gtype = "job"
		},
		"paisana-medico.permissao",
		"polpar.permissao",
		"player.blips",
	}, 

	["enfermeiro"] = {
		_config = {
			title = "Enfermeiro",
			gtype = "job"
		},
		"enfermeiro.permissao",
		"paramedico.permissao",
		"polpar.permissao",
		"player.blips",
	},
	["paisana-enfermeiro"] = {
		_config = {
			title = "Paisana Enfermeiro",
			gtype = "job"
		},
		"paisana-enfermeiro.permissao",
		"polpar.permissao",
		"player.blips",
	}, 
	["paramedico"] = {
		_config = {
			title = "Paramedico",
			gtype = "job"
		},
		"paramedico.permissao",
		"polpar.permissao",
		"para.permissao",
		"player.blips",
	}, 
	["paisana-paramedico"] = {
		_config = {
			title = "Paramedico de Folga",
			gtype = "job"
		},
		"paisana-paramedico.permissao",
		"polpar.permissao",
		"player.blips",
	},
-----------------------------------------------------------------------------
--[	POLICIA ]----------------------------------------------------------------
-----------------------------------------------------------------------------
	["policia"] = {
		_config = {
			title = "Policial",
			gtype = "job"
		},
		"policia.permissao",
		"policial.permissao",
		"patrulha.permissao",
		"player.blips",
	},
	["paisana-policia"] = {
		_config = {
			title = "Policial de folga",
			gtype = "job"
		},
		"paisana-policia.permissao",
	},
	["acao-policia"] = {
		_config = {
			title = "Policial em Ação",
			gtype = "job"
		},
		"policial-em-acao.permissao",
		"acao-policia.permissao",
		"mochila.permissao",
	},
	["medico-policia"] = {
		_config = {
			title = "Medico Policial",
			gtype = "job"
		},
		"policia.permissao",
		"medico-policia.permissao",
		"patrulha.permissao",
		"player.blips",
	},
	["medico-paisana-policia"] = {
		_config = {
			title = "Policial Médico de folga",
			gtype = "job"
		},
		"medico-paisana-policia.permissao",
	},
	["medico-acao-policia"] = {
		_config = {
			title = "Policial Médico em Ação",
			gtype = "job"
		},
		"policial-em-acao.permissao",
		"medico-acao-policia.permissao",
		"mochila.permissao",
	},
	["comando-policia"] = {
		_config = {
			title = "Comandante",
			gtype = "job"
		},
		"policia.permissao",
		"comando-policia.permissao",
		"patrulha.permissao",
		"player.blips",
	},
	["comando-paisana-policia"] = {
		_config = {
			title = "Comandante de folga",
			gtype = "job"
		},
		"comando-paisana-policia.permissao",
	},
	["comando-acao-policia"] = {
		_config = {
			title = "Comandante em Ação",
			gtype = "job"
		},
		"policial-em-acao.permissao",
		"comando-acao-policia.permissao",
		"mochila.permissao",
	},
-----------------------------------------------------------------------------
--[TRABALHOS]----------------------------------------------------------------
-----------------------------------------------------------------------------
	["mecanico"] = {
		_config = {
			title = "Mecânico",
			gtype = "job"
		},
		"mecanico.permissao",
		"desmanche.permissao",
		"bennys.permissao",
	},
	["paisana-mecanico"] = {
		_config = {
			title = "Mecânico de folga",
			gtype = "job"
		},
		"paisana-mecanico.permissao",
	},
	["lider-mecanico"] = {
		_config = {
			title = "Lider Mecânica",
			gtype = "job"
		},
		"mecanico.permissao",
		"desmanche.permissao",
		"bennys.permissao",
	},
	["advogado"] = {
		_config = {
			title = "Advogado",
			gtype = "job",
		},
		"advogado.permissao",
	},
	["desembargador"] = {
		_config = {
			title = "Desembargador",
			gtype = "job",
		},
		"desembargador.permissao",
		"advogado.permissao",
	},
	["promotor"] = {
		_config = {
			title = "Promotor de Justiça",
			gtype = "job",
		},
		"promotor.permissao",
		"advogado.permissao",
	},
	["juiz"] = {
		_config = {
			title = "Juiz",
			gtype = "job",
		},
		"juiz.permissao",
		"advogado.permissao",
	},
	-----------------------------------------------------------------------------
	--[	Organização e Facções ]--------------------------------------------------
	-----------------------------------------------------------------------------

	["lider-Vanilla"] = {
		_config = {
			title = "Lider Vanilla",
			gtype = "job"
		},
		"vanilla.permissao",
		"ilegal.permissao",
		"lavagem.permissao",
	},

	["Vanilla"] = {
		_config = {
			title = "Vanilla",
			gtype = "job"
		},
		"vanilla.permissao",
		"ilegal.permissao",
		"lavagem.permissao",
	},

	["lider-Tequilala"] = {
		_config = {
			title = "Lider Tequilala",
			gtype = "job"
		},
		"lider-tequilala.permissao",
		"tequilala.permissao",
		"ilegal.permissao",
		"lavagem.permissao",
	},

	["Tequilala"] = {
		_config = {
			title = "Tequilala",
			gtype = "job"
		},
		"tequilala.permissao",
		"ilegal.permissao",
		"lavagem.permissao",
	},
		
	["lider-Bahamas"] = {
		_config = {
			title = "Lider Bahamas",
			gtype = "job"
		},
		"lider-bahamas.permissao",
		"bahamas.permissao",
		"ilegal.permissao",
		"lavagem.permissao",
	},

	["Bahamas"] = {
		_config = {
			title = "Bahamas",
			gtype = "job"
		},
		"bahamas.permissao",
		"ilegal.permissao",
		"lavagem.permissao",
	},

-- DROGAS
---------------
-- MACONHA

["lider-Groove"] = {
	_config = {
		title = "Lider Groove",
		gtype = "job",
	},
	"lider-groove.permissao",
	"groove.permissao",
	"ilegal.permissao",
	"drogas.permissao",
},
	["Groove"] = {
		_config = {
			title = "Groove",
			gtype = "job",
		},
		"groove.permissao",
		"ilegal.permissao",
		"drogas.permissao",
		"maconha.permissao",
	},

-- META

["lider-Vagos"] = {
	_config = {
		title = "Lider Vagos",
		gtype = "job",
	},
	"lider-vagos.permissao",
	"vagos.permissao",
	"ilegal.permissao",
	"drogas.permissao",
},
	["Vagos"] = {
		_config = {
			title = "Vagos",
			gtype = "job",
		},
		"vagos.permissao",
		"ilegal.permissao",
		"drogas.permissao",
		"metanfetamina.permissao",
	},

-- COCAINA

	["lider-Bloods"] = {
		_config = {
			title = "Lider Bloods",
			gtype = "job",
		},
		"lider-bloods.permissao",
		"bloods.permissao",
		"ilegal.permissao",
		"drogas.permissao",
	},
	["Bloods"] = {
		_config = {
			title = "Bloods",
			gtype = "job",
		},
		"bloods.permissao",
		"ilegal.permissao",
		"drogas.permissao",
		"cocaina.permissao",
	},

-- LSD

["lider-Ballas"] = {
	_config = {
		title = "Lider Ballas",
		gtype = "job",
	},
	"lider-ballas.permissao",
	"bloods.permissao",
	"ilegal.permissao",
	"drogas.permissao",
},
	["ballas"] = {
		_config = {
			title = "Ballas",
			gtype = "job",
		},
		"ballas.permissao",
		"ilegal.permissao",
		"drogas.permissao",
		"lsd.permissao",
	},

-- DESMANCHE LOCKPICK
---------------
["lider-Motoclub"] = {
	_config = {
		title = "Lider Motoclub",
		gtype = "job",
	},
	"lider-motoclub.permissao",
	"motoclub.permissao",
	"ilegal.permissao",
	"desmanche.permissao",
},

["Motoclub"] = {
	_config = {
		title = "Motoclub",
		gtype = "job",
	},
	"motoclub.permissao",
	"ilegal.permissao",
	"desmanche.permissao",
},


	
["lider-Hells"] = {
	_config = {
		title = "Lider Hells",
		gtype = "job"
	},
	"lider-hells.permissao",
	"hells.permissao",
	"ilegal.permissao",
	"desmanche.permissao",
},	

["Hells"] = {
	_config = {
		title = "Hells",
		gtype = "job"
	},
	"hells.permissao",
	"ilegal.permissao",
	"desmanche.permissao",
},
-- ARMA
---------------

	["lider-Bratva"] = {
		_config = {
			title = "Lider Bratva",
			gtype = "job",
		},
		"lider-bratva.permissao",
		"bratva.permissao",
		"ilegal.permissao",
		"armas.permissao",
	},
	
	["Bratva"] = {
		_config = {
			title = "Bratva",
			gtype = "job",
		},
		"bratva.permissao",
		"ilegal.permissao",
		"armas.permissao",
	},

	["lider-Crips"] = {
		_config = {
			title = "Lider Crips",
			gtype = "job",
		},
		"lider-crips.permissao",
		"crips.permissao",
		"ilegal.permissao",
		"armas.permissao",
	},

	["Crips"] = {
		_config = {
			title = "Crips",
			gtype = "job"
		},
		"crips.permissao",
		"ilegal.permissao",
		"armas.permissao",
	},
-- MUNICAO
	["lider-Mafia"] = {
		_config = {
			title = "Lider Mafia",
			gtype = "job",
		},
		"lider-mafia.permissao",
		"mafia.permissao",
		"ilegal.permissao",
		"municao.permissao",
	},
	["Mafia"] = {
		_config = {
			title = "Mafia",
			gtype = "job"
		},
		"mafia.permissao",
		"ilegal.permissao",
		"municao.permissao",
	},

	["lider-Triade"] = {
		_config = {
			title = "Lider Triade",
			gtype = "job",
		},
		"lider-triade.permissao",
		"triade.permissao",
		"municao.permissao",
		"ilegal.permissao",
	},

	["Triade"] = {
		_config = {
			title = "Triade",
			gtype = "job",
		},
		"triade.permissao",
		"municao.permissao",
		"ilegal.permissao",
	},

	-----------------------------------------------------------------------------
	---[	grupo de casas mods ]------------------------------------------------
	-----------------------------------------------------------------------------
	["mansaomalibu"] = {
		_config = {
			title = "Casa Malibu"
		},
		"mansaomalibu.permissao",
	},
	["mansaogold"] = {
		_config = {
			title = "Casa Gold"
		},
		"mansaogold.permissao",
	},
	["cobertura"] = {
		_config = {
			title = "Cobertura"
		},
		"cobertura.permissao",
	},
	["cobertura2"] = {
		_config = {
			title = "Cobertura 2"
		},
		"cobertura2.permissao",
	},
	["mansaoextra01"] = {
		_config = {
			title = "Mansao Extra 01"
		},
		"mansaoextra01.permissao",
	},
	["mansaoextra02"] = {
		_config = {
			title = "Mansao Extra 02"
		},
		"mansaoextra02.permissao",
	},
}

cfg.users = {
	[13] = { "CEO" },
	[12] = { "CEO" },
}

cfg.selectors = {}

return cfg