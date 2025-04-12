Citizen.CreateThread(function()
    local bhops = 0
    local reduction = 0
    while true do
      local ped = PlayerPedId()
      if IsPedJumping(ped) then
        bhops = bhops + 1
        if bhops >= 1 then
          Citizen.Wait(300)
          SetPedToRagdoll(ped, 500, 500, 0, 0, 0, 0)
        end
      end
      Citizen.Wait(1100)
      reduction = reduction + 1
      if reduction == 2 then
        bhops = math.max(bhops - 1, 0)
        reduction = 0
      end
    end
  end)