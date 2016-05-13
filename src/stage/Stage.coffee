Snake = require './Snake'
Foods = require './Foods'

class Stage extends createjs.Stage
	snakes: {}

	connect:=>
		socket = io()

		socket.on 'foods', (foods)=>
			@foods = new Foods()
			@foods.setData foods
			@addChild @foods

		socket.on 'food-move',(f,g)=>
			@foods.move f,g

		socket.on 'snakes', (snakes)=>
			for id,snake of @snakes
				if snakes[id]?
					snake.setData snakes[id]
					delete snakes[id]
				else
					@layer.removeChild snake
					delete @snakes[id]

			for id,body of snakes
				@snakes[id] = new Snake()
				@snakes[id].setData body
				@layer.addChild @snakes[id]

			@lookAt @snakes[socket.id]

		window.addEventListener 'keydown',({keyCode})->
			if 37 <= keyCode <= 40
				socket.emit 'key', keyCode


	lookAt:(snake)=>
		return unless snake?
		@layer.set
			x: parseInt(@stageWidth/2,10)  - snake.body[0].x
			y: parseInt(@stageHeight/2,10) - snake.body[0].y

		@foods?.setCenter
			x: snake.body[0].x
			y: snake.body[0].y


	constructor:->
		super 'canvas'
		@canvas.focus()
		@snapToPixel = true
		# @set
		# 	scaleX: 4
		# 	scaleY: 4

		@layer = new createjs.Container()
		@addChild @layer

		createjs.Ticker.setFPS 60
		createjs.Ticker.on 'tick', @

		window.addEventListener 'resize',@resize
		@resize()

		@connect()



	resize:=>
		@stageWidth  = window.innerWidth
		@stageHeight = window.innerHeight

		@canvas.setAttribute 'width' ,@stageWidth
		@canvas.setAttribute 'height',@stageHeight



module.exports = Stage
