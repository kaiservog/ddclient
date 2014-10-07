class window.PerspectiveSimetric
	#@images should be ordered by clockwise, start by the sprite of looking at the camera
	constructor: (@sides) ->
		@utils = new Utils()
		@getSide = (target, self) ->
			angle = @utils.angle target.getPosition(), self

			if angle >= 0 and angle < 45 then return @sides[0]
			else if angle >= 45 and angle < 135 then return @sides[1]
			else if angle >= 135 and angle < 225 then return @sides[2]
			else if angle >= 225 and angle <= 315 then return @sides[3]
			else return @sides[0] #angle >= 315 and angle <= 360 then 