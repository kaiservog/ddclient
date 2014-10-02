class window.Label extends TextScene
	constructor: (@text) ->
		@getMesh = ->
			@mesh

		@setPosition = (x, z) ->
			@mesh.position.x = x + @xPos / 2
			@mesh.position.y = 60
			@mesh.position.z = z

		@update = (selfPLayer) ->
			new Utils().stare selfPLayer, @
			@mesh.rotation.y = @yRotation
			#@mesh.position.y++

		c = document.createElement 'canvas'
		ctx = c.getContext '2d'
		ctx.font = "Bold 10px Helvetica"
		ctx.fillStyle = "#FFFFFF"
		ctx.fillText @text, c.width / 2, c.height / 2
		
		@xPos = ctx.measureText(@text).width
		texture = new THREE.Texture c
		texture.needsUpdate = true

		material = new THREE.MeshBasicMaterial {map: texture}
		material.transparent = true

		@yRotation = 0
		
		@mesh = new THREE.Mesh new THREE.PlaneGeometry(c.width, c.height), material
		@mesh.doubleSided = true