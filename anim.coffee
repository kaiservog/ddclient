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
				obj.rotation.z -= up
			else if tick.actual() < downTime
				obj.rotation.z += down
			else if tick.actual() < delayTime
			else if tick.actual() < restoreTime
				obj.rotation.z -= restore
			else
				obj.rotation.z = 0



		@weaponAtk = (obj, frameIndex) ->
			switch frameIndex
				when 1
					obj.rotation = 5
				when 2, 3, 4, 5
					obj.rotation = -100
				when 6
					obj.rotation = 0
