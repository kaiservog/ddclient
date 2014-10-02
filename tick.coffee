class window.Tick
	
	constructor: (maxTicks) ->
		@max = maxTicks
		@ticks = 1
		@counted = false

		@update = (qtd) ->
			if !qtd then qtd = 1
			if @ticks >= @max then @ticks = 0
			@ticks += qtd
			@counted = @ticks == qtd
			@counted

		@check = -> @counted

		@actual = -> @ticks
			


