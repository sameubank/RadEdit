app.on 'get', '/', (request, response) ->
	send response, 'site/index'

exports.unload = ->