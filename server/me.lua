local function TableToString(tab)
    local str = ""
    for i = 1, #tab do
        str = str .. " " .. tab[i]
    end
    return str
end

RegisterCommand('me', function(source, args, rawCommand)
    if source ~= nil then
		local text = rawCommand:sub(3)
        if not text:find("font size") then
            if not text:find("<") then
                TriggerClientEvent('3dme:shareDisplay', -1, text, source)
            else
                vRPclient.notify(source,{"~r~Nu poti sa folosesti '<' in /me"})
            end
        else
            DropPlayer(source,"Ti foame tati?")
        end
    end
end, false)

RegisterNetEvent("3dme:triggerDisplay")
AddEventHandler("3dme:triggerDisplay", function(text)
    if source ~= nil then
        TriggerClientEvent('3dme:shareDisplay', -1, text, source)
    end
end)