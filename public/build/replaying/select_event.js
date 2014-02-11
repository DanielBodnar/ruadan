(function() {
  define([], function() {
    var SelectEvent;
    return SelectEvent = (function() {
      function SelectEvent() {}

      SelectEvent.handle = function(event, destDocument, deserializer) {
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
      };

      return SelectEvent;

    })();
  });

}).call(this);
