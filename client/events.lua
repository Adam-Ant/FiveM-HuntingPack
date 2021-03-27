finishMessages = {
	['win'] = "~g~WINNER",
	['lose'] = "~r~LOSER",
	['cancel'] = ""
}

team = "attack"
isActive = false
blipId = 0

displayText = false

RegisterNetEvent('huntingpack:clStartSpawn')
AddEventHandler('huntingpack:clStartSpawn',function(map, srvTeam, playerVehicle)
	DoScreenFadeOut(250)
	Citizen.Wait(260)

	local mapData = courses[map]
    local spawnCoords = mapData.spawns[team]
	team = srvTeam

	lobbyActive = false
	isActive = true

	if team == "runner" then
		vehicleModel = runnerVehicles[playerVehicle].model
	else
		vehicleModel = adVehicles[playerVehicle].model
	end

	SetEntityCoords(PlayerPedId(), spawnCoords.x, spawnCoords.y, spawnCoords.z + 2, false, false, false, false)

    vehicle = spawnVehicle(vehicleModel, spawnCoords.x, spawnCoords.y, spawnCoords.z, spawnCoords.w)
	SetVehicleColours(vehicle.VehicleId, vehicleColours[team], vehicleColours[team])
    SetPedIntoVehicle(GetPlayerPed(-1), vehicle.VehicleId, -1)

	-- Create blip
	if mapData.goalBlip == nil then
		mapData.goalBlip = mapData.goal
	end

	blipId = addMissionBlip(mapData.goalBlip.x, mapData.goalBlip.y, mapData.goalBlip.z)

	-- Create end marker, make it live if runner
	Citizen.CreateThread(function()
		drawMarker(mapData.goal)
	end)

	if team == "runner" then
		local powerMultiplier = 1
		if runnerVehicles[playerVehicle].power then
			powerMultiplier = runnerVehicles[playerVehicle].power
		end

		ModifyVehicleTopSpeed(vehicle.VehicleId, powerMultiplier)
 		Citizen.CreateThread(function()
 			bombActive(runnerVehicles[playerVehicle].speed, runnerVehicles[playerVehicle].time)
 		end)

		Citizen.CreateThread(function()
			checkGoal(mapData.goal)
		end)
	end
	TriggerServerEvent('huntingpack:svReportReadyToStart')
end)

RegisterNetEvent('huntingpack:clGameStart')
AddEventHandler('huntingpack:clGameStart',function()
	countdownActive = true
	Citizen.CreateThread(function()
		while countdownActive do
			 -- Disable acceleration/reverse every frame until race starts
			 DisableControlAction(2, 71, true)
			 DisableControlAction(2, 72, true)
			 Citizen.Wait(0)
		end
	end)
	DoScreenFadeIn(250)
	-- pause for effect..
	Citizen.Wait(1000)
	doRaceCountdown()
	countdownActive = false
end)

RegisterNetEvent('huntingpack:clGameFinish')
AddEventHandler('huntingpack:clGameFinish', function(status)
	DoScreenFadeOut(100)
	Citizen.Wait(110)
	ped = GetPlayerPed(-1)

	-- Only teleport if the game started
	if isActive then
			-- TODO: Should this just respawn randomly instead?
		SetEntityCoords(PlayerPedId(), spawnPoint.x, spawnPoint.y, spawnPoint.z + 1, false, false, false, false)
	end

	isActive = false
	lobbyActive = false

	if IsPedInAnyVehicle(ped, false) then
		local vehicle = GetVehiclePedIsIn(ped, false)
                res = exports["vehicle-manager"]:DeleteVehicle(vehicle, false)
	end

	SetBlipRoute(blipId, false)
	SetBlipAlpha(blipId, 0)
	blipId = 0

	Citizen.Wait(250)

	if IsPedDeadOrDying(ped) then
	    	exports.spawnmanager:forceRespawn()
	end

	if team == "attack" then
		if status == 'lose' then
			status = 'win'
		elseif status == 'win' then
			status = 'lose'
		end
	end

	finishMessage = finishMessages[status]

	if status == 'win' then
		-- TODO: Play Sound
		print('Winner')
	elseif status == 'win' then
		-- TODO: Play sound
		print('loser')
	end

	CreateThread(function()
		Citizen.SetTimeout(5000, function()
			displayText = false
		end)
    displayText = true
		displaySplashText(finishMessage, 0.35, 0.3, 2.5)
	end)

	DoScreenFadeIn(500)
end)


function drawMarker(marker)
	while isActive do
		DrawMarker(1, marker.x, marker.y, marker.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, marker.w, marker.w, marker.w, 255, 255, 0, 50, false, true, 2, nil, nil, false)
		Citizen.Wait(0)
	end
end

-- TODO: Move this into utils and generic?
function checkGoal(marker)
	local hasTouched = false
	markerPos = vector3(marker.x, marker.y, marker.z - 3)
	while isActive do
		local playerCoord = GetEntityCoords(PlayerPedId(), false)
		if Vdist2(playerCoord, markerPos) < (marker.w * 1.5) then
			if not hasTouched then
				hasTouched = true
				TriggerServerEvent("huntingpack:svGameFinish", "win")
			end
		end
		Citizen.Wait(0)
	end
end
