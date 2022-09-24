local QBCore = exports['qb-core']:GetCoreObject()
local Player

RegisterNetEvent("ktrp-leoshop:client:playerMenu",function(player)
	Player = player    
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
RegisterNetEvent("ktrp-leoshop:client:previewMenu",function(vehData)
    local number = vehData.number
    local submenuList = {}
	submenuList[#submenuList + 1] = {
   		header = 'Return to Vehicle List',
    	icon = 'fa-solid fa-angles-left',
    	params = {
        	event = 'ktrp-leoshop:client:returnPM',
        	args = {}
        }
    }
	submenuList[#submenuList + 1] = {
   		header = 'buy',
    	icon = 'fa-solid fa-angles-left',
    	params = {
        	event = 'ktrp-leoshop:client:PayMenu',
        	args = {
 				name = vehData.name, -- value we want to pass
                spawnName = vehData.spawnName,
                price = vehData.price
       		}
        }
    }
	exports['qb-menu']:openMenu(submenuList)
end)