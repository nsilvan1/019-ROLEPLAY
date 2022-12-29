local weapon_list = {}
local state_ready = false
local in_arena = false

function tvRP.playerStateReady(state)
	state_ready = state
end

local cachestate = {}
cachestate.firstcds = true
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10000)
		if not in_arena and IsPlayerPlaying(PlayerId()) and state_ready then		
			local coords = GetEntityCoords(PlayerPedId(),true)
			if cachestate.firstcds then 
			cachestate.cds = coords
			cachestate.firstcds = false
			end
			if ( #(coords - cachestate.cds) >= 3 ) then
			vRPserver._updatePos(coords.x, coords.y, coords.z)
			cachestate.cds = coords
			end
			local health = tvRP.getHealth()
			if health ~= cachestate.health then
			vRPserver._updateHealth(health)
			cachestate.health = health
			end
			local armour = tvRP.getArmour()
			if armour ~= cachestate.armour then
			vRPserver._updateArmor(armour)
			cachestate.armour = armour
			end
			local clothes = tvRP.getCustomization()
			if json.encode(clothes) ~= json.encode(cachestate.clothes) then
				vRPserver._updateCustomization(clothes)
				cachestate.clothes = clothes
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if not in_arena and IsPlayerPlaying(PlayerId()) and state_ready then
			local weapons = tvRP.getWeapons()
			if json.encode(weapons) ~= json.encode(cachestate.weapons) then
			vRPserver._updateWeapons(weapons)
			cachestate.weapons = weapons
			end
		end
	end
end)

RegisterNetEvent("mirtin_survival:updateArena")
AddEventHandler("mirtin_survival:updateArena", function(boolean)
	in_arena = boolean
end)

RegisterNetEvent('save:database')
AddEventHandler('save:database',function()
	if IsPlayerPlaying(PlayerId()) and state_ready then
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
		vRPserver._updatePos(x,y,z)
		vRPserver._updateHealth(tvRP.getHealth())
		vRPserver._updateWeapons(tvRP.getWeapons())
		vRPserver._updateCustomization(tvRP.getCustomization())
		vRPserver._updateArmor(tvRP.getArmour())
	end
end)

