Session = require("../../app/models/session.coffee")

endInactiveSessions = ->
  Session.all().then( (sessions) ->
    sessions.filter( (session) -> session.isInactive() )
            .forEach( (session) -> session.end() )
  )

module.exports = endInactiveSessions
