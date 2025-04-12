
local CreateThread = Citizen.CreateThread
local isPressed = IsDisabledControlJustPressed

function Draw3DText(x,y,z, text,font,scl)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local scale = scl or 0.5
    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end
config = { 
    ['Garaje Smurd'] = {
        posLeave = vector3(340.04345703125, -584.89984130859, 28.796857833862),
        posJoin = vector3(330.15191650391, -601.22796630859, 43.28405380249),
    },
    ['Elicopter Smurd'] = {
        posJoin = vec3(331.82781982422, -595.48248291016, 43.284057617188),
        posLeave = vec3(338.87100219727, -583.9609375, 74.161804199219),
    }
}

CreateThread(function()
    local ticks = 500
    while true do
        for i, v in pairs(config) do
            if #(_GCOORDS - v.posJoin) < 1.0 then
                ticks = 1
                Draw3DText(v.posJoin[1], v.posJoin[2], v.posJoin[3], 'Apasa ~g~E~w~ pentru a intra in ~r~'..i,0,0.4) 
                if isPressed(0,38) then
                    SetEntityCoords(_GPED, v.posLeave)
                end
            elseif #(_GCOORDS - v.posLeave) < 1.0 then
                ticks = 1
                Draw3DText(v.posLeave[1], v.posLeave[2], v.posLeave[3], 'Apasa ~g~E~w~ pentru a iesii din ~r~'..i,0,0.4) 
                if isPressed(0,38) then
                    SetEntityCoords(_GPED, v.posJoin)
                end
            end
        end
        Wait(ticks)
        ticks = 500
    end
end)
