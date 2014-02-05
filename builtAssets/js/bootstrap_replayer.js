(function() {
  define(['jquery', 'replaying/deserializer'], function($, Deserializer) {
    var currentEventId, deserializer, destDocument, doEvent, events, getNextEvent, handleEvent, iframe, lastTime, mousePointer;
    lastTime = 0;
    currentEventId = 0;
    events = null;
    iframe = null;
    mousePointer = null;
    deserializer = null;
    getNextEvent = function() {
      return events[currentEventId++];
    };
    doEvent = function(func, timestamp) {
      var _this = this;
      setTimeout((function() {
        func();
        return handleEvent(getNextEvent());
      }), timestamp - lastTime);
      return lastTime = timestamp;
    };
    handleEvent = function(event) {
      if (!event) {
        return;
      }
      if (lastTime === 0) {
        lastTime = event.data.timestamp * 1;
      }
      switch (event.action) {
        case "scroll":
          doEvent((function() {
            return iframe.contentWindow.scrollTo(event.data.x, event.data.y);
          }), event.data.timestamp * 1);
          break;
        case "mouse":
          doEvent((function() {
            mousePointer.style.left = "" + event.data.x + "px";
            return mousePointer.style.top = "" + event.data.y + "px";
          }), event.data.timestamp * 1);
          break;
        case "select":
          doEvent((function() {
            var endNode, range, startNode, _ref, _ref1;
            startNode = deserializer.idMap[(_ref = event.data.anchorNode) != null ? _ref.id : void 0];
            endNode = deserializer.idMap[(_ref1 = event.data.focusNode) != null ? _ref1.id : void 0];
            if (!(startNode && endNode)) {
              return;
            }
            range = destDocument.createRange();
            range.setStart(startNode, event.data.anchorOffset);
            range.setEnd(endNode, event.data.focusOffset);
            destDocument.getSelection().removeAllRanges();
            return destDocument.getSelection().addRange(range);
          }), event.data.timestamp * 1);
          break;
        case "mutation":
          doEvent((function() {
            return event.data.forEach(function(data) {
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
                return data.removedNodes.forEach(function(node) {
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
            });
          }), event.data.timestamp * 1);
          break;
        default:
          console.log("unhandled event", event);
          handleEvent(getNextEvent());
          break;
      }
    };
    mousePointer = document.getElementById("themouse");
    iframe = document.getElementById("theframe");
    destDocument = iframe.contentDocument;
    return $.get("http://127.0.0.1:3000/view", function(data) {
      var newNode, res;
      deserializer = new Deserializer(document);
      res = deserializer.deserialize(data.initialMutationState.nodes);
      newNode = destDocument.adoptNode(res);
      destDocument.replaceChild(newNode, destDocument.documentElement);
      iframe.contentWindow.scrollTo(data.initialScrollState.x, data.initialScrollState.y);
      iframe.setAttribute("width", "" + data.initialViewportState.width);
      iframe.setAttribute("height", "" + data.initialViewportState.height);
      iframe.setAttribute("frameborder", "0");
      iframe.style.width = "" + data.initialViewportState.width + "px";
      iframe.style.height = "" + data.initialViewportState.height + "px";
      events = data.events;
      return $(iframe).ready(function() {
        console.log("load event");
        return handleEvent(getNextEvent());
      });
    });
  });

}).call(this);
