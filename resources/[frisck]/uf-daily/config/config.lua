cfg = {}

cfg.command = ""

cfg.listOnePorcentage = 0.1 --ou false (Colocar na lista apenas itens raros.)

cfg.actions = {
  login = {
    chat_notify = {enable = false, message = "^7𝐒𝐄𝐉𝐀 𝐁𝐄𝐌 𝐕𝐈𝐍𝐃𝐎 ! 𝐏𝐀𝐑𝐀 𝐕𝐄𝐑 𝐎 𝐒𝐄𝐔 𝐒𝐓𝐀𝐓𝐔𝐒, 𝐃𝐈𝐆𝐈𝐓𝐄 /𝐇𝐎𝐑𝐀𝐒"},
    event_notify = {enable = false, message = "^7𝐒𝐄𝐉𝐀 𝐁𝐄𝐌 𝐕𝐈𝐍𝐃𝐎 ! 𝐏𝐀𝐑𝐀 𝐕𝐄𝐑 𝐎 𝐒𝐄𝐔 𝐒𝐓𝐀𝐓𝐔𝐒, 𝐃𝐈𝐆𝐈𝐓𝐄 /𝐇𝐎𝐑𝐀𝐒"},
    sound_beep  = {enable = false}
  },
  reedemGift = {
    baloons = {enable = false}
  },
  chat_template = '<div style="display:flex;align-items:center;justify-content:center;padding:10px;margin:5px 0;background-image: linear-gradient(to right, rgba(39, 203, 255,1) 3%, rgba(46, 128, 255,0) 95%);border-radius: 5px;">{0}</div>'
}


--[[
  Mínimo de raridade é 0.1;
]]

