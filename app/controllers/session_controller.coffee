Session = requireApp("app/models/session")

module.exports = (app) ->

  class app.SessionController

    # start a new session. return sessionId if successfuly.
    @start = (req, res) ->
      Session.start(req.body.name).then((session) ->
        res.json {
          sessionId: session.attributes.id
        }
      ).catch( (error) ->
        res.json {}
      )

    # continue a running session. returns session data and
    # canContinue param that indicates if the session can continue
    @continue = (req, res) ->
      Session.get(req.body.sessionId).then( (session) ->
        res.json {
          canContinue: session.canContinue()
          session: session.toJSON()
        }
      )

    # end a running session
    @end = (req, res) ->
      Session.end(req.body.sessionId).then( ->
        res.json {}
      )

    # returns session data for all sessions
    @sessions = (req, res) ->
      Session.all().then((sessions) ->
        res.json {
          sessions: sessions
        }
      )
