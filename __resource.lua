resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

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