global.fs = require 'fs'
global.jade = require 'jade'
global.coffee = require 'coffee-script'
global.templates = {}
global.staticContent = {}
global.isDevMode = true
global.isWindows = /win/i.test(process.platform)
global.startTime = new Date

jade.templates = {}
fs.tree = {}

mime =
	html: "text/html"
	css: "text/css"
	js: "text/javascript"
	png: "image/png"
	jpg: "image/jpg"
	gif: "image/gif"
	json: "text/json"
	ico: "image/x-icon"

modifiedTimes = {}


loadFiles = ->
	walk documentRoot, checkFile, checkDir
	fs.treeString = treeString fs.tree['']
	setTimeout loadFiles, 1000


# Load application files first because other files reference them.
setTimeout (-> walk documentRoot + '/src/app', checkFile), 1

# Load all files
setTimeout loadFiles, 250


class Node
	constructor: (@rel) ->
		@name = @rel.replace /.*\//, ''

getNode = (rel) ->
	node = fs.tree[rel]
	if not node
		node = fs.tree[rel] = new Node rel
	return node

treeString = (node, maxDepth = 100) ->
	if node
		string = node.name
		if node.files and maxDepth
			maxDepth--
			string += '/'
			string += (treeString file, maxDepth for file in node.files).join '|'
			string += '\\'
		return string


checkFile = (path, stat) ->
	modifiedTime = stat.mtime.getTime()
	previousTime = modifiedTimes[path]
	recentlyModified = modifiedTime > previousTime

	if recentlyModified or not previousTime
		modifiedTimes[path] = modifiedTime
		loadFile path, modifiedTime, previousTime


checkDir = (path, files) ->
	rel = path.substr(documentRoot.length + 1)
	dir = getNode rel
	dir.files = []
	for file in files
		if file[0] isnt '.'
			unless rel is '' and file is 'build'
				dir.files.push getNode rel + (if rel then '/' else '') + file


compileFile = (path, callback) ->
	fs.readFile source, (err, content) ->
		log.error if err
		if /\.coffee$/.test source
			content = coffee.compile('' + content)
			content = content.replace(/^\(function\(\) \{/, '')
			content = content.replace(/\}\)\.call\(this\);[\r\n]*$/, '')
		callback(content)


refreshClients = (changed) ->
	clearTimeout refreshClients.t
	refreshClients.t = setTimeout(->
		io.sockets.emit 'refresh', changed
	, 1200)



restartApp = (rel) ->
	log.warn "Critical file changed (#{rel}). Restarting app."
	setTimeout process.exit, 10


loadFile = (path, modifiedTime, isReload) ->
	rel = path.substr(documentRoot.length + 1)
	pos = rel.indexOf "/"
	dir = rel.substr 0, pos
	rel = rel.substr pos + 1

	if isReload
		log "Updated: #{rel}"

	# Load static files.
	if dir is "static"
		fs.readFile path, (err, content) ->
			loadStatic rel, content
			extension = getExtension path
			type = mime[extension] or "text/html"
			href = rel.replace(/\.html$/, '').replace(/\.coffee$/, '.js')
			app.on "GET", "/" + href, (request, response) ->
				response.writeHead 200, {"Content-Type": type}
				response.end statics.content[rel]
			refreshClients 'static'

	# Load jade templates for the server.
	else if dir is "views"
		# Load dependent templates
		loadTemplate = (name, path) ->
			fs.readFile path, (err, content) ->
				template = jade.compile(content,
					filename: path
				)
				templates[name] = template
				templates[name].path = path
				refreshClients 'template'

		name = rel.replace(/\.[a-z]+$/, "")
		loadTemplate name, path

		for otherName of templates
			if otherName isnt name
				loadTemplate otherName, templates[otherName].path

	# Load modules
	else
		path = path.replace(/\//g, "\\") if isWindows
		if /(coffee|js|json)$/.test path
			# If it's not the first time, we may need to reload or restart.
			module = require.cache[path]
			if module
				# Reloadable modules have an unload function.
				if module.unload
					module.unload()
				# Non-reloadable modules require an application restart.
				else if isReload
					return restartApp rel
			else
				delete require.cache[path]
				require path
				refreshClients 'module'


# Recursively walk a directory, calling functions on each file and directory.
walk = (dir, fileCallback, dirCallback) ->
	fs.readdir dir, (err, files) ->
		dirCallback dir, files if dirCallback
		if err
			return
		files.forEach (filename) ->
			if filename[0] isnt '.'
				path = dir + "/" + filename
				fs.stat path, (err, stat) ->
					isDirectory = stat.isDirectory()
					if isDirectory
						walk path, fileCallback, dirCallback
					else
						fileCallback path, stat if fileCallback


statics =
	content: {}
	parents: {}
	groups: {}
	timeouts: {}


loadStatic = (rel, content) ->
	if /\.coffee$/.test rel
		content = coffee.compile('' + content)
		content = content.replace(/^\(function\(\) \{/, '')
		content = content.replace(/\}\)\.call\(this\);[\r\n]*$/, '')
	statics.content[rel] = content
	if groups = statics.parents[rel]
		for group in groups
			compileStatic group
			clearTimeout statics.timeouts[group]
			statics.timeouts[group] = setTimeout( ->
				compileStatic group
			, 500)


compileStatic = (group) ->
	files = config.statics[group]
	code = ''
	for file in files
		code += "/* FILE: #{file} */\n"
		code += statics.content[file]
	statics.content[group] = code

	type = mime[getExtension group]
	app.on "GET", group, (request, response) ->
		response.set "Content-Type", type
		response.send statics.content[group]

	refreshClients 'static'


mapStatics = ->
	groups = config.statics
	for group, files of groups
		for file in files
			list = statics.parents[file] or (statics.parents[file] = [])
			list.push group if list.indexOf(group) < 0


getExtension = (file) ->
	return file.replace /.*\./, ''


mapStatics()