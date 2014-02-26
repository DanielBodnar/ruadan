NodeMap = require('./node_map.coffee')

class Serializer
  constructor: (@knownNodesMap = new NodeMap()) ->
  serialize: (node, recursive = false, withStyle = true)->
    return null unless node?

    data = @knownNodesMap.get(node)
    return data if data? #we already serialzied the node
    id = @knownNodesMap.set(node)
    data = {
      nodeType: node.nodeType
      id: id
    }

    data.styles = @_serializeStyle(node) if withStyle

    switch data.nodeType
      when Node.DOCUMENT_NODE
        elm = node
        data.nodeTypeName = "DOCUMENT_NODE"
        data.url = elm.url
        data.alinkColor = elm.alinkColor
        data.dir = elm.dir
        @_serializeChildNodes(elm, data) if recursive && elm.childNodes.length
        break
      when Node.DOCUMENT_TYPE_NODE
        docType = node
        data.publicId = docType.publicId
        data.systemId = docType.systemId
        data.nodeTypeName = "DOCUMENT_TYPE_NODE"
        break
      when Node.COMMENT_NODE, Node.TEXT_NODE
        data.textContent = node.textContent
        data.nodeTypeName = "TEXT_NODE"
        break
      when Node.ELEMENT_NODE
        elm = node
        data.nodeTypeName = "ELEMENT_NODE"
        data.tagName = elm.tagName

        data.attributes = @_serializeAttributes(elm, data)
        if data.tagName.toLowerCase() == "img"
          data.attributes["src"] = elm.src

        if elm.tagName.toLowerCase()=="link"
          data.attributes["href"] = elm.href

        @_serializeChildNodes(elm, data) if recursive && elm.childNodes.length
        break

    @knownNodesMap.set(node, data)
    data

  _serializeAttributes: (node, data)->
    attributes = {}
    for attrib in node.attributes
      attributes[attrib.name] = attrib.value if attrib.specified
    attributes

  _serializeChildNodes: (node, data)->
    data.childNodes = []

    child = node.firstChild
    while child
      serializeStyle = node.tagName != "HEAD"
      serialized = @serialize(child, true, serializeStyle)
      data.childNodes.push serialized
      child = child.nextSibling

  _serializeStyle: (node) ->
    # During a CSS transition, getComputedStyle returns the original property value in Firefox, but the final property value in WebKit.
#      computedStyle = @_serializeCSSStyleDeclaration(getComputedStyle(node))
#      inlineStyle = @_serializeCSSStyleDeclaration(node.style)
    @_serializeCSSStyleDeclaration(node.style) #we only save inline stylesheets

#      result = _.extend({}, computedStyle, inlineStyle)
#      result



  _serializeCSSStyleDeclaration: (style)->
    return {} unless style
    result = {}

    for i in [0...style.length]
      key = style[i]
      value = style[key]
      result[key] = value if value?
    result

#    _serializeLinkTag: (node, data)->
#      return unless node.sheet?
#      data.styleText = _.chain(node.sheet.rules).map((v) -> v.cssText).value().join("\n")

module.exports = Serializer