EventHandler = require('./event_handler.coffee')
UrlEvent = require('../../events/url.coffee')

class Url extends EventHandler
  action: UrlEvent::action

  constructor: (@addressBar) ->

  handle: (event) ->
    @addressBar.innerText = event.data.newUrl

module.exports = Url
