shared_script "@ThnAC/natives.lua"
fx_version 'bodacious'
game 'gta5'

author 'MrDaGree'
description 'A resource which provides extensive controls for Emergency Lighting System-V created by Lt.Caine'

shared_script 'shared/*.lua'

client_script {
    'vcf.lua',
    'config.lua',
    'client/**/*.lua'
}

server_script {
    'vcf.lua',
    'config.lua',
    'server/**/*.lua'
}