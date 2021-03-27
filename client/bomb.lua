bombMessages = {
  ['installed']        = 'Bomb installed with arm speed of ~g~%d %s~s~ and delay of ~g~%d~s~ seconds.',
  ['armed']            = '~y~Armed.',
  ['destroyed']        = '~r~Destroyed.',
}



function bombActive(speedLimit, allowedSeconds)
  isArmed = false
  limit = speedLimit
  speed = 0
  secondsBelow = 0

  vehicle = GetVehiclePedIsUsing(PlayerPedId())

  showNotification(bombMessages['installed'], speedLimit, 'mph', allowedSeconds)

  Citizen.CreateThread(function()
    while isActive do
      if isArmed then
        if speed < limit then
          colour = "~r~"
        else
          colour = "~g~"
        end
      else
        colour = "~y~"
      end
      floatRemaining = allowedSeconds - secondsBelow
      if floatRemaining < 0 then floatRemaining = 0 end
      timeRemaining = string.format("%s%.1f", colour, floatRemaining)
      SetTextFont(0)
      SetTextProportional(0)
      SetTextScale(1.0, 1.0)
      SetTextColour(247, 247, 247, 255)
      SetTextDropShadow(0, 0, 0, 0,255)
      SetTextEdge(1, 0, 0, 0, 255)
      SetTextDropShadow()
      SetTextOutline()
      BeginTextCommandDisplayText('STRING')
      AddTextComponentString(timeRemaining)
      EndTextCommandDisplayText(0.5, 0.03)
      Citizen.Wait(0)
    end
  end)

  while isActive do
    Citizen.Wait(100)

    speed = GetEntitySpeed(vehicle) * 2.236936


    if speed >= limit then
      if secondsBelow < allowedSeconds - 1 then
        playedFinalWarning = false
      end
      if isArmed then
        playedBombBelow = false

        if not playedBombAbove then
          playedBombAbove = true
          PlaySoundFrontend(-1, 'Bomb_Disarmed', 'GTAO_Speed_Convoy_Soundset', 1)
        end
        
        if secondsBelow > 0 then
          secondsBelow = secondsBelow - 0.1
        end

        if secondsBelow < 0 then
          secondsBelow = 0
        end
      else
        isArmed = true
        playedBombAbove = true
        playedBombBelow = false
        showNotification(bombMessages['armed'])
        PlaySoundFrontend(-1, 'Bomb_Armed', 'GTAO_Speed_Convoy_Soundset', 1)
        Citizen.CreateThread(function ()
          while isArmed and isActive do
            if secondsBelow > 0 and secondsBelow < allowedSeconds and speed < limit then
              PlaySoundFrontend(-1, 'CONFIRM_BEEP', 'HUD_MINI_GAME_SOUNDSET', 1)
            end
            Citizen.Wait(1000)
          end
        end)
      end
    end

    if isArmed and speed < limit then
      playedBombAbove = false
      if not playedBombBelow then
        playedBombBelow = true
        PlaySoundFrontend(-1, 'Bomb_Armed', 'GTAO_Speed_Convoy_Soundset', 1)
      end
      secondsBelow = secondsBelow + 0.1
    end

    if secondsBelow > allowedSeconds - 1 then
      if not playedFinalWarning then
        playedFinalWarning = true
        PlaySoundFrontend(-1, 'Fail', 'dlc_xm_silo_laser_hack_sounds', 1)
      end
    end

    if secondsBelow >= allowedSeconds + 0.25 then
      isActive = false
      isArmed = false
      secondsBelow = 0
      showNotification(bombMessages['destroyed'])
      doExplosion(vehicle)
      doExplosion(vehicle)
      doExplosion(vehicle)
      NetworkExplodeVehicle(vehicle, true, false, 0)
      Citizen.Wait(2000)
      TriggerServerEvent("huntingpack:svGameFinish", "lose")
      break
    end
  end
end

function doExplosion(vehicle)
  local coords = GetEntityCoords(vehicle)
  AddExplosion(coords.x,
  coords.y,
  coords.z,
  'EXPLOSION_TRUCK', -- int explosionType
  10.0,             -- float damageScale
  true,            -- BOOL isAudible
  false,           -- BOOL isInvisible
  1.5              -- float cameraShake
  )
end
