fs.cache = {} unless fs.cache

app.on 'get', '/svg', (request, response) ->
	send response, 'code/svg'