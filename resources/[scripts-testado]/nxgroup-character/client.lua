local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

PL = {}
Tunnel.bindInterface("nxgroup-character", PL)
vSERVER = Tunnel.getInterface("nxgroup-character")

RegisterNetEvent("nxgroup-character:characterCreate")

local cam = nil

function f(n)
	n = n + 0.00000
	return n
end

function setCamHeight(height)
	local pos = GetEntityCoords(PlayerPedId())
	SetCamCoord(cam,vector3(pos.x,pos.y,f(height)))
end

local function StartFade()
	DoScreenFadeOut(500)
	while IsScreenFadingOut() do
		Citizen.Wait(1)
	end
end

local function EndFade()
	ShutdownLoadingScreen()
	DoScreenFadeIn(500)
	while IsScreenFadingIn() do
		Citizen.Wait(1)
	end
end

AddEventHandler("nxgroup-character:characterCreate",function()

	local ped = PlayerPedId()
	SetEntityInvincible(ped,false) --mqcu
	SetEntityVisible(ped,true,false)
	FreezeEntityPosition(ped,true)

	SetTimeout(1000,function()
		if not DoesCamExist(cam) then
			cam = CreateCam("DEFAULT_SCRIPTED_CAMERA",false)
			
			SetCamCoord(cam,vector3(975.70,65.80,116.70))   
	        SetCamRot(cam,0.0,0.0,149.00,2) 
			SetCamActive(cam,true)
			RenderScriptCams(true,true,20000000000000000000000000,0,0,0)
		end
		
		TriggerCreateCharacter()
	end)
end)

local isInCharacterMode = false
local currentCharacterMode = { fathersID = 0, mothersID = 21, skinColor = 0, skinColor2 = 0, shapeMix = 0.6, shapeMix2 = 0.0, eyesColor = 0, eyebrowsHeight = 0, eyebrowsWidth = 0, noseWidth = 0, noseHeight = 0, noseLength = 0, noseBridge = 0, noseTip = 0, noseShift = 0, cheekboneHeight = 0, cheekboneWidth = 0, cheeksWidth = 0, lips = 0, jawWidth = 0, jawHeight = 0, chinLength = 0, chinPosition = 0, chinWidth = 0, chinShape = 0, neckWidth = 0, hairModel = 4, firstHairColor = 0, secondHairColor = 0, eyebrowsModel = 0, eyebrowsColor = 0, beardModel = -1, beardColor = 0, chestModel = -1, chestColor = 0, blushModel = -1, blushColor = 0, lipstickModel = -1, lipstickColor = 0, blemishesModel = -1, ageingModel = -1, complexionModel = -1, sundamageModel = -1, frecklesModel = -1, makeupModel = -1 }

function TriggerCreateCharacter()
	isInCharacterMode = true
	StartFade()	
	changeGender("mp_m_freemode_01")
	refreshDefaultCharacter()
	TaskUpdateSkinOptions()
	TaskUpdateFaceOptions()
	TaskUpdateHeadOptions()
	SetEntityCoordsNoOffset(PlayerPedId(),975.2,64.95,116.16,true,true,true) 
	SetEntityHeading(PlayerPedId(),f(320))
	Wait(5000)
	EndFade()
	SetNuiFocus(isInCharacterMode,isInCharacterMode)
	SendNUIMessage({ "manageVisibility", isInCharacterMode })
end

