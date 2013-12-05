global.log = console.log

tracer = require 'tracer'
colors = require 'colors'
colorConsole = tracer.colorConsole(
	filters:
		log: colors.default
		trace: colors.cyan
		debug: colors.magenta
		info: colors.green
		warn: [colors.yellow, colors.bold]
		error: [colors.red, colors.bold]
	format: "{{timestamp}} {{title}} {{file}}:{{line}} - {{message}}{{stack}}"
	preprocess: (data) ->
		data.stack =  if data.title is 'error' then '\n' + data.stack.join '\n' else ''
		data.title = data.title.toUpperCase()
	dateformat: "m/d/yy H:MM:ss"
)

global.log = colorConsole.log
for key of colorConsole
	log[key] = colorConsole[key]