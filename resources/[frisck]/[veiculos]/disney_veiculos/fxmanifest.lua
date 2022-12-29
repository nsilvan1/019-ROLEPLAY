client_script "@vrp/lib/lib.lua" --Para remover esta pendencia de todos scripts, execute no console o comando "uninstall"

fx_version 'adamant'
game 'gta5'

files {
	"data/**/*",
	"data/**",
	"data/*",
	'data/**/*.meta',
	"audio/*",
	"audio/**/*",
}

client_scripts {
	"tuning.lua",
	"plate.lua",
 }
		

-- METAS
data_file "HANDLING_FILE" "data/**/handling.meta"
data_file "VEHICLE_LAYOUTS_FILE" "data/**/vehiclelayouts.meta"
data_file "VEHICLE_METADATA_FILE" "data/**/vehicles.meta"
data_file "CARCOLS_FILE" "data/**/carcols.meta"
data_file "VEHICLE_VARIATION_FILE" "data/**/carvariations.meta"

-- AUDIO
data_file "AUDIO_WAVEPACK" "audio/elegyx/dlc_elegyx"
data_file "AUDIO_GAMEDATA" "audio/elegyx/elegyx_game.dat"
data_file "AUDIO_SOUNDDATA" "audio/elegyx/elegyx_sounds.dat"              