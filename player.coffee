class Player extends Live
	constructor: (x, z, @sprites) ->
		@live = new SceneObj x, z, @sprites, ['R', 'F', 'L', 'B', 'F1', 'F2', 'F3', 'F4', 'F5', 'F6']

	@update = (delta, selfPlayer, blocks) ->
			@live.update delta, selfPlayer, blocks