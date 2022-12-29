    local model =  'mp_m_freemode_01'
    local spawncds = vector4(-826.0,-112.99,27.99,161.57)
    local spawnLocations =  nil 

    CreateThread(function()
        if not LocalPlayer.state.loggedIn then

            local plyid = PlayerId()

            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(10)
            end
            SetPlayerModel(plyid,model)
            SetModelAsNoLongerNeeded(model)

            local ped = PlayerPedId()
            LocalPlayer.state.ped = ped
            SetEntityCoordsNoOffset(ped,spawncds.x,spawncds.y,spawncds.z, false, false, false, true)
            SetEntityHeading(ped,spawncds.w)

            FreezeEntityPosition(ped,true)
            SetEntityInvincible(ped,true)
            SetEntityCollision(ped,false)
            SetEntityVisible(ped,false)
            SetPlayerControl(plyid,false,false)
            ClearPedTasksImmediately(ped)
            ClearPlayerWantedLevel(plyid)

            RequestCollisionAtCoord(spawncds.x,spawncds.y,spawncds.z)
            local time = GetGameTimer()
            while (not HasCollisionLoadedAroundEntity(ped) and (GetGameTimer() - time) < 5000) do
                Wait(10)
            end

            DoScreenFadeOut(1000)
            Wait(1000)
            ShutdownLoadingScreen()
            Wait(100)
            DoScreenFadeIn(1000)

            FreezeEntityPosition(ped,false)
            SetEntityInvincible(ped,false)
            SetEntityVisible(ped,true)
            SetEntityCollision(ped,true)
            SetPlayerControl(plyid,true,false)

            LocalPlayer.state.loggedIn = true
            
            TriggerEvent("playerSpawned")
        end
    end)