function refreshDefaultCharacter()
	SetPedDefaultComponentVariation(PlayerPedId())
	ClearAllPedProps(PlayerPedId())
	if GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01") then
        SetPedComponentVariation(PlayerPedId(),1,-1,0,2)
        SetPedComponentVariation(PlayerPedId(),5,-1,0,2)
        SetPedComponentVariation(PlayerPedId(),7,20,0,2)
        SetPedComponentVariation(PlayerPedId(),3,0,0,2)
        SetPedComponentVariation(PlayerPedId(),4,26,6,2)
        SetPedComponentVariation(PlayerPedId(),8,15,0,2)
        SetPedComponentVariation(PlayerPedId(),6,8,2,2)
        SetPedComponentVariation(PlayerPedId(),11,208,22,2)
        SetPedComponentVariation(PlayerPedId(),9,-1,0,2)
        SetPedComponentVariation(PlayerPedId(),10,-1,0,2)
        SetPedPropIndex(PlayerPedId(),2,-1,0,2)
        SetPedPropIndex(PlayerPedId(),6,-1,0,2)
        SetPedPropIndex(PlayerPedId(),7,-1,0,2)
    else
        SetPedComponentVariation(PlayerPedId(),1,-1,0,2)
        SetPedComponentVariation(PlayerPedId(),5,-1,0,2)
        SetPedComponentVariation(PlayerPedId(),7,86,0,2)
        SetPedComponentVariation(PlayerPedId(),3,14,0,2)
        SetPedComponentVariation(PlayerPedId(),4,87,0,2)
        SetPedComponentVariation(PlayerPedId(),8,6,0,2)
        SetPedComponentVariation(PlayerPedId(),6,4,0,2)
        SetPedComponentVariation(PlayerPedId(),11,212,4,2)
        SetPedComponentVariation(PlayerPedId(),9,-1,0,2)
        SetPedComponentVariation(PlayerPedId(),10,-1,0,2)
        SetPedPropIndex(PlayerPedId(),2,-1,0,2)
        SetPedPropIndex(PlayerPedId(),6,-1,0,2)
        SetPedPropIndex(PlayerPedId(),7,-1,0,2)
    end
end

function changeGender(model)
	local mhash = GetHashKey(model)
	while not HasModelLoaded(mhash) do
		RequestModel(mhash)
		Citizen.Wait(10)
	end

	if HasModelLoaded(mhash) then
		SetPlayerModel(PlayerId(),mhash)
		SetPedMaxHealth(PlayerPedId(),400)
		SetEntityHealth(PlayerPedId(),400)
		SetModelAsNoLongerNeeded(mhash)
	end
end

RegisterNUICallback('cDone',function(data,cb)
	SetNuiFocus(isInCharacterMode, isInCharacterMode)
	SendNUIMessage({ CharacterMode = not isInCharacterMode, CharacterMode2 = isInCharacterMode, CharacterMode3 = not isInCharacterMode })
end)

RegisterNUICallback('BackPart1', function(data,cb)
	SetNuiFocus(isInCharacterMode, isInCharacterMode)
	SendNUIMessage({ CharacterMode = isInCharacterMode, CharacterMode2 = not isInCharacterMode, CharacterMode3 = not isInCharacterMode })
end)

RegisterNUICallback('cDonePart2', function(data,cb)
	SetNuiFocus(isInCharacterMode, isInCharacterMode)
	SendNUIMessage({ CharacterMode = not isInCharacterMode, CharacterMode2 = not isInCharacterMode, CharacterMode3 = isInCharacterMode })
end)

RegisterNUICallback('BackPart2', function(data,cb)
	SetNuiFocus(isInCharacterMode, isInCharacterMode)
	SendNUIMessage({ CharacterMode = not isInCharacterMode, CharacterMode2 = isInCharacterMode, CharacterMode3 = not isInCharacterMode })
end)

