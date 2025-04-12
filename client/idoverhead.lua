local disPlayerNames = 13

local playerData = {}

local idsOn = false

local fontsLoaded = false
local fontId
Citizen.CreateThread(function()
  Citizen.Wait(1000)
  RegisterFontFile('wmk')
  fontId = RegisterFontId('Freedom Font')
  fontsLoaded = true
end)

function antiMeta(apasat)
    if apasat then
        if DoesEntityExist(PlayerPedId()) then
            Citizen.CreateThread(function()
                RequestAnimDict("anim@heists@ornate_bank@thermal_charge")
                while not HasAnimDictLoaded("anim@heists@ornate_bank@thermal_charge") do
                    Citizen.Wait(100)
                end
                TaskPlayAnim(PlayerPedId(), "anim@heists@ornate_bank@thermal_charge", "cover_eyes_loop", 8.0, -8, -1, 49, 0, 0, 0, 0)
				ExecuteCommand("me Se scarpina la ochi")
			end)
        end
    else 
        ClearPedSecondaryTask(PlayerPedId())
    end
end

RegisterNetEvent("ples-idoverhead:setCViewing")
AddEventHandler("ples-idoverhead:setCViewing", function(sid, val)
	if playerData[sid] then
		playerData[sid].view = val

		if val then
			Citizen.CreateThread(function()
				if (playerData[sid].dst or 99) < 20 then

					local id = GetPlayerFromServerId(sid)
					local ped = GetPlayerPed(id)

					while playerData[sid].view do

						if not NetworkIsPlayerActive(id) or ped == PlayerPedId() then
							break
						end

						if IsPedInAnyVehicle(ped, false) then
							local veh = GetVehiclePedIsIn(ped)
							if not IsThisModelABike(GetEntityModel(veh)) then
								if GetPedInVehicleSeat(veh, -1) == ped then
									x2, y2, z2 = table.unpack(GetOffsetFromEntityInWorldCoords(veh, -0.4, 0.0, 0.0))
								elseif GetPedInVehicleSeat(veh, 0) == ped then
									x2, y2, z2 = table.unpack(GetOffsetFromEntityInWorldCoords(veh, 0.4, 0.0, 0.0))
								elseif GetPedInVehicleSeat(veh, 1) == ped then
									x2, y2, z2 = table.unpack(GetOffsetFromEntityInWorldCoords(veh, -0.4, -0.8, 0.0))
								else
									x2, y2, z2 = table.unpack(GetOffsetFromEntityInWorldCoords(veh, 0.4, -0.8, 0.0))
								end
							else
								if GetPedInVehicleSeat(veh, -1) == ped then
									x2, y2, z2 = table.unpack(GetOffsetFromEntityInWorldCoords(veh, 0.0, 0.0, 0.3))
								else
									x2, y2, z2 = table.unpack(GetOffsetFromEntityInWorldCoords(veh, 0.0, -0.5, 0.5))
								end
							end
						else
							x2, y2, z2 = table.unpack(GetEntityCoords(ped, true))
						end
						DrawText3D(x2, y2, z2+1, playerData[sid].user_id, 2, fontId, {255, 94, 94})

						Citizen.Wait(1)
					end
				end
			end)
		end
	end
end)


local arecooldown = false 
local arenontificare = false 

RegisterCommand('+viewid', function()
    if arecooldown then
        if not arenontificare then
            tvRP.notify("Asteapta 3 secunde") 
            arenontificare = true 
        end
        return
    end

    arecooldown = true 
    arenontificare = false 
    idsOn = true
    antiMeta(true)
    TriggerServerEvent("ples-idoverhead:setViewing", true)

    Citizen.CreateThread(function()
        Citizen.Wait(3000) 
        arecooldown = false 
        antiMeta(false) 
    end)
end, false)

RegisterCommand('-viewid', function()
    if arecooldown then
        if not arenontificare then
            tvRP.notify("Asteapta 3 secunde") 
            arenontificare = true 
        end
        return
    end

    arecooldown = true 
    arenontificare = false 
    idsOn = false
    antiMeta(false)
    TriggerServerEvent("ples-idoverhead:setViewing", false)

    Citizen.CreateThread(function()
        Citizen.Wait(3000) 
        arecooldown = false 
    end)
end, false)

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

