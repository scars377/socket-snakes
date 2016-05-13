Snakes = require './Snakes'
Foods = require './Foods'

class Stage extends createjs.Stage
	connect:=>
		socket = io()

		socket.on 'connect',=>
			@snakes.setId socket.id

		socket.on 'foods', (foods)=>
			@foods.setData foods

		socket.on 'food-move',(f,g)=>
			@foods.move f,g

		socket.on 'snakes', (snakes)=>
			@snakes.setSnake snakes
			@foods.setCenter @snakes.getCenter()
			@update()

		window.addEventListener 'keydown',({keyCode})->
			if 37 <= keyCode <= 40
				socket.emit 'key', keyCode

	constructor:->
		super 'canvas'
		@canvas.focus()
		@snapToPixel = true

		window.addEventListener 'resize',@resize
		@resize()

		@foods = new Foods()
		@snakes = new Snakes()
		@addChild @foods,@snakes

		@connect()



	resize:=>
		@stageWidth  = window.innerWidth
		@stageHeight = window.innerHeight

		@canvas.setAttribute 'width' ,@stageWidth
		@canvas.setAttribute 'height',@stageHeight



module.exports = Stage
