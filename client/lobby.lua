local teamComboBoxItems = { '~r~Attackers~u~', '~g~Defenders~u~', '~b~Runners~u~' }
local internalTeams = { 'attack', 'defend', 'runner' }
local teamComboBoxIndex = 1

local lobbySettings = {
    ["attack"] = "LOADING",
    ["defend"] = "LOADING",
    ["runner"] = "LOADING",
    ["map"] = "LOADING"
}

local mapComboBoxItems = {}
for i in pairs(courses) do
	table.insert(mapComboBoxItems, i)
end
table.sort(mapComboBoxItems)

local adVehicleComboBoxItems = {}
for i in pairs(adVehicles) do
	table.insert(adVehicleComboBoxItems, i)
end
table.sort(adVehicleComboBoxItems)

local runnerVehicleComboBoxItems = {}
for i in pairs(runnerVehicles) do
	table.insert(runnerVehicleComboBoxItems, i)
end
table.sort(runnerVehicleComboBoxItems)

local playerTeams = {}

local _altSprite = false

lobbyActive = false

RegisterCommand('hp', function()
    if not lobbyActive and not isActive then
        TriggerServerEvent('huntingpack:svStartLobby')
    end
end)

RegisterNetEvent('huntingpack:clStartLobby')
AddEventHandler('huntingpack:clStartLobby', function(isHost)
    lobbyActive = true

    lobbySettings = {
        ["attack"] =  adVehicleComboBoxItems[1],
        ["defend"] =  adVehicleComboBoxItems[1],
        ["runner"] = runnerVehicleComboBoxItems[1],
        ["map"] = mapComboBoxItems[1],
    }
    
    local mapComboBoxIndex = 1
    local attackVehicleComboBoxIndex = 1
    local defendVehicleComboBoxIndex = 1
    local runnerVehicleComboBoxIndex = 1

    Citizen.CreateThread(function()
        lobbyCamera()
    end)

    TriggerServerEvent('huntingpack:svTeamUpdate', team)

    WarMenu.CreateMenu('lobby', 'Hunting Pack', 'Lobby')

    WarMenu.OpenMenu('lobby')

    while lobbyActive do
        if not WarMenu.IsAnyMenuOpened() then
            WarMenu.OpenMenu('lobby')
        end

        if WarMenu.Begin('lobby') then
            if WarMenu.SpriteButton('Sprite Button', 'commonmenu', _altSprite and 'shop_gunclub_icon_b' or 'shop_garage_icon_b') then
                _altSprite = not _altSprite
            end

			local _, int_teamComboBoxIndex = WarMenu.ComboBox('Team', teamComboBoxItems, teamComboBoxIndex)
			if int_teamComboBoxIndex ~= teamComboBoxIndex then
				teamComboBoxIndex = int_teamComboBoxIndex
				team = internalTeams[teamComboBoxIndex]
                TriggerServerEvent('huntingpack:svTeamUpdate', team)
			end

            if isHost then

                local _, int_mapComboBoxIndex = WarMenu.ComboBox('Map', mapComboBoxItems, mapComboBoxIndex)
                if int_mapComboBoxIndex ~= mapComboBoxIndex then
                    mapComboBoxIndex = int_mapComboBoxIndex
                    TriggerServerEvent('huntingpack:svLobbyUpdate', "map", mapComboBoxItems[mapComboBoxIndex])
                end

                local _, int_attackVehicleComboBoxIndex = WarMenu.ComboBox('Attack Vehicle', adVehicleComboBoxItems, attackVehicleComboBoxIndex)
                if int_attackVehicleComboBoxIndex ~= attackVehicleComboBoxIndex then
                    attackVehicleComboBoxIndex = int_attackVehicleComboBoxIndex
                    TriggerServerEvent('huntingpack:svLobbyUpdate', "attack", adVehicleComboBoxItems[attackVehicleComboBoxIndex])
                end

                local _, int_defendVehicleComboBoxIndex = WarMenu.ComboBox('Defence Vehicle', adVehicleComboBoxItems, defendVehicleComboBoxIndex)
                if int_defendVehicleComboBoxIndex ~= defendVehicleComboBoxIndex then
                    defendVehicleComboBoxIndex = int_defendVehicleComboBoxIndex
                    TriggerServerEvent('huntingpack:svLobbyUpdate', "defend", adVehicleComboBoxItems[defendVehicleComboBoxIndex])
                end

                local _, int_runnerVehicleComboBoxIndex = WarMenu.ComboBox('Runner Vehicle', runnerVehicleComboBoxItems, runnerVehicleComboBoxIndex)
                if int_runnerVehicleComboBoxIndex ~= runnerVehicleComboBoxIndex then
                    runnerVehicleComboBoxIndex = int_runnerVehicleComboBoxIndex
                    TriggerServerEvent('huntingpack:svLobbyUpdate', "runner", runnerVehicleComboBoxItems[runnerVehicleComboBoxIndex])
                end

                if (WarMenu.Button('Start Game')) then
                    TriggerServerEvent('huntingpack:svStartSpawn', lobbySettings)
                end

            end

            local playerColouredList = ""

            for i, v in pairs(playerTeams) do
                colour = ""
                if v == 'attack' then
                    colour = "~r~"
                elseif v == 'defend' then
                    colour = "~g~"
                elseif v == 'runner' then
                    colour = "~b~"
                end

                playerColouredList = playerColouredList .. colour .. i .. "~u~  "
            end

            WarMenu.Button("Players", playerColouredList)
            if not isHost then
                WarMenu.Button("Map", lobbySettings["map"])
                WarMenu.Button("Attackers Vehicle", lobbySettings["attack"])
                WarMenu.Button("Defenders Vehicle", lobbySettings["defend"])
                WarMenu.Button("Runner Vehicle", lobbySettings["runner"])
            end
            WarMenu.End()
        end

        Citizen.Wait(0)
    end

    WarMenu.CloseMenu()

end)

RegisterNetEvent('huntingpack:clTeamUpdate')
AddEventHandler('huntingpack:clTeamUpdate', function(recvPlayerTeams)
    playerTeams = recvPlayerTeams
end)

RegisterNetEvent('huntingpack:clLobbyUpdate')
AddEventHandler('huntingpack:clLobbyUpdate', function(recvSetting, recvOpt)
    lobbySettings[recvSetting] = recvOpt
end)

function lobbyCamera()
    cam = CreateCam('DEFAULT_SCRIPTED_CAMERA')

	local coordsCam = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.5, 0.5)
	local coordsPly = GetEntityCoords(PlayerPedId())
	SetCamCoord(cam, coordsCam)
	PointCamAtCoord(cam, coordsPly['x'], coordsPly['y'], coordsPly['z']+0.0)

    DisplayRadar(false)
    DisableAllControlActions(0)

	SetCamActive(cam, true)
	RenderScriptCams(true, false, 500, true, true)

    while lobbyActive do
        DisableAllControlActions(0)
        EnableControlAction(0, 191, true)
        EnableControlAction(0, 199, true)
        EnableControlAction(0, 200, true)
        EnableControlAction(0, 245, true)
        Citizen.Wait(1)
    end

    SetCamActive(cam, false)
    RenderScriptCams(false, false, 0, true, true)

    DisplayRadar(true)
    EnableAllControlActions(0)

    DestroyCam(cam, true)
end