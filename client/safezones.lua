
inSafeZone = false
safeZone = nil

local fontId
Citizen.CreateThread(function()
	Citizen.Wait(1000)
	RegisterFontFile('wmk')
	fontId = RegisterFontId('Freedom Font')
end)

local maxspeed = 40
local kmh = 3.6

local CreateThread = Citizen.CreateThread
local safeZones = { 
	['JAIL'] = {pos = vector3(-453.09634399414,6108.5795898438,30.624862670898),radius = 50.0},
    ['Spawn'] = {pos = vector3(-512.8564453125,-229.53701782227,36.170806884766),radius = 70.0}
}

local drawText = function(x,y,scale,text,font,outline)
    SetTextFont(fontId)
    SetTextProportional(0)
    SetTextScale(scale,scale)
    SetTextColour(255,255,255,255)
    SetTextDropShadow(50,5,5,5,255)
    if outline then
        SetTextOutline()
    end
    SetTextCentre(1)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x,y)
end

function tvRP.isInSafeZone()
	return inSafeZone
end

CreateThread(function()
	CreateThread(function()
		local ticks = 500
		while true do
			local ped = PlayerPedId()

			if (inSafeZone) then
				ticks = 1
				drawText(0.960,0.005,0.25,' ~g~SAFEZONE',1,false)
	
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

				SetVehicleMaxSpeed(GetVehiclePedIsIn(ped, false),maxspeed / kmh)
	
				SetEntityInvincible(ped, true)
				SetEntityInvincible(PlayerId(), true)
				ResetPedVisibleDamage(ped)
				ClearPedBloodDamage(ped)
				SetEntityCanBeDamaged(ped, false)
				NetworkSetFriendlyFireOption(false)
	
			else
				ticks = 500
				SetVehicleMaxSpeed(GetVehiclePedIsIn(ped, false),540.0)
				SetEntityInvincible(ped, false)
				SetEntityInvincible(PlayerId(), false)
				SetEntityCanBeDamaged(ped, true)
				NetworkSetFriendlyFireOption(true)
			end
			Wait(ticks)
			ticks = 500
		end
	end)
    while true do
        Wait(500)
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        for key,value in pairs(safeZones) do
            pos = value.pos
            radius = value.radius
            if #(coords - pos) < radius then
                inSafeZone = true
                safeZone = key
            end
        end
        if safeZone ~= nil then
            pos = safeZones[safeZone].pos
			radius = safeZones[safeZone].radius
            if #(pos - coords) > radius then
                inSafeZone = false
                safeZone = nil
            end
        end
    end
end)

