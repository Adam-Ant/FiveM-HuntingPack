fx_version 'bodacious'
games {'gta5'}


author 'Adam-Ant'
description 'Hutning Pack reimplemented in FiveM for more freedom'
version '1.0.0'


resource_type 'gametype' { name = 'FiveM Hunting Pack' }

client_scripts {
  '@warmenu/warmenu.lua',
  'client/*.lua'
}

shared_scripts {
  'data.lua',
  'utils.lua'
}

server_script "server.lua"
