define([
  'lodash'
  'jquery'
  'recording/serializer'
], (
  _
  $
  Serializer
)->
  class RecorderClient

    constructor: (@document)->
      @viewport = {}

    initialize: (rootElement)->
      @viewport ||= {}
      @serializer = new Serializer()
      initialData =
        nodes: @serializer.serialize(rootElement, true)
        viewport:
          height: @viewport.height
          width: @viewport.width

      $.post("http://127.0.0.1:3000/record", initialData: initialData)


    setViewportHeight: (heightInPixels)->
      @viewport.height = heightInPixels

    setViewportWidth: (widthInPixels)->
      @viewport.width = widthInPixels

    onChange: (mutations)->
      _.each(mutations, (mutation)=> @_handleMutation(mutation))

    _handleMutation: (mutation)->
      console.log("mutation", mutation)
      @_handleAddedNodes(mutation.addedNodes) if @_hasAddedNodes(mutation)

    _hasAddedNodes: (mutation)->
      mutation.addedNodes? && mutation.addedNodes.length>0

    _handleAddedNodes: (nodes)->
      _.each(nodes, (node)=> @_handleAddedNode(node))

    _handleAddedNode: (node)->
      serializedNode = @serializer.serialize(node, true)
      console.log("serialized node", serializedNode)
)
