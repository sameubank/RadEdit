express = require "express"
global.app = express()
global.io = require('socket.io').listen(app.listen(config.port), {log: false})

log.info "Application listening on port " + config.port

app.on = (method, routePath, callback) ->
	existingRoute = null
	routes = app.routes[method] or []
	routes.forEach (route, i) ->
		existingRoute = route	if route.path is routePath

	if existingRoute
		existingRoute.callbacks = [callback]
	else
		app.get routePath, callback

app.on 'GET', '/ping', (request, response) ->
	response.send {}


global.send = (response, templateName, context) ->
	response.send templates[templateName] context


process.on "uncaughtException", (err) ->
	log.error err


io.on = io.sockets.on

io.on 'connection', (socket) ->

	socket.on 'error', (error) ->
		log error