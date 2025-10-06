fx_version 'adamant'

game 'gta5'
name 'samy_weapondamage'
description 'A lightweight script for modifying weapon damage'
author 'iitzSamy'

version '1.0.0'
lua54 'yes'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client.lua'
}

escrow_ignore {
    'client.lua',
    'config.lua'
}