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
    SpawnMoney = 'https://discord.com/api/webhooks/1058385299870322719/erA3_CwXFRVM6LzMFznEFB4aJvfZYYQTnYk2QR5pu02Q3X6A4c9neLXFjZ9F-2s6nVDG',
    LogUnban = 'https://discord.com/api/webhooks/1058385517613416569/dVU49P6SGqaMi9gz9fLVqlsAjM4vFHRFRBaeq3B-NEL7JohK2WC2FzO8_-hBqHp7ScQR',
    LogBan = 'https://discord.com/api/webhooks/1058385593656164375/ustycaAtJbr0SO-IElJc5ahgjh9KlWpgK7TZUVxhQcd_SpO2HjbuftVTlJS3M-jOBWUT',
    LogNc = 'https://discord.com/api/webhooks/1058385787865022465/g8LGkzRpBOGK-YTtz7lLikQWcNuBk_zFtGsykQPYmBSDcsfuIUd0sRiLU7ds4N1_bcJc',
    LogBan2Hack = 'https://discord.com/api/webhooks/1058385593656164375/ustycaAtJbr0SO-IElJc5ahgjh9KlWpgK7TZUVxhQcd_SpO2HjbuftVTlJS3M-jOBWUT',
    LogKick = 'https://discord.com/api/webhooks/1058385994409312287/fXnwN5c7y6iU-RxHe9fyjnBWsGN41XQ3aBf1FlQBLq991a8yweMS7Jr6sTxfSYqZc-hL',
    LogUnWl = 'https://discord.com/api/webhooks/1058386130858418297/mad5nkSbR21QjK-8TPJ_Xnl4Xvq07OFfe36s2WFoONmA7X1EAKiShEyaOTXPABHurx-4',
    LogWl = 'https://discord.com/api/webhooks/1058386130858418297/mad5nkSbR21QjK-8TPJ_Xnl4Xvq07OFfe36s2WFoONmA7X1EAKiShEyaOTXPABHurx-4',
    LogGodAll = 'https://discord.com/api/webhooks/1058386246516359250/JAiVOplwytfsoqdnh55kUdBBdiOrpZtbwfEPBeIT7-szIlf0mSXpZn5t8Uc5g3duPtJL',
    LogFix = 'https://discord.com/api/webhooks/1058386393061130372/k1gFC-79NYgZOMu1TQyUoo00FB3j3XjmJg4bwNZ6B8XXASORpBP0XkeyPA6mEJ1aPkXR',
    LogRemCar = 'https://discord.com/api/webhooks/1058386590705123369/M2QJapEeq_lthWG_-eF9W98zIQCbEDLzCCpm6ORFyzz2o989aeGktuOHMCNCrtN3VqqK',
    LogAddCar = 'https://discord.com/api/webhooks/1058386590705123369/M2QJapEeq_lthWG_-eF9W98zIQCbEDLzCCpm6ORFyzz2o989aeGktuOHMCNCrtN3VqqK',
    logRetirarDetido = 'https://discord.com/api/webhooks/1058386752668180520/Fjtg5h2r-JsufZcew3AXRiLLbhuG1apdrz7qHw8XGKWDk80z9XODjzB4iuVGfKHnH4qA',
    LogkickSrc = 'https://discord.com/api/webhooks/1058386904808173678/aowRxvJF2Lerw3fK75uxwqo87faxkxZ5i4C8jT1yb_cmOqnoiN66j6c9GMdJJk-6yGnA',
    LogGovernadorMsg = 'https://discord.com/api/webhooks/1058387018251513976/rCKQWvhSoa9TLpjwYewOcxIIGpuAph4xXtawBiVtuidD--e3bqq5XdWoSMFAbeyvvFGT',
    LogMod = 'https://discord.com/api/webhooks/1058387282220044339/AUUKKgpWJTbiqhcOkyR1ub4cNw5zpM_BrfezPJZhPBAGdngYfzjvhn3khiCL9ux0JCnt',
    LogAdmMsg = 'https://discord.com/api/webhooks/1058387018251513976/rCKQWvhSoa9TLpjwYewOcxIIGpuAph4xXtawBiVtuidD--e3bqq5XdWoSMFAbeyvvFGT',
    LogEnviarDinheiro = 'https://discord.com/api/webhooks/1058387901148303370/mRlpy2rP6_9nHB55RqI5LfOMzALF_ayIJc3807u15Ll1CroQUutyDZQEndk5rCpm0JCg',
    LogSalario = 'https://discord.com/api/webhooks/1058387980051550228/_itoOOJawyaWk3UNfGOJEsSB0e3IHzV_hVQeWS9jmFzKlFZ-sWe1eAd2kuE5KAidj-MB',
    LogCobrar = 'https://discord.com/api/webhooks/1058388501114138724/i-Qy6sfLnhgUskalQeS5GzOyOmRUrEndf6xVWqin2ztdcmPT7t1FeV2zMJXbzrTvWZYE',
    LogChamadosFeitos = 'https://discord.com/api/webhooks/1058388651756761188/tEKweI2EEQvWdloYiQu4g-qGEJKmKxAYMOXEf4xka_cDbEs9Dz-emEYjq0h-l27DmZE-', 
    LogChamadosAtendeu = 'https://discord.com/api/webhooks/1058392502677286942/nXTAqfrrLdVq7kTeXLf0XZ5pKEKK5CA4trY6U7jR-FkuJVDxKfWNcBUw74utTCM6ZFx7',
    LogDenuncia = 'https://discord.com/api/webhooks/1058393162642620516/tjT4_sJkiTvQaW5ZhWC0LbTkCrX6JokUXrn3K5wFB-v2kiHNra40laYw5oW9LdAzZzKM',
    LogFinalizar = 'https://discord.com/api/webhooks/1058393247304667156/1syp7N3NGavuAqJ7M2-9c2dAvgWluATIZT4OUl8DELCBgccJ1PrQzXUaCfSGj19XFXll',
    LogSocorro = 'DQ5eZQyMbCsAGDoE7vq3zsPH7v43EvfUV6',
    LogDumpDinheiro = 'https://discord.com/api/webhooks/1058393405782245396/IK-71BS-LXGxvT_lxMq_cvej9-zd-0nSA3fmvIhCnz7-1v16m2IFtQKtSA6shQQaKKPx',
    LogCapuz2 = 'https://discord.com/api/webhooks/1058393480105308242/Ifcu1jIDgLSHew-04-G0FciHEv9-xsTpqwLDX2P0SznDO0-8q1vk8rvY7GuRXkxwh7X7',
    LogChat = 'https://discord.com/api/webhooks/1058387018251513976/rCKQWvhSoa9TLpjwYewOcxIIGpuAph4xXtawBiVtuidD--e3bqq5XdWoSMFAbeyvvFGT',
    LogMorte = 'https://discord.com/api/webhooks/1058395499465551933/gs30ptiBPg6Z1crHVRecL_5bqWWDIOxj4Un-QUtzyZpukOtGi017wMx6UtjcUW5RuRdn',
    LogAddCoins = '',
    LogBuyCoinsGame = '',
    LogReset = 'https://discord.com/api/webhooks/1058397613872910426/O8gbCP24VyviDq9ZeTxhlfCoFRewU5ARUZUOtYi5rpKn-7nFLAUWfDBbRTpKByY03GMa',
    LogCrash = 'https://discord.com/api/webhooks/1058397840713469982/kvY9JokLOtcvMxDwrrML87O2Rox2kmq-i5OTIEjeuq3u1WjS96__mMvCcjhSOr2Q1cmI',
    LogComandoFesta = 'https://discord.com/api/webhooks/1058387018251513976/rCKQWvhSoa9TLpjwYewOcxIIGpuAph4xXtawBiVtuidD--e3bqq5XdWoSMFAbeyvvFGT',
    LogHackButton = '',
    LogDm = 'https://discord.com/api/webhooks/1058387018251513976/rCKQWvhSoa9TLpjwYewOcxIIGpuAph4xXtawBiVtuidD--e3bqq5XdWoSMFAbeyvvFGT',
    LogTp = 'https://discord.com/api/webhooks/1058397918626840609/8_nVFRmjlnbLfmicW0nOILIEhrAuKHV_jbTvCEvOgo8BOki-41GFfOEtBXCndhvfHQ-b',
    LogGod = 'https://discord.com/api/webhooks/1058386246516359250/JAiVOplwytfsoqdnh55kUdBBdiOrpZtbwfEPBeIT7-szIlf0mSXpZn5t8Uc5g3duPtJL', 
    LogAdmin = 'https://discord.com/api/webhooks/1058398137582112778/jX8wwCtWZGIz62YczaJ122zKsa7GC1ZIEOHGCzCxT3R6FoMxWEWz8KmPkR_brTsJ5D2G',
    LogAnunciosEms = 'https://discord.com/api/webhooks/1058387018251513976/rCKQWvhSoa9TLpjwYewOcxIIGpuAph4xXtawBiVtuidD--e3bqq5XdWoSMFAbeyvvFGT',
    LogSpawnVeiculo = 'https://discord.com/api/webhooks/1058398211116646540/14S4Kf01PRlh9WXmhsO1-sNuCYlh-oS67I6pC4ofWKwNyGtp-4KIl5r2Kk4ESBi2Je7O',
    LogCL = 'https://discord.com/api/webhooks/1058398369921376408/M3MLH9jNow0EsjjplTrx95WhWj4bR9yPKBjgJQZpD504wnsjlNPAL3ijDU9nscn6jZ0T',
    

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