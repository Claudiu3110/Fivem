local hostageAllowedWeapons = {
	"WEAPON_PISTOL",
	"WEAPON_COMBATPISTOL",
	"WEAPON_SNSPISTOL",
	"WEAPON_APPISTOL",
	"WEAPON_PISTOL50"
}
-- Modify this by your server' s weapons

local holdingHostage = false
local beingHeldHostage = false
local holdingHostageInProgress = false
local takeHostageAnimNamePlaying = ""
local takeHostageAnimDictPlaying = ""
local takeHostageControlFlagPlaying = 0

local function DrawTextOverHostage(x,y,z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())

	if onScreen then
		SetTextScale(0.19, 0.19)
		SetTextFont(0)
		SetTextProportional(1)
		-- SetTextScale(0.0, 0.55)
		SetTextColour(255, 255, 255, 255)
		SetTextDropshadow(0, 0, 0, 0, 55)
		SetTextEdge(2, 0, 0, 0, 150)
		SetTextDropShadow()
		SetTextOutline()
		SetTextEntry("STRING")
		SetTextCentre(1)
		AddTextComponentString(text)
		DrawText(_x,_y)
	end
end

local function GetClosestPlayer(radius)
	local players = GetActivePlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = GetPlayerPed(-1)
	local plyCoords = GetEntityCoords(ply, 0)
	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if(target ~= ply) then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = #(targetCoords-plyCoords)
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end
	if closestDistance <= radius and IsPedInAnyVehicle(GetPlayerPed(closestPlayer), false) == false then
		return closestPlayer
	else
		return -1
	end
end

local function drawNativeNotification(text)
	SetTextComponentFormat('STRING')
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local function releaseHostage()
	lib = 'reaction@shove'
	anim1 = 'shove_var_a'
	lib2 = 'reaction@shove'
	anim2 = 'shoved_back'
	distans = 0.11 
	distans2 = -0.24 
	height = 0.0
	spin = 0.0
	length = 100000
	controlFlagMe = 120
	controlFlagTarget = 0
	animFlagTarget = 1
	attachFlag = false
	local closestPlayer = GetClosestPlayer(2)
	target = GetPlayerServerId(closestPlayer)
	if closestPlayer ~= 0 then
		TriggerServerEvent('Hostage:sync', lib, lib2, anim1, anim2, distans, distans2, height, target, length, spin, controlFlagMe, controlFlagTarget, animFlagTarget, attachFlag)
	end
end 

local function killHostage()
	lib = 'anim@gangops@hostage@'
	anim1 = 'perp_fail'
	lib2 = 'anim@gangops@hostage@'
	anim2 = 'victim_fail'
	distans = 0.11 
	distans2 = -0.24
	height = 0.0
	spin = 0.0
	length = 0.2
	controlFlagMe = 168
	controlFlagTarget = 0
	animFlagTarget = 1
	attachFlag = false
	local closestPlayer = GetClosestPlayer(2)
	target = GetPlayerServerId(closestPlayer)
	if target ~= 0 then
		TriggerServerEvent('Hostage:sync', lib, lib2, anim1, anim2, distans, distans2, height, target, length, spin, controlFlagMe, controlFlagTarget, animFlagTarget, attachFlag)
	end
end

