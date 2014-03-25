Event = require('./event.coffee')
Deserializer = require('../node/deserializers/deserializer.coffee')
UrlEvent = require('./url.coffee')
ScrollEvent = require('./scroll.coffee')
ViewportEvent = require('./viewport.coffee')

class NewPage extends Event
  action: "newPage"

  constructor: (pageName, domSnapshot, urlEvent, scrollEvent, viewportEvent, selectionEvent, timestamp) ->
    super({
      pageName: pageName,
      domSnapshot: domSnapshot,
      url: urlEvent,
      scrollPosition: scrollEvent,
      viewport: viewportEvent
    },
    timestamp)

  _serializeData: ->
    {
      pageName: @data.pageName,
      domSnapshot: @data.domSnapshot.toJson(),
      url: @data.url.toJson(),
      scrollPosition: @data.scrollPosition.toJson(),
      viewport: @data.viewport.toJson()
    }

  @_deserializeData: (data) ->
    {
      pageName: data.pageName,
      domSnapshot: Deserializer.nodeTreeFromJson(data.domSnapshot),
      url: UrlEvent.fromJson(data.url),
      scrollPosition: ScrollEvent.fromJson(data.scrollPosition),
      viewport: ViewportEvent.fromJson(data.viewport)
    }

module.exports = NewPage
