
_PlayerPedId = nil
selecting = false
cam = nil
modelHash = GetHashKey("brioso")
vehicle = nil

setGarage = function(id,type)
    local state     = 0
    local vagas     = {} 
    local startPos  = {}
    selecting = true

    CreateThread(function() 
        while selecting do 
            _PlayerPedId = PlayerPedId()
            local ui = GetMinimapAnchor() 
            if state == 0 then 
                drawTxt2(ui.right_x+0.0015,ui.bottom_y-0.060,1.0,1.0,0.45,"PRESSIONE ~r~[E]~w~ PARA ESCOLHER O LOCAL DA GARAGEM",255,255,255,215)            
                 drawTxt2(ui.right_x+0.0015,ui.bottom_y-0.030,1.0,1.0,0.45,"PRESSIONE ~r~[F7]~w~ PARA CANCELAR",255,255,255,215)            
            else 
                drawTxt2(ui.right_x+0.0015,ui.bottom_y-0.060,1.0,1.0,0.45,"POSICIONE O VEÍCULO NA VAGA DESEJADA",255,255,255,215)            
                drawTxt("PRESSIONE ~r~[E]~w~ PARA CONFIRMAR",4,0.5,0.8,0.45,255,255,255,215)           
                drawTxt2(ui.right_x+0.0015,ui.bottom_y-0.030,1.0,1.0,0.35,"VAGAS SELECIONADAS: ~r~"..#vagas.."/2",255,255,255,215)           
                if #vagas > 0 then 
                    DrawCustomMarker(1, vagas[1].pos.x,vagas[1].pos.y,vagas[1].pos.z-0.7, 0, 2.0, 2.0, 1.0, {255, 255, 255, 100}, 0)
                    
                end
            end

            -- cam check 

            if state == 1 and cam and DoesCamExist(cam)  then 
                local vehCoords = GetEntityCoords(vehicle)
                if#(vehCoords - GetEntityCoords(_PlayerPedId)) > 30.0 then 
                    TriggerEvent("Notify", "negado","A vaga não pode ser tão longe da garagem!")
                    SetEntityCoords(vehicle, startPos)
                else 
                    SetCamCoord(cam,vehCoords.x,vehCoords.y,vehCoords.z+8.0)
                end
            end

            if IsControlJustPressed(0, 38) then 
                if state == 0 then 
                    startPos = GetEntityCoords(_PlayerPedId)
                    state = 1 
                    RequestModel(modelHash)
                    while not HasModelLoaded(modelHash) do
                        Wait(10)
                    end
                    local f,r,_,cds = GetEntityMatrix(_PlayerPedId)
                    vehicle = CreateVehicle(modelHash, cds+r*0.3, GetEntityHeading(_PlayerPedId), false, false)
                    createCam()
                    SetEntityAlpha(vehicle, 200, false)
                    SetEntityCollision(vehicle, true, false)
                    SetEntityNoCollisionEntity(
                    vehicle,_PlayerPedId,false
                    );

                else 
                    PlaySound(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 0, 0, 1)

                   local pos,heading= GetEntityCoords(vehicle),GetEntityHeading(vehicle)
                   table.insert(vagas,{pos = { x = pos.x, y = pos.y, z = pos.z}, h = heading })
                   if #vagas == 2 then
                    leaveGarageSet(id,type,{vagas = vagas, spawn = startPos }) 
                   end
                end
            end
            DisableControlAction(0, 34)
            DisableControlAction(0, 32)
            DisableControlAction(0, 9)
            DisableControlAction(0, 22)
            DisableControlAction(0, 33)

            if IsDisabledControlPressed(0, 22) --[[ jump]] then 
                SetVehicleForwardSpeed(vehicle, 0.0)
            end

            if IsDisabledControlPressed(0, 32) --[[ frente]] then 
                SetVehicleForwardSpeed(vehicle, 3.0)
                TaskVehicleTempAction(_PlayerPedId, vehicle, 23, 1.0)
            end

            
            if IsDisabledControlPressed(0, 33) --[[ frente]] then 
                SetVehicleForwardSpeed(vehicle, -3.0)
                TaskVehicleTempAction(_PlayerPedId, vehicle, 23, 1.0)

            end

            if IsDisabledControlPressed(0,34) then
                TaskVehicleTempAction(_PlayerPedId, vehicle, 10, 1.0)
          end

            if IsDisabledControlPressed(0,9) then
                TaskVehicleTempAction(_PlayerPedId, vehicle, 11, 1.0)
            end

            Wait(1)
        end
    end)
end


function createCam()
    cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
    SetCamActive(cam, true)
    RenderScriptCams(1, 1, 5000, 1, 1)
    local plyCds = GetEntityCoords(vehicle)
    SetCamCoord(cam,plyCds.x,plyCds.y,plyCds.z+8.0)
    SetCamFov(cam, 90.0)
    SetCamRot(cam, -90.0, 0.0, GetEntityHeading(vehicle), true)
    return
end

function deleteCam()
    RenderScriptCams(0, 1, 2000, 1, 1)
    DestroyCam(cam, false)
    return
end


function drawTxt2(x,y,width,height,scale,text,r,g,b,a)
    SetTextFont(4)
    SetTextScale(scale,scale)
    SetTextColour(r,g,b,a)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x,y)
end

function drawTxt(text,font,x,y,scale,r,g,b,a)
    SetTextFont(font)
    SetTextScale(scale,scale)
    SetTextColour(r,g,b,a)
    SetTextOutline()
    SetTextCentre(1)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x,y)
end
function GetMinimapAnchor()
    local safezone = GetSafeZoneSize()
    local safezone_x = 1.0 / 20.0
    local safezone_y = 1.0 / 20.0
    local aspect_ratio = GetAspectRatio(0)
    local res_x, res_y = GetActiveScreenResolution()
    local xscale = 1.0 / res_x
    local yscale = 1.0 / res_y
    local Minimap = {}
    Minimap.width = xscale * (res_x / (4 * aspect_ratio))
    Minimap.height = yscale * (res_y / 5.674)
    Minimap.left_x = xscale * (res_x * (safezone_x * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.bottom_y = 1.0 - yscale * (res_y * (safezone_y * ((math.abs(safezone - 1.0)) * 10)))
    Minimap.right_x = Minimap.left_x + Minimap.width
    Minimap.top_y = Minimap.bottom_y - Minimap.height
    Minimap.x = Minimap.left_x
    Minimap.y = Minimap.top_y
    Minimap.xunit = xscale
    Minimap.yunit = yscale
    return Minimap
end

function DrawCustomMarker(type, x, y, z, rotation, scaleX, scaleY, scaleZ, color, anim)
    DrawMarker(type, x, y, z, 0, 0, 0, 0, rotation, 0, scaleX, scaleY, scaleZ, color[1], color[2], color[3], color[4], anim, 0, 0, 0)
end
