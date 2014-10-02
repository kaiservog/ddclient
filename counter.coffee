class window.Counter extends TextScene
	materials: []
	space: 0.7

	loadTexture: (n) ->
		@materials.push(THREE.ImageUtils.loadTexture "img/counters/" + n + ".png")
		#@invisibleTexture = THREE.ImageUtils.loadTexture "img/invisible.png"
		#@invisibleTexture.repeat.set 4, 4
		#@invisibleTexture.wrapS = @invisibleTexture.wrapT = THREE.RepeatWrapping

	constructor: (value) ->
		@joinNumber = (n) ->
			position = new THREE.Vector3()
			margin = (@numbersString.length * 4) / 2

			if @nOld 
				position.copy @nOld.position
				position.x += @nOld.scale.x + @space
			else 
				position.set 0-margin, 0, 1

			numberSprite = new THREE.Sprite new THREE.SpriteMaterial({ map : @materials[n] })
			numberSprite.scale.x = 3
			numberSprite.scale.y = 3

			numberSprite.position.copy position

			@nOld = numberSprite
			@numbers.push numberSprite


		@getMesh = -> @mesh

		@setPosition = (x, z) ->
			@mesh.position.x = x
			@mesh.position.y = 40
			@mesh.position.z = z

			###
			for n in @numbers
				do (n) ->
					n.position.x += x
					n.position.z += z
			###

		@update = (selfPLayer) ->
			new Utils().stare selfPLayer, @
			@mesh.rotation.y = @yRotation

			@mesh.position.y++
			@mesh

		@value = value + ''
		@counter = new THREE.Geometry()
		@numbersString = @value.split("")

		@numbers = []
		@loadTexture number for number in [0..9]
		@joinNumber parseInt n for n in @numbersString
		width = @numbersString.length * 5
		height = 10

		@yRotation = 0

		material = new THREE.MeshBasicMaterial( {  transparent: true, opacity: 0.0 } )
		@mesh = new THREE.Mesh(new THREE.PlaneGeometry(width, height), material)
		@mesh.add n for n in @numbers