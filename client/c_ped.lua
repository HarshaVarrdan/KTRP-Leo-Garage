local QBCore = exports['qb-core']:GetCoreObject()
local previewVeh
local Player

--[[RegisterNetEvent("OnResourceStart",function()
    print("KTRP_LEOGARAGE has been started")
	TriggerEvent("ktrp-leoshop:client:spawnped")        
end)]]--

    CreateThread(function()
        local PD_PedCoords = Config.PD_Ped.Coords
        local PD_PedHash = Config.PD_Ped.ModelHash
        local PD_PedModel = Config.PD_Ped.ModelName
        if not DoesEntityExist(PDGaragePed) then
            RequestModel( GetHashKey(PD_PedModel) )
            while ( not HasModelLoaded( GetHashKey(PD_PedModel) ) ) do
                Wait(1)
            end
            PDGaragePed = CreatePed(1, PD_PedHash, PD_PedCoords, true, true)
            FreezeEntityPosition(PDGaragePed, true)
            SetEntityInvincible(PDGaragePed, true)
            SetBlockingOfNonTemporaryEvents(PDGaragePed, true)
        end
        exports['qb-target']:AddTargetEntity(PDGaragePed, {
            options = {
                {
                    num = 1,
                    type = "client",
                    event = "ktrp-leoshop:client:pdJobCheck",
                    label = "PD Vehicle Shop",
                    icon = 'fa-regular fa-building',
                }
            },
            distance = 1.5
        })
     end)
	CreateThread(function()
        local EMS_PedCoords = Config.EMS_Ped.Coords
        local EMS_PedHash = Config.EMS_Ped.ModelHash
        local EMS_PedModel = Config.EMS_Ped.ModelName
        if not DoesEntityExist(PDGaragePed) then
            RequestModel( GetHashKey(EMS_PedModel) )
            while ( not HasModelLoaded( GetHashKey(EMS_PedModel) ) ) do
                Wait(1)
            end
            EMSGaragePed = CreatePed(1, EMS_PedHash, EMS_PedCoords, true, true)
            FreezeEntityPosition(EMSGaragePed, true)
            SetEntityInvincible(EMSGaragePed, true)
            SetBlockingOfNonTemporaryEvents(EMSGaragePed, true)
        end
        exports['qb-target']:AddTargetEntity(EMSGaragePed, {
            options = {
                {
                    num = 1,
                    type = "client",
                    event = "ktrp-leoshop:client:emsJobCheck",
                    label = "EMS Vehicle Shop",
                    icon = 'fa-regular fa-building',
                }
            },
            distance = 1.5
        })
    end)
	print("ktrp-leogarage Has been Started! Leo's Can buy you're Vehicles")

--end)



