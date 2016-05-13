class Food extends createjs.Shape
	constructor:->
		super()
		@graphics.f('#ff0').dr(0,0,1,1)
		# @graphics.f('#660').dr(2,2,6,6)



class Foods extends createjs.Container
	foods: []

	constructor:->
		super()

	setData:(foods)->
		for f,i in foods
			g = @foods[i]
			if !g?
				@foods[i] = g = new Food()
				@addChild g
			g.set f

		for g,j in @foods when j>=i
			@removeChild g




module.exports = Foods
