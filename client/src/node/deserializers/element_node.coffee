Node = require('./node.coffee')

class ElementNode extends Node
  _createDomNode: (document) ->
    domNode = null

    switch (@data.tagName)
      when 'HTML', 'HEAD', 'BODY'
        domNode = document.getElementsByTagName(@data.tagName)[0]
        break
      when 'IFRAME'
        domNode = document.createElement('NO-SCRIPT')
        break
      when 'SCRIPT'
        domNode = document.createElement('NO-SCRIPT')
        break
      else
        domNode = document.createElement(@data.tagName)
        break

    domNode

module.exports = ElementNode
