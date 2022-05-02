fx_version 'cerulean'

game 'gta5'

name 'Framework'
author 'Mahan Moulaei'
description 'RolePlay Framework'

version '0.0'

shared_scripts {
	'shared/locale.lua',
	'locales/*.lua',

	'config.lua',

	'shared/functions/table.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',

	'server/tables.lua',

	'server/MySQL.lua',

	'server/events.lua',

	'server/main.lua',
}

client_scripts {
	'client/main.lua',
}

ui_page {

}

files {

}

dependencies {
	'oxmysql',
	'spawnmanager',
}
