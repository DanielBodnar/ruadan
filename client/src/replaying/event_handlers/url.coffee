EventHandler = require('./event_handler.coffee')
UrlEvent = require('../../events/url.coffee')

class Url extends EventHandler
  action: UrlEvent::action

  constructor: () ->

  handle: (event) ->
    console.info("Url changed from", event.data.oldUrl, "to", event.data.newUrl)

module.exports = Url
