(function() {
  define([], function() {
    var MouseEvent;
    return MouseEvent = (function() {
      function MouseEvent() {}

      MouseEvent.handle = function(event, mousePointer) {
        mousePointer.style.left = "" + event.data.x + "px";
        return mousePointer.style.top = "" + event.data.y + "px";
      };

      return MouseEvent;

    })();
  });

}).call(this);
