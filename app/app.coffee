# Modules
express = require 'express'
http = require 'http'
app = express()
util = require('util')

assets = require 'connect-assets'

publicDir = __dirname + '/public'
env = app.get 'env'

# Boot setup
require("#{__dirname}/../config/boot")(app)

# Configuration
app.configure ->
  port = process.env.PORT || 3100
  port = process.argv[process.argv.indexOf('-p') + 1] if process.argv.indexOf('-p') >= 0
  app.set 'port', port
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'jade'

  app.use((req, res, next) ->
    res.header("Access-Control-Allow-Origin", "*")
    res.header("Access-Control-Allow-Headers", "X-Requested-With,Content-Type,Accept")
    next()
  )

  app.use express.static(__dirname + '/../public')
  app.use express.static(__dirname + '/../bower_components')

  app.use express.logger()

  app.use express.json()
  app.use express.bodyParser({limit: '50mb'})

  app.use express.methodOverride()

  app.use app.router




app.configure 'development', ->
  app.use express.errorHandler({showStack: true, dumpExceptions: true})


# Routes
require("#{__dirname}/routes")(app)

# Server
http.createServer(app).listen(app.get('port'), ->
  console.log "Express server listening on port #{app.get('port')} in #{app.settings.env} mode"
)
