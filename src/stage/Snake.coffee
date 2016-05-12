class Snake extends createjs.Shape
	body: [[50,40]]
	dir: 0
	color: '#fff'

	constructor:(@body, @dir, @color)->
		super()

	move:(@body)=>
		@graphics.clear()
		@graphics.f @color
		@graphics.dr(x, y, 10, 10) for [x,y] in @body


module.exports = Snake
