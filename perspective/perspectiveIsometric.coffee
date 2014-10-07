class window.PerspectiveSimetric
	#@images should be ordered by clock SENTIDO, start by the sprite of looking at the camera
	constructor: (@sides) ->
		@utils = new Utils()
		@getSide = (target, self) ->
			angle = @utils.angle target.getPosition(), self

			if angle >= 0 and angle < 89 then return @sides[0]
			else if angle >= 90 and angle < 180 then return @sides[1]
			else if angle >= 180 and angle < 270 then return @sides[2]
			else  return @sides[3] #angle >= 270 and angle <= 360 then
			