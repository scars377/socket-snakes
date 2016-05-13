port = 3000
ip = '192.168.1.101'

express = require 'express'
app = express()
server = app.listen port,ip,->console.log 'server start'

app.use express.static 'dist'

socketio = require 'socket.io'
io = socketio server

clients = {}
foods = []

randColor = ->
	return '#'+(
		(Math.random()*0x80 + 0x7f) << 16 |
		(Math.random()*0x80 + 0x7f) << 8 |
		(Math.random()*0x80 + 0x7f)
	).toString 16



createSnake = ->
	x = Math.random()*1280|0
	y = Math.random()*720|0
	dir = Math.random()*4|0
	return {
		body: [[x,y]]
		dir: dir
		nextDir: dir
		color: randColor()
	}


io.on 'connect',(socket)->
	console.log 'connect'

	{id} = socket

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
		x: Math.random()*1280|0
		y: Math.random()*720|0
	}

tryEatFood = (n)->
	for f,i in foods
		if f.x is n[0] and f.y is n[1]
			foods.splice i,1
			io.emit 'foods',foods
			return true
	return false

move = ->
	snakes = {}
	for id,{socket,snake} of clients
		{body, dir, nextDir} = snake

		n = body[0].concat()
		switch nextDir
			when 0 then n[0] -= 1
			when 1 then n[0] += 1
			when 2 then n[1] -= 1
			when 3 then n[1] += 1

		snake.dir = nextDir

		body.unshift n
		body.pop() unless tryEatFood n

		snakes[id] = {body}

	io.emit 'snakes', snakes

setInterval move,100

createFoods() for i in [0..100]