local weapon_types = {
	"WEAPON_NAVYREVOLVER",
	"WEAPON_MILITARYRIFLE",
	"WEAPON_HAZARDCAN",
	"WEAPON_GADGETPISTOL",
	"WEAPON_COMBATSHOTGUN",
	"WEAPON_CERAMICPISTOL",			   
	"GADGET_PARACHUTE",
	"WEAPON_KNIFE",
	"WEAPON_KNUCKLE",
	"WEAPON_NIGHTSTICK",
	"WEAPON_HAMMER",
	"WEAPON_BAT",
	"WEAPON_GOLFCLUB",
	"WEAPON_CROWBAR",
	"WEAPON_BOTTLE",
	"WEAPON_DAGGER",
	"WEAPON_HATCHET",
	"WEAPON_MACHETE",
	"WEAPON_FLASHLIGHT",
	"WEAPON_SWITCHBLADE",
	"WEAPON_POOLCUE",
	"WEAPON_PIPEWRENCH",
	"WEAPON_STONE_HATCHET",
	"WEAPON_WRENCH",
	"WEAPON_BATTLEAXE",
	"WEAPON_AUTOSHOTGUN",
	

	"WEAPON_GRENADE",
	"WEAPON_STICKYBOMB",
	"WEAPON_PROXMINE",
	"WEAPON_BZGAS",
	"WEAPON_SMOKEGRENADE",
	"WEAPON_MOLOTOV",
	"WEAPON_FIREEXTINGUISHER",
	"WEAPON_PETROLCAN",
	"WEAPON_CERAMICPISTOL",
	"WEAPON_MILITARYRIFLE",
	"WEAPON_GADGETPISTOL",
	"WEAPON_NAVYREVOLVER",
	"WEAPON_SNOWBALL",
	"WEAPON_FLARE",
	"WEAPON_BALL",
	

	"WEAPON_PISTOL",
	"WEAPON_PISTOL_MK2",
	"WEAPON_COMBATPISTOL",
	"WEAPON_APPISTOL",
	"WEAPON_REVOLVER",
	"WEAPON_REVOLVER_MK2",
	"WEAPON_DOUBLEACTION",
	"WEAPON_PISTOL50",
	"WEAPON_SNSPISTOL",
	"WEAPON_SNSPISTOL_MK2",
	"WEAPON_HEAVYPISTOL",
	"WEAPON_VINTAGEPISTOL",
	"WEAPON_STUNGUN",
	"WEAPON_FLAREGUN",
	"WEAPON_MARKSMANPISTOL",
	"WEAPON_RAYPISTOL",
	"WEAPON_HEAVYSNIPER_MK2",
	

	"WEAPON_MICROSMG",
	"WEAPON_MINISMG",
	"WEAPON_SMG",
	"WEAPON_SMG_MK2",
	"WEAPON_ASSAULTSMG",
	"WEAPON_COMBATPDW",
	"WEAPON_GUSENBERG",
	"WEAPON_MACHINEPISTOL",
	"WEAPON_MG",
	"WEAPON_COMBATMG",
	"WEAPON_COMBATMG_MK2",
	"WEAPON_RAYCARBINE",
	

	"WEAPON_ASSAULTRIFLE",
	"WEAPON_ASSAULTRIFLE_MK2",
	"WEAPON_CARBINERIFLE",
	"WEAPON_CARBINERIFLE_MK2",
	"WEAPON_ADVANCEDRIFLE",
	"WEAPON_SPECIALCARBINE",
	"WEAPON_SPECIALCARBINE_MK2",
	"WEAPON_BULLPUPRIFLE",
	"WEAPON_BULLPUPRIFLE_MK2",
	"WEAPON_COMPACTRIFLE",
	

	"WEAPON_PUMPSHOTGUN",
	"WEAPON_PUMPSHOTGUN_MK2",
	"WEAPON_SWEEPERSHOTGUN",
	"WEAPON_SAWNOFFSHOTGUN",
	"WEAPON_BULLPUPSHOTGUN",
	"WEAPON_ASSAULTSHOTGUN",
	"WEAPON_COMBATSHOTGUN",
	"WEAPON_MUSKET",
	"WEAPON_HEAVYSHOTGUN",
	"WEAPON_DBSHOTGUN",
	

	"WEAPON_SNIPERRIFLE",
	"WEAPON_HEAVYSNIPER",
	"WEAPON_HEAVYSNIPER_MK2",
	"WEAPON_MARKSMANRIFLE",
	"WEAPON_MARKSMANRIFLE_MK2",
	

	"WEAPON_GRENADELAUNCHER",
	"WEAPON_GRENADELAUNCHER_SMOKE",
	"WEAPON_RPG",
	"WEAPON_MINIGUN",
	"WEAPON_FIREWORK",
	"WEAPON_RAILGUN",
	"WEAPON_HOMINGLAUNCHER",
	"WEAPON_COMPACTLAUNCHER",
	"WEAPON_RAYMINIGUN",
	"WEAPON_PIPEBOMB"
}
function tvRP.getWeapons()
	local player = PlayerPedId()
	local ammo_types = {}
	local weapons = {}
	for k,v in pairs(weapon_types) do
		local hash = GetHashKey(v)
		if HasPedGotWeapon(player,hash) then
			local weapon = {}
			weapons[v] = weapon
			local atype = Citizen.InvokeNative(0x7FEAD38B326B9F74,player,hash)
			if ammo_types[atype] == nil then
				ammo_types[atype] = true
				weapon.ammo = GetAmmoInPedWeapon(player,hash)
			else
				weapon.ammo = 0
			end
		end
	end
	weapons = tvRP.legalWeaponsChecker(weapons)										
	return weapons
end

function tvRP.replaceWeapons(weapons)
	local old_weapons = tvRP.getWeapons()
	tvRP.giveWeapons(weapons,true)
	return old_weapons
end

