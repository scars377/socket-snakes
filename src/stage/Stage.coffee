Snake = require './Snake'
Foods = require './Foods'

class Stage extends createjs.Stage
	connect:=>
		socket = io()

		snake = null


		socket.on 'foods', (foods)=>
			if !@foods?
				@foods = new Foods()
				@addChild @foods
			@foods.setData foods


		socket.on 'you',({body,dir,color})=>
			snake = new Snake body,dir,color
			@addChild snake

		socket.on 'move', (body)->snake?.move body

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
		@canvas.setAttribute 'width', window.innerWidth
		@canvas.setAttribute 'height',window.innerHeight



module.exports = Stage