cfg.gifts = {
  ['1' --[[Checkpoint de horas!]]] = {
    [0.1] = { 
      globalMessage = {enable = true, message= "🎉{nome} {sobrenome} pegou um item raro no Jogue Mais! ({item})🎉"},
      gifts = {
        {idname = "wbody|WEAPON_SNSPISTOL", name='Pistola Fajuta', amount =  {min = 1, max = 1}},
      }
    },
    [0.4] = { 
      globalMessage = {enable = false, message= "🎉{nome} {sobrenome} pegou um item raro no Jogue Mais! ({item})🎉"},
      gifts = {
        {idname = "lockpick", name='Lockpick', amount =  {min = 1, max = 2}},
      }
    },
    [0.6] = { 
      globalMessage = {enable = false, message= "🎉{nome} {sobrenome} pegou um item raro no Jogue Mais! ({item})🎉"},
      gifts = {
        {idname = "dinheirosujo", name='Dinheiro Sujo', amount =  {min = 15000, max = 30000}},
      }
    }
  },
  ['2'] = {
    [0.1 --[[Raridade do item]]] = { 
      globalMessage = {enable = true, message= "🎉{nome} {sobrenome} pegou um item raro no Jogue Mais! ({amount} {item})🎉"},
      gifts = {
        -- {idname = "wbody|WEAPON_SPECIALCARBINE", name='G-36', amount =  {min = 1, max = 1}},
        {idname = "wbody|WEAPON_ASSAULTRIFLE", name='AK-47', amount =  {min = 1, max = 1}},
      }
    }, 
    [0.1] = { 
      globalMessage = {enable = false, message= "🎉{nome} {sobrenome} pegou um item raro no Jogue Mais! ({item})🎉"},
      gifts = {
        {idname = "wbody|WEAPON_PISTOL", name='M1911', amount =  {min = 1, max = 1}},
        {idname = "wbody|WEAPON_PISTOL_MK2", name='Five-Seven', amount =  {min = 1, max = 1}},
      }
    },
    [0.6] = { 
      globalMessage = {enable = false, message= "🎉{nome} {sobrenome} pegou um item raro no Jogue Mais! ({item})🎉"},
      gifts = {
        {idname = "wbody|WEAPON_BAT", name='Taco de Beisebol', amount =  {min = 1, max = 1}},
        {idname = "wbody|WEAPON_SWITCHBLADE", name='Canivete', amount =  {min = 1, max = 1}},
        {idname = "wbody|WEAPON_KNIFE", name='Faca', amount =  {min = 1, max = 1}},
        {idname = "wbody|WEAPON_KNUCKLE", name='Soco Inglês', amount =  {min = 1, max = 1}},
      }
    },
    [0.8] = { 
      globalMessage = {enable = false, message= "🎉{nome} {sobrenome} pegou um item raro no Jogue Mais! ({item})🎉"},
      gifts = {
        {idname = "lockpick", name='Lockpick', amount =  {min = 1, max = 5}},
      }
    },
    [0.9] = { 
      globalMessage = {enable = false, message= "🎉{nome} {sobrenome} pegou um item raro no Jogue Mais! ({item})🎉"},
      gifts = {
        {idname = "dinheirosujo", name='Dinheiro Sujo', amount =  {min = 35000, max = 45000}},
      }
    }
  },
  ['3'] = {
    [0.1 --[[Raridade do item]]] = { 
      globalMessage = {enable = true, message= "🎉{nome} {sobrenome} pegou um item raro no Jogue Mais! ({amount} {item})🎉"},
      gifts = {
        {idname = "wbody|WEAPON_ASSAULTRIFLE", name='AK-47', amount =  {min = 1, max = 1}},
        -- {idname = "wbody|WEAPON_SPECIALCARBINE", name='G-36', amount =  {min = 1, max = 1}},
        {idname = "wbody|WEAPON_ASSAULTSMG", name='Mtar-21', amount =  {min = 1, max = 1}},
      }
    }, 
    [0.2] = { 
      globalMessage = {enable = false, message= "🎉{nome} {sobrenome} pegou um item raro no Jogue Mais! ({item})🎉"},
      gifts = {
        {idname = "wbody|WEAPON_PISTOL", name='M1911', amount =  {min = 1, max = 1}},
        {idname = "wbody|WEAPON_PISTOL_MK2", name='Five-Seven', amount =  {min = 1, max = 1}},
      }
    },
    [0.5] = { 
      globalMessage = {enable = false, message= "🎉{nome} {sobrenome} pegou um item raro no Jogue Mais! ({item})🎉"},
      gifts = {
        {idname = "wbody|WEAPON_BAT", name='Taco de Beisebol', amount =  {min = 1, max = 1}},
        {idname = "wbody|WEAPON_SWITCHBLADE", name='Canivete', amount =  {min = 1, max = 1}},
        {idname = "wbody|WEAPON_KNIFE", name='Faca', amount =  {min = 1, max = 1}},
        {idname = "wbody|WEAPON_KNUCKLE", name='Soco Inglês', amount =  {min = 1, max = 1}},
      }
    },
    [0.7] = { 
      globalMessage = {enable = false, message= "🎉{nome} {sobrenome} pegou um item raro no Jogue Mais! ({item})🎉"},
      gifts = {
        {idname = "lockpick", name='Lockpick', amount =  {min = 2, max = 6}},
      }
    },
    [0.8] = { 
      globalMessage = {enable = false, message= "🎉{nome} {sobrenome} pegou um item raro no Jogue Mais! ({item})🎉"},
      gifts = {
        {idname = "dinheirosujo", name='Dinheiro Sujo', amount =  {min = 40000, max = 50000}},
      }
    }
  },
  ['16'] = {
    [0.1 --[[Raridade do item]]] = { 
      globalMessage = {enable = true, message= "🎉{nome} {sobrenome} pegou um item raro no Jogue Mais! ({amount} {item})🎉"},
      gifts = {
        {idname = "wbody|WEAPON_ASSAULTRIFLE", name='AK-47', amount =  {min = 1, max = 1}},
        {idname = "wbody|WEAPON_SPECIALCARBINE", name='G-36', amount =  {min = 1, max = 1}},
        {idname = "wbody|WEAPON_ASSAULTSMG", name='Mtar-21', amount =  {min = 1, max = 1}},
      }
    }, 
    [0.2] = { 
      globalMessage = {enable = false, message= "🎉{nome} {sobrenome} pegou um item raro no Jogue Mais! ({item})🎉"},
      gifts = {
        {idname = "wbody|WEAPON_PISTOL", name='M1911', amount =  {min = 1, max = 1}},
        {idname = "wbody|WEAPON_PISTOL_MK2", name='Five-Seven', amount =  {min = 1, max = 1}},
      }
    },
    [0.6] = { 
      globalMessage = {enable = false, message= "🎉{nome} {sobrenome} pegou um item raro no Jogue Mais! ({item})🎉"},
      gifts = {
        {idname = "wbody|WEAPON_BAT", name='Taco de Beisebol', amount =  {min = 1, max = 1}},
        {idname = "wbody|WEAPON_SWITCHBLADE", name='Canivete', amount =  {min = 1, max = 1}},
        {idname = "wbody|WEAPON_KNIFE", name='Faca', amount =  {min = 1, max = 1}},
        {idname = "wbody|WEAPON_KNUCKLE", name='Soco Inglês', amount =  {min = 1, max = 1}},
      }
    },
    [0.8] = { 
      globalMessage = {enable = false, message= "🎉{nome} {sobrenome} pegou um item raro no Jogue Mais! ({item})🎉"},
      gifts = {
        {idname = "lockpick", name='Lockpick', amount =  {min = 3, max = 7}},
      }
    },
    [0.9] = { 
      globalMessage = {enable = false, message= "🎉{nome} {sobrenome} pegou um item raro no Jogue Mais! ({item})🎉"},
      gifts = {
        {idname = "dinheirosujo", name='Dinheiro Sujo', amount =  {min = 45000, max = 70000}},
      }
    }
  },
  ['18'] = {
    [0.1 --[[Raridade do item]]] = { 
      globalMessage = {enable = true, message= "🎉{nome} {sobrenome} pegou um item raro no Jogue Mais! ({amount} {item})🎉"},
      gifts = {
        {idname = "wbody|WEAPON_ASSAULTRIFLE", name='AK-47', amount =  {min = 1, max = 1}},
        -- {idname = "wbody|WEAPON_SPECIALCARBINE", name='G-36', amount =  {min = 1, max = 1}},
        {idname = "wbody|WEAPON_ASSAULTSMG", name='Mtar-21', amount =  {min = 1, max = 1}},
      }
    }, 
    [0.2] = { 
      globalMessage = {enable = false, message= "🎉{nome} {sobrenome} pegou um item raro no Jogue Mais! ({item})🎉"},
      gifts = {
        {idname = "wbody|WEAPON_PISTOL", name='M1911', amount =  {min = 1, max = 1}},
        {idname = "wbody|WEAPON_PISTOL_MK2", name='Five-Seven', amount =  {min = 1, max = 1}},
      }
    },
    [0.6] = { 
      globalMessage = {enable = false, message= "🎉{nome} {sobrenome} pegou um item raro no Jogue Mais! ({item})🎉"},
      gifts = {
        {idname = "wbody|WEAPON_BAT", name='Taco de Beisebol', amount =  {min = 1, max = 1}},
        {idname = "wbody|WEAPON_SWITCHBLADE", name='Canivete', amount =  {min = 1, max = 1}},
        {idname = "wbody|WEAPON_KNIFE", name='Faca', amount =  {min = 1, max = 1}},
        {idname = "wbody|WEAPON_KNUCKLE", name='Soco Inglês', amount =  {min = 1, max = 1}},
      }
    },
    [0.7] = { 
      globalMessage = {enable = false, message= "🎉{nome} {sobrenome} pegou um item raro no Jogue Mais! ({item})🎉"},
      gifts = {
        {idname = "wammo|WEAPON_PISTOL_MK2", name='M F.Seven', amount =  {min = 70, max = 150}},
      }
    },
    [0.9] = { 
      globalMessage = {enable = false, message= "🎉{nome} {sobrenome} pegou um item raro no Jogue Mais! ({item})🎉"},
      gifts = {
        {idname = "dinheirosujo", name='Dinheiro Sujo', amount =  {min = 50000, max = 75000}},
      }
    }
  },
  ['22'] = {
    [0.1 --[[Raridade do item]]] = { 
      globalMessage = {enable = true, message= "🎉{nome} {sobrenome} pegou um item raro no Jogue Mais! ({amount} {item})🎉"},
      gifts = {
        {idname = "wbody|WEAPON_ASSAULTRIFLE", name='AK-47', amount =  {min = 1, max = 1}},
        -- {idname = "wbody|WEAPON_SPECIALCARBINE", name='G-36', amount =  {min = 1, max = 1}},
        {idname = "wbody|WEAPON_ASSAULTSMG", name='Mtar-21', amount =  {min = 1, max = 1}},
      }
    }, 
    [0.2] = { 
      globalMessage = {enable = false, message= "🎉{nome} {sobrenome} pegou um item raro no Jogue Mais! ({item})🎉"},
      gifts = {
        {idname = "wbody|WEAPON_PISTOL", name='M1911', amount =  {min = 1, max = 1}},
        {idname = "wbody|WEAPON_PISTOL_MK2", name='Five-Seven', amount =  {min = 1, max = 1}},
      }
    },
    [0.3] = { 
      globalMessage = {enable = false, message= "🎉{nome} {sobrenome} pegou um item raro no Jogue Mais! ({item})🎉"},
      gifts = {
        {idname = "wbody|WEAPON_BAT", name='Taco de Beisebol', amount =  {min = 1, max = 1}},
        {idname = "wbody|WEAPON_SWITCHBLADE", name='Canivete', amount =  {min = 1, max = 1}},
        {idname = "wbody|WEAPON_KNIFE", name='Faca', amount =  {min = 1, max = 1}},
        {idname = "wbody|WEAPON_KNUCKLE", name='Soco Inglês', amount =  {min = 1, max = 1}},
      }
    },
    [0.5] = { 
      globalMessage = {enable = false, message= "🎉{nome} {sobrenome} pegou um item raro no Jogue Mais! ({item})🎉"},
      gifts = {
        {idname = "wammo|WEAPON_PISTOL_MK2", name='M F.Seven', amount =  {min = 100, max = 200}},
      }
    },
    [0.7] = { 
      globalMessage = {enable = false, message= "🎉{nome} {sobrenome} pegou um item raro no Jogue Mais! ({item})🎉"},
      gifts = {
        {idname = "dinheirosujo", name='Dinheiro Sujo', amount =  {min = 60000, max = 80000}},
      }
    }
  },

}

