BaseObserver = require('./base_observer.coffee')
Serializer = require('../../node/serializers/serializer.coffee')
AttributeMutationEvent = require('../../events/mutation/attribute.coffee')
CharacterDataMutationEvent = require('../../events/mutation/character_data.coffee')
AddNodesMutationEvent = require('../../events/mutation/add_nodes.coffee')
RemoveNodesMutationEvent = require('../../events/mutation/remove_nodes.coffee')
Window = require('../../helpers/window.coffee')


class MutationObserverObserver extends BaseObserver
  EVENTS: {
    CHANGE: 'change'
  }

  observe: ->
    MutationObserver = @window.MutationObserver || @window.WebKitMutationObserver || @window.MozMutationObserver
    @observer = new MutationObserver( (mutations) =>
      @_onChange(mutations)
    )

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
    @emit(@EVENTS.CHANGE, result.filter( (mutation) -> mutation? )) # we remove nulls since handleMutation may return null

  # returns mutation event or null if event is not applicable.
  _handleMutation: (mutation) ->
    switch(mutation.type)
      when "attributes"
        return null unless @nodeMap.getNodeId(mutation.target)
        return new AttributeMutationEvent(
          @nodeMap.getNodeId(mutation.target),
          mutation.attributeName,
          mutation.attributeNamespace,
          mutation.oldValue,
          mutation.target.getAttribute(mutation.attributeName)
        )
      when "characterData"
        return null unless @nodeMap.getNodeId(mutation.target)
        return new CharacterDataMutationEvent(
          @nodeMap.getNodeId(mutation.target),
          mutation.oldValue,
          mutation.target.data
        )
      when "childList"
        if (mutation.addedNodes.length > 0)
          parentId = @nodeMap.getNodeId(mutation.target)
          return null unless parent?
          return new AddNodesMutationEvent(
            Array.prototype.map.call(mutation.addedNodes, (node) => Serializer.serializeSubTree(node, @nodeMap)),
            parentId,
            @nodeMap.getNodeId(mutation.previousSibling),
            @nodeMap.getNodeId(mutation.nextSibling)
          )
        else if (mutation.removedNodes.length > 0)
          removedNodeIds = Array.prototype.map.call(mutation.removedNodes, (node) => @nodeMap.getNodeId(node)).filter( (nodeId) -> nodeId? )
          parent = @nodeMap.getNodeId(mutation.target)
          return null if removedNodeIds.length == 0 || !parent
          return new RemoveNodesMutationEvent(
            parent,
            removedNodeIds
          )
        else
          console.error("Weird childlist mutation event", mutation)
      else
        console.error("Weird mutation event", mutation)
        null

module.exports = MutationObserverObserver
