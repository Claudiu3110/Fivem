

local show_policeDoc = {function(player,choice)
	user_id = vRP.getUserId(player)
	vRPclient.getNearestPlayers(player,{15}, function(nplayers)
		userList = ""
		for i,v in pairs(nplayers) do
			userList = userList.. "[".. vRP.getUserId(i) .."]".. GetPlayerName(i).. " | "
		end
		if userList ~= "" then
			vRP.prompt(player,"Jucatori Apropriati: "..userList.."","", function(player,nearestId)
				nearestId = parseInt(nearestId)
				if nearestId ~= nil then
					local playerSource = vRP.getUserSource(nearestId)
					if playerSource ~= nil then
						vRP.getUserIdentity(user_id, function(identity)
							if identity then
								name = identity.name
								firstname = identity.firstname
								age = identity.age
								poza = player
								rank = vRP.getFactionRank(user_id)
    		    				vRP.getUserAddress(user_id, function(address)
    		    				  local home = ""
    		    				  local number = ""
								  poza = player
    		    				  if address then
    		    				    home = address.home
    		    				    number = address.number
    		    				  else
    		    				  	home = "Fara Domiciliu"
    		    				  	number = 0
    		    				  end
									--TriggerClientEvent("showPoliceDocument", source, {name = "Comsa", firstname = "Mafiotu", age = 30, address = "Strada AmPulaMare Nr. 23"})
									vRP.request(playerSource, "<font color= 'red'>"..GetPlayerName(player).."</font> <font color= 'green'>["..vRP.getUserId(player).."]</font> vrea sa-ti arate legitimatia. Accepti?",50, function(player,ok)
										if ok then
											TriggerClientEvent("claudiu:showPoliceBadge", playerSource, {nume = name, prenume = firstname, target = poza, rank = rank})
										end
									end)
								end)
							end
		
						end)
					else
						vRPclient.notify(player,{"Acest jucator nu este in aproprierea ta."})
					end
				else
					vRPclient.notify(player, {"Invalid value"})
				end
			end)
		end
	end)
end,"Arata legitimatia de politie!"}


local show_SRIDoc = {function(player,choice)
	user_id = vRP.getUserId(player)
	vRPclient.getNearestPlayers(player,{15}, function(nplayers)
		userList = ""
		for i,v in pairs(nplayers) do
			userList = userList.. "[".. vRP.getUserId(i) .."]".. GetPlayerName(i).. " | "
		end
		if userList ~= "" then
			vRP.prompt(player,"Jucatori Apropriati: "..userList.."","", function(player,nearestId)
				nearestId = parseInt(nearestId)
				if nearestId ~= nil then
					local playerSource = vRP.getUserSource(nearestId)
					if playerSource ~= nil then
						vRP.getUserIdentity(user_id, function(identity)
							if identity then
								name = identity.name
								firstname = identity.firstname
								age = identity.age
								poza = player
								rank = vRP.getFactionRank(user_id)
    		    				vRP.getUserAddress(user_id, function(address)
    		    				  local home = ""
    		    				  local number = ""
								  poza = player
    		    				  if address then
    		    				    home = address.home
    		    				    number = address.number
    		    				  else
    		    				  	home = "Fara Domiciliu"
    		    				  	number = 0
    		    				  end
									--TriggerClientEvent("showPoliceDocument", source, {name = "Comsa", firstname = "Mafiotu", age = 30, address = "Strada AmPulaMare Nr. 23"})
									vRP.request(playerSource, "<font color= 'red'>"..GetPlayerName(player).."</font> <font color= 'green'>["..vRP.getUserId(player).."]</font> vrea sa-ti arate legitimatia. Accepti?",50, function(player,ok)
										if ok then
											TriggerClientEvent("claudiu:showSRIBadge", playerSource, {nume = name, prenume = firstname, target = poza, rank = rank})
										end
									end)
								end)
							end
		
						end)
					else
						vRPclient.notify(player,{"Acest jucator nu este in aproprierea ta."})
					end
				else
					vRPclient.notify(player, {"Invalid value"})
				end
			end)
		end
	end)
end,"Arata legitimatia de SRI!"}



local show_smurddoc = {function(player,choice)
	user_id = vRP.getUserId(player)
	vRPclient.getNearestPlayers(player,{15}, function(nplayers)
		userList = ""
		for i,v in pairs(nplayers) do
			userList = userList.. "[".. vRP.getUserId(i) .."]".. GetPlayerName(i).. " | "
		end
		if userList ~= "" then
			vRP.prompt(player,"Jucatori Apropriati: "..userList.."","", function(player,nearestId)
				nearestId = parseInt(nearestId)
				if nearestId ~= nil then
					local playerSource = vRP.getUserSource(nearestId)
					if playerSource ~= nil then
						vRP.getUserIdentity(user_id, function(identity)
							if identity then
								name = identity.name
								firstname = identity.firstname
								age = identity.age
								poza = player
								rank = vRP.getFactionRank(user_id)
    		    				vRP.getUserAddress(user_id, function(address)
    		    				  local home = ""
    		    				  local number = ""
								  poza = player
    		    				  if address then
    		    				    home = address.home
    		    				    number = address.number
    		    				  else
    		    				  	home = "Fara Domiciliu"
    		    				  	number = 0
    		    				  end
									--TriggerClientEvent("showPoliceDocument", source, {name = "Comsa", firstname = "Mafiotu", age = 30, address = "Strada AmPulaMare Nr. 23"})
									vRP.request(playerSource, "<font color= 'red'>"..GetPlayerName(player).."</font> <font color= 'green'>["..vRP.getUserId(player).."]</font> vrea sa-ti arate legitimatia. Accepti?",50, function(player,ok)
										if ok then
											TriggerClientEvent("claudiu:showSmurdBadge", playerSource, {nume = name, prenume = firstname, target = poza})
										end
									end)
								end)
							end
		
						end)
					else
						vRPclient.notify(player,{"Acest jucator nu este in aproprierea ta."})
					end
				else
					vRPclient.notify(player, {"Invalid value"})
				end
			end)
		end
	end)
end,"Arata legitimatia de smurd!"}


vRP.registerMenuBuilder("police", function(add,data)
  local user_id = vRP.getUserId(data.player)
  if user_id ~= nil then
    local choices = {}
	
    if vRP.isUserInFaction(user_id,"Politia Romana") then
      choices["Arata Legitimatie"] = show_policeDoc 
    end
	
    add(choices)
  end
end)

vRP.registerMenuBuilder("police", function(add,data)
	local user_id = vRP.getUserId(data.player)
	if user_id ~= nil then
	  local choices = {}
	  
	  if vRP.isUserInFaction(user_id,"SRI") then
		choices["Arata Legitimatie"] = show_SRIDoc 
	  end
	  
	  add(choices)
	end
  end)

vRP.registerMenuBuilder("main", function(add,data)
	local user_id = vRP.getUserId(data.player)
	if user_id ~= nil then
	  local choices = {}
	  
	  if vRP.isUserInFaction(user_id,"Smurd") then
		choices["Arata Legitimatie"] = show_smurddoc 
	  end
	  
	  add(choices)
	end
  end)