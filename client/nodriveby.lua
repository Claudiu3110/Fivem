
local passengerDriveBy = true



Citizen.CreateThread(function()
	while true do
		time = 500

		playerPed = PlayerPedId()
		car = GetVehiclePedIsIn(playerPed, false)
		if car then
			time = 0
			if GetPedInVehicleSeat(car, -1) == playerPed then
				SetPlayerCanDoDriveBy(PlayerId(), false)
			elseif passengerDriveBy then
				SetPlayerCanDoDriveBy(PlayerId(), true)
			else
				SetPlayerCanDoDriveBy(PlayerId(), false)
			end
		end
		Wait(time)
	end
end)