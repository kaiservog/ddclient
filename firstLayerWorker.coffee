self.addEventListener 'message', (e) ->
	selfPlayer = e.data
	#self.postMessage @selfPlayer
	v = selfPlayer.look()
	hx = selfPlayer.getPosition().x + (v.x * 2 )
	hy = selfPlayer.getPosition().y + v.y * 1.5
	hz = selfPlayer.getPosition().z + v.z * 2
	
	selfPlayer.hands.position.x = hx
	selfPlayer.hands.position.y = hy
	selfPlayer.hands.position.z = hz

	setTimeout "layerPosition()", 10

#@layerPosition @selfPlayer