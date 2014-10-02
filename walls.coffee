class window.Walls
	constructor: (@tiles) ->
		@mapWalls = (l)->
			@haveWall l, c for c in [0..@tiles[0].length-1]

		@haveWall = (l, c) ->
			if c < @tiles[0].length and @tiles[l][c] == 0 and @tiles[l][c+1] == 1 then @vWalls.push {l: l, c: c}
			if c > 0 and @tiles[l][c] == 0 and @tiles[l][c-1] == 1 then @vWalls.push {l: l, c: c-1}

			if l < @tiles.length-1 and @tiles[l][c] == 0 and @tiles[l+1][c] == 1 then @hWalls.push {l: l, c: c}
			if l > 0 and @tiles[l][c] == 0 and @tiles[l-1][c] == 1 then @hWalls.push {l: l-1, c: c}

		@drawWalls = ->
			vPlanes = (@createPlane vWall.c, vWall.l, true for vWall in @vWalls)
			hPlanes = (@createPlane hWall.c, hWall.l for hWall in @hWalls)
			@planes = vPlanes.concat hPlanes

		@createPlane = (x, z, isVertical) ->
			z = (@tiles.length) - z
			x = (@tiles[0].length) - x - 3

			if !isVertical then x += 1
			x = x * 100
			z = z * 100
			if isVertical then x += 50 else z -= 50


			plane = new THREE.Mesh(new THREE.PlaneGeometry(100, 300))	
			plane.position.set x, 150, z

			if isVertical then plane.rotation.y = 90 * (Math.PI / 180)
			#THREE.GeometryUtils.merge w, mesh for mesh in @planes
			THREE.GeometryUtils.merge @wallsGeo, plane
			plane

		@haveHorizontalWall = (index) ->
			if @tiles[i] == 0 and @tiles[i+10] == 1 then return index
			else return undefined

		@getMesh = @getBlock = -> @mesh


		@vWalls = []
		@hWalls = []
		@planes = []
		@wallsGeo = new THREE.Geometry()
		@texture = THREE.ImageUtils.loadTexture('img/wall.png')
		@texture.repeat.set 4, 4
		@texture.wrapS = @texture.wrapT = THREE.RepeatWrapping
		@wMaterial = new THREE.MeshLambertMaterial({ map : @texture })
		@wMaterial.side = THREE.DoubleSide
		@mapWalls l for l in [0..@tiles.length - 1]
		@drawWalls()

		@mesh = new THREE.Mesh(@wallsGeo, @wMaterial)
