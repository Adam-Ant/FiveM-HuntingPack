RegisterNetEvent('gameStart')
AddEventHandler('gameStart', function(attackVehicle, defenseVehicle, runnerVehicle, map, bombSpeed, bombTime, powerMultiplier)
 	for _, playerId in ipairs(GetPlayers()) do
		TriggerClientEvent('cl_gameStart', playerId, attackVehicle, defenseVehicle, runnerVehicle, map, bombSpeed, bombTime, powerMultiplier)
		Citizen.Wait(500)
	end
	
end)

RegisterCommand('cancel', function(source, args)
	TriggerEvent('gameFinish', 'cancel')
end)

RegisterNetEvent('gameFinish')
AddEventHandler('gameFinish', function(status)
	TriggerClientEvent('cl_gameFinish', -1, status)
end)
