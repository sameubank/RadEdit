app.get '/', (request, response) ->
	send response, 'index'

exports.unload = ->