RegisterNUICallback('cDoneSave',function(data,cb)
	isInCharacterMode = false
	SetNuiFocus(isInCharacterMode,isInCharacterMode)
	SendNUIMessage({ 'manageVisibility',false })
	if GetEntityModel(PlayerPedId()) == GetHashKey("mp_m_freemode_01") then
        SetPedComponentVariation(PlayerPedId(),1,-1,0,2)
        SetPedComponentVariation(PlayerPedId(),5,-1,0,2)
        SetPedComponentVariation(PlayerPedId(),7,20,0,2)
        SetPedComponentVariation(PlayerPedId(),3,0,0,2)
        SetPedComponentVariation(PlayerPedId(),4,26,6,2)
        SetPedComponentVariation(PlayerPedId(),8,15,0,2)
        SetPedComponentVariation(PlayerPedId(),6,8,2,2)
        SetPedComponentVariation(PlayerPedId(),11,208,22,2)
        SetPedComponentVariation(PlayerPedId(),9,-1,0,2)
        SetPedComponentVariation(PlayerPedId(),10,-1,0,2)
        SetPedPropIndex(PlayerPedId(),2,-1,0,2)
        SetPedPropIndex(PlayerPedId(),6,-1,0,2)
        SetPedPropIndex(PlayerPedId(),7,-1,0,2)
    else
        SetPedComponentVariation(PlayerPedId(),1,-1,0,2)
        SetPedComponentVariation(PlayerPedId(),5,-1,0,2)
        SetPedComponentVariation(PlayerPedId(),7,86,0,2)
        SetPedComponentVariation(PlayerPedId(),3,14,0,2)
        SetPedComponentVariation(PlayerPedId(),4,87,0,2)
        SetPedComponentVariation(PlayerPedId(),8,6,0,2)
        SetPedComponentVariation(PlayerPedId(),6,4,0,2)
        SetPedComponentVariation(PlayerPedId(),11,212,4,2)
        SetPedComponentVariation(PlayerPedId(),9,-1,0,2)
        SetPedComponentVariation(PlayerPedId(),10,-1,0,2)
        SetPedPropIndex(PlayerPedId(),2,-1,0,2)
        SetPedPropIndex(PlayerPedId(),6,-1,0,2)
        SetPedPropIndex(PlayerPedId(),7,-1,0,2)
    end

	SetEntityCoordsNoOffset(PlayerPedId(),-279.4,-1914.82,29.95,true,true,true)
	SetEntityHeading(PlayerPedId(),f(71.68))

	local characterNome = data.name 
    local characterSobrenome = data.lastName 
    local characterAge = tonumber(data.age) or 0

    if 1 > #characterNome then 
        TriggerEvent("nyo_notify", "#FFA500","Importante", "O nome do personagem precisa ser maior", 5000)
        return 
    end

    if 1 > #characterSobrenome then 
        TriggerEvent("nyo_notify", "#FFA500","Importante", "O sobrenome do personagem precisa ser maior", 5000)
        return 
    end
    
    if 18 > characterAge or 100 < characterAge then 
        TriggerEvent("nyo_notify", "#FFA500","Importante", "Idade incorreta", 5000)
        return
    end
	StartFade()
	vSERVER.finishedCharacter(characterNome,characterSobrenome,characterAge,currentCharacterMode)
	cb(true)

	Wait(5000)

	EndFade()
	SetEntityInvincible(PlayerPedId(),false)
	SetEntityVisible(PlayerPedId(),true)
	FreezeEntityPosition(PlayerPedId(),false)

	SetCamActive(cam,false)
	StopCamPointing(cam)
	RenderScriptCams(0,0,0,0,0,0)
	SetFocusEntity(PlayerPedId())
end)

local getCharacterDrawable = function(part)
	if part == 12 then
		return tonumber(GetNumberOfPedDrawableVariations(PlayerPedId(),2))
	elseif part == -1 then
		return tonumber(GetNumberOfPedDrawableVariations(PlayerPedId(),0))
	elseif part == -2 then
		return 64
	else
		return tonumber(GetNumHeadOverlayValues(part))
	end
end

local getCharacterDrawableTextures = function(part)
	if part == -1 then
		return tonumber(GetNumHairColors())
	else
		return 64
	end
end

RegisterNUICallback("getGenderData", function(data, cb)
    local maxHair = getCharacterDrawable(12)
    local maxEyesBrows = getCharacterDrawable(2)
    local maxBeard = getCharacterDrawable(1)
    local maxBlush = getCharacterDrawable(5)
    local maxChest = getCharacterDrawable(10)
    local maxLipstick = getCharacterDrawable(8)
    local maxBlemishes = getCharacterDrawable(0)
    local maxAgeing = getCharacterDrawable(3)
    local maxComplexion = getCharacterDrawable(6)
    local maxSundamage = getCharacterDrawable(7)
    local maxFreckles = getCharacterDrawable(9)
    local maxMakeup = getCharacterDrawable(4)
    
    cb({
		{ optionName = "Cabelo", optionId = "hairModel", category = 'hair',min=0,max=maxHair,step=1 },
		{ optionName = "Sombrancelha", optionId = "eyebrowsModel", category = 'hair',min=0,max=maxEyesBrows,step=1 },
		{ optionName = "Barba", optionId = "beardModel", category = 'beard',min=0,max=maxBeard,step=1 },
		{ optionName = "Blush", optionId = "blushModel", category = 'make',min=-1,max=maxBlush,step=1 },
		{ optionName = "Pelo Corporal", optionId = "chestModel", category = 'beard',min=-1,max=maxChest,step=1 },
		{ optionName = "Batom", optionId = "lipstickModel", category = 'make',min=-1,max=maxLipstick,step=1 },
		{ optionName = "Manchas", optionId = "blemishesModel", category = 'make',min=-1,max=maxBlemishes,step=1 },
		{ optionName = "Envelhecimento", optionId = "ageingModel", category = 'make',min=-1,max=maxAgeing,step=1 },
		{ optionName = "Aspecto", optionId = "complexionModel", category = 'make',min=-1,max=maxComplexion,step=1 },
		{ optionName = "Pele", optionId = "sundamageModel", category = 'make',min=-1,max=maxSundamage,step=1 },
		{ optionName = "Sardas", optionId = "frecklesModel", category = 'make',min=-1,max=maxFreckles,step=1 },
		{ optionName = "Maquiagem", optionId = "makeupModel", category = 'make',min=-1,max=maxMakeup,step=1 },
    })
end)