cfg.initialAutoStart = true     -- Registrar o primeiro ciclo diário automaticamente, após iniciar a resource.
cfg.adminCommand = 'iniciar_evento' -- Isso só podera ser executado pelo console. (/iniciar_evento)

cfg.webhooks = {
  weekEnd = 'https://discord.com/api/webhooks/1053311312349896744/53lSIVqbU-mKLSyTfYf-CT1SB30PdeL9ssnTCV5QRTabmfGO3dbxSpn1DPF2p6XcGgwI',
  log = 'https://discord.com/api/webhooks/1053311312349896744/53lSIVqbU-mKLSyTfYf-CT1SB30PdeL9ssnTCV5QRTabmfGO3dbxSpn1DPF2p6XcGgwI',
  reportbug = 'https://discord.com/api/webhooks/1053311312349896744/53lSIVqbU-mKLSyTfYf-CT1SB30PdeL9ssnTCV5QRTabmfGO3dbxSpn1DPF2p6XcGgwI',
  reedemGift = 'https://discord.com/api/webhooks/1053311312349896744/53lSIVqbU-mKLSyTfYf-CT1SB30PdeL9ssnTCV5QRTabmfGO3dbxSpn1DPF2p6XcGgwI',
  info = {
    title  = 'Jogue mais Ganhe Mais',
    footer = 'UF-DAILY'
  }
}

cfg.identity = {
  sobrenome = "name", --[[ Nome do campo de sobrenome, nome baseado nas tabelas.]]
  nome      = "firstname",
}

cfg.nui = {
  nextGift = 'PROXIMA PREMIAÇÃO',
  actualGift = 'PREMIAÇÃO ATUAL',
  percentList = 'CHANCE DE GANHAR',
  title = 'RECOMPENSAS DIARIAS',
  hoursDesc = 'Horas Jogadas',
  reedemButton = 'Receber'
} 

return cfg