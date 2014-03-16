_ = require('lodash')
SerializationHelpers = require('./helpers.coffee')
Window = require('../helpers/window.coffee')

# Base class for specific node serializers
class Node
  @types: {
    DOCUMENT_NODE: Window.Node.DOCUMENT_NODE,
    DOCUMENT_TYPE_NODE: Window.Node.DOCUMENT_TYPE_NODE,
    COMMENT_NODE: Window.Node.COMMENT_NODE,
    TEXT_NODE: Window.Node.TEXT_NODE,
    ELEMENT_NODE: Window.Node.ELEMENT_NODE
  }

  type: undefined # override in subclasses

  constructor: (@data) ->
    @childNodes = []

  addChild: (child) ->
    @childNodes.push(child)

  setId: (@nodeId) ->

  toJson: ->
    {
      nodeId: @nodeId,
      type: @type,
      data: @data,
      childNodes: @childNodes.map( (child) -> child.toJson() )
    }

  @serialize: (domNode) ->
    new this(_.extend(@_getDefaultNodeData(domNode), @_getNodeData(domNode)))

  #override this in subclasses and return the data specific to your node type
  @_getNodeData: (domNode) ->
    {}

  @_getDefaultNodeData: (domNode, withAttributes = true, withStyle = true) ->
    data = {}
    data.attributes = SerializationHelpers.serializeAttributes(domNode) if withAttributes
    data.style = SerializationHelpers.serializeStyle(domNode) if withStyle
    data

module.exports = Node