RegisterNUICallback('cChangeHeading',function(data,cb)
	SetEntityHeading(PlayerPedId(),f(data.camRotation))
	cb('ok')
end)

RegisterNUICallback('ChangeGender',function(data,cb)
	currentCharacterMode.gender = data.gender
	if data.gender == 1 then
		changeGender("mp_f_freemode_01")
	else
		changeGender("mp_m_freemode_01")
	end
	refreshDefaultCharacter()
	TaskUpdateSkinOptions()
	TaskUpdateFaceOptions()
	TaskUpdateHeadOptions()
	cb('ok')
end)

RegisterNUICallback('UpdateSkinOptions',function(data,cb)
	currentCharacterMode.fathersID = data.fathersID or currentCharacterMode.fathersID
	currentCharacterMode.mothersID = data.mothersID or currentCharacterMode.mothersID
	currentCharacterMode.skinColor = data.skinColor or currentCharacterMode.skinColor
	currentCharacterMode.shapeMix = data.shapeMix or currentCharacterMode.shapeMix

	TaskUpdateSkinOptions()
	cb('ok')
end)

function TaskUpdateSkinOptions()
	local data = currentCharacterMode
	SetPedHeadBlendData(PlayerPedId(),data.fathersID,data.mothersID,0,data.skinColor,data.skinColor2,0,f(data.shapeMix),0,0,false)
end

RegisterNUICallback('UpdateFaceOptions',function(data,cb)
	currentCharacterMode.eyesColor = data.eyesColor or currentCharacterMode.eyesColor
	currentCharacterMode.eyebrowsHeight = data.eyebrowsHeight or currentCharacterMode.eyebrowsHeight
	currentCharacterMode.eyebrowsWidth = data.eyebrowsWidth or currentCharacterMode.eyebrowsWidth
	currentCharacterMode.noseWidth = data.noseWidth or currentCharacterMode.noseWidth
	currentCharacterMode.noseHeight = data.noseHeight or currentCharacterMode.noseHeight
	currentCharacterMode.noseLength = data.noseLength or currentCharacterMode.noseLength
	currentCharacterMode.noseBridge = data.noseBridge or currentCharacterMode.noseBridge
	currentCharacterMode.noseTip = data.noseTip or currentCharacterMode.noseTip
	currentCharacterMode.noseShift = data.noseShift or currentCharacterMode.noseShift
	currentCharacterMode.cheekboneHeight = data.cheekboneHeight or currentCharacterMode.cheekboneHeight
	currentCharacterMode.cheekboneWidth = data.cheekboneWidth or currentCharacterMode.cheekboneWidth
	currentCharacterMode.cheeksWidth = data.cheeksWidth or currentCharacterMode.cheeksWidth
	currentCharacterMode.lips = data.lips or currentCharacterMode.lips
	currentCharacterMode.jawWidth = data.jawWidth or currentCharacterMode.jawWidth
	currentCharacterMode.jawHeight = data.jawHeight or currentCharacterMode.jawHeight
	currentCharacterMode.chinLength = data.chinLength or currentCharacterMode.chinLength
	currentCharacterMode.chinPosition = data.chinPosition or currentCharacterMode.chinPosition
	currentCharacterMode.chinWidth = data.chinWidth or currentCharacterMode.chinWidth
	currentCharacterMode.chinShape = data.chinShape or currentCharacterMode.chinShape
	currentCharacterMode.neckWidth = data.neckWidth or currentCharacterMode.neckWidth
	TaskUpdateFaceOptions()
	cb('ok')
end)

