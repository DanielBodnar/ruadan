_ = require('lodash')
BaseNode = require("../node.coffee")

class Node extends BaseNode
  INVALID_ATTRIBUTES = ["@role"]

  toDomNode: (document) ->
    domNode = @_createDomNode(document)
    Node._addAttributes(domNode, @data.attributes) if @data.attributes
    Node._addStyle(domNode, @data.style) if @data.style
    domNode

  _createDomNode: ->
    throw "Override in specific nodes"

  @_addAttributes: (domNode, attributes) ->
    return unless domNode.setAttribute?

    _(attributes).omit( (v, k) -> INVALID_ATTRIBUTES.indexOf(k) > -1 ).forIn( (value, key) ->
      try
        domNode.setAttribute(key, value)
      catch ex
        console.error("Could not set attribute", domNode, key, value)
        throw ex
    )

    switch(domNode.tagName?.toLowerCase())
      when "img"
        domNode.src = attributes.src
        break
      when "link"
        domNode.href = attributes.href
        break

  @_addStyle: (domNode, style) ->
    return unless domNode.style?

    for key, value of style
      domNode.style[key] = value

module.exports = Node
