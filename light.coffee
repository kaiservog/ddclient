class window.Light extends SceneObj
	light: new THREE.PointLight(0xFFFFFF)

	constructor: (x, y, z) ->
		@light.position.set(x, y, z)
		@light.castShadow = false

	getMesh: ->
		@light