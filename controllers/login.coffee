app.on 'get', '/login', (request, response) ->
	send response, 'login'

exports.unload = ->