local extraHomes = { 
	["SPACE04"] = {
		["vault"] = { -280.0,-722.52,125.47 },
		["wardrobe"] = { -280.0,-722.52,125.47 },
		["management"] = { -279.98, -723.11, 124.0 },
	},
	["SPACE05"] = {
		["vault"] = { -1721.93,381.61,89.74 },
		["wardrobe"] = { -1721.93,381.61,89.74 },
		["management"] = { -1721.93,381.61,89.74 },
	}, 
}

Citizen.CreateThread( function()
	while true do
		local timeDistance = 999 
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) and houseOpen == "" then 
			local coords = GetEntityCoords(ped)
			for k,v in pairs(extraHomes) do 
				local distance = #(coords - vec3(v["management"][1],v["management"][2],v["management"][3]))
				if distance <= 2 then 
					timeDistance = 4 
					DrawText3Ds(v["management"][1],v["management"][2],v["management"][3],"[~g~E~w~] - OPÇÕES")
					if IsControlJustPressed(0,38) and vSERVER.checkWay(k,true) then
						exports["dynamic"]:SubMenu("Gerenciamento","Funções da sua residência de luxo.","wayHome")
						exports["dynamic"]:AddButton("Adicionar","Adicione um morador em sua residência.","homes:extraHomes","newResident","wayHome",true)
						exports["dynamic"]:AddButton("Remover","Remova um morador de sua residência.","homes:extraHomes","remResident","wayHome",true)
					end
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)


RegisterCommand("bau",function(source,args,rawCommand)
	local ped = PlayerPedId()
	if not IsPedInAnyVehicle(ped) and houseOpen == "" then 
		local coords = GetEntityCoords(ped)
		for k,v in pairs(extraHomes) do 
			local distance = #(coords - vec3(v["vault"][1],v["vault"][2],v["vault"][3]))
			if distance <= 5 then 
				if vSERVER.checkWay(k) then 
					vSERVER.checkPermissions({homeName = k, homeInterfone = 0},true)
				end
			end
		end
	end
end)

RegisterCommand("roupas",function(source,args,rawCommand)
	local ped = PlayerPedId()
	if not IsPedInAnyVehicle(ped) and houseOpen == "" then 
		local coords = GetEntityCoords(ped)
		for k,v in pairs(extraHomes) do 
			local distance = #(coords - vec3(v["wardrobe"][1],v["wardrobe"][2],v["wardrobe"][3]))
			if distance <= 5 then 
				if vSERVER.checkWay(k) then 
					openClothes()
				end
			end
		end
	end
end)