Session = require_app("app/models/session")

module.exports = (app) ->

  class app.SessionController


    @start = (req, res) ->
      session = new Session()
      res.json {
        sessionId: session.attributes.id
      }

    @sessions = (req, res) ->
      Session.all().then((sessions) ->
        res.json {
          sessions: sessions
        }
      )
