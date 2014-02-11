(function() {
  define(['jquery', 'replaying/deserializer', 'replaying/select_event', 'replaying/mouse_event', 'replaying/scroll_event', 'replaying/mutation_event'], function($, Deserializer, SelectEvent, MouseEvent, ScrollEvent, MutationEvent) {
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
      var handler;
      if (!event) {
        return;
      }
      if (lastTime === 0) {
        lastTime = event.data.timestamp * 1;
      }
      handler = null;
      switch (event.action) {
        case "scroll":
          handler = ScrollEvent.handle.bind(ScrollEvent, event, iframe);
          break;
        case "mouse":
          handler = MouseEvent.handle.bind(MouseEvent, event, mousePointer);
          break;
        case "select":
          handler = SelectEvent.handle.bind(SelectEvent, event, destDocument, deserializer);
          break;
        case "mutation":
          handler = MutationEvent.handle.bind(MutationEvent, event, deserializer, destDocument);
          break;
        default:
          handler = null;
      }
      if (handler) {
        return doEvent(handler, event.data.timestamp * 1);
      } else {
        console.log("unhandled event", event);
        return handleEvent(getNextEvent());
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
        return handleEvent(getNextEvent());
      });
    });
  });

}).call(this);
