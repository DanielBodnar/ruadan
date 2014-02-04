# Modules
express = require 'express'
http = require 'http'
app = express()
util = require('util')

assets = require 'connect-assets'
jsPrimer = require 'connect-assets-jsprimer'

#requirejsMiddleware = require 'requirejs-middleware'

publicDir = __dirname + '/public'
env = app.get 'env'

# Boot setup
require("#{__dirname}/../config/boot")(app)

# Configuration
app.configure ->
  port = process.env.PORT || 3000
  port = process.argv[process.argv.indexOf('-p') + 1] if process.argv.indexOf('-p') >= 0
  app.set 'port', port
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'jade'

  app.use((req, res, next) ->
    res.header("Access-Control-Allow-Origin", "*")
    res.header("Access-Control-Allow-Headers", "X-Requested-With")
    next()
  )
  app.use express.static(__dirname + '/../public')
  app.use express.static(__dirname + '/../bower_components')


  app.use express.logger()
  app.use express.bodyParser({limit: '50mb'})
  app.use express.methodOverride()
#  app.use((req, res, next) ->
#    console.log("params: ",util.inspect(req.params), "query:", util.inspect(req.query),
#        "body:", util.inspect(req.body))
#    next()
#  )
  app.use app.router




app.configure 'development', ->
  app.use express.errorHandler()


# Routes
require("#{__dirname}/routes")(app)

# Server
http.createServer(app).listen app.get('port'), ->
  console.log "Express server listening on port #{app.get 'port'} in #{app.settings.env} mode"
