local nui = nil

local cancelando = false
RegisterNetEvent('cancelando')
AddEventHandler('cancelando',function(status)
	cancelando = status
end)

Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	if cfg.target then
		for k,v in pairs(cfg.localidades) do
			if v.nui == "atm" then	
				exports["target"]:AddCircleZone("Bank:"..k,vector3(v.x,v.y,v.z),1.00,{
					name = "Bank:"..k,
					heading = 3374176
				},{
					shop = v.nui,
					distance = 0.75,
					options = {
						{
							event = "bank:openSystem",
							label = "Caixa Eletrônico",
							tunnel = "client"
						}
					}
				})
			else
				exports["target"]:AddCircleZone("Bank:"..k,vector3(v.x,v.y,v.z),1.00,{
					name = "Bank:"..k,
					heading = 3374176
				},{
					shop = v.nui,
					distance = 0.75,
					options = {
						{
							event = "bank:openSystem",
							label = "Banco",
							tunnel = "client"
						}
					}
				})
			end
		end

		local props = {}
		for k,v in pairs(cfg.propsATM) do
			table.insert(props,GetHashKey(v))
		end
		exports["target"]:AddTargetModel(props,{
			options = {
				{
					event = "bank:openSystem",
					label = "Caixa Eletrônico",
					tunnel = "client"
				}
			},
			shop = "atm",
			distance = 0.75
		})
	else
		while true do
			local timeDistance = 1000
			local ped = PlayerPedId()
			if not IsPedInAnyVehicle(ped) and not cancelando then
				local coords = GetEntityCoords(ped)
				for k,v in pairs(cfg.localidades) do
					local distance = #(coords - vector3(v.x,v.y,v.z))
					if (distance <= 2 and v.nui == "banco") or (distance <= 0.4 and v.nui == "atm") then
						timeDistance = 5
						DrawText3D(v.x,v.y,v.z,"~g~E~w~   ABRIR")
						if IsControlJustPressed(1,38) then				
							SetNuiFocus(true,true)
							TransitionToBlurred(1000)
							SendNUIMessage({ action = "showMenu", nui = v.nui })
							if v.nui == "atm" then
								vRP._playAnim(false,{{"amb@prop_human_atm@male@base","base"}},true)
								nui = v.nui
							end
						end
					end
				end
			end
			Citizen.Wait(timeDistance)
		end
	end
end)
RegisterNetEvent("bank:openSystem")
AddEventHandler("bank:openSystem",function(bank)
	SetNuiFocus(true,true)
	TransitionToBlurred(1000)
	SendNUIMessage({ action = "showMenu", nui = bank[1] })
	if bank[5] == "atm" or bank[1] == "atm" then
		vRP._playAnim(false,{{"amb@prop_human_atm@male@base","base"}},true)
		nui = bank[5] or bank[1]
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANKCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("bankClose",function(data)
	SetNuiFocus(false,false)
	TransitionFromBlurred(1000)
	SendNUIMessage({ action = "hideMenu" })
	if nui == "atm" then
		vRP._playAnim(false,{{"amb@prop_human_atm@male@exit","exit"}},false)
		Citizen.Wait(4000)
		vRP._stopAnim()
	end
	nui = nil
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTBANK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestBank",function(data,cb)
	cb({ resultado = vRPSend.requestBank() })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTFINES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestFines",function(data,cb)
	local resultado = vRPSend.requestFines()
	while not resultado do
		resultado = vRPSend.requestFines()
		Citizen.Wait(10)
	end
	if resultado then
		cb({ resultado = resultado })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FINESPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("finesPayment",function(data)
	if data.id ~= nil then
		vRPSend.finesPayment(data.id,data.price)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSALARY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestMySalarys",function(data,cb)
	local resultado = vRPSend.requestMySalarys()
	while not resultado do
		resultado = vRPSend.requestMySalarys()
		Citizen.Wait(10)
	end
	if resultado then
		cb({ resultado = resultado })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SALARYPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("salaryRecipe",function(data)
	if data.id ~= nil then
		vRPSend.salaryPayment(data.id,data.price)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTINVOICES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestInvoices",function(data,cb)
	local resultado = vRPSend.requestInvoices()
	while not resultado do
		resultado = vRPSend.requestInvoices()
		Citizen.Wait(10)
	end

	if resultado then
		cb({ resultado = resultado })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTMYINVOICES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("requestMyInvoices",function(data,cb)
	local resultado = vRPSend.requestMyInvoices()
	while not resultado do
		resultado = vRPSend.requestMyInvoices()
		Citizen.Wait(10)
	end

	if resultado then
		cb({ resultado = resultado })
	end
end)

function vRPReceiver.returnotify(status,text)
	if status then
		PlaySoundFrontend(-1,"CONFIRM_BEEP","HUD_MINI_GAME_SOUNDSET")
	else
		PlaySoundFrontend(-1, "Hack_Failed", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS")
	end
	if text ~= nil then
		SendNUIMessage({ action = "notify", status = status, notify = text })
	end
end

RegisterNUICallback("notifysound",function(data)
	vRPReceiver.returnotify(data.status,nil)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVOICESPAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("invoicesPayment",function(data)
	if data.id ~= nil then
		vRPSend.invoicesPayment(data.id,data.price,data.nuser_id)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTDEPOSITO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("bankDeposit",function(data)
	if parseInt(data.deposito) > 0 then
		vRPSend.bankDeposit(data.deposito)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTDEPOSITO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("bankWithdraw",function(data)
	if parseInt(data.saque) > 0 then
		vRPSend.bankWithdraw(data.saque)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRANSFERIR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("bankTransfer",function(data)
	vRPSend.transferir(data.id,data.valor)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_PANK:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_bank:Update")
AddEventHandler("vrp_bank:Update",function(action)
	SendNUIMessage({ action = action })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECEIVESALARY
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(30*60000)
		TriggerServerEvent("Q_player:salary")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x,y,z,text)
	local onScreen,_x,_y = World3dToScreen2d(x,y,z)
	SetTextFont(4)
	SetTextScale(0.35,0.35)
	SetTextColour(255,255,255,255)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 400
	DrawRect(_x,_y+0.0125,0.01+factor,0.03,0,0,0,100)
end