RegisterKeyMapping('+viewid', 'Vezi ID-urile', 'keyboard', 'DELETE')

AddEventHandler("playerSpawned", function()

	Citizen.CreateThread(function()
	    while true do
	        while idsOn do
	            for _, id in ipairs(GetActivePlayers()) do
	    			if NetworkIsPlayerActive(id) then
	    				if GetPlayerPed(id) ~= PlayerPedId() then
	    					local sId = GetPlayerServerId(id)
	                        if playerData[sId] then
	                        	if playerData[sId].dst then
		        					if playerData[sId].dst < disPlayerNames then
		        						local ped = GetPlayerPed(id)
										if IsPedInAnyVehicle(ped, false) then
											local veh = GetVehiclePedIsIn(ped)
											if not IsThisModelABike(GetEntityModel(veh)) then
												if GetPedInVehicleSeat(veh, -1) == ped then
													x2, y2, z2 = table.unpack(GetOffsetFromEntityInWorldCoords(veh, -0.4, 0.0, 0.0))
												elseif GetPedInVehicleSeat(veh, 0) == ped then
													x2, y2, z2 = table.unpack(GetOffsetFromEntityInWorldCoords(veh, 0.4, 0.0, 0.0))
												elseif GetPedInVehicleSeat(veh, 1) == ped then
													x2, y2, z2 = table.unpack(GetOffsetFromEntityInWorldCoords(veh, -0.4, -0.8, 0.0))
												else
													x2, y2, z2 = table.unpack(GetOffsetFromEntityInWorldCoords(veh, 0.4, -0.8, 0.0))
												end
											else
												if GetPedInVehicleSeat(veh, -1) == ped then
													x2, y2, z2 = table.unpack(GetOffsetFromEntityInWorldCoords(veh, 0.0, 0.0, 0.3))
												else
													x2, y2, z2 = table.unpack(GetOffsetFromEntityInWorldCoords(veh, 0.0, -0.5, 0.5))
												end
											end
										else
											x2, y2, z2 = table.unpack(GetEntityCoords(ped, true))
										end
		        						if NetworkIsPlayerTalking(id) then
		        							DrawText3D(x2, y2, z2+1, playerData[sId].user_id, 2, fontId, {200, 0, 0})
		        						else
		        							DrawText3D(x2, y2, z2+1, playerData[sId].user_id, 2, fontId, {255, 255, 255})
		        						end
		        					end
		        				end
	                        end
	    				end
	    			end
	            end
	            Citizen.Wait(1)
	        end
	        Citizen.Wait(200)
	    end
	end)

	Citizen.CreateThread(function()
	    while true do
	    	local selfPed = PlayerPedId()
	        for _, id in ipairs(GetActivePlayers()) do
	            if NetworkIsPlayerActive(id) then
	            	local userPed = GetPlayerPed(id)
	                if userPed ~= selfPed then
                        local x1, y1, z1 = table.unpack(GetEntityCoords(selfPed, true))
                        local x2, y2, z2 = table.unpack(GetEntityCoords(userPed, true))
                        local distance = math.floor(#(vector3(x1,  y1,  z1) - vector3(x2,  y2,  z2)))

                        if playerData[GetPlayerServerId(id)] then
                        	playerData[GetPlayerServerId(id)].dst = distance
                        end
	                end
	            end
	        end
	        Citizen.Wait(3000)
	    end
	end)
end)

RegisterNetEvent("id:initPlayer")
AddEventHandler("id:initPlayer", function(src, uid)
	playerData[src] = {user_id = uid}
end)

RegisterNetEvent("id:removePlayer")
AddEventHandler("id:removePlayer", function(src)
	playerData[src] = nil
end)


OGFont = RegisterFontId('Font Logo')

function DrawText3D(x,y,z, text, scl, font, colors) 

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local tefut=GetGameplayCamCoords()
    local dist = #(tefut - vector3(x,y,z))
 
    local scale = (1/dist)*scl
    local fov = (1/GetGameplayCamFov())*100
    scale = scale*fov

    if not colors then
      colors = {255, 255, 255}
    end
    if font == "OGFont" then
      font = OGFont
    end
   
    if onScreen then
        SetTextScale(0.0*scale, 1.1*scale)
        SetTextFont(font or 2)
        SetTextProportional(1)
        SetTextColour(colors[1], colors[2], colors[3], 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end