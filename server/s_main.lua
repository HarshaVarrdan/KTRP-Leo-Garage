local QBCore = exports['qb-core']:GetCoreObject()
local Player


local function GeneratePlate()
    local plate = QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(2)
    local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then
        return GeneratePlate()
    else
        return plate:upper()
    end
end


RegisterNetEvent('ktrp-leoshop:server:buyLeoVehicle', function(vehData,paymentMethod)
    local src = source
    vehicle = vehData.spawnName
    local pData = QBCore.Functions.GetPlayer(src)
    local cid = pData.PlayerData.citizenid                                
    local cash = pData.PlayerData.money['cash']
    local bank = pData.PlayerData.money['bank']
    local vehiclePrice = vehData.price
    local plate = GeneratePlate()
    if paymentMethod == "Cash" then 
		if cash > tonumber(vehiclePrice) then
        	MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
            	pData.PlayerData.license,
            	cid,
            	vehicle,
            	GetHashKey(vehicle),
            	'{}',
            	plate,
            	'police',
            	0
        	})
        	TriggerClientEvent('QBCore:Notify', src, vehData.name.."Purchase Successful", 'success')
        	TriggerClientEvent('qb-vehicleshop:client:buyShowroomVehicle', src, vehicle, plate)
        	pData.Functions.RemoveMoney('cash', vehiclePrice, 'vehicle-bought-in-LeoShop')
    	else
        	TriggerClientEvent('QBCore:Notify', src, "You Don't have enough Money in Hand", 'error')
    	end
    elseif paymentMethod == "Bank" then 
    	if bank > tonumber(vehiclePrice) then
        	MySQL.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, garage, state) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
            	pData.PlayerData.license,
            	cid,
            	vehicle,
            	GetHashKey(vehicle),
            	'{}',
            	plate,
            	'police',
            	0
       		})
        	TriggerClientEvent('QBCore:Notify', src, vehData.name.."Purchase Successful", 'success')
        	TriggerClientEvent('ktrp-leogarage:client:buyShowroomVehicle', src, vehicle, plate)
        	pData.Functions.RemoveMoney('bank', vehiclePrice, 'vehicle-bought-in-LeoShop')
    	else
        	TriggerClientEvent('QBCore:Notify', src, "You Don't have enough Money in Bank", 'error')
    	end
    end
end)

RegisterNetEvent("ktrp-leoshop:server:pdJobCheck",function()
    Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "police" then
        if Player.PlayerData.job.onduty then
            TriggerClientEvent("ktrp-leoshop:client:sharePlayer",source,Player)
        else
            TriggerClientEvent('QBCore:Notify',source,"You are in Off-Duty","error")
        end
    else
        TriggerClientEvent('QBCore:Notify',source,"You are not in Police Job","error")
    end
end)

RegisterNetEvent("ktrp-leoshop:server:emsJobCheck",function()
    Player = QBCore.Functions.GetPlayer(source)
    if Player.PlayerData.job.name == "ambulance" then
        if Player.PlayerData.job.onduty then
            TriggerClientEvent("ktrp-leoshop:client:sharePlayer",source,Player.PlayerData.job,Player)
        else
            TriggerClientEvent('QBCore:Notify',source,"You are in Off-Duty","error")
        end
    else
        TriggerClientEvent('QBCore:Notify',source,"You are not in EMS Job","error")
    end
end)