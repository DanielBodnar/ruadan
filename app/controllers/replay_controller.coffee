Session = requireApp("app/models/session")
TimeHelpers = requireApp("app/helpers/time.coffee")

module.exports = (app) ->

  class app.ReplayController
    @replay = (req, res) ->
      res.render 'replay', sessionId: req.params.sessionId

    @sessions = (req, res) ->
      Session.all().then((sessions) ->
        sessionViewData = sessions.map( (session) ->
          {
            id: session.attributes.id,
            name: session.attributes.name,
            start: TimeHelpers.printTime(session.attributes.startTimestamp)
            end: TimeHelpers.printTime(session.attributes.endTimestamp)
          }
        )
        res.render 'sessions', sessions: sessionViewData
      )
