_ = require('lodash')
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

  getChildren: ->
    @childNodes

  setId: (@nodeId) ->

  getId: ->
    @nodeId

  toJson: ->
    {
      nodeId: @nodeId,
      type: @type,
      data: @data,
      childNodes: @childNodes.map( (child) -> child.toJson() )
    }

  @fromJson: (json) ->
    node = new this(json.data)
    node.setId(json.nodeId)
    node


module.exports = Node
