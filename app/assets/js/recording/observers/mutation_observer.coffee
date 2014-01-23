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
      @observer = new MutationObserver((mutations)=>@_onChange(mutations))

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
      _.each(mutations, (mutation)=> @_handleMutation(mutation))
#      @trigger('change', [mutations])

    _handleMutation: (mutation)->
      console.log("mutation", mutation)
#      @_handleAddedNodes(mutation.addedNodes) if @_hasAddedNodes(mutation)

    _hasAddedNodes: (mutation)->
      mutation.addedNodes? && mutation.addedNodes.length > 0

    _handleAddedNodes: (nodes)->
      _.each(nodes, (node)=>
        @_handleAddedNode(node))

    _handleAddedNode: (node)->
      serializedNode = @serializer.serialize(node, true)
      console.log("serialized node", serializedNode)


)
