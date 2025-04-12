local timeIntervalChange = 3600 
local hour = 12
local minutes = 0

local currentWeather = 'EXTRASUNNY'
local lastWeather = currentWeather

local disabled = false
local blackout = false

RegisterNetEvent("claudiu:setTime", function (hour1, minutes1)
    hour = hour1
    minutes = minutes1
end)

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait((timeIntervalChange*1000)/60)
        minutes = minutes + 1
        if minutes == 60 then 
            minutes = 0
            hour = hour + 1
            if hour == 24 then
                hour = 0
            end
        end
    end
end)

Citizen.CreateThread(function()
   while true do 
        Citizen.Wait(500)
        NetworkOverrideClockTime(hour, minutes, 0)
    end
end)

RegisterNetEvent('claudiu:updateWeather', function(newWeather, newBlackout)
    currentWeather = newWeather
    blackout = newBlackout
end)


Citizen.CreateThread(function()
    while true do
        if not disable then
            if lastWeather ~= currentWeather then
                lastWeather = currentWeather
                SetWeatherTypeOverTime(currentWeather, 15.0)
                Citizen.Wait(15000)
            end

            Citizen.Wait(75)

            SetArtificialLightsState(blackout)
            SetArtificialLightsStateAffectsVehicles(false)
            ClearOverrideWeather()
            ClearWeatherTypePersist()
            SetWeatherTypePersist(lastWeather)
            SetWeatherTypeNow(lastWeather)
            SetWeatherTypeNowPersist(lastWeather)

            if lastWeather == 'XMAS' then
                SetForceVehicleTrails(true)
                SetForcePedFootstepsTracks(true)
            else
                SetForceVehicleTrails(false)
                SetForcePedFootstepsTracks(false)
            end

            local rainLevel = 0.0
            if lastWeather == 'RAIN' then
                rainLevel = 0.3
            elseif lastWeather == 'THUNDER' then
                rainLevel = 0.5
            end
            SetRainLevel(rainLevel)
        else
            Citizen.Wait(100)
            SetArtificialLightsState(blackout)
            SetArtificialLightsStateAffectsVehicles(false)
        end
    end
end)

RegisterNetEvent('vSync:DisableSync')
AddEventHandler('vSync:DisableSync', function()
    disable = true
    Citizen.CreateThread(function()
        while disable do
            SetRainFxIntensity(0.0)
            SetWeatherTypePersist('EXTRASUNNY')
            SetWeatherTypeNow('EXTRASUNNY')
            SetWeatherTypeNowPersist('EXTRASUNNY')
            NetworkOverrideClockTime(23, 0, 0)
            Citizen.Wait(1)
        end
    end)
end)

RegisterNetEvent('vSync:EnableSync')
AddEventHandler('vSync:EnableSync', function()
    disable = false
    Citizen.Wait(1)
    NetworkOverrideClockTime(hour, minutes, 0)
    SetWeatherTypeOverTime(currentWeather, 15.0)
    SetArtificialLightsState(blackout)
    SetArtificialLightsStateAffectsVehicles(false)
end)

Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/weather', 'Schimba vremea.', {{ name="weatherType", help="Tip Vreme: extrasunny, clear, neutral, smog, foggy, overcast, clouds, clearing, rain, thunder, snow, blizzard, snowlight, xmas & halloween"}})
    TriggerEvent('chat:addSuggestion', '/freezeweather', 'Activeaza/Dezactiveaza vremea.')
    TriggerEvent('chat:addSuggestion', '/blackout', 'Activeaza/Dezactiveaza Blackout.')
end)