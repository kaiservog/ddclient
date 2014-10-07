class window.Live
class window.SceneObj
	constructor: (x, z, @sprites, @spritesMap, @perspective) ->
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

			@side = @perspective.getSide selfPlayer, this

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
