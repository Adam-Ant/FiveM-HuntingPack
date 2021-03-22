spawnPoint = vector3(-980, -2995, 14)

courses  = {
	airport_dev = {
		pretty_name = "Airport Dev Track",
		spawns = {
			defense = vector4(-1330,-3040,14,235),
			attack = vector4(-1400,-3000,14,235),
			runner = vector4(-1280,-3080,14,235),
		},
		goal = vector4(-900, -3295,17,4)
	},
	lester_to_docks = {
		pretty_name = "Lester's Factory to the Docks",
		spawns = {
			attack = vector4(771,-489,36,209),
			defense = vector4(791.5,-914,24.8,182),
			runner = vector4(773,-964,25.5,182),
		},
		goal = vector4(-413, -2464 ,5.5 ,6)
	},
	storm_drain = {
		pretty_name = "Up the Storm Drain",
		spawns = {
			defense = vector4(665.5, 1479, 10, 14.5),
			attack = vector4(640.5, -1813.0, 10, 355),
			runner = vector4(600, -1407, 10, 15.5),
		},
		goal = vector4(1097, -209, 55, 4)
	},
	beachy_boi = {
		pretty_name = "Beachy Boi",
		spawns = {
			defense = vector4(-1837.36, -760.02, 8.47, 229.14),
			attack = vector4(-2044.08, -529.69, 8.82, 324.02),
			runner = vector4(-1861.32, -808.5, 6, 322.57),
		},
		goal = vector4(-1537.86, -2265.92, 5.65, 4),
	},
	building_up = {
		pretty_name = "Building up",
		spawns = {
			defense = vector4(-134.91, -511.88, 29.73, 93.76),
			attack = vector4(-74.69, -818.92, 326.56, 324.7),
			runner = vector4(-139.68, -594.08, 212.16, 201),
		},
		goal = vector4(-1796.17, -1180.36, 13.4, 4)
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
	['Bruiser'] = { model = 'bruiser'},
	['Voodoo'] = { model = 'voodoo2' },
	['Kalhari'] = { model = 'kalahari' },
	['Osiris'] = { model = 'osiris' },
	['Vagner'] = { model = 'vagner' },
}

runnerVehicles = { 
	['Glendale'] = {
		model = 'glendale',
		time = 10,
		speed = 35,
	},
	['Ripley'] = {
		model = 'ripley',
		time = 10,
		speed = 25,
	},
	['Dump Truck'] = {
		model = 'dump',
		time = 10,
		speed = 12,
	},
	['Dune Truck'] = {
		model = 'rallytruck',
		time = 10,
		speed = 45,
	},
	['Bus'] = {
		model = 'bus',
		time = 10,
		speed = 25,
	},
	['Cerberus'] = {
		model = 'cerberus',
		time = 10,
		speed = 30,
	},
	['Stockade'] = {
		model = 'stockade',
		time = 10,
		speed = 30,
	},
	['RCV'] = {
		model = 'riot2',
		time = 10,
		speed = 30,
	},
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
--attack: brutus2
--defend: bruiser
--runner: cerberus
--
--attack: voodoo
--defender: kalahari
--runner: stockade
--
--attack: orirus
--defender: vagner
--runner: rcv
