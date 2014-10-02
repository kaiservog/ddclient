class window.Shoot extends Live
	constructor: (@begin, @end, @sprites, @velocity) ->
		@live = new SceneObj @begin.x, @begin.z, @sprites, ['R', 'F', 'L', 'B']
		@live.velocity = @velocity
		@route = new Route Utils::getDirection('north'), @end, @live

		@update = (delta, selfPlayer) ->
			@route.update()
			@live.update delta, selfPlayer

		@getLive = -> @live

class window.ShootFactory
	spritesKeys: ['R', 'F', 'L', 'B']
	texturePool: {}

	flipTexture: (flip, textures, i) ->
		if !flip then return
		textures[i].repeat.set(-1, 1);
		textures[i].offset.set( 1, 0);


	loadTexture: (key, locale) ->
		texture = @texturePool[key]
		if !texture then @texturePool[key] = texture = THREE.ImageUtils.loadTexture(locale + "/" + ShootInfo::get(key))
		texture

	loadTextures: (name) ->
		textureKey = "shoot.#{name}.sprite."
		textureLocation = ShootInfo::get(textureKey + 'locale') + '/'
		texturesKeys = (textureKey + key for key in @spritesKeys)
		
		textures = (@loadTexture texturesKey, textureLocation for texturesKey in texturesKeys)

		flips = (ShootInfo::get(textureKey + key + '.flip') for key in @spritesKeys)

		@flipTexture flips[i], textures, i for i in [0..flips.length-1]

		textures

	createSprite: (texture, name, index) ->
		key = @spritesKeys[index]
		size = ShootInfo::get("shoot.#{name}.sprite.#{key}.size")
		sprite = new THREE.Sprite new THREE.SpriteMaterial({ map : texture })

		sprite.visible = false
		sprite.scale.set size.w, size.h, 0
		sprite.castShadow = false
		sprite.dynamic = true
		sprite

	get: (name, begin, end) ->
		textures = @loadTextures name
		sprites = {}
		sprites[@spritesKeys[i]] = @createSprite textures[i], name, i for i in [0..@spritesKeys.length-1]

		new Shoot begin, end, sprites, ShootInfo::get('shoot.fireball.velocity')

class window.ShootInfo
	class window.ShootInfo
	dic: {}

	get: (key) ->
		@dic[key]

	ShootInfo::dic['shoot.fireball.name'] =  'fireball'
	ShootInfo::dic['shoot.fireball.sprite.locale'] = 'img'
	ShootInfo::dic['shoot.fireball.sprite.R'] = 'fireball_3.png'
	ShootInfo::dic['shoot.fireball.sprite.F'] = 'fireball_6.png'
	ShootInfo::dic['shoot.fireball.sprite.L'] = 'fireball_3.png'
	ShootInfo::dic['shoot.fireball.sprite.B'] = 'fireball_6.png'
	ShootInfo::dic['shoot.fireball.sprite.L.flip'] = true
	ShootInfo::dic['shoot.fireball.sprite.B.flip'] = true
	ShootInfo::dic['shoot.fireball.sprite.R.size'] = {w: 112 / 2, h: 72 / 2}
	ShootInfo::dic['shoot.fireball.sprite.F.size'] = {w: 72 / 2, h: 68 / 2}
	ShootInfo::dic['shoot.fireball.sprite.L.size'] = {w: 112 / 2, h: 72 / 2}
	ShootInfo::dic['shoot.fireball.sprite.B.size'] = {w: 72 / 2, h: 68 / 2}
	ShootInfo::dic['shoot.fireball.velocity'] = 0.05