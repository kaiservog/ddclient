class window.TextScene
class window.Map
	constructor: (selfPlayer) ->

		@add = (obj, type) ->
			try
			  switch type
			  	when Types::LIVE
			  		@scene.add mesh for mesh in obj.getLive().getMeshes()
			  	when Types::TEXT
			  		@sceneText.add obj.getMesh()
			  	when Types::MESH
			  		@scene.add obj.getMesh()

			catch error
				console.log error

		@clean = ->
			@scene.remove obj for obj in @scene.children when obj && obj.dynamic	

		@getBlocks = -> @walls

		@scene = new THREE.Scene
		@sceneText = new THREE.Scene

		@sceneText.add selfPlayer.getCameraObject()
		@scene.add new THREE.AmbientLight 0xFFFFFF
		@sceneText.add new THREE.AmbientLight 0xFFFFFF

		@tiles = [[0,0,0,0,0,0,0,0,0,0],
				  [0,0,1,1,1,1,1,0,0,0],
				  [0,0,1,1,1,1,1,0,0,0],
				  [0,0,0,0,1,0,0,0,0,0],
				  [0,1,1,0,1,0,1,1,0,0],
				  [0,1,1,1,1,1,1,1,0,0],
				  [0,1,1,0,1,0,1,1,0,0],
				  [0,0,0,0,1,0,0,0,0,0],
				  [0,0,0,0,1,0,0,0,0,0],
				  [0,0,0,0,0,0,0,0,0,0]]

		@floor = new Floor @tiles
		@walls = new Walls @tiles
		
		@add @floor, Types::MESH
		@add @walls, Types::MESH