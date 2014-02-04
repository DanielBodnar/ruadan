define([
  'lodash'
  'recording/node_map'
], (
  _
  NodeMap
)->
  #comment
  class Serialzier
    constructor: (@knownNodesMap = new NodeMap()) ->
    serialize: (node, recursive = false)->
      return null unless node?

      data = @knownNodesMap.get(node)
      return data if data? #we already serialzied the node
      id = @knownNodesMap.set(node)
      data = {
        nodeType: node.nodeType
        id: id
      }
      data.styles = @_serializeStyle(node)
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


          @_serializeLinkTag(node, data) if elm.tagName.toLowerCase()=="link"
          data.attributes = @_serializeAttributes(elm, data)
          if data.tagName.toLowerCase() == "img"
            data.attributes["src"] = elm.src
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
        data.childNodes.push @serialize(child, true)
        child = child.nextSibling

    _serializeStyle: (node) ->
      style = getComputedStyle(node)
      _.chain(style)
        .filter((value)-> !_.isEmpty(style[value]))
        .map((value) -> [value, style[value]])
        .compact()
        .value()

    _serializeLinkTag: (node, data)->
      return unless node.sheet?
      data.styleText = _.chain(node.sheet.rules).map((v) -> v.cssText).value().join("\n")

  Serialzier
)








