Snake = require './Snake'
Foods = require './Foods'

class Stage extends createjs.Stage
	snakes: {}

	connect:=>
		socket = io()

		snake = null

		socket.on 'foods', (foods)=>
			if !@foods?
				@foods = new Foods()
				@addChild @foods
			@foods.setData foods

		socket.on 'snakes', (snakes)=>
			for id,body of snakes
				if !@snakes[id]?
					@snakes[id] = new Snake()
					@addChild @snakes[id]
				@snakes[id].setData body

		window.addEventListener 'keydown',({keyCode})->
			if 37 <= keyCode <= 40
				socket.emit 'key', keyCode

	constructor:->
		@connect()

		super 'canvas'
		@canvas.focus()

		createjs.Ticker.setFPS 60
		createjs.Ticker.on 'tick', @

		window.addEventListener 'resize',@resize
		@resize()


	resize:=>
		@canvas.setAttribute 'width' ,1280
		@canvas.setAttribute 'height',720



module.exports = Stage
