-- Menu
local _altX = false
local _altY = false
local _altWidth = false
local _altTitle = false
local _altSubTitle = false
local _altMaxOption = false

-- Controls
local teamComboBoxItems = { '~r~Attackers~u~', '~g~Defenders~u~', '~b~Runners~u~' }
local internalTeams = { 'attack', 'defense', 'runner' }


local teamComboBoxIndex = 1

local mapsComboBoxItems = {}
local internalMaps = {}
local mapsComboBoxIndex = 1

for k in pairs(courses) do
	table.insert(internalMaps, k)
	table.insert(mapsComboBoxItems, courses[k].pretty_name)
end

local attackVehicleComboBoxIndex = 1
local defendVehicleComboBoxIndex = 1
local adVehicleComboBoxItems = {}

for i in pairs(adVehicles) do
	table.insert(adVehicleComboBoxItems, i)
end
table.sort(adVehicleComboBoxItems)
table.insert(adVehicleComboBoxItems, 'Custom')

local runnerVehicleComboBoxIndex = 1
local runnerVehicleComboBoxItems = {}

for i in pairs(runnerVehicles) do
	table.insert(runnerVehicleComboBoxItems, i)
end
table.sort(runnerVehicleComboBoxItems)
table.insert(runnerVehicleComboBoxItems, 'Custom')

WarMenu.CreateMenu('main', 'Hunting Pack', 'Main Menu')

WarMenu.CreateSubMenu('main_setup', 'main', 'Game Setup')
WarMenu.CreateSubMenu('main_start', 'main', 'Are you sure?')

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		-- Check for menu key (.)
		if IsControlJustReleased(0, 81) then
			TriggerEvent('huntingpack:showMenu')
		end
	end
end)

AddEventHandler('huntingpack:showMenu', function()
	if WarMenu.IsAnyMenuOpened() then
		return
	end

	WarMenu.OpenMenu('main')

	bombSpeed = 25
	bombTime = 10

	while not isActive do
		if WarMenu.Begin('main') then
			local _, int_teamComboBoxIndex = WarMenu.ComboBox('Team', teamComboBoxItems, teamComboBoxIndex)
			if int_teamComboBoxIndex ~= teamComboBoxIndex then
				teamComboBoxIndex = int_teamComboBoxIndex
				team = internalTeams[teamComboBoxIndex]
			end

			WarMenu.MenuButton('Game Setup', 'main_setup')

			WarMenu.MenuButton('Start', 'main_start')

			WarMenu.End()
		elseif WarMenu.Begin('main_setup') then

			local _, int_attackVehicleComboBoxIndex = WarMenu.ComboBox('Attack Vehicle', adVehicleComboBoxItems, attackVehicleComboBoxIndex)
			if int_attackVehicleComboBoxIndex ~= attackVehicleComboBoxIndex then
				attackVehicleComboBoxIndex = int_attackVehicleComboBoxIndex
				if attackVehicleComboBoxIndex == #adVehicleComboBoxItems then
					attackVehicle = ""
				else
					attackVehicle = adVehicles[adVehicleComboBoxItems[attackVehicleComboBoxIndex]].model
				end
			end

			-- If its the last one - enable the custom box
			if attackVehicleComboBoxIndex == #adVehicleComboBoxItems then
				local pressed, attackCustomText = WarMenu.InputButton('Attack Vehicle Model Name', nil, attackVehicle)
				if pressed then
					if attackCustomText then
						-- TODO: Check this to be a valid model
						attackVehicle = attackCustomText
					end
				end	
			end

			local _, int_defendVehicleComboBoxIndex = WarMenu.ComboBox('Defence Vehicle', adVehicleComboBoxItems, defendVehicleComboBoxIndex)
			if int_defendVehicleComboBoxIndex ~= defendVehicleComboBoxIndex then
				defendVehicleComboBoxIndex = int_defendVehicleComboBoxIndex
				if defendVehicleComboBoxIndex == #adVehicleComboBoxItems then
					defendVehicle = ""
				else
					defendVehicle = adVehicles[adVehicleComboBoxItems[defendVehicleComboBoxIndex]].model
				end
			end

			-- If its the last one - enable the custom box
			if defendVehicleComboBoxIndex == #adVehicleComboBoxItems then
				local pressed, defendCustomText = WarMenu.InputButton('Defence Vehicle Model Name', nil, defendVehicle)
				if pressed then
					if defendCustomText then
						-- TODO: Check this to be a valid model
						defendVehicle = defendCustomText
					end
				end		
			end
			
			local _, int_runnerVehicleComboBoxIndex = WarMenu.ComboBox('Runner Vehicle', runnerVehicleComboBoxItems, runnerVehicleComboBoxIndex)
			if int_runnerVehicleComboBoxIndex ~= runnerVehicleComboBoxIndex then
				runnerVehicleComboBoxIndex = int_runnerVehicleComboBoxIndex
				if runnerVehicleComboBoxIndex == #runnerVehicleComboBoxItems then
					runnerVehicle = ""
				else
					runnerVehicle = runnerVehicles[runnerVehicleComboBoxItems[runnerVehicleComboBoxIndex]].model
					bombSpeed = runnerVehicles[runnerVehicleComboBoxItems[runnerVehicleComboBoxIndex]].speed
					bombTime = runnerVehicles[runnerVehicleComboBoxItems[runnerVehicleComboBoxIndex]].time
					print(bombSpeed)
					print(bombTime)
				end
			end

			-- If its the last one - enable the custom box
			if runnerVehicleComboBoxIndex == #runnerVehicleComboBoxItems then
				local pressed, runnerCustomText = WarMenu.InputButton('Runner Vehicle Model Name', nil, runnerVehicle)
				if pressed then
					if runnerCustomText then
						-- TODO: Check this to be a valid model
						runnerVehicle = runnerCustomText
						bombSpeed = 30
						bombTime = 10
					end
				end		
			end


			local _, int_mapsComboBoxIndex = WarMenu.ComboBox('Map', mapsComboBoxItems, mapsComboBoxIndex)
			if int_mapsComboBoxIndex ~= mapsComboBoxIndex then
				mapsComboBoxIndex = int_mapsComboBoxIndex
				selectedMap = internalMaps[mapsComboBoxIndex]
			end

			WarMenu.Button(attackVehicle)
			WarMenu.Button(defendVehicle)
			WarMenu.Button(runnerVehicle)
			WarMenu.Button(selectedMap)

			WarMenu.End()
		elseif WarMenu.Begin('main_start') then
			WarMenu.MenuButton('No', 'main')

			if WarMenu.Button('~r~Yes') then
				print(bombSpeed)
				print(bombTime)
				TriggerServerEvent('gameStart', attackVehicle, defendVehicle, runnerVehicle, selectedMap, bombSpeed, bombTime)
				WarMenu.CloseMenu()
			end

			WarMenu.End()
		else
			return
		end

		Citizen.Wait(0)
	end
	WarMenu.CloseMenu()
end)
