bombMessages = {
	['installed']        = 'Bomb installed with arm speed of ~g~%d %s~s~ and delay of ~g~%d~s~ seconds.',
	['armed']            = '~y~Armed.',
	['destroyed']        = '~r~Destroyed.',
}

function bombActive(speedLimit, allowedSeconds)
	isArmed = false
	limit = speedLimit
	secondsBelow = 0
	vehicle = GetVehiclePedIsUsing(PlayerPedId())
	
	showNotification(bombMessages['installed'], speedLimit, 'mph', allowedSeconds)

	while isActive do
		Citizen.Wait(250)

		speed = GetEntitySpeed(vehicle) * 2.236936

		if speed >= limit then
			secondsBelow = 0

			if not isArmed then
				isArmed = true
				showNotification(bombMessages['armed'])
				PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', 1)
				Citizen.CreateThread(function ()
					while isArmed and isActive do
						if secondsBelow > 0 and secondsBelow < allowedSeconds then
							PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', 1)
						end
						Citizen.Wait(1000)
					end 
				end)
			end
		end

		if isArmed and speed < limit then
			secondsBelow = secondsBelow + 0.25
		end

		if secondsBelow == allowedSeconds then
			PlaySoundFrontend(-1, 'BEEP_GREEN', 'DLC_HEIST_HACKING_SNAKE_SOUNDS', 0)
		end


		if secondsBelow >= allowedSeconds + 1.5 then
			isActive = false
			isArmed = false
			secondsBelow = 0
			showNotification(bombMessages['destroyed'])
			doExplosion(vehicle)
			NetworkExplodeVehicle(vehicle, true, false, 0)
			Citizen.Wait(2000)
			TriggerServerEvent("gameFinish", "lose")
			break
		end
	end
end

function doExplosion(vehicle)
	local coords = GetEntityCoords(vehicle)
	AddExplosion(coords.x,
	coords.y,
	coords.z,
	'EXPLOSION_CAR', -- int explosionType
	10.0,             -- float damageScale
	true,            -- BOOL isAudible
	false,           -- BOOL isInvisible
	1.0              -- float cameraShake
	)
end
