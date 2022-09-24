local QBCore = exports['qb-core']:GetCoreObject()
local Player
local plyPed


RegisterNetEvent("ktrp-leoshop:client:player",function(player)
	Player = player
end)

RegisterNetEvent('ktrp-leoshop:client:buyShowroomVehicle', function(vehicle, plate)
    print("Vehicle Spawned")
    QBCore.Functions.SpawnVehicle(vehicle, function(veh)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        exports['LegacyFuel']:SetFuel(veh, 100)
        SetVehicleNumberPlateText(veh, plate)
        SetEntityHeading(veh, Config.SpawnLoc.w)
        SetEntityAsMissionEntity(veh, true, true)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        TriggerServerEvent("qb-vehicletuning:server:SaveVehicleProps", QBCore.Functions.GetVehicleProperties(veh))
    end, Config.SpawnLoc, true)
end)

RegisterNetEvent("ktrp-leoshop:client:returnPM",function(job)
	previewClose()
end)

RegisterNetEvent("ktrp-leoshop:client:previewVehicle",function(data)
    local plyPed = PlayerPedId()
    lastpos = GetEntityCoords(plyPed)
    --SetEntityCoords(plyPed, 453.16662, -1024.837, 28.514112)
    SetEntityVisible(plyPed, false)
    SetNuiFocus(true, true)
    changeCam()
    local pos = Config.viewcoords
	print("Preview"..data.spawnName)
    if DoesEntityExist(previewVeh) then
        DeleteEntity(previewVeh)
        while DoesEntityExist(previewVeh) do Wait(250) end
    end
    RequestModel(data.spawnName)
    while not HasModelLoaded(data.spawnName) do Wait(100) end
    previewVeh = CreateVehicle(data.spawnName, pos.x, pos.y, pos.z, 62.03, false, false)
    SetVehicleDirtLevel(previewVeh, 0)
    SetVehicleModKit(previewVeh, 0)
    SetVehicleExtra(previewVeh, 1)
    SetVehicleExtra(previewVeh, 2)
    TriggerEvent("ktrp-leoshop:client:previewMenu",data)

end)

function changeCam()
    DoScreenFadeOut(500)
    Wait(1000)
    if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    end
    SetCamActive(cam, true)
    SetCamRot(cam,vector3(-10.0,0.0, -155.999), true)
    SetCamFov(cam,80.0)
    SetCamCoord(cam, vector3(463.57, -1020.11, 28.6))
    PointCamAtCoord(cam, Config.viewcoords)
    RenderScriptCams(true, false, 2500.0, true, true)
    DoScreenFadeIn(1000)
    Wait(1000)
end

function previewClose()
    SetEntityCoords(PlayerPedId(), lastpos.x, lastpos.y, lastpos.z)
    SetEntityVisible(PlayerPedId(), true)
    DeleteEntity(previewVeh)
    DoScreenFadeOut(500)
    Wait(500)
    RenderScriptCams(false, false, 1, true, true)
    DestroyAllCams(true)
    SetNuiFocus(false, false)
    DoScreenFadeIn(500)
    Wait(500)
end