define([
  'lodash'
  'eventEmitter'
  'recording/serializer'
],(
  _
  EventEmitter
  Serializer
)->
  class MutationObserver extends EventEmitter
    constructor: ()->
      @serializer = new Serializer()
      MutationObserver = window.MutationObserver || window.WebKitMutationObserver || window.MozMutationObserver
      @observer = new MutationObserver(@_onChange.bind(@))

    initialize: (@element)->
      currentState = @serializer.serialize(@element, true)
      eventData =
        nodes: currentState,
        timestamp: new Date().getTime()
      @trigger("initialize", [eventData])

    observe: (options = {})->
      defaultOptions =
        childList: true
        attributes: true
        characterData: true
        subtree: true
        attributeOldValue: true
        characterDataOldValue: true
        cssProperties: true
        cssPropertyOldValue: true
        attributeFilter: []

      @observer.observe(@element, _.extend(defaultOptions, options))

    disconnect: ->
      @observer.disconnect()

    _onChange: (mutations)->
      result = _(mutations).map(@_handleMutation.bind(@)).flatten().value()
      @trigger('change', [result])

    _handleMutation: (mutation)->
      result = {}
      result.addedNodes = @_serializeNodes(mutation.addedNodes) if @_hasAddedNodes(mutation)
      result.removedNodes = @_serializeNodes(mutation.removedNodes) if @_hasRemovedNodes(mutation)

      result.nextSiblingId = @serializer.knownNodesMap.get(mutation.nextSibling).id if mutation.nextSibling
      result.previousSiblingId = @serializer.knownNodesMap.get(mutation.previousSibling).id if mutation.previousSibling

      result.type = mutation.type
      result.oldValue = mutation.oldValue
      result.attributeName = mutation.attributeName

      result.targetNodeId = @serializer.knownNodesMap.get(mutation.target).id
#      console.log(mutation, result)

      result

    _hasAddedNodes: (mutation)->

      mutation.addedNodes?.length > 0

    _hasRemovedNodes: (mutation)->
      mutation.removedNodes?.length > 0

    _serializeNodes: (nodes)->
      _.map(nodes, (node)=>
        @serializer.serialize(node, true)
      )

)
