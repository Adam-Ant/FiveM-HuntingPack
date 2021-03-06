function chat(sender, str)
    TriggerEvent(
        'chat:addMessage',
        {
            color = {255, 0, 0},
            multiline = true,
            args = {sender, str}
        }
    )
end

function getVehicleInDirection(coordFrom)
	local rayHandle = StartExpensiveSynchronousShapeTestLosProbe(coordFrom.x, coordFrom.y, coordFrom.z + 20, coordFrom.x, coordFrom.y, 0, 10, GetPlayerPed(-1), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

function addMissionBlip(x, y, z)
	local blipId = 0
	blipId = AddBlipForCoord(x, y, z)
	SetBlipRoute(blipId, true)
	return blipId
end

function doRaceCountdown()
	PlaySoundFrontend(-1, "3_2_1","HUD_MINI_GAME_SOUNDSET", 1)
    Citizen.CreateThread(function () displaySplashText("~r~3", 0.482, 0.15, 4.0) end)
    Citizen.Wait(1000)
    PlaySoundFrontend(-1, "3_2_1","HUD_MINI_GAME_SOUNDSET", 1)
    Citizen.CreateThread(function () displaySplashText("~r~2", 0.482, 0.15, 4.0) end)
    Citizen.Wait(1000)
    PlaySoundFrontend(-1, "3_2_1","HUD_MINI_GAME_SOUNDSET", 1)
    Citizen.CreateThread(function () displaySplashText("~r~1", 0.4925, 0.15, 4.0) end)
    Citizen.Wait(700)
    PlaySoundFrontend(-1, "Start","DLC_AW_Frontend_Sounds", 1)
    Citizen.Wait(300)
    displayText = true
    Citizen.CreateThread(function () displaySplashText("~g~GO", 0.4373, 0.15, 4.0) end)
    Citizen.SetTimeout(500, function() displayText = false end)
end

function displaySplashText(message, x, y, scale)
	alpha = 255
	while displayText or alpha > 0 do
		if not displayText then
			alpha = alpha - 5
			if alpha < 0 then alpha = 0 end
		end
		SetTextFont(0)
		SetTextProportional(0)
		SetTextScale(scale,scale)
		SetTextColour(247, 247, 247, alpha)
		SetTextDropShadow(0, 0, 0, 0,255)
		SetTextEdge(1, 0, 0, 0, 255)
		SetTextDropShadow()
		SetTextOutline()
		BeginTextCommandDisplayText('STRING')
		AddTextComponentString(message)
		EndTextCommandDisplayText(x, y)
		Citizen.Wait(0)
	end
end

function spawnVehicle(model, x, y, z, heading)
	local success = false
	local dimensions = GetModelDimensions(GetHashKey(model))
	local spawnOffset = 2.0
	local coords = vector3(x, y, z)
	local closest = 0
	repeat
        	vehicle = exports["vehicle-manager"]:SafelySpawnVehicle(model, coords, heading)
		success = vehicle.Success

		if success == false then
			if closest == 0 then
				loop = 0
				repeat
					closest = getVehicleInDirection(coords)
					Citizen.Wait(0)
					loop = loop + 1
				until closest ~= 0 or loop == 100
			end
			coords = GetOffsetFromEntityInWorldCoords(closest, math.abs(dimensions.x) + spawnOffset, 0, 0)
			spawnOffset = spawnOffset + 1
			Citizen.Wait(0)
		end
	until success == true
	return vehicle
end


function showNotification(message, ...)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(string.format(message, ...))
	DrawNotification(shouldBlink, false)
end
