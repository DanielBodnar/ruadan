(function() {
  define(['jquery', 'replaying/deserializer'], function($, Deserializer) {
    return $.get("http://127.0.0.1:3000/view", function(data) {
      var deserializer, destDocument, html, iframe, newNode, res;
      deserializer = new Deserializer(document);
      res = deserializer.deserialize(data.initialMutationState.nodes);
      iframe = document.getElementById("theframe");
      destDocument = iframe.contentDocument;
      newNode = destDocument.importNode(res, true);
      destDocument.replaceChild(newNode, destDocument.documentElement);
      html = res.innerHTML;
      iframe.contentWindow.scrollTo(data.initialScrollState.x, data.initialScrollState.y);
      iframe.setAttribute("width", "" + data.initialViewportState.width);
      iframe.setAttribute("height", "" + data.initialViewportState.height);
      iframe.setAttribute("frameborder", "0");
      iframe.style.width = "" + data.initialViewportState.width + "px";
      iframe.style.height = "" + data.initialViewportState.height + "px";
      data = {
        viewport: data.initialViewportState,
        scroll: data.initialScrollState,
        html: html
      };
      if (window.callPhantom) {
        return window.callPhantom(data);
      }
    });
  });

}).call(this);
