class window.SelfPlayer
	constructor: (height, width) ->
		@getPosition = ->
			@controls.getObject().position
			
		@attack = ->
			@tickerAtk.update() 
			@weaponAnimScript.wa @hands, @tickerAtk

		@getCameraObject = ->
			@controls.getObject()

		@update = (delta, blocks) ->

			@controls.update()
			if @state == 'ATK' then @attack()
			@setupRays @rays[i], i for i in [0..3]

			collisions = new Utils().hasCollision @rays, blocks
			if collisions
				if collisions[0].length > 0 then @controls.forward = false else @controls.forward = true
				if collisions[1].length > 0 then @controls.right = false else @controls.right = true
				if collisions[2].length > 0 then @controls.back = false else @controls.back = true
				if collisions[3].length > 0 then @controls.left = false else @controls.left = true
			

		@cancelMove = ->

		@setMove = (boolean) ->
			@controls.enabled = boolean

		@look = ->
			v =  new THREE.Vector3()
			@controls.getDirection v
			v

		@lookCart = ->
			v =  new THREE.Vector3()
			@controls.getDirectionCart v
			v

		@look2 = ->
			@controls.getDirection

		@setupRays = (ray, index) ->
			myDir = @lookCart()

			if index == 0 then dir = myDir
			else if index == 1 then dir = new THREE.Vector3( myDir.z * - 1, 0, myDir.x );
			else if index == 2 then dir = new THREE.Vector3( myDir.x * - 1, 0, myDir.z * - 1);
			else if index == 3 then dir = new THREE.Vector3( myDir.z, 0, myDir.x * - 1);

			ray.set @getPosition(), dir
			ray.near = 0
			ray.far = 20

		@viewAngle = 75
		@aspect = width / height
		@near = 1
		@far = 1000

		#@hands = new THREE.Sprite new THREE.SpriteMaterial({ map : THREE.ImageUtils.loadTexture("img/mace.png") }) 
		@hands = new THREE.Mesh(new THREE.PlaneGeometry(1, 1),
			new THREE.MeshLambertMaterial({ map : THREE.ImageUtils.loadTexture("img/mace.png"), transparent: true }))
		@camera = new THREE.PerspectiveCamera @viewAngle, @aspect, @near, @far

		@controls = new THREE.PointerLockControls @camera, this
		
		@camera.add @hands
		@hands.position.x =  (95 / 100) * 2 - 1
		@hands.position.y =  (10 / 100) * 2 - 1
		@hands.position.z =  -1.5
		@hands.rotation.y = 150

		@controls.movementSpeed = 0.1
		@controls.lookSpeed = 0.001
		@controls.noFly = true
		@controls.enabled = false

		@controls.getObject().position.set 400, 40, 400
		@controls.getObject().rotation.y = Math.PI
		@tickerAtk = new Tick 100
		@weaponAnim = new Anim 1, 6
		@weaponAnimScript = new AnimScript()
		@state = 'ATK'

		@rays = [new THREE.Raycaster(), new THREE.Raycaster(), new THREE.Raycaster(), new THREE.Raycaster()]
		