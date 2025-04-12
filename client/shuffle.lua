local disableShuffle = true
function disableSeatShuffle(flag)
	disableShuffle = flag
end

Citizen.CreateThread(function()
	while true do
		Wait(500)
		local ped = PlayerPedId()
		while IsPedInAnyVehicle(ped, false) and disableShuffle do
			Wait(0)
			local veh = GetVehiclePedIsIn(ped, false)
			if GetPedInVehicleSeat(veh, 0) == ped then
				if GetIsTaskActive(ped, 165) then
					SetPedIntoVehicle(ped, veh, 0)
				end
			end
		end
	end
end)

RegisterCommand("shuff", function()
	local veh = GetVehiclePedIsIn(PlayerPedId(), false)
	if veh then
		disableSeatShuffle(false)
		Citizen.Wait(5000)
		disableSeatShuffle(true)
	end
end)