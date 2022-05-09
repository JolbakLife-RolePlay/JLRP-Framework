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
	'config.weapons.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',

	'server/tables.lua',

	'server/MySQL.lua',
	
	'server/functions.lua',

	'server/classes/player.lua',

	'server/events.lua',

	'server/main.lua',

	'server/loops.lua',

	-- for Framework table injection we remove them from shared_scripts
	'shared/functions/*.lua',	
	'shared/framework.lua',
}

client_scripts {
	'client/tables.lua',
	'client/functions.lua',
	'client/events.lua',
	'client/main.lua',
	'client/loops.lua',

	-- for Framework table injection we remove them from shared_scripts
	'shared/functions/*.lua',	
	'shared/framework.lua',
}

ui_page {
	'html/ui.html'
}

files {
	'imports.lua',

	'html/ui.html',

	'html/css/app.css',

	'html/javascript/mustache.min.js',
	'html/javascript/wrapper.js',
	'html/javascript/app.js',

	'html/fonts/pdown.ttf',
	'html/fonts/bankgothic.ttf',

	'html/images/accounts/bank.png',
	'html/images/accounts/black_money.png',
	'html/images/accounts/money.png'
}

dependencies {
	'oxmysql',
	'spawnmanager',
}
