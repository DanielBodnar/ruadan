EventEmitter = require('eventemitter').EventEmitter


class MutationObserverObserver extends EventEmitter
  constructor: (@serializer) ->
    MutationObserver = window.MutationObserver || window.WebKitMutationObserver || window.MozMutationObserver
    @observer = new MutationObserver( (mutations) =>
      @_onChange(mutations)
    )

  initialize: (@element) ->
    currentState = @serializer.serialize(@element, true)
    eventData =
      nodes: currentState,
      timestamp: new Date().getTime()
    @emit("initialize", eventData)

  observe: (options = {}) ->
    defaultOptions =
      childList: true
      attributes: true
      characterData: true
      subtree: true
      attributeOldValue: true
      characterDataOldValue: true
      cssProperties: true
      cssPropertyOldValue: true
      attributeFilter: null

    @observer.observe(@element, defaultOptions)


  disconnect: ->
    @observer.disconnect()

  _onChange: (mutations) ->
    result = Array.prototype.map.call(mutations, (mutation) => @_handleMutation(mutation))
    @emit('change', result)

  _handleMutation: (mutation) ->
    result = {}
    result.addedNodes = @_serializeNodes(mutation.addedNodes) if @_hasAddedNodes(mutation)
    result.removedNodes = @_serializeNodes(mutation.removedNodes) if @_hasRemovedNodes(mutation)

    result.nextSiblingId = @serializer.knownNodesMap.get(mutation.nextSibling).id if mutation.nextSibling
    result.previousSiblingId = @serializer.knownNodesMap.get(mutation.previousSibling).id if mutation.previousSibling

    result.type = mutation.type
    result.oldValue = mutation.oldValue
    result.attributeName = mutation.attributeName
    result.attributeValue = mutation.target.getAttribute(result.attributeName) if result.attributeName?

    result.targetNodeId = @serializer.knownNodesMap.get(mutation.target).id
    result.timestamp = new Date().getTime()

    result

  _hasAddedNodes: (mutation) ->
    mutation.addedNodes?.length > 0

  _hasRemovedNodes: (mutation) ->
    mutation.removedNodes?.length > 0

  _serializeNodes: (nodes) ->
    Array.prototype.map.call(nodes, (node) =>
      @serializer.serialize(node, true)
    )

module.exports = MutationObserverObserver
