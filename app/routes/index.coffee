module.exports = (app) ->

  app.get  '/sessions', app.SessionController.sessions
  app.post '/start',    app.SessionController.start
  app.post '/continue', app.SessionController.continue
  app.post '/end',      app.SessionController.end

  app.post '/record', app.EventController.record
  app.get '/view', app.EventController.view

  app.get '/replay/:sessionId', app.ReplayController.replay
  app.get '/replay', app.ReplayController.sessions

# PhantomJs
  app.get '/phantom/:sessionId', app.PhantomController.index

  app.get '/index', app.ApplicationController.index


  # Error handling (No previous route found. Assuming it’s a 404)
  app.get '/*', (req, res) ->
    NotFound res

  NotFound = (res) ->
    res.render '404', status: 404, view: 'four-o-four'
