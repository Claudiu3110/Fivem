local stopCleanup = false;

RegisterCommand('cancelcleanup',function(source)
  local user_id = vRP.getUserId{source}
  if vRP.isUserMod{user_id} then 
    stopCleanup = true 
    TriggerClientEvent('chatMessage',-1,'^3Tunner^0 Admin-ul ^3'..GetPlayerName(source) .. '^0 a oprit stergerea masinilor!')
  end
end)

local deleteEveryVehicle = function()
  if not stopCleanup then 
  TriggerClientEvent('chatMessage',-1,'^3Tunner^0: Toate masinile neocupate au fost sterse cu succes!')
    local vehs = GetAllVehicles()
      for k,v in pairs(vehs) do 
          if DoesEntityExist(v) then
        if GetPedInVehicleSeat(v,-1) == 0 then 
          DeleteEntity(v) 
        end
      end;
      end
  end
end

RegisterCommand('cleanup',function(source,args)
  local mins = tonumber(args[1])
  if not mins then return TriggerClientEvent('chatMessage',source,'^3Tunner^0: /cleanup secunde') end;
  if mins <= 0 then return TriggerClientEvent('chatMessage',source,'^3Tunner^0: /cleanup secunde') end ;
    local user_id = vRP.getUserId{source}
    if vRP.isUserMod{user_id} then 
    stopCleanup = false
        TriggerClientEvent('chatMessage',-1,'^3Tunner^0 Admin-ul ^3'..GetPlayerName(source) .. '^0 a activat stergerea masinilor neocupate in ^3' .. mins .. '^0 secunde')

        local embed = {
            {
              ["color"] = 0xcf0000,
              ["title"] = "".. "Cleanup".."",
              ["description"] = "**Cleanup:** "..GetPlayerName(source).." a activat stergerea masinilor neocupate in ".. mins .." secunde !",
              ["thumbnail"] = {
                ["url"] = "",
              },
              ["footer"] = {
              ["text"] = "",
              },
            }
          }
          PerformHttpRequest('https://discord.com/api/webhooks/1238989487862972557/ZdgF9prBoqea8ZYdLsn-ruYegXyj2iNSo2O1sOT3eMwKRaTMCkSWqoHLlz_eT4YjmP2P', function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' }) 
        Citizen.SetTimeout(1000 * mins, deleteEveryVehicle)
    end
end)
