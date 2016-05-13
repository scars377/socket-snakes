Tiles = require './Tiles'

class Foods extends Tiles
	constructor:->
		super()

	move:(f,g)=>
		m = @getPoint f
		Object.assign m,g

		@updateTile @getTile f
		@updateTile @getTile g

	getPoint:(f)=>
		for p in @points
			return p if f.x is p.x and f.y is p.y
		return null

	updateTile:(t)=>
		t.graphics.clear()
		for p in @points when @getTile(p) is t
			t.graphics.f(p.color ? '#999').dr p.x,p.y,1,1
		t.updateCache()

module.exports = Foods
