Session = require_app("app/models/session")

module.exports = (app) ->

  class app.ReplayController
    @replay = (req, res) ->
      res.render 'replay', sessionId: req.params.sessionId

    @sessions = (req, res) ->
      Session.allValid().then((sessions) ->
        res.render 'sessions', sessions: sessions
      )
