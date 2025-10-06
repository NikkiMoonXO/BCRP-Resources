fx_version 'cerulean'
use_experimental_fxv2_oal 'yes'
lua54 'yes'
game 'gta5'

name 'oc-throwitems'
author 'octane'
version '1.0.1'
description 'Throw items from inventory'

dependencies {
	'ox_lib'
}

shared_scripts {
	'@ox_lib/init.lua',
	'config.lua'
}

server_scripts {
	'server.lua'
}

client_script 'client.lua'



ox_libs {
	'math',
	'locale',
}

escrow_ignore {
"config.lua",
"readme.md"

}
dependency '/assetpacks'