currentButton = 0

delegate 'menu', 'div.menu', 'click', (event, menu, clickedButton) ->
	currentButton = clickedButton
	turnOn = not hasClass clickedButton, 'on'
	buttons = getChildren menu
	for button in buttons
		flipButton button, if button == clickedButton then turnOn else false

flipButton = (button, turnOn) ->
	flipClass button, 'on', turnOn
	if area = getElement button.id.replace 'Button', ''
		flipClass area, 'on', turnOn

bind 'editor', 'mousedown', ->
	flipButton currentButton