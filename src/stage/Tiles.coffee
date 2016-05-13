class Tiles extends createjs.Container
	w: 8000
	h: 8000
	rows: 16
	cols: 16

	points: null
	tiles: null

	constructor:(cache=true)->
		super()

		dc = @w/@cols
		dr = @h/@rows

		@tiles = []
		for r in [0..@rows-1]
			for c in [0..@cols-1]
				t = new createjs.Shape()
				if cache
					t.cache c*dc, r*dr, dc, dr
				@tiles.push t
				@addChild t



		@on 'added',@added

	added:({target})=>
		return if target isnt @
		window.addEventListener 'resize',@resize
		@resize()

	resize:=>
		@x = parseInt @stage.stageWidth/2,10
		@y = parseInt @stage.stageHeight/2,10


	getTile:({x,y})->
		c = parseInt x/@w*@cols,10
		r = parseInt y/@h*@rows,10
		i = r*@cols + c
		return @tiles[i]

	setData:(@points)=>
		for p,i in @points
			@getTile(p).graphics.f(p.color ? '#999').dr p.x,p.y,1,1
		for tile in @tiles
			try
				tile.updateCache()

	setCenter:({x,y})=>
		centerX = x %% @w
		centerY = y %% @h

		centerC = parseInt centerX/@w*@cols,10
		centerR = parseInt centerY/@h*@rows,10

		dc = parseInt @cols/2,10
		dr = parseInt @rows/2,10

		maxC = centerC + dc
		minC = centerC - dc
		maxR = centerR + dr
		minR = centerR - dr

		for t,i in @tiles
			tileC = i%@cols
			tileR = parseInt i/@cols,10

			if tileC < minC
				t.x = -centerX + @w
			else if tileC > maxC
				t.x = -centerX - @w
			else
				t.x = -centerX

			if tileR < minR
				t.y = -centerY + @h
			else if tileR > maxR
				t.y = -centerY - @h
			else
				t.y = -centerY

module.exports = Tiles
