function idlecamremove()
    DisableIdleCamera(true)
end

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(100)
        idlecamremove()
    end
end)