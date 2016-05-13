class Snake extends createjs.Shape
	color: '#fff'

	constructor:()->
		super()

	setData:({body,color})=>
		@body = body
		@color = color if color?

		@graphics.clear()
		@graphics.f @color
		@graphics.dr(x, y, 1, 1) for {x,y} in body


module.exports = Snake
