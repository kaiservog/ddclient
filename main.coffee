class window.Marked
	constructor: (@ticksToDeath, @obj, @type) ->
		@ticks = 0

class window.Killer
	markeds: []

	update: (@map, @memory) ->
		@mustDie marked for marked in @markeds

	mustDie: (marked) ->
		marked.ticks++
		if marked.ticks >= marked.ticksToDeath then @kill marked

	kill: (marked) ->
		obj = marked.obj
		type = marked.type

		switch type 
			when Types::LIVE
				@map.scene.remove live for live in obj.getLive().getMeshes()
				@removeFromArray obj, @memory.lives
				
			when Types::TEXT
				@map.sceneText.remove obj.getMesh()
				@removeFromArray obj, @memory.texts

			when Types::MESH
				@map.scene.remove obj.getMesh()
				@removeFromArray obj, @memory.texts

			when Types::BLOCK
				@removeFromArray obj, @memory.blocks
		@removeFromArray marked, @markeds

	removeFromArray: (obj, array) ->
		idx = array.indexOf obj
		array.splice idx, 1

	add: (obj, ticksToDeath, type) ->
		@markeds.push new Marked(ticksToDeath, obj, type)

class window.Types
	LIVE: 1
	TEXT: 2
	MESH: 3
	BLOCK: 4

class window.Memory	
	constructor: (@map) ->
		@lives = []
		@effects = []
		@players = []
		@texts = []
		@blocks =[]

		@add = (obj, type, ticksToDeath) ->
			switch type
				when Types::LIVE
					@lives.push obj
					@map.add obj, type
					if ticksToDeath then Killer::add obj, ticksToDeath, type

				when Types::TEXT
					@texts.push obj
					@map.add obj, type
					if ticksToDeath then Killer::add obj, ticksToDeath, type

				when Types::BLOCK
					@blocks.push obj
					if ticksToDeath then Killer::add obj, ticksToDeath, type

				else console.error 'Unknown type'


class window.Main
	constructor: ->
		@height = window.innerHeight 
		@width = window.innerWidth 
		@ticks = 0
		@updating = false
		@clock = new THREE.Clock()

		@renderer = new THREE.WebGLRenderer
		@renderer.setSize(@width, @height) 	
		@renderer.shadowMapEnabled = false
		@renderer.autoClear = false

		canvas = document.getElementById('container')
		canvas.appendChild(@renderer.domElement)

		@selfPlayer = new SelfPlayer @height, @width
		@map = new Map @selfPlayer
		@hud = new Hud @selfPlayer
		@memory = new Memory @map

		instructions = document.getElementById 'instructions'
		element = document.body

		instructions.addEventListener 'click', (event) ->
			element.requestPointerLock = element.requestPointerLock || element.mozRequestPointerLock || element.webkitRequestPointerLock
			element.requestPointerLock()

		
		@dino = MonsterFactory::get('dino')
		@dino.live.setPosition 400, 800

		@counter = new Counter 1231344219890
		@counter.setPosition 400, 500

		@label = new Label "Kaiservog"
		@label.setPosition 400, 500

		@fireball = ShootFactory::get 'fireball', new THREE.Vector3(400, 0, 400), new THREE.Vector3(400, 0, 800)

		@memory.add @map.getBlocks(), Types::BLOCK

		##@skull = MonsterFactory::get('skull')
		#@skull.live.setPosition 650, 550
		#@skull.live.state = 'WALKING'
		
		@memory.add @dino, Types::LIVE
		@memory.add @counter, Types::TEXT, 120
		@memory.add @label, Types::TEXT
		@memory.add @fireball, Types::LIVE

		selfPlayer = @selfPlayer

		@pointerlockchange = (event) ->
			if (document.pointerLockElement == element || document.mozPointerLockElement == element || document.webkitPointerLockElement == element ) 
				selfPlayer.setMove true;
			else
				selfPlayer.setMove false;

		@pointerlockerror = (event) ->
			console.log 'Algum erro estranho no pointerlock'

		document.addEventListener 'pointerlockchange', @pointerlockchange, false 
		document.addEventListener 'mozpointerlockchange', @pointerlockchange, false 
		document.addEventListener 'webkitpointerlockchange', @pointerlockchange, false 

		document.addEventListener 'mozpointerlockerror', @pointerlockerror, false 
		document.addEventListener 'webkitpointerlockerror', @pointerlockerror, false
		
		@update = ->
			timeR = new Date().getTime()
			@render()
			time = new Date().getTime()

			Killer::update @map, @memory

			live.update 0, @selfPlayer, @blocks for live in @memory.lives
			text.update @selfPlayer for text in @memory.texts
			@selfPlayer.update 0, @memory.blocks
			
			
			info = document.getElementById('info')
			info.innerText = @infoText @selfPlayer.getPosition(), @selfPlayer.look()
			
			timeT = new Date().getTime() - time
			timeTR = new Date().getTime() - timeR
			#if timeT+timeTR > 10 then console.log ' timeTR = ' + timeTR + ' timeT = ' + timeT

		@render = ->
			@renderer.render @map.scene, @selfPlayer.camera
			@renderer.clearDepth()
			@renderer.render @map.sceneText, @selfPlayer.camera

		@infoText = (pos, dir)->
			x = pos.x
			y = pos.y
			z = pos.z
			dx = dir.x
			dy = dir.y
			dz = dir.z
			text = "x: #{x}, z: #{z} - x: #{dx}, y: #{dy}, z: #{dz}"
			text


class window.Animate
	constructor: ->
		@running = true
		@main = new Main
		window.m = @main

		@animate = ->
			requestAnimationFrame animate.animate
			#if !animate.main.updating then 
			if animate.running then animate.main.update()
			
	animate = new Animate()
	animate.animate()
	
