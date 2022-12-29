config = {}
-- aqui coloca os pontos de procura
config.iniciar = {	[1] = { ['x'] = 1651.1, ['y'] =  2564.43, ['z'] = 45.57},
                    [2] = { ['x'] = 1652.72, ['y'] = 2564.34, ['z'] = 45.57},
                    [3] = { ['x'] = 1654.04, ['y'] = 2564.35, ['z'] = 45.57},
                    [4] = { ['x'] = 1632.33, ['y'] = 2529.16, ['z'] = 45.57},
                    [5] = { ['x'] = 1630.41, ['y'] = 2527.02, ['z'] = 45.57},
                    [6] = { ['x'] = 1644.56, ['y'] = 2490.84, ['z'] = 45.57},
                    [7] = { ['x'] = 1643.17, ['y'] = 2490.81, ['z'] = 45.57},
                    [8] = { ['x'] = 1622.5, ['y'] = 2507.0, ['z'] = 45.57},
                    [9] = { ['x'] = 1622.36, ['y'] = 2508.29, ['z'] = 45.57},
                    [10] = { ['x'] = 1608.5, ['y'] = 2566.47, ['z'] = 45.57},
                    [11] = { ['x'] = 1609.53,['y'] = 2567.5, ['z'] = 45.57}}

-- Local para iniciar a figa                    
config.fuga = { 
    [1] = { ['x'] = 1573.7, ['y'] = 2513.78, ['z'] = 45.57},
}
-- teleport para fora da prisao
config.fugaTeleport = { 
    [1] = { ['x'] = 1534.94, ['y'] = 2588.98, ['z'] = 45.4},
}
config.posicaoDinamica = true
-- aqui tem que colocar a quantidade de pontos
config.pontos = 11
-- aqui é o percentual de acerto
config.percent = 99
-- aqui é o percentual para a fuga
config.percentFuga = 99
-- aqui valida se vai incluir o player como foragido
config.foragido = true
-- aqui é o tempo da animação
config.tempoAnimacao = 5000
-- aqui é o item a ser dropado
config.dropItem = 'chave'
-- aqui são os itens auxiliar 
config.itemAux = { 
    [1] = { ['item'] = 'agua', ['nome']='agua' },
    [2] = { ['item'] = 'sanduiche', ['nome']='sanduiche'},
    [3] = { ['item'] = 'pirulito', ['nome']='pirulito'},
    [4] = { ['item'] = 'paocomovo', ['nome']='pao com ovo'},
    [5] = { ['item'] = 'brigadeiro', ['nome']='brigadeiro'},
    [6] = { ['item'] = 'chocolate', ['nome']='chocolate'},
    [7] = { ['item'] = 'maconha', ['nome']='maconha'},
    [8] = { ['item'] = 'cerveja', ['nome']='cerveja'},
    [9] = { ['item'] = 'vodka', ['nome']='vodka'},
    [10] = { ['item'] = 'bandagem', ['nome']='bandagem'},
}
config.qtdItem = 10

return config