RegisterNetEvent('Hostage:syncTarget')
AddEventHandler('Hostage:syncTarget', function(target, animationLib, animation2, distans, distans2, height, length, spin, controlFlag, animFlagTarget, attach)
	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	if holdingHostageInProgress then
		holdingHostageInProgress = false
	else
		holdingHostageInProgress = true
	end
	beingHeldHostage = true
	Citizen.CreateThread(function()
		while true do
			if beingHeldHostage then
				DisableControlAction(0,21,true) 
				DisableControlAction(0,24,true) 
				DisableControlAction(0,25,true) 
				DisableControlAction(0,47,true) 
				DisableControlAction(0,58,true) 
				DisableControlAction(0,263,true) 
				DisableControlAction(0,264,true) 
				DisableControlAction(0,257,true) 
				DisableControlAction(0,140,true) 
				DisableControlAction(0,141,true) 
				DisableControlAction(0,142,true) 
				DisableControlAction(0,143,true) 
				DisableControlAction(0,75,true)
				DisableControlAction(27,75,true)  
				DisableControlAction(0,22,true) 
				DisableControlAction(0,32,true) 
				DisableControlAction(0,268,true)
				DisableControlAction(0,33,true) 
				DisableControlAction(0,269,true)
				DisableControlAction(0,34,true) 
				DisableControlAction(0,270,true)
				DisableControlAction(0,35,true) 
				DisableControlAction(0,271,true)
				if not IsEntityPlayingAnim(GetPlayerPed(-1), takeHostageAnimDictPlaying, takeHostageAnimNamePlaying, 3) then
					TaskPlayAnim(GetPlayerPed(-1), takeHostageAnimDictPlaying, takeHostageAnimNamePlaying, 8.0, -8.0, 100000, takeHostageControlFlagPlaying, 0, false, false, false)
				end
			else
				break
			end
			Wait(0)
		end
	end)
	RequestAnimDict(animationLib)
	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if spin == nil then spin = 180.0 end
	if attach then
		AttachEntityToEntity(GetPlayerPed(-1), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)
	end
	if controlFlag == nil then controlFlag = 0 end
	if animation2 == "victim_fail" then
		SetEntityHealth(GetPlayerPed(-1),0)
		DetachEntity(GetPlayerPed(-1), true, false)
		TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
		beingHeldHostage = false
		holdingHostageInProgress = false
	elseif animation2 == "shoved_back" then
		holdingHostageInProgress = false
		DetachEntity(GetPlayerPed(-1), true, false)
		TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
		beingHeldHostage = false
	else
		TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	end
	takeHostageAnimNamePlaying = animation2
	takeHostageAnimDictPlaying = animationLib
	takeHostageControlFlagPlaying = controlFlag
end)

RegisterNetEvent('Hostage:syncMe')
AddEventHandler('Hostage:syncMe', function(animationLib, animation, length, controlFlag, animFlag)
	local playerPed = GetPlayerPed(-1)
	ClearPedSecondaryTask(GetPlayerPed(-1))
	RequestAnimDict(animationLib)
	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	takeHostageAnimNamePlaying = animation
	takeHostageAnimDictPlaying = animationLib
	takeHostageControlFlagPlaying = controlFlag
	if animation == "perp_fail" then 
		SetPedShootsAtCoord(GetPlayerPed(-1), 0.0, 0.0, 0.0, 0)
		holdingHostageInProgress = false 
	end
	if animation == "shove_var_a" then 
		Wait(900)
		ClearPedSecondaryTask(GetPlayerPed(-1))
		holdingHostageInProgress = false 
	end
end)

RegisterNetEvent('Hostage:cl_stop')
AddEventHandler('Hostage:cl_stop', function()
	holdingHostageInProgress = false
	beingHeldHostage = false 
	holdingHostage = false 
	ClearPedSecondaryTask(GetPlayerPed(-1))
	DetachEntity(GetPlayerPed(-1), true, false)
end)

