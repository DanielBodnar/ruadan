Session = require_app("app/models/session")

module.exports = (app) ->

  class app.SessionController

    @start = (req, res) ->
      Session.start(req.body.name).then((session) ->
        res.json {
          sessionId: session.attributes.id
        }
      ).catch( (error) ->
        res.json {}
      )

    @end = (req, res) ->
      Session.end(req.body.sessionId).then( ->
        res.json {}
      )

    @sessions = (req, res) ->
      Session.allValid().then((sessions) ->
        res.json {
          sessions: sessions
        }
      )
