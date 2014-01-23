module.exports = (app) ->
  # Index
  app.get '/', app.ApplicationController.index
  app.post '/record', app.ApplicationController.record
  app.get '/replay', app.ApplicationController.replay
  app.get '/view', app.ApplicationController.view

  # Error handling (No previous route found. Assuming it’s a 404)
  app.get '/*', (req, res) ->
    NotFound res

  NotFound = (res) ->
    res.render '404', status: 404, view: 'four-o-four'