local function takeHostage()
	if GetEntityHealth(GetPlayerPed(-1)) > 102 then
		ClearPedSecondaryTask(GetPlayerPed(-1))
		DetachEntity(GetPlayerPed(-1), true, false)
		for i=1, #hostageAllowedWeapons do
			if HasPedGotWeapon(GetPlayerPed(-1), GetHashKey(hostageAllowedWeapons[i]), false) then
				if GetAmmoInPedWeapon(GetPlayerPed(-1), GetHashKey(hostageAllowedWeapons[i])) > 0 then
					canTakeHostage = true
					foundWeapon = GetHashKey(hostageAllowedWeapons[i])
					break
				end
			end
		end
		if not canTakeHostage then
			drawNativeNotification("Ai nevoie de un pistol cu munitie pentru a-l lua ostatic cu arma la gat!")
		end
		if not holdingHostageInProgress and canTakeHostage then
			lib = 'anim@gangops@hostage@'
			anim1 = 'perp_idle'
			lib2 = 'anim@gangops@hostage@'
			anim2 = 'victim_idle'
			distans = 0.11 
			distans2 = -0.24 
			height = 0.0
			spin = 0.0
			length = 100000
			controlFlagMe = 49
			controlFlagTarget = 49
			animFlagTarget = 50
			attachFlag = true
			local closestPlayer = GetClosestPlayer(2)
			target = GetPlayerServerId(closestPlayer)
			doesTargetHaveHandsUp = IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'missminuteman_1ig_2', 'handsup_enter', 3)
			target = GetPlayerServerId(closestPlayer)
			if closestPlayer ~= -1 then
				if doesTargetHaveHandsUp then 
					SetCurrentPedWeapon(GetPlayerPed(-1), foundWeapon, true)
					holdingHostageInProgress = true
					holdingHostage = true
					TriggerServerEvent('Hostage:sync', lib, lib2, anim1, anim2, distans, distans2, height, target, length, spin, controlFlagMe, controlFlagTarget, animFlagTarget, attachFlag)
					Citizen.CreateThread(function()
						while true do
							if holdingHostage and holdingHostageInProgress then
								if IsEntityDead(GetPlayerPed(-1)) then
									holdingHostage = false
									holdingHostageInProgress = false
									local closestPlayer = GetClosestPlayer(2)
									target = GetPlayerServerId(closestPlayer)
									TriggerServerEvent("Hostage:stop",target)
									Wait(100)
									releaseHostage()
								end
								DisableControlAction(0,24,true) 
								DisableControlAction(0,25,true) 
								DisableControlAction(0,47,true) 
								DisableControlAction(0,58,true) 
								DisablePlayerFiring(GetPlayerPed(-1),true)
								local playerCoords = GetEntityCoords(GetPlayerPed(-1))
								DrawTextOverHostage(playerCoords.x,playerCoords.y,playerCoords.z,"[E] Elibereaza, [G] Omoara")
								if IsDisabledControlJustPressed(0,38) then
									holdingHostage = false
									holdingHostageInProgress = false
									local closestPlayer = GetClosestPlayer(2)
									target = GetPlayerServerId(closestPlayer)
									TriggerServerEvent("Hostage:stop",target)
									Wait(100)
									releaseHostage()
								elseif IsDisabledControlJustPressed(0,58) then 
									holdingHostage = false
									holdingHostageInProgress = false
									local closestPlayer = GetClosestPlayer(2)
									target = GetPlayerServerId(closestPlayer)
									TriggerServerEvent("Hostage:stop",target)
									killHostage()
								end
								if not IsEntityPlayingAnim(GetPlayerPed(-1), takeHostageAnimDictPlaying, takeHostageAnimNamePlaying, 3) then
									TaskPlayAnim(GetPlayerPed(-1), takeHostageAnimDictPlaying, takeHostageAnimNamePlaying, 8.0, -8.0, 100000, takeHostageControlFlagPlaying, 0, false, false, false)
								end
								if IsPedGettingIntoAVehicle(PlayerPedId(-1)) then
									TriggerServerEvent("Hostage:stop",target)
									holdingHostageInProgress = false
									holdingHostage = false
									StopAnimTask(PlayerPedId(-1), "anim@gangops@hostage@", "perp_idle", 0)
									Wait(1000)
									ClearPedTasksImmediately(PlayerPedId(-1))
									Wait(50)
									drawNativeNotification("Nu poti lua pe cineva ostatic conducand un vehicul")
								end
							else
								break
							end
							Wait(0)
						end
					end)
				else
					drawNativeNotification("Omul trebuie sa fie cu mainile sus!")
				end
			else
				drawNativeNotification("Nimeni in apropiere pentru a-l lua ostatic!")
			end
		end
		canTakeHostage = false
	end
end

RegisterCommand("takehostage", function() ExecuteCommand("th") end, false)

RegisterCommand("th",function()
	if not tvRP.isHandcuffed() and not tvRP.isInComa() and not tvRP.isInEvent() and not inSafeZone then
		if IsPedInAnyVehicle(PlayerPedId(-1), false) then
			drawNativeNotification("Nu poti lua pe cineva ca ostatic intr-un vehicul")
		else
			takeHostage()
		end
	end
end, false)

local carryingBackInProgress = false
local carryAnimNamePlaying = ""
local carryAnimDictPlaying = ""
local carryControlFlagPlaying = 0

RegisterNetEvent('Carry:syncTarget')
AddEventHandler('Carry:syncTarget', function(target, animationLib, animation2, distans, distans2, height, length, spin, controlFlag)
	local playerPed = GetPlayerPed(-1)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	carryingBackInProgress = true
	RequestAnimDict(animationLib)
	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	if spin == nil then spin = 180.0 end
	AttachEntityToEntity(GetPlayerPed(-1), targetPed, 0, distans2, distans, height, 0.5, 0.5, spin, false, false, false, false, 2, false)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation2, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	carryAnimNamePlaying = animation2
	carryAnimDictPlaying = animationLib
	carryControlFlagPlaying = controlFlag
end)

