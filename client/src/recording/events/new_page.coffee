Event = require('./event.coffee')

class NewPage extends Event
  action: "newPage"

  constructor: (domSnapshot, urlEvent, scrollEvent, viewportEvent, selectionEvent, timestamp) ->
    super({
      domSnapshot: domSnapshot,
      url: urlEvent,
      scrollPosition: scrollEvent,
      viewport: viewportEvent,
      selection: selectionEvent
    },
    timestamp)

  _serializeData: ->
    {
      domSnapshot: @data.domSnapshot.toJson(),
      url: @data.url.toJson(),
      scrollPosition: @data.scrollPosition.toJson(),
      viewport: @data.viewport.toJson(),
      selection: @data.selection.toJson()
    }

module.exports = NewPage
