-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
local checkHouse = {}

extraHouses = { 
	["SPACE04"] = { maxMoradores = 5, chestWeight = 5000 }
}


function cO.checkWay(houseName,checkOwner)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local checkConsult = exports["oxmysql"]:executeSync("SELECT * FROM characters_wayhomes WHERE character_id = ? AND name = ?",{user_id,houseName})
		if checkConsult[1] then 
			if checkOwner then 
				local getAcess = (checkConsult[1]["owner"] == 1) 
				if getAcess then 
					checkHouse[user_id] = houseName
					return true 
				end
				return false  
			end
			return true 
		end
		return false 
	end
end

RegisterServerEvent("homes:extraHomes",function(action)
	local source = source 
	local user_id = vRP.getUserId(source)
	checkHouse[user_id] = "SPACE04"
	if user_id and checkHouse[user_id] then
		local options = { 
			["newResident"] = { function(user_id,homeName) 
				checkHouse[user_id] = nil
				local nplayer = vRP.prompt(source, "Insira o passaporte que deseja adicionar em sua residência.","0")
				if nplayer and nplayer ~= "" and parseInt(nplayer) > 0 and vRP.getUserSource(parseInt(nplayer))  then 
					local nuser_id = parseInt(nplayer)
					local homesCount = exports["oxmysql"]:executeSync("SELECT COUNT(*) as qtd FROM characters_wayhomes WHERE name = @name",{ name = homeName })
					if homesCount[1]["qtd"] >= extraHouses[homeName]["maxMoradores"] then
						TriggerClientEvent("Notify",source,"negado","Atingiu o máximo de moradores.",5000)
						return
					end

					local identity = vRP.getUserIdentity(nuser_id)
					local newConsult = exports["oxmysql"]:executeSync("SELECT * FROM characters_wayhomes WHERE character_id = ? AND name = ?",{nuser_id,homeName})
					if newConsult[1] then
						TriggerClientEvent("Notify",source,"importante","<b>"..identity["name"].." "..identity["firstname"].."</b> já pertence a residência.",5000)
					else
						exports["oxmysql"]:execute("INSERT INTO characters_wayhomes(character_id,name,owner,time) VALUES(@id,@name,0,0)",{ id = nuser_id, name = homeName })
						TriggerClientEvent("Notify",source,"sucesso","Adicionado o(a) <b>"..identity["name"].." "..identity["firstname"].."</b> a residência.",5000)
					end
				end
			end },
			["remResident"] = { function(user_id,homeName)  
				checkHouse[user_id] = nil
				local nplayer = vRP.prompt(source, "Insira o passaporte que deseja remover da sua residência.","0")
				if nplayer and nplayer ~= "" and parseInt(nplayer) > 0 and vRP.getUserSource(parseInt(nplayer)) then 
					local nuser_id = parseInt(nplayer)
					local newConsult = exports["oxmysql"]:executeSync("SELECT * FROM characters_wayhomes WHERE character_id = ? AND name = ?",{nuser_id,homeName})
					if newConsult[1] then
						local identity = vRP.getUserIdentity(nuser_id)
						if newConsult[1] then
							exports["oxmysql"]:execute("DELETE FROM characters_wayhomes WHERE name = @name AND character_id = @user_id",{ user_id = nuser_id, name = homeName })
							TriggerClientEvent("Notify",source,"sucesso","Removido o(a) <b>"..identity["name"].." "..identity["firstname"].."</b> da residência.",5000)
						else
							TriggerClientEvent("Notify",source,"negado","Não foi possível encontrar o passaporte <b>"..vRP.format(nuser_id).."</b> na residência.",5000)
						end
					else
						TriggerClientEvent("Notify",source,"negado","Passaporte inválido.",5000)
					end
				end
			end }
		}

		if options[action] then
			TriggerClientEvent("dynamic:closeSystem2", source)
			options[action][1](user_id,checkHouse[user_id])
		end
		

	end
end)


Citizen.CreateThread( function()
	local extraHomes = exports["oxmysql"]:executeSync("SELECT * FROM characters_wayhomes WHERE time > 0 AND owner = 1")
	for k,v in pairs(extraHomes) do 
		if parseInt(os.time()) >= parseInt(v["time"] + 24 * 35 * 60 * 60) then
			exports["oxmysql"]:execute("DELETE FROM vrp_srv_data WHERE dkey = ?",{"chest:"..v["name"]})
			exports["oxmysql"]:execute("DELETE FROM characters_wayhomes WHERE name = ?",{ v["name"] })
		end
	end
end)
