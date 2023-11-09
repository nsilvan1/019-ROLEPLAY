RegisterCommand('setvoiceintent', function(source, args)
	if GetConvarInt('voice_allowSetIntent', 1) == 1 then
		local intent = args[1]
		if intent == 'speech' then
			MumbleSetAudioInputIntent(GetHashKey('speech'))
		elseif intent == 'music' then
			MumbleSetAudioInputIntent(GetHashKey('music'))
		end
	end
end)

local playerMuted = false
RegisterCommand('cycleproximity', function()
	if GetConvarInt('voice_enableProximity', 1) ~= 1 then return end
	if playerMuted then return end
	local voiceMode = mode
	local newMode = voiceMode + 1
	voiceMode = (newMode <= #Cfg.voiceModes and newMode) or 1
	local voiceModeData = Cfg.voiceModes[voiceMode]
	MumbleSetAudioInputDistance(voiceModeData[1] + 0.0)
	mode = voiceMode
	LocalPlayer.state:set('proximity', {
		index = voiceMode,
		distance =  voiceModeData[1],
		mode = voiceModeData[2],
	}, GetConvarInt('voice_syncData', 1) == 1)
	-- make sure we update the UI to the latest voice mode
	SendNUIMessage({
		voiceMode = voiceMode - 1
	})
	TriggerEvent('pma-voice:setTalkingMode', voiceMode)
	TriggerEvent("nation_hud:setVoipMode", voiceMode)
end, false)
--RegisterKeyMapping('cycleproximity', 'Cycle Proximity', 'keyboard', GetConvar('voice_defaultCycle', 'HOME'))
RegisterKeyMapping('cycleproximity', 'Cycle Proximity', 'keyboard', 'HOME')


function MutePlayer() 
	playerMuted = true
	LocalPlayer.state:set('proximity', {
		index = 0,
		distance = 0.1,
		mode = 'Muted',
	}, GetConvarInt('voice_syncData', 1) == 1)
	MumbleSetAudioInputDistance(0.1)
end
exports('MutePlayer', MutePlayer)
RegisterNetEvent('pma-voice:MutePlayer', MutePlayer)

function DesmutePlayer() 
	playerMuted = false
	local voiceModeData = Cfg.voiceModes[mode]
	LocalPlayer.state:set('proximity', {
		index = mode,
		distance =  voiceModeData[1],
		mode = voiceModeData[2],
	}, GetConvarInt('voice_syncData', 1) == 1)
	MumbleSetAudioInputDistance(Cfg.voiceModes[mode][1])
end
exports('DesmutePlayer', DesmutePlayer)
RegisterNetEvent('pma-voice:DesmutePlayer', DesmutePlayer)