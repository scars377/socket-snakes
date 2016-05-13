class Foods extends createjs.Container
	foods: []

	constructor:->
		super()
		@layers = [
			@addChild new createjs.Shape()
			@addChild new createjs.Shape()
			@addChild new createjs.Shape()
			@addChild new createjs.Shape()
		]

		@on 'added',@added

	added:({target})=>
		return if target isnt @
		window.addEventListener 'resize',@resize
		@resize()

	resize:=>
		@x = parseInt @stage.stageWidth/2,10
		@y = parseInt @stage.stageHeight/2,10

	getLayer:({x,y})->
		if x < 4000
			if y < 4000
				return @layers[0]
			else
				return @layers[1]
		else
			if y < 4000
				return @layers[2]
			else
				return @layers[3]

	setData:(@foods, update=false)=>
		for layer in @layers
			layer.graphics.clear().f '#999'

		for f,i in @foods
			@getLayer(f).graphics.f('#999').dr f.x,f.y,1,1

		for layer,i in @layers
			if update
				layer.updateCache()
			else
				c = parseInt i/2,10
				r = i%2
				layer.cache c*4000,r*4000,4000,4000

	move:(f,g)=>
		for h in @foods
			if f.x is h.x and f.y is h.y
				h.x = g.x
				h.y = g.y
				break
		@setData @foods,true

	setCenter:({x,y})=>
		x = x %% 8000
		y = y %% 8000

		if x < 2000
			@layers[0].x = -x
			@layers[1].x = -x
			@layers[2].x = -x - 8000
			@layers[3].x = -x - 8000
		else if x > 6000
			@layers[0].x = -x + 8000
			@layers[1].x = -x + 8000
			@layers[2].x = -x
			@layers[3].x = -x
		else
			@layers[0].x = -x
			@layers[1].x = -x
			@layers[2].x = -x
			@layers[3].x = -x

		if y < 2000
			@layers[0].y = -y
			@layers[1].y = -y - 8000
			@layers[2].y = -y
			@layers[3].y = -y - 8000
		else if y > 6000
			@layers[0].y = -y + 8000
			@layers[1].y = -y
			@layers[2].y = -y + 8000
			@layers[3].y = -y
		else
			@layers[0].y = -y
			@layers[1].y = -y
			@layers[2].y = -y
			@layers[3].y = -y


module.exports = Foods
