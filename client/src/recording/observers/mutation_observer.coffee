EventEmitter = require('eventemitter').EventEmitter
Serializer = require('../../node/serializers/serializer.coffee')
AttributeMutationEvent = require('../../events/mutation/attribute.coffee')
CharacterDataMutationEvent = require('../../events/mutation/character_data.coffee')
AddNodesMutationEvent = require('../../events/mutation/add_nodes.coffee')
RemoveNodesMutationEvent = require('../../events/mutation/remove_nodes.coffee')
Window = require('../../helpers/window.coffee')


class MutationObserverObserver extends EventEmitter
  constructor: (@element, @nodeMap) ->
    MutationObserver = Window.MutationObserver || Window.WebKitMutationObserver || Window.MozMutationObserver
    @observer = new MutationObserver( (mutations) =>
      @_onChange(mutations)
    )

  observe: (options = {}) ->
    defaultOptions =
      childList: true
      attributes: true
      characterData: true
      subtree: true
      attributeOldValue: true
      characterDataOldValue: true
      cssProperties: true
      cssPropertyOldValue: true
      attributeFilter: null

    @observer.observe(@element, defaultOptions)

  disconnect: ->
    @observer.disconnect()

  flush: ->
    @_onChange(@observer.takeRecords())

  _onChange: (mutations) ->
    result = Array.prototype.map.call(mutations, (mutation) => @_handleMutation(mutation))
    @emit('change', result)

  _handleMutation: (mutation) ->
    switch(mutation.type)
      when "attributes"
        return new AttributeMutationEvent(
          @nodeMap.getNodeId(mutation.target),
          mutation.attributeName,
          mutation.attributeNamespace,
          mutation.oldValue,
          mutation.target.getAttribute(mutation.attributeName)
        )
      when "characterData"
        return new CharacterDataMutationEvent(
          @nodeMap.getNodeId(mutation.target),
          mutation.oldValue,
          mutation.target.data
        )
      when "childList"
        if (mutation.addedNodes.length > 0)
          return new AddNodesMutationEvent(
            Array.prototype.map.call(mutation.addedNodes, (node) => Serializer.serializeSubTree(node, @nodeMap)),
            @nodeMap.getNodeId(mutation.target),
            @nodeMap.getNodeId(mutation.previousSibling),
            @nodeMap.getNodeId(mutation.nextSibling)
          )
        else if (mutation.removedNodes.length > 0)
          return new RemoveNodesMutationEvent(
            @nodeMap.getNodeId(mutation.target),
            Array.prototype.map.call(mutation.removedNodes, (node) => @nodeMap.getNodeId(node))
          )
        else
          console.error("Weird childlist mutation event", mutation)
      else
        console.error("Weird mutation event", mutation)
        null

module.exports = MutationObserverObserver
