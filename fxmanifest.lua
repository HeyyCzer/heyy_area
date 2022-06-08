fx_version 'cerulean'
game 'gta5'

author "HeyyCzer"
description "Bloqueia uma determinada área do mapa, para realização de ações"

shared_scripts "config/config.lua"

client_scripts {
	'@vrp/lib/utils.lua',
	'src/client.lua'
}

server_scripts {
	'@vrp/lib/utils.lua',
	'src/server.lua',
	'src/webhooks.lua',
}