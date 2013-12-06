localStorage = window.localStorage

getValue = (key) ->
	return localStorage.getItem(key)

setValue = (key, value) ->
	return localStorage.setItem(key, value)