function tvRP.giveWeapons(weapons,clear_before)
	local player = PlayerPedId()
	if clear_before then
		RemoveAllPedWeapons(player,true)
		weapon_list = {}		  
	end

	for k,weapon in pairs(weapons) do
		local hash = GetHashKey(k)
		local ammo = weapon.ammo or 0
		GiveWeaponToPed(player,hash,ammo,false)
		weapon_list[string.upper(k)] = weapon					 						 
	end
end

function tvRP.getWeaponsLegal()
									
	return weapon_list
end

function tvRP.legalWeaponsChecker(weapon)
	local source = source
	local weapon = weapon
	local weapons_legal = tvRP.getWeaponsLegal()
	local ilegal = false
	local weapons_ilegal = {}
	for v, b in pairs(weapon) do
	  if not weapon_list[string.upper(v)] then
		ilegal = true 
		table.insert(weapons_ilegal, {name=string.upper(v),ammo=b.ammo}) 														   
	  end
	end
	if ilegal then
		tvRP.giveWeapons(weapons_legal, true)
		weapon = weapons_legal
		TriggerServerEvent("LOG:ARMAS152", weapons_ilegal)									 
	end
	return weapon
end							   

function tvRP.setArmour(amount)	
	SetPedArmour(PlayerPedId(),amount)
end

function tvRP.getArmour()
	return GetPedArmour(PlayerPedId())
end

local function parse_part(key)
	if type(key) == "string" and string.sub(key,1,1) == "p" then
		return true,tonumber(string.sub(key,2))
	else
		return false,tonumber(key)
	end
end

function tvRP.getDrawables(part)
	local isprop, index = parse_part(part)
	if isprop then
		return GetNumberOfPedPropDrawableVariations(PlayerPedId(),index)
	else
		return GetNumberOfPedDrawableVariations(PlayerPedId(),index)
	end
end

function tvRP.getDrawableTextures(part,drawable)
	local isprop, index = parse_part(part)
	if isprop then
		return GetNumberOfPedPropTextureVariations(PlayerPedId(),index,drawable)
	else
		return GetNumberOfPedTextureVariations(PlayerPedId(),index,drawable)
	end
end

function tvRP.getCustomization()
	local ped = PlayerPedId()
	local custom = {}
	custom.modelhash = GetEntityModel(ped)

	for i = 0,20 do
		custom[i] = { GetPedDrawableVariation(ped,i),GetPedTextureVariation(ped,i),GetPedPaletteVariation(ped,i) }
	end

	for i = 0,10 do
		custom["p"..i] = { GetPedPropIndex(ped,i),math.max(GetPedPropTextureIndex(ped,i),0) }
	end
	return custom
end

function tvRP.setCustomization(custom)
	local r = async()
	Citizen.CreateThread(function()
		if custom then
			local ped = GetPlayerPed(-1)
			local mhash = nil

			if custom.modelhash then
				mhash = custom.modelhash
			elseif custom.model then
				mhash = GetHashKey(custom.model)
			end

			if mhash then
                local i = 0
                while not HasModelLoaded(mhash) and i < 10000 do
                    i = i + 1
                    RequestModel(mhash)
                    Citizen.Wait(10)
                end

                if HasModelLoaded(mhash) then
                    local weapons = tvRP.getWeapons()
                    local armour = GetPedArmour(ped)
                    local health = tvRP.getHealth()

                    SetPlayerModel(PlayerId(),mhash)
                    tvRP.setHealth(health)
                    tvRP.giveWeapons(weapons,true)
                    tvRP.setArmour(armour)
                    SetModelAsNoLongerNeeded(mhash)
                end
            end

			ped = GetPlayerPed(-1)
			SetPedMaxHealth(ped,400)

			for k,v in pairs(custom) do
				if k ~= "model" and k ~= "modelhash" then
					local isprop, index = parse_part(k)
					if isprop then
						if v[1] < 0 then
							ClearPedProp(ped,index)
						else
							SetPedPropIndex(ped,index,v[1],v[2],v[3] or 2)
						end
					else
						SetPedComponentVariation(ped,index,v[1],v[2],v[3] or 2)
					end
					TriggerEvent("nyoModule:barberUpdate", true)
					TriggerEvent("nyoModule:tattooUpdate", true)
				end
			end
		end
		r()
	end)
	return r:wait()
end