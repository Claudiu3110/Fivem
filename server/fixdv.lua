AddEventHandler('chatMessage', function(source, name, msg)
	if source ~= nil then
		local user_id = vRP.getUserId(source)
		if user_id ~= nil then
			if msg == "/fix" or msg == "/fixmasina" or msg == "/FIX" then
				if vRP.isUserMod(user_id) then
					CancelEvent()
					vRPclient.fixCar(source, {})
					vRPclient.notify(source,{"Masina s-a reparat!"})
					local embed = {
						{
						  ["color"] = 1234521,
						  ["description"] = "Adminul ".. GetPlayerName(source) .." ["..user_id.."] si-a reparat masina.",
						  ["thumbnail"] = {
							["url"] = "https://i.imgur.com/Bi2iC6K.png",
						  },
						  ["footer"] = {
						  ["text"] = "",
						  },
						}
					  }
					  PerformHttpRequest('871559146770690058/Qm6V9NVxQC9fMxdXaMnfOu5KGwTy9DoW9hDgyg0cAJ50-Jq9jgfFGil98odBjWPB24VT', function(err, text, headers) end, 'POST', json.encode({username = name, embeds = embed}), { ['Content-Type'] = 'application/json' }) 
					
				else
					CancelEvent()
					vRPclient.notify(source,{"Nu ai acces la aceasta comanda"})
				end
			elseif msg == "/dv" or msg == "/de" or msg == "/DV" or msg == "/DE" then
				CancelEvent()
				vRPclient.deleteCar(source, {})
			end
		end
	end
end)
