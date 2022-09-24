local QBCore = exports['qb-core']:GetCoreObject()
local Player

RegisterNetEvent("ktrp-leoshop:client:pdJobCheck",function()
	TriggerServerEvent("ktrp-leoshop:server:pdJobCheck")
end)

RegisterNetEvent("ktrp-leoshop:client:emsJobCheck",function()
	TriggerServerEvent("ktrp-leoshop:server:emsJobCheck")
end)

RegisterNetEvent("ktrp-leoshop:client:sharePlayer",function(player)
    Player = player
    TriggerEvent("ktrp-leoshop:client:playerMenu",Player)
    TriggerEvent("ktrp-leoshop:client:player",Player)
    TriggerEvent("ktrp-leoshop:client:menu",Player.PlayerData.job)
end)

RegisterNetEvent("ktrp-leoshop:client:buyVehicle",function(data)
    TriggerServerEvent("ktrp-leoshop:server:buyLeoVehicle", data.vehdata,data.paymethod)
end)

