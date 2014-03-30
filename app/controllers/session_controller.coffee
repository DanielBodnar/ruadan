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

    @continue = (req, res) ->
      Session.get(req.body.sessionId).then( (session) ->
        res.json {
          canContinue: session.canContinue()
          session: session.toJSON()
        }
      )

    @end = (req, res) ->
      Session.end(req.body.sessionId).then( ->
        res.json {}
      )

    @sessions = (req, res) ->
      Session.all().then((sessions) ->
        res.json {
          sessions: sessions
        }
      )
