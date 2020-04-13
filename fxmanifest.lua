fx_version 'adamant'

game 'gta5'

client_script "client.lua"
server_script "@mysql-async/lib/MySQL.lua"
server_script "server.lua"

files {
	"html/index.html",
	"html/index.js",
	"html/config.js",
	"html/textanim.js",
	"html/index.css",
	"html/custom.css",
	"html/textanim.css",
	"html/laptopscreenbg.jpg",
	"html/tabletbg.png",
}

ui_page "html/index.html"

dependency "es_extended"
