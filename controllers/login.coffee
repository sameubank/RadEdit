app.get '/login', (request, response) ->
	send response, 'login'

exports.unload = ->
	