local currentHour = nil
local currentMinutes = nil

availableWeatherTypes = {
    'EXTRASUNNY', 
    'CLEAR', 
    'FOGGY', 
    'CLEARING', 
    'RAIN',
    'THUNDER', 
    'SNOW', 
    'BLIZZARD', 
    'SNOWLIGHT', 
    'XMAS', 
    'HALLOWEEN',
}

local currentWeather = "EXTRASUNNY"
local newWeatherTimer = 60 
local dynamicWeather = true
local blackout = false

AddEventHandler("vRP:playerSpawn",function(user_id, source, first_spawn)
    if first_spawn then
        TriggerClientEvent("claudiu:setTime", source, tonumber(os.date("%H",os.time())), tonumber(os.date("%M",os.time())))
        TriggerClientEvent("claudiu:updateWeather", source, currentWeather, blackout)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000*60*newWeatherTimer)
        TriggerClientEvent("claudiu:setTime", -1, tonumber(os.date("%H",os.time())), tonumber(os.date("%M",os.time())))
        if dynamicWeather then
            NextWeatherStage()
        end
    end
end)

function NextWeatherStage()
    if currentWeather == "CLEAR" or currentWeather == "CLOUDS" or currentWeather == "EXTRASUNNY"  then
        local new = math.random(1,2)
        if new == 1 then
            currentWeather = "CLEARING"
        else
            currentWeather = "OVERCAST"
        end
    elseif currentWeather == "CLEARING" or currentWeather == "OVERCAST" then
        local new = math.random(1,6)
        if new == 1 then
            if currentWeather == "CLEARING" then currentWeather = "FOGGY" else currentWeather = "RAIN" end
        elseif new == 2 then
            currentWeather = "CLOUDS"
        elseif new == 3 then
            currentWeather = "CLEAR"
        elseif new == 4 then
            currentWeather = "EXTRASUNNY"
        elseif new == 5 then
            currentWeather = "SMOG"
        else
            currentWeather = "FOGGY"
        end
    elseif currentWeather == "THUNDER" or currentWeather == "RAIN" then
        currentWeather = "CLEARING"
    elseif currentWeather == "SMOG" or currentWeather == "FOGGY" then
        currentWeather = "CLEAR"
    end
    TriggerClientEvent("claudiu:updateWeather", -1, currentWeather, blackout)
end

RegisterCommand('weather', function(source, args)
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        if vRP.isUserAdmin(user_id) then
            local validWeatherType = false
            if args[1] ~= nil and args[1] ~= "" then 
                for i,wtype in ipairs(availableWeatherTypes) do
                    if wtype == string.upper(args[1]) then
                        validWeatherType = true
                    end
                end
                if validWeatherType then
                    vRPclient.notify(source,{"Vremea a fost schimbata la ~b~".. string.lower(args[1])})
                    currentWeather = string.upper(args[1])
                    tempWeatherTimer = newWeatherTimer
                    TriggerClientEvent("claudiu:updateWeather", -1, currentWeather, blackout)
                else
                    vRPclient.notify(source,{"~r~Vremea pe care ai aleso este invalida"})
                end
            else
                vRPclient.notify(source,{"~r~Comanda invalida, ~w~/weather <weathertype>"})
            end
        else
            vRPclient.notify(source,{"~r~Nu ai acces la aceasta comanda."})
        end
    end
end)

RegisterCommand('freezeweather', function(source, args)
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        if vRP.isUserSupervizor(user_id) then
            dynamicWeather = not dynamicWeather
            if not dynamicWeather then
                vRPclient.notify(source,{"Vremea dinamica este acum ~r~dezactivata."})
            else
                vRPclient.notify(source,{"Vremea dinamica este acum ~g~activata."})
            end
        else
            vRPclient.notify(source,{"Nu ai acces la aceasta comanda"})
        end
    end
end)

RegisterCommand('blackout', function(source)
    local user_id = vRP.getUserId(source)
    if user_id ~= nil then
        if vRP.isUserSupervizor(user_id) then
            blackout = not blackout
            TriggerClientEvent("claudiu:updateWeather", -1, currentWeather, blackout)
        end
    end
end)