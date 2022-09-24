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

RegisterNetEvent("ktrp-leoshop:client:pdJobCheck",function()
	TriggerServerEvent("ktrp-leoshop:server:pdJobCheck")
end)

RegisterNetEvent("ktrp-leoshop:client:emsJobCheck",function()
	TriggerServerEvent("ktrp-leoshop:server:emsJobCheck")
end)

RegisterNetEvent("ktrp-leoshop:client:sharePlayer",function(player)
    Player = player 
    TriggerEvent("ktrp-leoshop:client:menu",Player.PlayerData.job)
end)

RegisterNetEvent("ktrp-leoshop:client:menu",function(job)
    print("Menu started"..job.name)
    if job.name == "police" then
        local GarageMenu = {}
        GarageMenu[#GarageMenu + 1] = {
            isMenuHeader = true,
            header = tostring(Config.PDTitle),
            icon = 'fa-regular fa-building'
        }   
        for k,v in pairs(Config.PDCars[QBCore.Functions.GetPlayerData().job.grade.level]) do -- loop through our table
            GarageMenu[#GarageMenu + 1] = { -- insert data from our loop into the menu
                header = k,
                txt = v.price,
                icon = 'fa-solid fa-sack-dollar',
                params = {
                    event = 'ktrp-leoshop:client:SubMenu', -- event name
                    args = {
                        name = k, -- value we want to pass
                        spawnName = v.spawnname,
                        price = v.price,
                        number = 1,
                    }	
                }
            }
        end
        exports['qb-menu']:openMenu(GarageMenu) -- open our menu
    end
    if job.name == "ambulance" then
        local GarageMenu = {}
        GarageMenu[#GarageMenu + 1] = {
            isMenuHeader = true,
            header = tostring(Config.EMSTitle),
            icon = 'fa-regular fa-building'
        }   
        for k,v in pairs(Config.EMSCars[QBCore.Functions.GetPlayerData().job.grade.level]) do -- loop through our table
            GarageMenu[#GarageMenu + 1] = { -- insert data from our loop into the menu
                header = k,
                txt = v.price,
                icon = 'fa-solid fa-sack-dollar',
                params = {
                    event = 'ktrp-leoshop:client:PreviewMenu', -- event name
                    args = {
                        name = k, -- value we want to pass
                        spawnName = v.spawnname,
                        price = v.price,
                    }	
                }
            }
        end
    end
    exports['qb-menu']:openMenu(GarageMenu) -- open our menu
end)

RegisterNetEvent("ktrp-leoshop:client:SubMenu",function(vehData)
    local number = vehData.number
    local submenuList = {}
	submenuList[#submenuList + 1] = {
   		header = 'Return to Vehicle List',
    	icon = 'fa-solid fa-angles-left',
    	params = {
        	event = 'ktrp-leoshop:client:menu',
        	args = {
				name = Player.PlayerData.job.name,
       		}
        }
    }
    submenuList[#submenuList + 1] = {
        header = 'Buy',
        icon = 'fa-solid fa-angles-left',
        params = {
            event = 'ktrp-leoshop:client:PayMenu',
            args = {
                name = vehData.name, -- value we want to pass
                spawnName = vehData.spawnName,
                price = vehData.price,
                number = 1,
            }
        }
    }
    submenuList[#submenuList + 1] = {
        header = 'Preview',
        icon = 'fa-solid fa-angles-left',
        params = {
            event = 'ktrp-leoshop:client:previewVehicle',
            args = {
                name = vehData.name, -- value we want to pass
                spawnName = vehData.spawnName,
                price = vehData.price
            }
        }
    }
	exports['qb-menu']:openMenu(submenuList)
end)

RegisterNetEvent("ktrp-leoshop:client:PayMenu",function(vehData)
    local number = vehData.number
    local submenuList = {}
	submenuList[#submenuList + 1] = {
   		header = 'Return to Vehicle List',
    	icon = 'fa-solid fa-angles-left',
    	params = {
        	event = 'ktrp-leoshop:client:menu',
        	args = {
				name = Player.PlayerData.job.name,
       		}
        }
    }
    for l,u in pairs(Config.PayMethod) do
    	submenuList[#submenuList + 1] = {
            header = u,
        	txt = "Pay with "..u,
    		icon = 'fa-regular fa-money-bill-1',
    		params = {
            	event = 'ktrp-leoshop:client:buyVehicle', -- event name
            	args = {
                    vehdata = vehData,
            		paymethod = u, -- value we want to pass
        		}
    		} 
       	}
    end
	exports['qb-menu']:openMenu(submenuList)
end)

RegisterNetEvent("ktrp-leoshop:client:previewVehicle",function(data)
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
    TriggerEvent("ktrp-leoshop:client:menu",Player.PlayerData.job)

end)

RegisterNetEvent("ktrp-leoshop:client:buyVehicle",function(data)
    TriggerServerEvent("ktrp-leoshop:server:buyLeoVehicle", data.vehdata,data.paymethod)
end)
