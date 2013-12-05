fs.cache = {} unless fs.cache

app.on 'get', '/code', (request, response) ->
	send response, 'code/editor',
		tree: fs.treeString.replace(/([\\'])/g, '\\$1')

io.sockets.on 'connection', (socket) ->

	unlisten = ->
		rel = socket.rel
		file = fs.cache[rel]
		if file
			delete file.clients[socket.id]
	
	socket.on 'disconnect', ->
		unlisten()
		log 'disconnect'

	socket.on 'error', (error) ->
		log error

	socket.on 'code:get', (json) ->
		rel = json.rel
		unlisten() if socket.rel isnt rel

		sendFile = (file) ->
			log 'SOCKET ' + socket.id + ' LOADED: ' + rel
			file.clients[socket.id] = socket
			socket.rel = rel
			socket.emit 'code:got',
				rel: rel
				code: file.code

		file = fs.cache[rel]

		if file
			sendFile file
		else
			path = documentRoot + '/' + rel
			fs.readFile path, (err, content) ->
				sendFile fs.cache[rel] =
					version: 0
					rel: rel
					code: ('' + content).replace /\r/g, ''
					clients: {}

	socket.on 'code:change', (json) ->
		rel = json.rel
		change = json.change
		file = fs.cache[rel]
		if file
			code = file.code
			from = change[0]
			to = from + change[1]
			text = change[2]
			file.code = code.substr(0, from) + text + code.substr(to)
			for id, client of file.clients
				if id isnt socket.id
					log 'sending to ' + id, json
					client.emit 'code:changed', json
