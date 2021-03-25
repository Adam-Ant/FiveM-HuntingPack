playerTeams = {}
playerReady = {}

-- Lobby Handler
RegisterNetEvent('huntingpack:svStartLobby')
AddEventHandler('huntingpack:svStartLobby', function()
	playerTeams = {}
	playerReady = {}

	for _, playerId in ipairs(GetPlayers()) do
		isHost = false
		if playerId == tostring(source) then
			isHost = true
		end

		playerTeams[GetPlayerName(playerId)] = ""
		playerReady[GetPlayerName(playerId)] = false

		TriggerClientEvent('huntingpack:clStartLobby', playerId, isHost)
	end
	-- Send all players a list of all players, to show on Lobby Menu
	TriggerClientEvent('huntingpack:clTeamUpdate', -1, playerTeams)
end)

-- Recv'd whenever any player changes team
RegisterNetEvent('huntingpack:svTeamUpdate')
AddEventHandler('huntingpack:svTeamUpdate', function(recvTeam)
	playerTeams[GetPlayerName(tostring(source))] = recvTeam
	table.sort(playerTeams)
	TriggerClientEvent('huntingpack:clTeamUpdate', -1, playerTeams)
end)

-- Recv'd when a lobby setting is changed
RegisterNetEvent('huntingpack:svLobbyUpdate')
AddEventHandler('huntingpack:svLobbyUpdate', function(recvSetting, recvOpt)
	TriggerClientEvent('huntingpack:clLobbyUpdate', -1, recvSetting, recvOpt)
end)

-- Game Setup Handlers
RegisterNetEvent('huntingpack:svStartSpawn')
AddEventHandler('huntingpack:svStartSpawn', function(lobbySettings)
	Citizen.CreateThread(function()
		while true do
			local allReady = true
			for _, v in pairs(playerReady) do
				if not v then
					allReady = false
				end 
			end
			if allReady then
				break
			end
			Citizen.Wait(0)
		end
		TriggerClientEvent('huntingpack:clGameStart', -1)
	end)

	for _, playerId in ipairs(GetPlayers()) do
		playerName = GetPlayerName(playerId)
		local playerVehicle = lobbySettings[playerTeams[playerName]]

		-- Tell the client to move & spawn vehicle
		TriggerClientEvent('huntingpack:clStartSpawn', playerId, lobbySettings['map'], playerTeams[playerName], playerVehicle)

		-- If they dont report as ready in 5 sec, assume they are and keep spawning
		Citizen.SetTimeout(5000, function()
			if not playerReady[playerName] then
				playerReady[playerName] = true
				print("Warning: Forcing ready status for " .. playerName)
			end
		end)

		-- Wait for the player to report ready before spawning the next
		while not playerReady[playerName] do
			Citizen.Wait(0)
		end
	end
end)

-- Recv'd when a client has finished spawning vehicle
RegisterNetEvent('huntingpack:svReportReadyToStart')
AddEventHandler('huntingpack:svReportReadyToStart', function()
	playerReady[GetPlayerName(tostring(source))] = true
end)

-- Recv'd when game finished - win, loss or cancel
RegisterNetEvent('huntingpack:svGameFinish')
AddEventHandler('huntingpack:svGameFinish', function(status)
	TriggerClientEvent('huntingpack:clGameFinish', -1, status)
end)

RegisterCommand('cancel', function(source, args)
	TriggerEvent('huntingpack:svGameFinish', 'cancel')
end)
