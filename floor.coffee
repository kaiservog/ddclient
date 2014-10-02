class window.Floor extends SceneObj
	planeGeo: new THREE.PlaneGeometry(100, 100)
	
	constructor: (@tiles)->
		@addFloor = ->
			@addNormal obj for obj in @floorMeshs

		@create3DTile = (line, z) ->
			if line
				@createPlane x, z for x in [0..line.length-1] when line[x] isnt 0

		@getMesh = -> @floor

		@createPlane = (x, z) ->
				z = (@tiles.length) - z
				plane = new THREE.Mesh @planeGeo
				plane.castShadow = false
				plane.position.set(x * 100, 0, z * 100)
				plane.rotation.x = 270 * (Math.PI / 180)
				plane

		@floorMaterial = new THREE.MeshLambertMaterial({ map : THREE.ImageUtils.loadTexture('img/floor.png') })
		@floorMeshs = (@create3DTile @tiles[z], z for z in [0..@tiles.length-1] )
		floorGeo = new THREE.Geometry()
		THREE.GeometryUtils.merge floorGeo, mesh for mesh in arr for arr in @floorMeshs
		@floor = new THREE.Mesh(floorGeo, @floorMaterial) 