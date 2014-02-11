(function() {
  define([], function() {
    var MutationEvent;
    return MutationEvent = (function() {
      function MutationEvent() {}

      MutationEvent.handle = function(event, deserializer, destDocument) {
        return event.data.forEach(this.handleSingleMutation.bind(this, deserializer, destDocument));
      };

      MutationEvent.handleSingleMutation = function(deserializer, destDocument, data) {
        var target;
        target = deserializer.idMap[data.targetNodeId];
        if (data.addedNodes) {
          data.addedNodes.forEach(function(node) {
            var deserializedNode, sibling;
            deserializedNode = deserializer.deserialize(node, target);
            destDocument.adoptNode(deserializedNode);
            if (data.nextSiblingId) {
              sibling = deserializer.idMap[data.nextSiblingId];
              return target.insertBefore(deserializedNode, sibling);
            } else if (data.previousSiblingId) {
              sibling = deserializer.idMap[data.previousSiblingId];
              if (sibling.nextSibling) {
                return target.insertBefore(deserializedNode, sibling.nextSibling);
              } else {
                return target.appendChild(deserializedNode);
              }
            } else {
              return target.appendChild(deserializedNode);
            }
          });
        }
        if (data.removedNodes) {
          data.removedNodes.forEach(function(node) {
            var deserializedNode;
            if (target) {
              deserializedNode = deserializer.deserialize(node, target);
              target.removeChild(deserializedNode);
              return deserializer.deleteNode(node);
            } else {
              return console.log("no target", event);
            }
          });
        }
        if (data.attributeName) {
          return target.setAttribute(data.attributeName, data.attributeValue);
        }
      };

      return MutationEvent;

    })();
  });

}).call(this);
