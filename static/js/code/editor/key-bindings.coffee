altDown = false
ctrlDown = false
shiftDown = false

bind document, 'keydown', (event) ->
	key = event.keyCode
	alt = event.altKey
	ctrl = event.ctrlKey
	shift = event.shiftKey
	log "alt: #{alt}, ctrl: #{ctrl}, shift: #{shift}, key: #{key}"

	if ctrl and key is 83
		saveFile()