cfg = {
	target = false,
    darCoins = false, --sistema de dar coins true/false
	coins = 1, --valor coins ganhado a cada 30 min
    webhookbanco = ""
}

local randsalario = math.random(-3400,3400)
local randsalario2 = math.random(-2600,2600)
local randsalario3 = math.random(-1400,1400)

cfg.salario = {
    { ['group'] = "Residente", ['nome'] = "Residente", ['servico'] = false, ['salario'] =  250 },
	{ ['group'] = "Empresario", ['nome'] = "Empresario", ['servico'] = false, ['salario'] =  randsalario },
    { ['group'] = "Macroempreendedor", ['nome'] = "Macroempreendedor", ['servico'] = false, ['salario'] =  randsalario2 },
    { ['group'] = "Microempreendedor", ['nome'] = "Microempreendedor", ['servico'] = false, ['salario'] =  randsalario3 },
    { ['group'] = "Policia", ['nome'] = "Policia", ['servico'] = true, ['salario'] =  2400 },
    { ['group'] = "PoliciaAcao", ['nome'] = "Policia", ['servico'] = true, ['salario'] =  2400 },
    { ['group'] = "FBI", ['nome'] = "FBI", ['servico'] = true, ['salario'] =  2400  },
    { ['group'] = "Prefeito", ['nome'] = "Prefeito", ['servico'] = true, ['salario'] =  8000 },
    { ['group'] = "Prefeitura", ['nome'] = "Prefeitura", ['servico'] = true, ['salario'] =  3000 },
    { ['group'] = "Seguranca", ['nome'] = "Segurança", ['servico'] = true, ['salario'] =  3000 },
    { ['group'] = "Hospital", ['nome'] = "Paramedico", ['servico'] = true, ['salario'] =  2000 },
    { ['group'] = "Juiz", ['nome'] = "Juiz", ['servico'] = true, ['salario'] =  6000 },
    { ['group'] = "Promotor", ['nome'] = "Promotor", ['servico'] = true, ['salario'] =  3000 },
    { ['group'] = "Advogado", ['nome'] = "Advogado", ['servico'] = true, ['salario'] =  600 },
    { ['group'] = "Mecanico", ['nome'] = "Mecanico", ['servico'] = true, ['salario'] =  1000 },
    { ['group'] = "Jornalista", ['nome'] = "Jornalista", ['servico'] = true, ['salario'] =  2000 },
    { ['group'] = "Prata", ['nome'] = "VIP Prata", ['servico'] = false, ['salario'] =  1000 },
	{ ['group'] = "Ouro", ['nome'] = "VIP Ouro", ['servico'] = false, ['salario'] =  1500 },
    { ['group'] = "Platina", ['nome'] = "VIP Platina", ['servico'] = false, ['salario'] =  3000 },
    { ['group'] = "Diamante", ['nome'] = "VIP Diamante", ['servico'] = false, ['salario'] =  5000 },
	{ ['group'] = "Cartel", ['nome'] = "Cartel", ['servico'] = false, ['salario'] =  5000 },
	{ ['group'] = "AthenasAirlines", ['nome'] = "Athenas Airlines", ['servico'] = false, ['salario'] =  3500 },
	{ ['group'] = "AthenasFood", ['nome'] = "Athenas Food", ['servico'] = false, ['salario'] =  4000 },
}

