app.on 'get', '/login', (request, response) ->
	send response, 'site/login'

exports.unload = ->