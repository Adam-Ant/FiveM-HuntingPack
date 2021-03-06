spawnPoint = vector3(-980, -2995, 14)

courses  = {
	["ZZ Airport Dev Track"] = {
		spawns = {
			defend = vector4(-1330,-3040,14,235),
			attack = vector4(-1400,-3000,14,235),
			runner = vector4(-1280,-3080,14,235),
		},
		goal = vector4(-900, -3295,17,4)
	},
	["Lester's Factory to the Docks"] = {
		spawns = {
			attack = vector4(771,-489,36,209),
			defend = vector4(791.5,-914,24.8,182),
			runner = vector4(773,-964,25.5,182),
		},
		goal = vector4(-413, -2464 ,8 ,12),
		goalBlip = vector4(-348, -2529.8, 6, 8)
	},
	["Up the Storm Drain"] = {
		spawns = {
			defend = vector4(665.5, -1479, 10, 14.5),
			attack = vector4(640.5, -1813.0, 10, 355),
			runner = vector4(600, -1407, 10, 15.5),
		},
		goal = vector4(1097, -209, 58, 4)
	},
	["Beachy Boi"] = {
		spawns = {
			defend = vector4(-1837.36, -760.02, 8.47, 229.14),
			attack = vector4(-2044.08, -529.69, 8.82, 324.02),
			runner = vector4(-1861.32, -808.5, 6, 322.57),
		},
		goal = vector4(-1537.86, -2265.92, 5.65, 4),
	},
	["Building Up"] = {
		spawns = {
			defend = vector4(-134.91, -511.88, 29.73, 93.76),
			attack = vector4(-74.69, -818.92, 326.56, 324.7),
			runner = vector4(-139.68, -594.08, 212.16, 201),
		},
		goal = vector4(-1796.17, -1180.36, 13.4, 4)
	},
	["Cypress Flats to Del Pero Pier"] = {
		spawns = {
			defend = vector4(928, -2074.8, 30.5, 353),
			attack = vector4(911.8, -2243.7, 30.5, 353),
			runner = vector4(934.8, -2024.5, 29.75, 353),
		},
		goal = vector4(-1791, -1175.5, 15, 6)
	},
	-- Playtested, works
	["Dirt Track to Humane Labs"] = {
		spawns = {
			defend = vector4(922.5, 2199.4, 49, 56.5),
			attack = vector4(1053.8, 2043.7, 53, 32),
			runner = vector4(899.5, 2217.8, 49, 63.8),
		},
		goal = vector4(3385.5, 3719.72, 37, 6)
	},
}


adVehicles = { 
	['Adder'] = { model = 'adder'},
	['Vigilante'] = { model = 'vigilante'},
	['Ramp Buggy'] = { model = 'dune4' },
	['Phantom Wedge'] = { model = 'phantom2'},
	['Scramjet'] = { model = 'scramjet' },
	['Dune Truck'] = { model = 'rallytruck'},
	['Trashmaster'] = { model = 'trash'},
	['Voltic'] = { model = 'voltic' },
	['Rocket Voltic'] = { model = 'voltic2' },
	['Brutus'] = { model = 'brutus2' },
	['Dominator'] = { model = 'dominator5'},
	['Voodoo'] = { model = 'voodoo2' },
	['Kalhari'] = { model = 'kalahari' },
	['Osiris'] = { model = 'osiris' },
	['Vagner'] = { model = 'vagner' },
	['X80 Proto'] = { mode = 'prototipo'},
}

runnerVehicles = { 
	['Glendale'] = {
		model = 'glendale',
		time = 5,
		speed = 35,
	},
	['Ripley'] = {
		model = 'ripley',
		time = 5,
		speed = 25,
	},
	['Dump Truck'] = {
		model = 'dump',
		time = 10,
		speed = 12,
	},
	['Dune Truck'] = {
		model = 'rallytruck',
		time = 5,
		speed = 45,
	},
	['Bus'] = {
		model = 'bus',
		time = 5,
		speed = 25,
	},
	['Cerberus'] = {
		model = 'cerberus',
		time = 5,
		speed = 30,
		power = 0.9,
	},
	['Stockade'] = {
		model = 'stockade',
		time = 5,
		speed = 30,
	},
	['RCV'] = {
		model = 'riot2',
		time = 5,
		speed = 30,
	},
	['Chernobog'] = {
		model = 'chernobog',
		time = 7,
		speed = 30,
	},
}

-- Vehicle Colours from pastebin.com/pwHci0xK
vehicleColours = {
	["attack"] =  12,
	["defend"] =  121,
	["runner"] = 29,
}
--Presets
--attack: Dune
--defend: Trashmaster
--runner: Dump
--
--attack: voltic
--defend: rocket voltix
--runner: ripley
--

--
--attack: voodoo
--defender: kalahari
--runner: stockade
-- 

-- Playtested
--attack: orirus
--defender: vagner
--runner: rcv

--runner chernobog
--defender x80 proto
-- attacker ramp buggy

--attack: brutus
--defend: dominator
--runner: cerberus