cfg.soldo = {
	--Jornal------------------------------------------
    { ['perm'] = "jornalistachefe", ['nome'] = "Jornalista-Chefe", ['salario'] =  2700 },
	{ ['perm'] = "diretorexecutivo", ['nome'] = "Diretor-Executivo", ['salario'] =  5000 },
	{ ['perm'] = "diretorjornal", ['nome'] = "Diretor-Jornal", ['salario'] =  4000 },
	{ ['perm'] = "editorchefe", ['nome'] = "Editor-Chefe", ['salario'] =  3000 },
	{ ['perm'] = "editor", ['nome'] = "Editor", ['salario'] =  2000 },
	{ ['perm'] = "reporter", ['nome'] = "Reporter", ['salario'] =  1000 },
	{ ['perm'] = "chefereportagem", ['nome'] = "Chefe-Reportagem", ['salario'] =  2500 },

    { ['perm'] = "wl", ['nome'] = "Moderador", ['salario'] = 1600 },
	--Policia----------------------------------------------------
    { ['perm'] = "soldado", ['nome'] = "Soldado", ['salario'] = 400 },
    { ['perm'] = "cabo", ['nome'] = "Cabo", ['salario'] = 600 },
    { ['perm'] = "sgt3", ['nome'] = "3sgt", ['salario'] = 800 },
    { ['perm'] = "sgt2", ['nome'] = "2sgt", ['salario'] = 1000 },
    { ['perm'] = "sgt1", ['nome'] = "1sgt", ['salario'] = 1300 },
    { ['perm'] = "subtenente", ['nome'] = "Sub-Tenente", ['salario'] = 1500 },
    { ['perm'] = "tenente", ['nome'] = "Tenente", ['salario'] = 2600 },
    { ['perm'] = "capitao", ['nome'] = "Capitao", ['salario'] = 3000 },
    { ['perm'] = "comandante", ['nome'] = "Comandante", ['salario'] = 6000 },
	{ ['perm'] = "carcereiro", ['nome'] = "Carcereiro", ['salario'] =  1000 },
	{ ['perm'] = "major", ['nome'] = "Major", ['salario'] =  3500 },
	{ ['perm'] = "tencoronel", ['nome'] = "Tenente-Coronel", ['salario'] =  4000 },
	{ ['perm'] = "coronel", ['nome'] = "Coronel", ['salario'] =  4500 },
	{ ['perm'] = "comissario", ['nome'] = "Comissario", ['salario'] =  5000 },
	--Mecanica----------------------------------------------------------
    { ['perm'] = "chefemecanico", ['nome'] = "Chefe Mecanico", ['salario'] =  1000 },
	--Aleatorios--------------------------------------------------------------
    { ['perm'] = "celebridade", ['nome'] = "Celebridade", ['salario'] = 5000 },
    { ['perm'] = "subcelebridade", ['nome'] = "Subcelebridade", ['salario'] = 3000 },
    { ['perm'] = "influencer", ['nome'] = "Influencer", ['salario'] = 1500 },
    --HOSPITAL------------------------------------------------------------------------------------------
    { ['perm'] = "diretorhp", ['nome'] = "Diretor", ['salario'] = 13000 },
    { ['perm'] = "vicediretorhp", ['nome'] = "Vice-Diretor", ['salario'] = 8000 },
    { ['perm'] = "paramedico", ['nome'] = "Paramedico", ['salario'] = 500 },
	{ ['perm'] = "enfermeiro", ['nome'] = "Enfermeiro", ['salario'] = 2500 },
	{ ['perm'] = "medicochefe", ['nome'] = "Medico-Chefe", ['salario'] = 6000 },
	{ ['perm'] = "medico", ['nome'] = "Medico", ['salario'] = 4000 },
    { ['perm'] = "pediatra", ['nome'] = "Pediátra", ['salario'] = 500 },
    { ['perm'] = "gine", ['nome'] = "Ginecologista", ['salario'] = 500 },
    { ['perm'] = "psico", ['nome'] = "Psicologo", ['salario'] = 500 },
    { ['perm'] = "orto", ['nome'] = "Ortopedista", ['salario'] = 500 },
    { ['perm'] = "psiquiatra", ['nome'] = "Psiquiatra", ['salario'] = 500 },
    { ['perm'] = "neuro", ['nome'] = "Neurologista", ['salario'] = 500 },
    { ['perm'] = "gastro", ['nome'] = "Gastroenterologista", ['salario'] = 500 },
    { ['perm'] = "nutricionista", ['nome'] = "Nutricionista", ['salario'] = 500 },
    { ['perm'] = "cirurgiao", ['nome'] = "Cirurgiao Plastico", ['salario'] = 500 },
    { ['perm'] = "fisio", ['nome'] = "Fisioterapia", ['salario'] = 500 },
}

cfg.propsATM = {
	'prop_atm_01',
	'prop_atm_02',
	'prop_atm_03',
	'prop_fleeca_atm',
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCALIDADES
-----------------------------------------------------------------------------------------------------------------------------------------
cfg.localidades = {
	{ ['x'] = -1212.63, ['y'] = -330.80, ['z'] = 37.78, ['nui'] = "banco" },
	{ ['x'] = 149.85, ['y'] = -1040.71, ['z'] = 29.37, ['nui'] = "banco" },
	{ ['x'] = -2962.56, ['y'] = 482.95, ['z'] = 15.70, ['nui'] = "banco" },
	{ ['x'] = -111.97, ['y'] = 6469.19, ['z'] = 31.62, ['nui'] = "banco" },
	{ ['x'] = 1175.05, ['y'] = 2706.90, ['z'] = 38.09, ['nui'] = "banco" },
	{ ['x'] = -351.02, ['y'] = -49.97, ['z'] = 49.04, ['nui'] = "banco"},
	{ ['x'] = 314.13, ['y'] = -279.09, ['z'] = 54.17, ['nui'] = "banco" },
	{ ['x'] = 2536.02, ['y'] = -349.27, ['z'] = 93.15, ['nui'] = "banco"},
	{ ['x'] = 145.96, ['y'] = -1035.17, ['z'] = 29.35, ['nui'] = "atm"},
	{ ['x'] = 147.54, ['y'] = -1035.76, ['z'] = 29.35, ['nui'] = "atm"},
}
