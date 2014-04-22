# Modules
express = require('express')
app = express()

# Helpers setup
requireApp("./config/helpers")(app)
conf = requireApp('./config/config_manager.coffee')

# Configuration
app.configure ->

  app.set 'port', conf.app.port
  app.set 'views', "#{__dirname}/#{conf.app.views}"
  app.set 'view engine', conf.app.views_engine

  app.use((req, res, next) ->
    res.header("Access-Control-Allow-Origin", "*")
    res.header("Access-Control-Allow-Headers", "X-Requested-With,Content-Type,Accept")
    next()
  )

  app.use express.bodyParser({limit: '50mb'})

  app.use express.static("#{APP_ROOT}/public")
  app.use express.static("#{APP_ROOT}/bower_components")

  app.use express.logger()

  app.use express.json()
  app.use express.bodyParser({limit: '50mb'})

  app.use express.methodOverride()

  app.use app.router




app.configure 'development', ->
  app.use express.errorHandler({showStack: true, dumpExceptions: true})

# Routes
requireApp("app/routes")(app)

exports.app = app
# Server

