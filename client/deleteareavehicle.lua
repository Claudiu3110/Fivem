function tvRP.getNearestVehiclesInRadius(radius)
	local vehs = {}
	local vehicles = GetGamePool('CVehicle')

	local userCoords = GetEntityCoords(PlayerPedId())
	for _,clientVehicles in pairs(vehicles) do
		if DoesEntityExist(clientVehicles) or IsEntityAVehicle(clientVehicles) then
			local vehCoords = GetEntityCoords(clientVehicles)
			if #(userCoords - vehCoords) <= radius then
				if GetPedInVehicleSeat(clientVehicles,-1) == 0 then
					vehs[#vehs + 1] = VehToNet(clientVehicles)
				end
			end
		end
	end
	return vehs
end