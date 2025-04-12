
local handsup = false
RegisterCommand("+ridicamaini", function()
    if (GetVehiclePedIsIn(PlayerPedId()) == 0) then
        handsup = true
        Citizen.CreateThread(function()
            local dict = "missminuteman_1ig_2"
            RequestAnimDict(dict)
            while not HasAnimDictLoaded(dict) do
                Wait(100)
            end
        end)
        if handsup then
            TaskPlayAnim(PlayerPedId(), "missminuteman_1ig_2", "handsup_enter", 8.0, 8.0, -1, 50, 0, false, false, false)
            handsup = true
        end
    end
end)

RegisterCommand("-ridicamaini", function()
    if handsup then
        RemoveAnimSet("missminuteman_1ig_2")
        ClearPedSecondaryTask(PlayerPedId())
        handsup = false
    end
end)

RegisterKeyMapping("+ridicamaini", "Ridica mainile", "keyboard", "x")