# Modules
express = require 'express'
http = require 'http'
app = express()

assets = require 'connect-assets'
jsPrimer = require 'connect-assets-jsprimer'

coffeeDir = __dirname + '/coffee'
publicDir = __dirname + '/public'
env = app.get 'env'

# Boot setup
require("#{__dirname}/../config/boot")(app)

# Configuration
app.configure ->
  port = process.env.PORT || 3000
  if process.argv.indexOf('-p') >= 0
    port = process.argv[process.argv.indexOf('-p') + 1]

  app.set 'port', port
  app.set 'views', "#{__dirname}/views"
  app.set 'view engine', 'jade'
  app.use express.static(publicDir)
  app.use express.static('builtAssets')
  app.use express.favicon()
  app.use express.logger('dev')
  app.use express.bodyParser()
  app.use express.methodOverride()
#  app.use express.compiler
#    src: coffeeDir
#    dest: publicDir
#    enable: ['coffeescript']
  app.use assets(
    src: "#{__dirname}/assets"
    build: true
    buildsExpire: true
    detectChanges: true
    uglify: false
    debug: true
    buildFilenamer: (file, code)->
      file
  )
  app.use app.router

jsPrimer.loadAndWatchFiles assets, console.log, null, ()->

app.configure 'development', ->
  app.use express.errorHandler()

# Routes
require("#{__dirname}/routes")(app)

# Server
http.createServer(app).listen app.get('port'), ->
  console.log "Express server listening on port #{app.get 'port'} in #{app.settings.env} mode"
