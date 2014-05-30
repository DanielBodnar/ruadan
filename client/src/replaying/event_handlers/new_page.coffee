EventHandler = require('./event_handler.coffee')
Deserializer = require('../../node/deserializers/deserializer.coffee')
NewPageEvent = require('../../events/new_page.coffee')

class NewPage extends EventHandler
  action: NewPageEvent::action

  constructor: (@urlHandler, @scrollHandler, @viewportHandler, @document, @nodeMap) ->

  handle: (event) ->
    subEvents = event.data
    if (subEvents.domSnapshot)
      @_handleSnapshot(subEvents.domSnapshot)

    @urlHandler.handle(subEvents.url)
    @scrollHandler.handle(subEvents.scrollPosition)
    @viewportHandler.handle(subEvents.viewport)

  _handleSnapshot: (snapshot) ->
    rootDomNode = Deserializer.deserializeSubTree(@document.implementation.createHTMLDocument(),
                                                  snapshot,
                                                  @nodeMap)

    rootDomNode.addEventListener("DOMContentLoaded", (-> debugger), false)
    @document.adoptNode(rootDomNode)
    @document.replaceChild(rootDomNode, @document.documentElement)

module.exports = NewPage
