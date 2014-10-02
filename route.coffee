class window.Route
	constructor: (@direction, @endPosition, @live) ->
		@finished = false
		@prevTime = performance.now()

		@update =->
			position = @live.position
			@live.direction.set @direction.x, @direction.y, @direction.z

			proportion = new THREE.Vector3()
			direction = new THREE.Vector3()
			distance = new THREE.Vector3()
			step = new THREE.Vector3()

			distance.x = @endPosition.x - position.x 
			distance.z = @endPosition.z - position.z

			proportion.x = distance.x / distance.z
			if distance.z > 0 then proportion.z = 1 else proportion.z = -1

			if proportion.x > 1 or proportion.x < -1
				proportion.z = proportion.z / proportion.x
				if distance.x > 0 then proportion.x = 1 else proportion.x = -1				

			if position.x == @endPosition.x and position.z == @endPosition.z
				@finished = true
				return true

			time = performance.now()
			delta = ( time - @prevTime ) / 1000
			
			moviment = @live.velocity * delta

			step.x += moviment * proportion.x
			step.z += moviment * proportion.z
			
			if step.x >= 0 and position.x + step.x >= @endPosition.x 
				position.x = @endPosition.x
			else if step.x < 0 and position.x + step.x <= @endPosition.x 
				position.x = @endPosition.x
			else
				position.x += step.x

			if step.z >= 0 and position.z + step.z >= @endPosition.z 
				position.z = @endPosition.z
			else if step.z < 0 and position.z + step.z <= @endPosition.z 
				position.z = @endPosition.z
			else
				position.z += step.z

			x = Math.round position.y
			z = Math.round position.z

		@isFinished = ->
			@finished
