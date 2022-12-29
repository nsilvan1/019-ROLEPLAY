local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")

local vRP = Proxy.getInterface("vRP")
local GMServer = Tunnel.getInterface("gm")

local improvements = {}
local org_name, group, organization_members, is_mod, is_owner, user_id, money
local UIOpened = false

CreateThread(function()
    while not GMServer do Wait(500) end
    improvements = config.organizations
    for org, improvement in pairs(improvements) do
        for map, state in pairs(improvement) do
            if state then
                RequestIpl(map)
            else
                RemoveIpl(map) 
            end
        end
        GMServer.SyncIpls()
    end
end)

RegisterNetEvent('gm:setipl', function(iplname, state, org)
    if state then
        RequestIpl(iplname)
    else
        RemoveIpl(iplname) 
    end
    improvements[org][iplname] = state
end)

RegisterNetEvent("gm:openUI", function(_org_name, _group, _organization_members, _is_mod, _is_owner, _user_id, _money,_maxMembers,service)
    org_name, group, organization_members, is_mod, is_owner,  user_id, money = _org_name, _group, _organization_members, _is_mod, _is_owner,  _user_id, _money
    UIOpened = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        'openUI',
        {
            org_name = org_name,
            group = group,
            organization_members = organization_members,
            is_mod = is_mod,
            config = config,
            groups = config.organizations,
            is_owner = is_owner,
            user_id = user_id,
            improvements = improvements,
            money = money,
            maxMembers = config.organizations[org_name].maxMembers,
            service = service
        }
    })
end)

RegisterNUICallback('updade', function(data, cb)
    local success = GMServer.updade(_org_name, _group, _organization_members, _is_mod, _is_owner, _user_id, _money,maxMembers,service)
    org_name, group, organization_members, is_mod, is_owner,  user_id, money = _org_name, _group, _organization_members, _is_mod, _is_owner,  _user_id, _money

    cb({org_name = org_name,
    group = group,
    organization_members = organization_members,
    is_mod = is_mod,
    config = config,
    groups = GlobalState.GMGroups,
    is_owner = is_owner,
    user_id = user_id,
    improvements = improvements,
    money = money,
    maxMembers = maxMembers,
    service = service})
end)


RegisterNetEvent("gm:closeUI", function()
    SetNuiFocus(false, false)
    SendNUIMessage({
        'closeUI'
    })
end)

RegisterNUICallback("close", function(data, cb)
    if data.closeServer then
        TriggerServerEvent('gm:closeUI')
    end
    UIOpened = false
    level, xp, current_missions = nil, nil, nil
    SetNuiFocus(false, false)
    TransitionFromBlurred(1000)
    cb(true)
end)

RegisterNUICallback('invite-member', function(data, cb)
    if data.group ~= "-" then
        local success = GMServer.inviteMember(data.user_id, data.group)
        cb({success = true})
    end
    -- if success then 
    --     cb({success = success or false})
    -- end
end)

RegisterNUICallback("donate-money", function(data,cb)
    local success = GMServer.donateMoney(data.value)
    cb({success = success or false})
end)

RegisterNUICallback('promote', function(data,cb)
    local success, gName = GMServer.promote(data.user_id)
    cb { success = success or false, gName = gName }
end)

RegisterNUICallback('unpromote', function(data,cb)
    local success, gName = GMServer.unpromote(data.user_id)
    cb { success = success or false, gName = gName }
end)

RegisterNUICallback('demitido', function(data,cb)
    local success, gName = GMServer.demitido(data.user_id)
    cb { success = success or false, gName = gName }
end)

RegisterNUICallback('buy-map', function(data,cb)
    local success = GMServer.buyMap(data.id)
    cb { success = success or false }
end)