RegisterNetEvent('Carry:syncMe')
AddEventHandler('Carry:syncMe', function(animationLib, animation, length, controlFlag, animFlag)
	local playerPed = GetPlayerPed(-1)
	RequestAnimDict(animationLib)
	while not HasAnimDictLoaded(animationLib) do
		Citizen.Wait(10)
	end
	Wait(500)
	if controlFlag == nil then controlFlag = 0 end
	TaskPlayAnim(playerPed, animationLib, animation, 8.0, -8.0, length, controlFlag, 0, false, false, false)
	carryAnimNamePlaying = animation
	carryAnimDictPlaying = animationLib
	carryControlFlagPlaying = controlFlag
end)

RegisterNetEvent('Carry:cl_stop')
AddEventHandler('Carry:cl_stop', function()
	carryingBackInProgress = false
	ClearPedSecondaryTask(GetPlayerPed(-1))
	DetachEntity(GetPlayerPed(-1), true, false)
end)

local function carryPeople()
	if GetEntityHealth(GetPlayerPed(-1)) > 102 then
		if not carryingBackInProgress then
			lib = 'missfinale_c2mcs_1'
			anim1 = 'fin_c2_mcs_1_camman'
			lib2 = 'nm'
			anim2 = 'firemans_carry'
			distans = 0.15
			distans2 = 0.27
			height = 0.63
			spin = 0.0
			length = 100000
			controlFlagMe = 49
			controlFlagTarget = 33
			animFlagTarget = 1
			local closestPlayer = GetClosestPlayer(3)
			if closestPlayer ~= -1 then
				target = GetPlayerServerId(closestPlayer)
				if not IsEntityDead(GetPlayerPed(closestPlayer)) then
					carryingBackInProgress = true
					TriggerServerEvent('Carry:sync', lib, lib2, anim1, anim2, distans, distans2, height, target, length, spin, controlFlagMe, controlFlagTarget, animFlagTarget)
					Citizen.CreateThread(function()
						while true do
							if carryingBackInProgress then
								local playerPed = GetPlayerPed(-1)
								if not IsEntityPlayingAnim(playerPed, carryAnimDictPlaying, carryAnimNamePlaying, 3) then
									TaskPlayAnim(playerPed, carryAnimDictPlaying, carryAnimNamePlaying, 8.0, -8.0, 100000, carryControlFlagPlaying, 0, false, false, false)
								end
								SetPedMovementClipset(PlayerPedId(), "move_ped_crouched", true)
								local car = GetVehiclePedIsIn(playerPed, false)
								if car then
									if GetPedInVehicleSeat(car, -1) == playerPed and carryingBackInProgress then
										TriggerServerEvent("Carry:stop",target)
										carryingBackInProgress = false
										ClearPedTasks(playerPed)
										StopAnimTask(playerPed, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 0)
										drawNativeNotification("Nu poti lua pe cineva pe spate conducand un vehicul")
									end
								end
							else
								break
							end
							Wait(0)
						end
					end)
				else
					drawNativeNotification("Nu poti lua pe spate pe cineva lesinat!")
				end
			else
				drawNativeNotification("Nimeni in apropiere pentru a-l lua pe spate!")
			end
		else
			carryingBackInProgress = false
			ClearPedSecondaryTask(GetPlayerPed(-1))
			DetachEntity(GetPlayerPed(-1), true, false)
			local closestPlayer = GetClosestPlayer(3)
			target = GetPlayerServerId(closestPlayer)
			if target ~= 0 then 
				TriggerServerEvent("Carry:stop",target)
			end
		end
	end
end

RegisterCommand("carry",function() ExecuteCommand("cara") end, false)

RegisterCommand("cara",function()
	if not tvRP.isHandcuffed() and not tvRP.isInComa() and not tvRP.isInEvent() and not inSafeZone then
		if IsPedInAnyVehicle(PlayerPedId(-1), true) then
			drawNativeNotification("Nu poti lua pe cineva pe spate intr-un vehicul!")
		else
			carryPeople()
		end
	end
end, false)