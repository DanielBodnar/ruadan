define([
  'lodash'
], (
  _
)->
  class Deserializer
    constructor: (@document, @root = null, @idMap={}) ->
      @root = @document.implementation.createHTMLDocument()

    deleteNode: (nodeData)->
      delete @idMap[nodeData.id]

    deserialize: (nodeData, parent = @root)->
      return null unless nodeData?

      node = @idMap[nodeData.id]

      return node if node?

      switch "#{nodeData.nodeType}"
        when "#{Node.COMMENT_NODE}"
          node = @root.createComment(nodeData.textContent)
          break
        when "#{Node.TEXT_NODE}"
          node = @root.createTextNode(nodeData.textContent)
          break
        when "#{Node.DOCUMENT_TYPE_NODE}"
          node = @root.implementation.createDocumentType(
              nodeData.name,
              nodeData.publicId,
              nodeData.systemId)
          break
        when "#{Node.ELEMENT_NODE}"
          switch nodeData.tagName
            when 'HTML', 'HEAD', 'BODY'
              node = @root.getElementsByTagName(nodeData.tagName)[0]
              break
            when 'LINK'
              break if nodeData.attributes["rel"]?.toLowerCase() != "stylesheet"

#              node = @root.createComment('link')
              node = @root.createElement("style")
              href = nodeData.attributes["href"]
              nodeData.attributes["xhref"] = href

              delete nodeData.attributes["href"]

              node.innerHTML = nodeData.styleText
              break
            when 'IFRAME'
              node = @root.createComment('iframe')
              break
            when 'SCRIPT'
              node = @root.createElement('NO-SCRIPT')
              node.style.display = 'none'
              break
            else
              node = @root.createElement(nodeData.tagName)
              break

          node = @root.createElement(nodeData.tagName) unless node

          @_addAttributes(node, nodeData.attributes) unless node.nodeType == Node.COMMENT_NODE

      @_addStyle(node, nodeData.styles) if node.nodeType != Node.COMMENT_NODE

      throw "ouch" unless node

      switch nodeData.tagName
        when 'HTML', 'HEAD', 'BODY'
          break;
        else
          node = parent.appendChild(node) if parent && "#{parent.nodeType}" != "#{Node.COMMENT_NODE}"

      @idMap[nodeData.id] = node

      if nodeData.childNodes?
        for child in nodeData.childNodes
          @deserialize(child, node)


      node


    _addAttributes: (node, attributes)->
      _.each(attributes, (value, key)->
        node.setAttribute(key, value) unless _.isEmpty(value)
      )
      node

    _addStyle: (node, styles)->
      _.each(styles, (value, key) ->
        node.style[key] = value
      )



)
