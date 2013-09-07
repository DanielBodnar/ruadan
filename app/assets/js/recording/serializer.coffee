define([
  'lodash'
  'recording/node_map'
], (
  _
  NodeMap
)->
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
      @_serializeStyle(node, data)
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
          @_serializeAttributes(elm, data)
          @_serializeChildNodes(elm, data) if recursive && elm.childNodes.length
          break

      @knownNodesMap.set(node, data)
      data

    _serializeAttributes: (node, data)->
      data.attributes = {}
      i = 0
      while i < node.attributes.length
        attrib = node.attributes[i]
        data.attributes[attrib.name] = attrib.value if attrib.specified
        i++

    _serializeChildNodes: (node, data)->
      data.childNodes = []

      child = node.firstChild
      while child
        data.childNodes.push @serialize(child, true)
        child = child.nextSibling

    _serializeStyle: (node, data) ->
      res = _.chain(node.style).filter((value)->
        !_.isEmpty(node.style[value])
      ).map((value) ->
        [value, node.style[value]]
      ).compact().value()

      data.styles = res


    _serializeLinkTag: (node, data)->
      return unless node.sheet?
      data.styleText = _.chain(node.sheet.rules).map((v) -> v.cssText).value().join("\n")

  Serialzier
)








