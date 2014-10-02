class window.Utils
	getDirection: (dir) ->
		switch dir
			when 'north' then return new THREE.Vector3(0, 0, 1)
			when 'south' then return new THREE.Vector3(0, 0, -1)
			when 'weast' then return new THREE.Vector3(1, 0, 0)
			when 'east' then return new THREE.Vector3(-1, 0, 0)

	stare: (player, sceneObj) ->
		sceneObj.yRotation = player.controls.getObject().rotation.y
		#sceneObj.getMesh().rotation.y = player.controls.getObject().rotation.y

	wait: (func, time) ->
		if !time then time = 500
		setTimeout func, time

	id: (obj, id) -> 
		if !id then id = 'teste'
		obj.id4564652457 = id

	hasCollision: (rays, blocks) ->
		realBlocks = (block.getBlock() for block in blocks)
		collisions = (ray.intersectObjects realBlocks for ray in rays)
		#distance = 30

		collisions


	angle: (ref, target) ->
		targetDirPos = new THREE.Vector2 0, 0
		targetDir = new THREE.Vector2 target.direction.x, target.direction.z

		if targetDir.x < 0 then targetDirPos.x = targetDir.x * -1 else targetDirPos.x = targetDir.x
		if targetDir.y < 0 then targetDirPos.y = targetDir.y * -1 else targetDirPos.y = targetDir.y
		
		sideAxis = ''
		if targetDirPos.x > targetDirPos.y then sideAxis = 'Y' else sideAxis = 'X'

		left = false
		targetX = 0
		myX = ref.x - target.position.x
		targetY = 0
		myY = ref.z - target.position.z

		if sideAxis == 'X'
			if myX < 0 then left = true else left = false
			if targetDir.y > 0 then left = !left
		if sideAxis == 'Y'
			if myY < 0 then left = false else left = true
			if targetDir.x > 0 then left = !left
		
		vectorP = new THREE.Vector3().copy ref
		vectorP.x -= target.position.x
		vectorP.z -= target.position.z
		direction = new THREE.Vector3().copy target.direction
		#direction.x *= -1

		angle = (direction.angleTo vectorP) * (180/Math.PI)
		
		if left then angle = ((angle - 180) * -1 ) + 180
		angle