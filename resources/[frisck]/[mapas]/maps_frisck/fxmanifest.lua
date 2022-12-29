client_script "@vrp/lib/lib.lua" --Para remover esta pendencia de todos scripts, execute no console o comando "uninstall"
resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

fx_version 'bodacious'
game 'gta5'

this_is_a_map 'yes'


client_script {
    'client/*.lua',
    'coca.lua',
	'meta.lua',
	'maconha.lua',
	'lavagem.lua',
    'client.lua',
    'main.lua'
    -- 'client_mapa_menu.lua'

}

files {
    'interiorproxies.meta',
    'stream/vesp_props.ytyp',
    'stream/b_batalhao.ytyp',
    'stream/lafa2k_favelafix.ytyp',
    'stream/props.ytyp',
    'stream/v_int_40.ytyp',
    'interiorproxies.meta',
    'mapzoomdata.meta',
    'stream/*.ytd'
    ---
} 

data_file 'INTERIOR_PROXY_ORDER_FILE' 'interiorproxies.meta'
data_file 'DLC_ITYP_REQUEST' 'stream/vesp_props.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/b_batalhao.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/lafa2k_favelafix.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/props.ytyp'
data_file 'DLC_ITYP_REQUEST' 'stream/v_int_40.ytyp'   
data_file 'DLC_ITYP_REQUEST' 'stream/v_int_40.ytyp' 


data_file('DLC_ITYP_REQUEST')('stream/bobo_sandy_pd_karen_shell.ytyp')