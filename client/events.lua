finishMessages = {
	['win'] = "~g~WINNER",
	['lose'] = "~r~LOSER",
	['cancel'] = ""
}

team = "attack"
isActive = false
blipId = 0
attackVehicle = "adder"
defendVehicle = "adder"
runnerVehicle = "bus"
selectedMap = "airport_dev"

displayText = false

AddEventHandler('onClientGameTypeStart', function()
    exports.spawnmanager:setAutoSpawnCallback(function()
        exports.spawnmanager:spawnPlayer({
            x = spawnPoint.x,
            y = spawnPoint.y,
            z = spawnPoint.z
	})
    end)

    exports.spawnmanager:setAutoSpawn(true)
	exports.spawnmanager:forceRespawn()
end)

RegisterNetEvent('cl_gameStart')
AddEventHandler('cl_gameStart',function(srvAttackVehicle, srvDefendVehicle, srvRunnerVehicle, course, bombSpeed, bombTime, powerMultiplier )
	courseData = courses[course]
	if team == "defense" then
		vehicleModel = srvDefendVehicle
	elseif team == "attack" then
		vehicleModel = srvAttackVehicle
	elseif team == "runner" then
		vehicleModel = srvRunnerVehicle
	end

    local coords = courseData.spawns[team]

	DoScreenFadeOut(250)

	SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z + 2, false, false, false, false)

    vehicle = spawnVehicle(vehicleModel, coords.x, coords.y, coords.z, coords.w)
    SetPedIntoVehicle(GetPlayerPed(-1), vehicle.VehicleId, -1)
	isActive = true

	Citizen.CreateThread(function()
		drawMarker(courseData.goal)
	end)

	-- Create blip
	if courseData.goalBlip == nil then
		courseData.goalBlip = courseData.goal
	end

	blipId = addMissionBlip(courseData.goalBlip.x, courseData.goalBlip.y, courseData.goalBlip.z)

	-- BEEP BEEP MOTHERFUCKAAA
	if team == "runner" then
		ModifyVehicleTopSpeed(vehicle.VehicleId, powerMultiplier)
		Citizen.CreateThread(function()
			bombActive(bombSpeed, bombTime)
		end)

		Citizen.CreateThread(function()
			checkGoal(courseData.goal)
		end)
	end

	DoScreenFadeIn(500)
end)

RegisterNetEvent('cl_gameFinish')
AddEventHandler('cl_gameFinish', function(status)
	DoScreenFadeOut(100)
	ped = GetPlayerPed(-1)

	isActive = false

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

	SetEntityCoords(PlayerPedId(), spawnPoint.x, spawnPoint.y, spawnPoint.z + 1, false, false, false, false)

	if team == "attack" then
		if status == 'lose' then
			status = 'win'
		elseif status == 'win' then
			status = 'lose'
		end
	end

	finishMessage = finishMessages[status]

	if status == 'win' then
		-- Play Sound
		print('Winner')
	elseif status == 'win' then
		-- play sound
		print('loser')
	end

	CreateThread(function()
		Citizen.SetTimeout(5000, function()
			displayText = false
		end)
		displaySplashText(finishMessage)
	end)

	DoScreenFadeIn(500)
end)


function drawMarker(marker)
	while isActive do
		DrawMarker(1, marker.x, marker.y, marker.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, marker.w, marker.w, marker.w, 255, 255, 0, 50, false, true, 2, nil, nil, false)
		Citizen.Wait(0)
	end
end

function checkGoal(marker)
	local hasTouched = false
	markerPos = vector3(marker.x, marker.y, marker.z - 3)
	while isActive do
		local playerCoord = GetEntityCoords(PlayerPedId(), false)
		if Vdist2(playerCoord, markerPos) < (marker.w * 1.5) then
			if not hasTouched then
				hasTouched = true
				TriggerServerEvent("gameFinish", "win")
			end
		end
		Citizen.Wait(0)
	end
end
