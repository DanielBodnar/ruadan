(function() {
  define(['jquery', 'replaying/deserializer'], function($, Deserializer) {
    return $.get("http://127.0.0.1:3000/view", function(data) {
      var deserializer, html, initialState;
      deserializer = new Deserializer(document.getElementsByTagName("iframe")[0].contentWindow.document);
      deserializer.deserialize(data.nodes);
      html = document.getElementsByTagName("iframe")[0].contentWindow.document.getElementsByTagName("html")[0].innerHTML;
      initialState = {
        content: html,
        viewport: {
          width: data.viewport.width,
          height: data.viewport.height
        }
      };
      if (window.callPhantom) {
        return window.callPhantom(initialState);
      }
    });
  });

}).call(this);
