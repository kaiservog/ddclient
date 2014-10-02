class window.Live
class window.SceneObj
	constructor: (x, z, @sprites, @spritesMap) ->
		@actualSprite = @sprites['F']
		@state = 'REST'
		@side = 'F'

		@velocity = 1
		@walkingAni = new Anim 4, 9
		@yRotation = @actualSprite.rotation.y

		if !x then x=0
		if !z then z=0

		@position = @actualSprite.position
		@position.set x, 0, z
		@actualSprite.position.copy @position

		@direction = new THREE.Vector3 0, 0, -1

		@dirCollision = {x: 1, z:1}
		@ticker = new Tick 10

		@update = (delta, selfPlayer) ->
			@position.y = @actualSprite.scale.y / 2
			@actualSprite.position.copy @position

			sprite.position.copy @position for sprite in @sprites
			
			utils = new Utils()

			angle = utils.angle selfPlayer.getPosition(), this

			if angle >= 0 and angle < 45 then @side = 'F'
			else if angle >= 45 and angle < 135 then @side = 'R'
			else if angle >= 135 and angle < 225 then @side = 'B'
			else if angle >= 225 and angle < 315 then @side = 'L'
			else @side = 'F' #angle >= 315 and angle <= 360 then 

			if @state == 'WALKING' and @ticker.update() then @changeSpriteByIndex @walkingAni.next()
			else if @state == 'REST' then @changeSpriteByKey @side

		@changeSpriteBySprite = (sprite) ->
			@actualSprite.visible = false
			sprite.visible = true
			@position.y = sprite.scale.y / 2
			sprite.position.copy @position
			@actualSprite = sprite

		@changeSpriteByKey = (key) ->
			@actualSprite.visible = false
			sprite = @sprites[key]
			sprite.visible = true
			
			@position.y = sprite.scale.y / 2
			sprite.position.copy @position
			
			@actualSprite = sprite

		@changeSpriteByIndex = (index) ->
			mapKey = @spritesMap[index]
			@actualSprite.visible = false
			sprite = @sprites[mapKey]
			sprite.visible = true

			@position.y = sprite.scale.y / 2
			sprite.position.copy @position
			
			@actualSprite = sprite
		

		@setPosition = (x, z) ->
			@position.set x, @position.y, z

		@getMeshes = ->
			(@sprites[key] for key in @spritesMap)
