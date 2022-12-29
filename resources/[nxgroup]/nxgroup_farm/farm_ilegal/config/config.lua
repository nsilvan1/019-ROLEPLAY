cfg = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- START FARM
-----------------------------------------------------------------------------------------------------------------------------------------
cfg.StartCoords = {  
    -- armas feitos 
    { type = "Bratva", perm = "bratva.permissao", coords = vector3(-146.95,-959.72,269.14), blipname = "Coletar"},
    { type = "Pcc", perm = "pcc.permissao", coords = vector3(-2677.37,1335.87,144.26), blipname = "Coletar"},
    -- { type = "Cpx", perm = "cpx.permissao", coords = vector3(-1493.5,843.48,181.6), blipname = "Coletar"},
    -- --- municao feitos
    -- { type = "B13", perm = "b13.permissao", coords = vector3(956.29,-1635.84,30.31), blipname = "Coletar"},
    -- { type = "Fdn", perm = "fdn.permissao", coords = vector3(956.29,-1635.84,30.31), blipname = "Coletar"},
    -- ---- drogas Feito falta 1
    -- { type = "Gde", perm = "gde.permissao", coords = vector3(604.0,2072.71,89.71), blipname = "Coletar" },
    -- { type = "Tcp", perm = "tcp.permissao", coords = vector3(-2612.19,1688.39,141.87), blipname = "Coletar"},
    -- --- lavagem
    -- { type = "Vanilla", perm = "vanilla.permissao", coords = vector3(2490.3,2085.17,33.24), blipname = "Coletar"},
    -- { type = "Lux", perm = "lux.permissao", coords = vector3(2112.22,3892.61,33.3), blipname = "Coletar"},
    -- { type = "Sindicato", perm = "sindicato.permissao", coords = vector3(3258.42,5129.03,20.41), blipname = "Coletar"},
    -- { type = "Lux", perm = "lux.permissao", coords = vector3(2112.22,3892.61,33.3), blipname = "Coletar"},
    -- ---- desmanche
    -- { type = "Cdd", perm = "cdd.permissao", coords = vector3(-2612.19,1688.39,141.87), blipname = "Coletar"},
    -- { type = "Hells", perm = "hells.permissao", coords = vector3(-1493.5,843.48,181.6), blipname = "Coletar"},
    -- { type = "Motoclub", perm = "motoclub.permissao", coords = vector3(-2603.82,1922.98,167.31), blipname = "Coletar"},   

}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FARM LOCATION
-----------------------------------------------------------------------------------------------------------------------------------------
cfg.FarmLocs = {
    Gde = {
        [1] = { coords = vector3(1164.84,-319.68,69.21) }, 
        [2] = { coords = vector3(-705.63,-910.6,19.22) }, 
        [3] = { coords = vector3(-44.47,-1756.21,29.43) },
        [4] = { coords = vector3(-1821.66,796.82,138.09) },
        [5] = { coords = vector3(1130.28,-979.64,46.42) }, 
        [6] = { coords = vector3(-1481.38,-377.87,40.17) }, 
        [7] = { coords = vector3(-1222.79,-913.09,12.33) }, 
        [8] = { coords = vector3(2548.96,382.41,108.63) }, 
        [9] = { coords = vector3(-3044.71,587.26,7.91), final = true },
    },
    Tcp = {
        [1] = { coords = vector3(1164.84,-319.68,69.21) }, 
        [2] = { coords = vector3(-705.63,-910.6,19.22) }, 
        [3] = { coords = vector3(-44.47,-1756.21,29.43) },
        [4] = { coords = vector3(-1821.66,796.82,138.09) },
        [5] = { coords = vector3(1130.28,-979.64,46.42) }, 
        [6] = { coords = vector3(-1481.38,-377.87,40.17) }, 
        [7] = { coords = vector3(-1222.79,-913.09,12.33) }, 
        [8] = { coords = vector3(2548.96,382.41,108.63) }, 
        [9] = { coords = vector3(-3044.71,587.26,7.91), final = true },
    },
    Motoclub = {
        [1] = { coords = vector3(-1188.1,-1786.1,4.38) },
        [2] = { coords = vector3(-1576.3,-927.83,5.79) },
        [3] = { coords = vector3(-1643.57,259.67,55.89) },
        [4] = { coords = vector3(-3040.54,91.9,8.73) },
        [5] = { coords = vector3(-2554.67,2306.2,33.23) },
        [6] = { coords = vector3(159.53,6358.55,27.92) },
        [7] = { coords = vector3(3431.06,3746.19,27.02) },
        [8] = { coords = vector3(1763.58,-1618.08,112.65) },
        [9] = { coords = vector3(1543.35,811.52,78.61) },
        [10] = { coords = vector3(264.12,-3071.51,5.89),final = true  },
    },
    Pcc = {
        [1] = { coords = vector3(-1576.3,-927.83,5.79) },
        [2] = { coords = vector3(-1643.57,259.67,55.89) },
        [3] = { coords = vector3(-3040.54,91.9,8.73) },
        [4] = { coords = vector3(-2554.67,2306.2,33.23) },
        [5] = { coords = vector3(159.53,6358.55,27.92) },
        [6] = { coords = vector3(3431.06,3746.19,27.02) },
        [7] = { coords = vector3(1763.58,-1618.08,112.65) },
        [8] = { coords = vector3(1543.35,811.52,78.61) },
        [9] = { coords = vector3(264.12,-3071.51,5.89),final = true  },
    },
    Bratva = {
        [1] = { coords = vector3(-146.65,-963.16,269.14) },
        [2] = { coords = vector3(-145.79,-964.76,269.14) },
        [3] = { coords = vector3(-143.28,-965.81,269.14) },
        [4] = { coords = vector3(-141.49,-966.27,269.14),final = true  },

    },
    -- Bratva = {
    --     [1] = { coords = vector3(-1188.1,-1786.1,4.38) },
    --     [2] = { coords = vector3(-1576.3,-927.83,5.79) },
    --     [3] = { coords = vector3(-1643.57,259.67,55.89) },
    --     [4] = { coords = vector3(-3040.54,91.9,8.73) },
    --     [5] = { coords = vector3(-2554.67,2306.2,33.23) },
    --     [6] = { coords = vector3(159.53,6358.55,27.92) },
    --     [7] = { coords = vector3(3431.06,3746.19,27.02) },
    --     [8] = { coords = vector3(1763.58,-1618.08,112.65) },
    --     [9] = { coords = vector3(1543.35,811.52,78.61) },
    --     [10] = { coords = vector3(264.12,-3071.51,5.89),final = true  },
    -- },
    Hells = {
        [1] = { coords = vector3(-1188.1,-1786.1,4.38) },
        [2] = { coords = vector3(-1576.3,-927.83,5.79) },
        [3] = { coords = vector3(-1643.57,259.67,55.89) },
        [4] = { coords = vector3(-3040.54,91.9,8.73) },
        [5] = { coords = vector3(-2554.67,2306.2,33.23) },
        [6] = { coords = vector3(159.53,6358.55,27.92) },
        [7] = { coords = vector3(3431.06,3746.19,27.02) },
        [8] = { coords = vector3(1763.58,-1618.08,112.65) },
        [9] = { coords = vector3(1543.35,811.52,78.61) },
        [10] = { coords = vector3(264.12,-3071.51,5.89),final = true  },
    },
    B13 = {
        [1] = { coords = vector3(32.02,-100.69,56.01) },
        [2] = { coords = vector3(1459.2,-1930.63,71.81) }, 
        [3] = { coords = vector3(814.87,-109.61,80.61) },
        [4] = { coords = vector3(614.47,2784.22,43.49) },
        [5] = { coords = vector3(-3238.53,922.25,13.96) }, 
        [6] = { coords = vector3(133.73,-2203.36,7.19), final = true },
    },
    Fdn = {
        [1] = { coords = vector3(32.02,-100.69,56.01) }, 
        [2] = { coords = vector3(1459.2,-1930.63,71.81) }, 
        [3] = { coords = vector3(814.87,-109.61,80.61) }, 
        [4] = { coords = vector3(614.47,2784.22,43.49) },
        [5] = { coords = vector3(-3238.53,922.25,13.96) },
        [6] = { coords = vector3(133.73,-2203.36,7.19), final = true },
    },
    Cdd = {
        [1] = { coords = vector3(32.02,-100.69,56.01) }, 
        [2] = { coords = vector3(1459.2,-1930.63,71.81) }, 
        [3] = { coords = vector3(814.87,-109.61,80.61) }, 
        [4] = { coords = vector3(614.47,2784.22,43.49) },
        [5] = { coords = vector3(-3238.53,922.25,13.96) }, 
        [6] = { coords = vector3(133.73,-2203.36,7.19), final = true },
    }, 
    Sindicato = {
        [1] = { coords = vector3(977.0,16.0,80.99) }, 
        [2] = { coords = vector3(572.99,-2573.01,6.4) }, 
        [3] = { coords = vector3(185.82,1213.4,225.6) }, 
        [4] = { coords = vector3(-1615.0,2805.0,18.02) },
        [5] = { coords = vector3(2439.0,4068.0,38.07) }, 
        [6] = { coords = vector3(-1130.0,2692.0,18.8) }, 
        [7] = { coords = vector3(1194.0,2722.0,38.62) }, 
        [8] = { coords = vector3(3600.0,3658.0,33.87) }, 
        [9] = { coords = vector3(2545.0,374.01,108.62) }, 
        [10] = { coords = vector3(1129.01,-989.99,45.97), final = true },
    },
    Cpx = {
        [1] = { coords = vector3(977.0,16.0,80.99) }, 
        [2] = { coords = vector3(572.99,-2573.01,6.4) }, 
        [3] = { coords = vector3(185.82,1213.4,225.6) }, 
        [4] = { coords = vector3(-1615.0,2805.0,18.02) },
        [5] = { coords = vector3(2439.0,4068.0,38.07) }, 
        [6] = { coords = vector3(-1130.0,2692.0,18.8) }, 
        [7] = { coords = vector3(1194.0,2722.0,38.62) }, 
        [8] = { coords = vector3(3600.0,3658.0,33.87) }, 
        [9] = { coords = vector3(2545.0,374.01,108.62) }, 
        [10] = { coords = vector3(1129.01,-989.99,45.97), final = true },
    },
    Lux = {
        [1] = { coords = vector3(1381.92,-1544.70,57.10) },
        [2] = { coords = vector3(1229.23,-730.73,60.66) },
        [3] = { coords = vector3(1899.12,3781.42,32.87) },
        [4] = { coords = vector3(1385.50,3659.51,34.92) },
        [5] = { coords = vector3(1673.81,4658.25,43.38) },
        [6] = { coords = vector3(2564.87,4680.44,34.08) },
        [7] = { coords = vector3(2393.57,3321.65,47.71) },
        [8] = { coords = vector3(2352.64,2523.22,47.68) },
        [9] = { coords = vector3(-9.18,6653.56,31.25) },
        [10] = { coords = vector3(-96.82,6324.25,31.57) },
        [11] = { coords = vector3(-3205.48,1152.44,9.66) },
        [12] = { coords = vector3(-3082.67,407.01,6.97) },
        [13] = { coords = vector3(-1931.91,162.48,84.65) },
        [14] = { coords = vector3(-1369.16,-136.26,49.57) },
        [15] = { coords = vector3(-1876.90,-584.35,11.85) },
        [16] = { coords = vector3(-1113.86,-1193.78,2.37) },
        [17] = { coords = vector3(-1.96,-1442.09,30.96) },
        [18] = { coords = vector3(130.39,-1853.16,25.23) },
        [19] = { coords = vector3(1289.37,-1710.45,55.47) },
        [20] = { coords = vector3(123.95,64.71,79.74), final = true },
    },
    Vanilla = {
        [1] = { coords = vector3(32.02,-100.69,56.01) }, 
        [2] = { coords = vector3(1459.2,-1930.63,71.81) }, 
        [3] = { coords = vector3(814.87,-109.61,80.61) }, 
        [4] = { coords = vector3(614.47,2784.22,43.49) },
        [5] = { coords = vector3(-3238.53,922.25,13.96) }, 
        [6] = { coords = vector3(133.73,-2203.36,7.19), final = true },
    },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FARM ITEMS
-----------------------------------------------------------------------------------------------------------------------------------------
cfg.FarmItems = {
    Gde = {
        item = { item = "folhas-coca", a1 = 7, a2 = 9, item2 = "linha", a3 = 0, a4 = 0, item3 = "kevlar", a5 = 0, a6 = 0, times = 5 },
    },
    Tcp = {
        item = { item = "canabis-alta", a1 = 7, a2 = 9, item2 = "molas", a3 = 0, a4 = 0, item3 = "placa-metal", a5 = 0, a6 = 0, times = 5 },
    },
    Motoclub = {
        item = { item = "aco", a1 = 3, a2 = 6, item2 = "cobre", a3 = 3, a4 = 6, item3 = "relogio", a5 = 1, a6 = 2, times = 10 },
    },
    Pcc = {
        item = { item = "pecadearma", a1 = 9, a2 = 12, item2 = "agua", a3 = 0, a4 = 0, item3 = "placa-metal", a5 = 0, a6 = 0, times = 10 },
    },
    Bratva = {
        item = { item = "pecadearma", a1 = 9, a2 = 12, item2 = "agua", a3 = 0, a4 = 0, item3 = "placa-metal", a5 = 0, a6 = 0, times = 10 },
    },
    Hells = {
        item = { item = "aco", a1 = 3, a2 = 6, item2 = "cobre", a3 = 3, a4 = 6, item3 = "relogio", a5 = 1, a6 = 2, times = 10 },
    },
    B13 = {
        item = { item = "capsulas", a1 = 7, a2 = 13, item2 = "polvora", a3 = 7, a4 = 13, item3 = "placa-metal", a5 = 0, a6 = 0, times = 10 },
    },
    Fdn = {
        item = { item = "capsulas", a1 = 7, a2 = 13, item2 = "polvora", a3 = 7, a4 = 13, item3 = "placa-metal", a5 = 0, a6 = 0, times = 10 },
    },
    Cdd = {
        item = { item = "aco", a1 = 3, a2 = 6, item2 = "cobre", a3 = 3, a4 = 6, item3 = "relogio", a5 = 1, a6 = 2, times = 10 },
    },
    Sindicato = {
        item = { item = "fio", a1 = 3, a2 = 6, item2 = "cobre", a3 = 3, a4 = 6, item3 = "placa-metal", a5 = 0, a6 = 0, times = 10 },
    },
    Cpx = {
        item = { item = "pecadearma", a1 = 9, a2 = 12, item2 = "agua", a3 = 0, a4 = 0, item3 = "placa-metal", a5 = 0, a6 = 0, times = 10 },
    },
    Lux = {
        item = { item = "fio", a1 = 3, a2 = 6, item2 = "cobre", a3 = 3, a4 = 6, item3 = "placa-metal", a5 = 0, a6 = 0, times = 10 },
    },
    Vanilla = {
        item = { item = "fio", a1 = 3, a2 = 6, item2 = "cobre", a3 = 3, a4 = 6, item3 = "placa-metal", a5 = 0, a6 = 0, times = 10 },
    },
}
