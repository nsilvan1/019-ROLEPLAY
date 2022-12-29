local channels = {
    pagamentocasas = '',
    Casasvender = '',
    CasasTrocarGaragem = '',
    CasasComprarGaragem = '',
    CasasTransferir = '',
    CasasVender = '',
    CasasRemoverFaltaAluguel = '',
    CasasComprar = '',
    CasasComprarVip = '',
    ApComprar = '',
    ApComprarVip = '',
    SpawnMoney = 'https://discord.com/api/webhooks/1055535279894712341/ipBPorPh-AZywjnzp_5eijwRtmtSmAKtxr8toCtO9Ga9y1m-Fd68epgEH7RFFg4lhLxb',
    LogUnban = 'https://discord.com/api/webhooks/1055535387075944519/3YSvXotjHX-QYpQDGPQ0B0i6PFhUz6U5t7vvpr743ptqubsryJLsx351PItdIPjwNWP-',
    LogBan = 'https://discord.com/api/webhooks/1055535387075944519/3YSvXotjHX-QYpQDGPQ0B0i6PFhUz6U5t7vvpr743ptqubsryJLsx351PItdIPjwNWP-',
    LogNc = 'https://discord.com/api/webhooks/1055535778958151822/HCoeE9rgA46NTuPwK6By93WGuZyO4OsY6XnX_wm6rttHIZyqI03d56IPOzgf82yaQOuI',
    LogBan2Hack = 'https://discord.com/api/webhooks/1055535582870253668/V8nemfW7SQMCP4FTLlXROddYK38YQazlU5jiPLm0T_3o7lkbPe5mJvM9hGsIpw50nXu2',
    LogKick = 'https://discord.com/api/webhooks/1055535856091402262/atzEH6unSQepUmJMCg0-VgcPutwQ_VLnnXHGhPoHdff1ZwVgxK4ULiCrEnyIMfXm8PMG',
    LogUnWl = 'https://discord.com/api/webhooks/1055536021909032990/3p89-0QG8_MUxGk9YBMPG4yFL19wly0YjB0rRwzbbH76DrB5kgwCEeiDNSC8iFXzAsyh',
    LogWl = 'https://discord.com/api/webhooks/1055535930406084649/bYL8ZUc84v3fMhC_IvPSBJzoU1eSqmSQpTl5BAFEZizXxshRMz4hG2d95ADMKV56tJDX',
    LogGodAll = 'https://discord.com/api/webhooks/1055536104100606003/kKNquU9cRA8L_LaaLwE7UJRflMZDYu0aB6bhvHDBydZnY5GPv9Nq5a5BihB58KscUyFE',
    LogFix = 'https://discord.com/api/webhooks/1055536316273655880/cN7Str6AW9xle3Bh02WvDO1YecKQZs2cqGaE7iyApeNdU2oJdvlJ4eL4h37SnJlocWIB',
    LogRemCar = 'https://discord.com/api/webhooks/1055536402336591952/8sQGRkqCLptoyyajuc8lgLVcMKT-BEmJayRZqT54byVGju5-C-IHoOOf0wEZent8T4AS',
    LogAddCar = 'https://discord.com/api/webhooks/1055536496536453290/y5NX1nsJ-Ft0Ya9YmPFcDS7OcIVZG1fmuevAgiGg9syvp_ZDYuMup6kV-sM1GufKeqlM',
    logRetirarDetido = '',
    LogkickSrc = 'https://discord.com/api/webhooks/1055535856091402262/atzEH6unSQepUmJMCg0-VgcPutwQ_VLnnXHGhPoHdff1ZwVgxK4ULiCrEnyIMfXm8PMG',
    LogGovernadorMsg = 'https://discord.com/api/webhooks/1055536684009271336/cKsU2TyPg8IFDezAE7-_IXEjnirhf7gf-hR6rJOfHqOppJBt1Kj41afFvzu9N1byN6WZ',
    LogMod = 'https://discord.com/api/webhooks/1055536684009271336/cKsU2TyPg8IFDezAE7-_IXEjnirhf7gf-hR6rJOfHqOppJBt1Kj41afFvzu9N1byN6WZ',
    LogAdmMsg = 'https://discord.com/api/webhooks/1055536684009271336/cKsU2TyPg8IFDezAE7-_IXEjnirhf7gf-hR6rJOfHqOppJBt1Kj41afFvzu9N1byN6WZ',
    LogEnviarDinheiro = 'https://discord.com/api/webhooks/1055537883890589757/RbinvVmA6n1_Ox_onHigNxFzsNxFlhUKLO5KThkPxP0Yz43osUhuvd7_bNYLmYChHGNm',
    LogSalario = '',
    LogCobrar = '',
    LogChamadosFeitos = '', 
    LogChamadosAtendeu = '',
    LogDenuncia = '',
    LogFinalizar = '',
    LogSocorro = '',
    LogDumpDinheiro = '',
    LogCapuz2 = '',
    LogChat = '',
    LogMorte = 'https://discord.com/api/webhooks/1055536927677354064/rB9SJ4aMjMEkSZEtB8BpnHsSgbj_GCLl6UgyoacMgDNzSETS0l0lve7HiDP8_tBTw29x',
    LogAddCoins = '',
    LogBuyCoinsGame = '',
    LogReset = '',
    LogCrash = 'https://discord.com/api/webhooks/1055537400799039498/WlxIl8POP0V9js1eOSAcDUo9p3I1rJtx_4L5wEYLALQG5vJN8rxPPU7NIMGQEEObm2wF',
    LogComandoFesta = '',
    LogHackButton = '',
    LogDm = 'https://discord.com/api/webhooks/1055536684009271336/cKsU2TyPg8IFDezAE7-_IXEjnirhf7gf-hR6rJOfHqOppJBt1Kj41afFvzu9N1byN6WZ',
    LogTp = 'https://discord.com/api/webhooks/1055535778958151822/HCoeE9rgA46NTuPwK6By93WGuZyO4OsY6XnX_wm6rttHIZyqI03d56IPOzgf82yaQOuI',
    LogGod = 'https://discord.com/api/webhooks/1055536104100606003/kKNquU9cRA8L_LaaLwE7UJRflMZDYu0aB6bhvHDBydZnY5GPv9Nq5a5BihB58KscUyFE', 
    LogAdmin = 'https://discord.com/api/webhooks/1055536684009271336/cKsU2TyPg8IFDezAE7-_IXEjnirhf7gf-hR6rJOfHqOppJBt1Kj41afFvzu9N1byN6WZ',
    LogAnunciosEms = 'https://discord.com/api/webhooks/1055536684009271336/cKsU2TyPg8IFDezAE7-_IXEjnirhf7gf-hR6rJOfHqOppJBt1Kj41afFvzu9N1byN6WZ',
    LogSpawnVeiculo = 'https://discord.com/api/webhooks/1055537509410553876/VZhVeB75-WLLM01WuA_-fWxHbdCr3OgCqCd6yKBzKvlWmrb-ysplGU5Q-PiegnqODqgZ',
    LogCL = 'https://discord.com/api/webhooks/1055537400799039498/WlxIl8POP0V9js1eOSAcDUo9p3I1rJtx_4L5wEYLALQG5vJN8rxPPU7NIMGQEEObm2wF',
    

    --- arsenal policia
    LogClear = '',
}

function sendLog(channel,message,bool)
    local webhookLink = channels[channel]
    if not webhookLink then
        print('Log não enviada. Webhook não declarada corretamente ou nome do canal incorreto.')
        return
    end
    if bool then
        message = '```prolog\n'..message..'\r```'
        requestSendLog(webhookLink, message)
    else
        requestSendLog(webhookLink, message)
    end
end

function requestSendLog(webhookLink, message)
    PerformHttpRequest(webhookLink, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
end

function addWebhook(channel, webhooLink)
    channels[channel] = webhookLink
end