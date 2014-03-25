BaseNode = require('../node.coffee')
SerializationHelpers = require('./helpers.coffee')
_ = require('lodash')

class Node extends BaseNode
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
