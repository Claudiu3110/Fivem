RegisterServerEvent('Hostage:sync')
AddEventHandler('Hostage:sync', function(animationLib,animationLib2, animation, animation2, distans, distans2, height, targetSrc, length, spin, controlFlagSrc, controlFlagTarget, animFlagTarget, attachFlag)
	if source ~= nil and targetSrc ~= nil then
		TriggerClientEvent('Hostage:syncTarget', targetSrc, source, animationLib2, animation2, distans, distans2, height, length, spin, controlFlagTarget, animFlagTarget, attachFlag)
		TriggerClientEvent('Hostage:syncMe', source, animationLib, animation,length,controlFlagSrc,animFlagTarget)
	end
end)

RegisterServerEvent('Hostage:stop')
AddEventHandler('Hostage:stop', function(targetSrc)
	if targetSrc ~= nil then
		TriggerClientEvent('Hostage:cl_stop', targetSrc)
	end
end)

RegisterServerEvent('Carry:sync')
AddEventHandler('Carry:sync', function(animationLib,animationLib2, animation, animation2, distans, distans2, height, targetSrc, length, spin, controlFlagSrc, controlFlagTarget, animFlagTarget)
	if source ~= nil and targetSrc ~= nil then
		TriggerClientEvent('Carry:syncTarget', targetSrc, source, animationLib2, animation2, distans, distans2, height, length, spin, controlFlagTarget, animFlagTarget)
		TriggerClientEvent('Carry:syncMe', source, animationLib, animation, length, controlFlagSrc, animFlagTarget)
	end
end)

RegisterServerEvent('Carry:stop')
AddEventHandler('Carry:stop', function(targetSrc)
	if targetSrc ~= nil then
		TriggerClientEvent('Carry:cl_stop', targetSrc)
	end
end)