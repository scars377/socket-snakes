port = 3000
ip = 'localhost'
# ip = '192.168.1.101'

express = require 'express'
app = express()
server = app.listen port,ip,->console.log 'server start'

app.use express.static 'dist'

socketio = require 'socket.io'
io = socketio server



clients = {}
foods = []
world_size = 8000

randColor = ->
	c = [
		{r:Math.random(), c:'00'}
		{r:Math.random(), c:'00'}
		{r:Math.random(), c:'ff'}
		{r:Math.random(), c:'ff'}
		# {r:Math.random(), c:((Math.random()*0x50 + 0xaf)|0).toString(16)}
		# {r:Math.random(), c:((Math.random()*0x50 + 0xaf)|0).toString(16)}
	]
		.sort (a,b)->a.r-b.r
		.map ({c})->c
		.join ''
		.substr 0,6
	return "##{c}"

createSnake = ->
	x = Math.random()*world_size|0
	y = Math.random()*world_size|0
	dir = Math.random()*4|0
	return {
		body: [{x,y}]
		dir: dir
		nextDir: dir
		color: randColor()
	}


io.on 'connect',(socket)->
	console.log 'connect'

	id = socket.id.replace /\W/g,''

	snake = createSnake()
	clients[id] = { socket, snake }

	snakes = {}
	for id,{snake:{body,color}} of clients
		snakes[id] = {body,color}

	socket.emit 'snakes', snakes
	socket.emit 'foods', foods

	socket.on 'disconnect',->
		delete clients[id]

	socket.on 'key',(keyCode)->
		d = switch keyCode
			when 37 then 0 #left
			when 39 then 1 #right
			when 38 then 2 #up
			when 40 then 3 #down
		snake.nextDir = d if (snake.dir<2) isnt (d<2)

createFoods = ->
	foods.push {
		x: Math.random()*world_size|0
		y: Math.random()*world_size|0
	}
moveFood = (f)->
	f.x = Math.random()*world_size|0
	f.y = Math.random()*world_size|0
	return f


tryEatFood = (n)->
	for f,i in foods
		if f.x is n.x and f.y is n.y
			moveFood f
			io.emit 'food-move',n,f
			return true
	return false

move = ->
	snakes = {}
	for id,{socket,snake} of clients
		{body, dir, nextDir} = snake

		n = Object.assign {},body[0]
		switch nextDir
			when 0
				n.x -= 1
				n.x = world_size-1 if n.x < 0
			when 1
				n.x += 1
				n.x = 0 if n.x > world_size-1
			when 2
				n.y -= 1
				n.y = world_size-1 if n.y < 0
			when 3
				n.y += 1
				n.y = 0 if n.y > world_size-1

		snake.dir = nextDir

		body.unshift n
		body.pop() unless tryEatFood n

		snakes[id] = {body}

	io.emit 'snakes', snakes

setInterval move,50

createFoods() for i in [0..100000]
