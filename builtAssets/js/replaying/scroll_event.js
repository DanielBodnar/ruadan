(function() {
  define([], function() {
    var ScrollEvent;
    return ScrollEvent = (function() {
      function ScrollEvent() {}

      ScrollEvent.handle = function(event, iframe) {
        return iframe.contentWindow.scrollTo(event.data.x, event.data.y);
      };

      return ScrollEvent;

    })();
  });

}).call(this);
