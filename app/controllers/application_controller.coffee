module.exports = (app) ->
  class app.ApplicationController

    initializer = {}
    # GET /
    @index = (req, res) ->
      res.render 'index',
        initializer: initializer

    @record = (req, res) ->
      console.log("RECORD")
      console.log req.body.initialData
      initializer = req.body.initialData
      res.json initializer

    @view = (req, res) ->
      console.log "view", initializer
      res.json initializer

    @replay = (req, res)->
      res.render 'replay',
        initializer: initializer

