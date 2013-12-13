app.on 'get', '/', (request, response) ->
	send response, 'index'

exports.unload = ->
	