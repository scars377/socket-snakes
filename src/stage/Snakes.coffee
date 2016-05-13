Tiles = require './Tiles'

class Snakes extends Tiles
	snakes:{}
	id: ''

	constructor:->
		super(false)

	setId:(@id)=>

	setSnake:(snakes)=>
		for id,snake of @snakes
			if snakes[id]?
				snake.body = snakes[id].body
				delete snakes[id]
			else
				delete @snakes[id]

		for id,snake of snakes
			@snakes[id] = snake


		for t in @tiles
			t.graphics.clear()

		for id,{body,color} of @snakes
			for p in body
				@getTile(p).graphics.f(color).dr p.x,p.y,1,1

		return @setCenter @getCenter()

	getCenter:=>@snakes[@id].body[0]

module.exports = Snakes
