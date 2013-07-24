path = require('path')
express = require('express')
mongoose = require('mongoose')
util = require('util')

PORT = process.env.PINGPONG_PORT ? 8000
global.rootDir = process.env.PINGPONG_DIR ? __dirname
global.path = () -> path.resolve(global.rootDir, arguments...)

app = express()

commonHeaders = (req, res, next)->
	res.header "Access-Control-Allow-Origin", "*"
	res.header "Access-Control-Allow-Methods", "POST,PUT,DELETE,GET,OPTIONS"
	res.header "Access-Control-Allow-Headers", "Content-Type"
	res.header "Cache-Control", "no-cache, no-store, must-revalidate"
	res.header "Pragma", "no-cache"
	res.header "Expires", "0"
	next()

app.configure ->
	app.use express.errorHandler dumpExceptions: true
	app.use express.bodyParser()
	app.use commonHeaders
	app.use app.router
	app.use express.static global.path('public')

require('./server/routing').handle(app)
require('./server/schema').connect()

require('./server/rest-model').handle(app)
require('./server/rest-etc').handle(app)
require('./server/rest-report').handle(app)

app.use (err, req, res, next)->
	d = new Date().toLocaleString();
	if err.name and err.message
		msg = "#{d} - #{err.name}: #{err.message}"
		console.error msg
		if err.value
			console.error "    Value: #{err.value}"
	else
		msg = "#{d} - Unknown Error (See Server Logs)"
		console.error "#{d} - Unknown Error: ", err
	res.send(msg, 500)


app.listen(PORT)
util.log "Server started (port = #{PORT})"