function TaskUpdateFaceOptions()
	local ped = PlayerPedId()
	local data = currentCharacterMode

	-- Olhos
	SetPedEyeColor(ped,data.eyesColor)
	-- Sobrancelha
	SetPedFaceFeature(ped,6,data.eyebrowsHeight)
	SetPedFaceFeature(ped,7,data.eyebrowsWidth)
	-- Nariz
	SetPedFaceFeature(ped,0,data.noseWidth)
	SetPedFaceFeature(ped,1,data.noseHeight)
	SetPedFaceFeature(ped,2,data.noseLength)
	SetPedFaceFeature(ped,3,data.noseBridge)
	SetPedFaceFeature(ped,4,data.noseTip)
	SetPedFaceFeature(ped,5,data.noseShift)
	-- Bochechas
	SetPedFaceFeature(ped,8,data.cheekboneHeight)
	SetPedFaceFeature(ped,9,data.cheekboneWidth)
	SetPedFaceFeature(ped,10,data.cheeksWidth)
	-- Boca/Mandibula
	SetPedFaceFeature(ped,12,data.lips)
	SetPedFaceFeature(ped,13,data.jawWidth)
	SetPedFaceFeature(ped,14,data.jawHeight)
	-- Queixo
	SetPedFaceFeature(ped,15,data.chinLength)
	SetPedFaceFeature(ped,16,data.chinPosition)
	SetPedFaceFeature(ped,17,data.chinWidth)
	SetPedFaceFeature(ped,18,data.chinShape)
	-- Pescoço
	SetPedFaceFeature(ped,19,data.neckWidth)
end

RegisterNUICallback('UpdateHeadOptions',function(data,cb)
	currentCharacterMode.hairModel = data.hairModel or currentCharacterMode.hairModel
	currentCharacterMode.firstHairColor = data.firstHairColor or currentCharacterMode.firstHairColor
	currentCharacterMode.secondHairColor = data.secondHairColor or currentCharacterMode.secondHairColor
	currentCharacterMode.eyebrowsModel = data.eyebrowsModel or currentCharacterMode.eyebrowsModel
	currentCharacterMode.eyebrowsColor = data.eyebrowsColor or currentCharacterMode.eyebrowsColor
	TaskUpdateHeadOptions()
	cb('ok')
end)

RegisterNUICallback('UpdateBeardOptions',function(data,cb)
	currentCharacterMode.beardModel = data.beardModel or currentCharacterMode.beardModel
	currentCharacterMode.beardColor = data.beardColor or currentCharacterMode.beardColor
	currentCharacterMode.chestModel = data.chestModel or currentCharacterMode.chestModel
	currentCharacterMode.chestColor = data.chestColor or currentCharacterMode.chestColor

	TaskUpdateBeardOptions()
	cb('ok')
end)

RegisterNUICallback('UpdateMakeOptions',function(data,cb)
	currentCharacterMode.blushModel = data.blushModel or currentCharacterMode.blushModel
	currentCharacterMode.blushColor = data.blushColor or currentCharacterMode.blushColor
	currentCharacterMode.lipstickModel = data.lipstickModel or currentCharacterMode.lipstickModel
	currentCharacterMode.lipstickColor = data.lipstickColor or currentCharacterMode.lipstickColor
	currentCharacterMode.blemishesModel = data.blemishesModel or currentCharacterMode.blemishesModel
	currentCharacterMode.ageingModel = data.ageingModel or currentCharacterMode.ageingModel
	currentCharacterMode.complexionModel = data.complexionModel or currentCharacterMode.complexionModel
	currentCharacterMode.sundamageModel = data.sundamageModel or currentCharacterMode.sundamageModel
	currentCharacterMode.frecklesModel = data.frecklesModel or currentCharacterMode.frecklesModel
	currentCharacterMode.makeupModel = data.makeupModel or currentCharacterMode.makeupModel
	
	TaskUpdateMakeOptions()
	cb('ok')
end)

