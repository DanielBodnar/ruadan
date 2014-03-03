Session = require_app("app/models/session")

module.exports = (app) ->

  class app.ReplayController

    @replay = (req, res) ->
      res.render 'replay', sessionId: req.params.session

    @sessions = (req, res) ->
      Session.all().then((sessions) ->
        res.render 'sessions', sessions: sessions
      )
