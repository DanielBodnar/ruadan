module.exports = (app) ->

  class app.ApplicationController

    @replay = (req, res) ->
      res.render 'replay'