function TaskUpdateHeadOptions()
	local ped = PlayerPedId()
	local data = currentCharacterMode
	-- Cabelo
	SetPedComponentVariation(ped,2,data.hairModel,0,0)
	SetPedHairColor(ped,data.firstHairColor,data.secondHairColor)
	-- Sobracelha 
	SetPedHeadOverlay(ped,2,data.eyebrowsModel,0.99)
	SetPedHeadOverlayColor(ped,2,1,data.eyebrowsColor,data.eyebrowsColor)
	-- Barba
	SetPedHeadOverlay(ped,1,data.beardModel,0.99)
	SetPedHeadOverlayColor(ped,1,1,data.beardColor,data.beardColor)
	-- Pelo Corporal
	SetPedHeadOverlay(ped,10,data.chestModel,0.99)
	SetPedHeadOverlayColor(ped,10,1,data.chestColor,data.chestColor)
	-- Blush
	SetPedHeadOverlay(ped,5,data.blushModel,0.99)
	SetPedHeadOverlayColor(ped,5,2,data.blushColor,data.blushColor)
	-- Battom
	SetPedHeadOverlay(ped,8,data.lipstickModel,0.99)
	SetPedHeadOverlayColor(ped,8,2,data.lipstickColor,data.lipstickColor)
	-- Manchas
	SetPedHeadOverlay(ped,0,data.blemishesModel,0.99)
	SetPedHeadOverlayColor(ped,0,0,0,0)
	-- Envelhecimento
	SetPedHeadOverlay(ped,3,data.ageingModel,0.99)
	SetPedHeadOverlayColor(ped,3,0,0,0)
	-- Aspecto
	SetPedHeadOverlay(ped,6,data.complexionModel,0.99)
	SetPedHeadOverlayColor(ped,6,0,0,0)
	-- Pele
	SetPedHeadOverlay(ped,7,data.sundamageModel,0.99)
	SetPedHeadOverlayColor(ped,7,0,0,0)
	-- Sardas
	SetPedHeadOverlay(ped,9,data.frecklesModel,0.99)
	SetPedHeadOverlayColor(ped,9,0,0,0)
	-- Maquiagem
	SetPedHeadOverlay(ped,4,data.makeupModel,0.99)
	SetPedHeadOverlayColor(ped,4,0,0,0)
end

function TaskUpdateBeardOptions()
	local ped = PlayerPedId()
	local data = currentCharacterMode

	SetPedHeadOverlay(ped,1,data.beardModel,0.99)
	SetPedHeadOverlayColor(ped,1,1,data.beardColor,data.beardColor)

	SetPedHeadOverlay(ped,10,data.chestModel,0.99)
	SetPedHeadOverlayColor(ped,10,1,data.chestColor,data.chestColor)
end

function TaskUpdateMakeOptions()
	local ped = PlayerPedId()
	local data = currentCharacterMode

	SetPedHeadOverlay(ped,5,data.blushModel,0.99)
	SetPedHeadOverlayColor(ped,5,2,data.blushColor,data.blushColor)
	-- Battom
	SetPedHeadOverlay(ped,8,data.lipstickModel,0.99)
	SetPedHeadOverlayColor(ped,8,2,data.lipstickColor,data.lipstickColor)
	-- Manchas
	SetPedHeadOverlay(ped,0,data.blemishesModel,0.99)
	SetPedHeadOverlayColor(ped,0,0,0,0)
	-- Envelhecimento
	SetPedHeadOverlay(ped,3,data.ageingModel,0.99)
	SetPedHeadOverlayColor(ped,3,0,0,0)
	-- Aspecto
	SetPedHeadOverlay(ped,6,data.complexionModel,0.99)
	SetPedHeadOverlayColor(ped,6,0,0,0)
	-- Pele
	SetPedHeadOverlay(ped,7,data.sundamageModel,0.99)
	SetPedHeadOverlayColor(ped,7,0,0,0)
	-- Sardas
	SetPedHeadOverlay(ped,9,data.frecklesModel,0.99)
	SetPedHeadOverlayColor(ped,9,0,0,0)
	-- Maquiagem
	SetPedHeadOverlay(ped,4,data.makeupModel,0.99)
	SetPedHeadOverlayColor(ped,4,0,0,0)
end