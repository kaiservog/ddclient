class window.Monster extends Live
	constructor: (x, z, @sprites) ->
		@live = new SceneObj x, z, @sprites, ['R', 'F', 'L', 'B', 'F1', 'F2', 'F3', 'F4', 'F5', 'F6']
		a = new THREE.Vector3(400, 0, 500)
		b = new THREE.Vector3(650, 0, 500)
		c = new THREE.Vector3(400, 0, 500)
		d = new THREE.Vector3(250, 0, 500)
		e = new THREE.Vector3(400, 0, 800)

		@sul = new THREE.Vector3(0, 0, -1)
		@norte = new THREE.Vector3(0, 0, 1)
		@leste = new THREE.Vector3(-1, 0, 0)
		@oeste = new THREE.Vector3(1, 0, 0)
		@i = 0

		@routes = [new Route(@sul, a, @live), new Route(@oeste, b, @live), new Route(@leste, c, @live), new Route(@leste, d, @live), new Route(@norte, e, @live)]
		@update = (delta, selfPlayer) ->
			if @i > 4 then @i = 0
			if @routes[@i].isFinished()
				@routes[@i] = new Route(@routes[@i].direction, @routes[@i].endPosition, @live)
				@i += 1
			else
				@routes[@i].update()
			@live.update delta, selfPlayer
			#@actualSprite.visible = true nao sei se posso tirar
			#@actualSprite.rotation.y = @yRotation
			#utils.stare selfPlayer, this
			#if ! utils.hasCollision @position, @direction, blocks then @position.x += 0.5 * @direction.x

		@getLive = -> @live