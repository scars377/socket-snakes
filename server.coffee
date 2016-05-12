port = 3000

express = require 'express'
app = express()
server = app.listen port,->console.log 'server start'

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
	x = (Math.random()*500*.1|0)*10
	y = (Math.random()*500*.1|0)*10
	return {
		body: [[x,y]]
		dir: Math.random()*4|0
		color: randColor()
	}


io.on 'connect',(socket)->
	console.log 'connect'

	snake = createSnake()
	socket.emit 'you', snake
	socket.emit 'foods', foods

	{id} = socket
	clients[id] = { socket, snake }

	socket.on 'disconnect',->
		delete clients[id]

	socket.on 'key',(keyCode)->
		d = switch keyCode
			when 37 then 0 #left
			when 39 then 1 #right
			when 38 then 2 #up
			when 40 then 3 #down
		snake.dir = d if (snake.dir<2) isnt (d<2)

createFoods = ->
	foods.push {
		x: (Math.random()*500*.1|0)*10
		y: (Math.random()*500*.1|0)*10
	}


tryEatFood = (n)->
	for f,i in foods
		if f.x is n[0] and f.y is n[1]
			foods.splice i,1
			io.emit 'foods',foods
			return true
	return false

move = ->
	for id,{socket,snake:{body, dir}} of clients
		n = body[0].concat()
		switch dir
			when 0 then n[0] -= 10
			when 1 then n[0] += 10
			when 2 then n[1] -= 10
			when 3 then n[1] += 10

		body.unshift n
		body.pop() unless tryEatFood n

		socket.emit 'move',body

setInterval move,200


createFoods() for i in [0..100]
