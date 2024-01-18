lua54 'yes'
fx_version 'adamant'
games { 'gta5' };

name 'RageUI';
 
client_scripts {
	'@ox_lib/init.lua',
    "config_boombox.lua",
	"client/*.lua",
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	"config_boombox.lua",
    "server/*.lua",
}
