RegisterCommand('dvarea', function(source,args)
	local user_id = vRP.getUserId(source)
	local radius = tonumber(args[1]) or 5
	if not user_id then return end

	if vRP.isUserAdmin(user_id) then
		vRPclient.getNearestVehiclesInRadius(source,{radius},function(vehicles)
			for _,veh in pairs(vehicles) do
				local netVehicle = NetworkGetEntityFromNetworkId(veh)
				DeleteEntity(netVehicle)
			end
			local adminName = GetPlayerName(source)
			TriggerClientEvent('chatMessage',-1,('^3Tunner:^0 Admin-ul ^3%s ^0 (^3%s^0) a sters toate masinile pe o raza de ^3%s^0 metrii'):format(adminName,user_id,radius))
		end)
	end
end)