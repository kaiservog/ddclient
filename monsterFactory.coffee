class window.MonsterFactory
	spritesKeys: ['R', 'F', 'L', 'B', 'F1', 'F2', 'F3', 'F4', 'F5', 'F6']
	texturePool: {}

	flipTexture: (flip, textures, i) ->
		if !flip then return
		textures[i].repeat.set(-1, 1);
		textures[i].offset.set( 1, 0);

	loadTexture: (key, locale) ->
		texture = @texturePool[key]
		if !texture then @texturePool[key] = texture = THREE.ImageUtils.loadTexture(locale + "/" + MonsterInfo::get(key))
		texture

	loadTextures: (name) ->
		textureKey = "monster.#{name}.sprite."
		textureLocation = MonsterInfo::get(textureKey + 'locale') + '/'
		texturesKeys = (textureKey + key for key in @spritesKeys)
		
		textures = (@loadTexture texturesKey, textureLocation for texturesKey in texturesKeys)

		flips = (MonsterInfo::get(textureKey + key + '.flip') for key in @spritesKeys)

		@flipTexture flips[i], textures, i for i in [0..flips.length-1]

		textures

	createSprite: (texture, name, index) ->
		key = @spritesKeys[index]
		size = MonsterInfo::get("monster.#{name}.sprite.#{key}.size")
		sprite = new THREE.Sprite new THREE.SpriteMaterial({ map : texture })

		sprite.visible = false
		sprite.scale.set size.w, size.h, 0
		sprite.castShadow = false
		sprite.dynamic = true
		sprite

	get: (name, x, z) ->		
		textures = @loadTextures name
		sprites = {}
		sprites[@spritesKeys[i]] = @createSprite textures[i], name, i for i in [0..@spritesKeys.length-1]
		
		new Monster x, z, sprites