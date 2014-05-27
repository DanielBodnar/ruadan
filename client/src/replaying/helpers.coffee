baseURL = require('build_config/base_url.coffee')
Player = require('../replaying/player/player.coffee')

### Helper class with various methods to start the replaying, prepare the events for the replaying
  and get the events from the server.
  TODO: should probaly move this later on to another various specific classes
###
class ReplayHelpers
  @doReplay: (events, document) ->
    events = Player.prepareEvents(events)
    player = new Player(events, document)
    player.start()

  @getEvents: (session, cb)->
    request = new XMLHttpRequest()
    request.open('GET', "#{baseURL}/view?sessionId=#{session}", true)

    request.onload = ->
      if (request.status >= 200 && request.status < 400)
        data = JSON.parse(request.responseText)
        cb(data.events)
      else
        console.error("error requesting info from the server", request)

    request.onerror = ->
      console.error("error requesting info from the server", request)

    request.send()

module.exports = ReplayHelpers