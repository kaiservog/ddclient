class window.Anim
	constructor: (@start, @end) ->
		@index = start

		@next = -> 
			@index += 1
			if @index > @end then @reset()
			@actual()

		@actual = ->
			@index

		@previous = ->
			@inde -1

		@reset = ->
			@index = @start

class window.AnimScript
	constructor: ->
		@graus = Math.PI / 180

		@wa = (obj, tick) ->
			totalTicks = tick.max
			upTime =      (totalTicks * 30)/ 100
			downTime =    upTime + (totalTicks * 10)/ 100
			delayTime =   downTime + (totalTicks * 20)/ 100
			restoreTime = delayTime + (totalTicks * 40)/ 100

			up = (50 * @graus) / upTime
			down = (100 * @graus) / (downTime - upTime)
			restore = (50 * @graus)/ (restoreTime - delayTime)

			if tick.actual() < upTime
				obj.material.rotation -= up
			else if tick.actual() < downTime
				obj.material.rotation += down
			else if tick.actual() < delayTime
			else if tick.actual() < restoreTime
				obj.material.rotation -= restore
			else
				obj.material.rotation = 0



		@weaponAtk = (obj, frameIndex) ->
			switch frameIndex
				when 1
					obj.material.rotation = 5
				when 2, 3, 4, 5
					obj.material.rotation = -100
				when 6
					obj.material.rotation = 0
