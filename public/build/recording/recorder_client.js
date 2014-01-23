(function() {
  define(['lodash', 'jquery'], function(_, $, Serializer) {
    var RecorderClient;
    return RecorderClient = (function() {
      function RecorderClient(document) {
        this.document = document;
      }

      RecorderClient.prototype.initialize = function(rootElement) {
        this.rootElement = rootElement;
      };

      RecorderClient.prototype.setInitialMutationState = function(data) {
        return this._record("initialMutationState", data);
      };

      RecorderClient.prototype.setInitialScrollState = function(data) {
        return this._record("initialScrollState", data);
      };

      RecorderClient.prototype.setInitialViewportState = function(data) {
        return this._record("initialViewportState", data);
      };

      RecorderClient.prototype.onMutation = function(data) {};

      RecorderClient.prototype.onMouseMove = function(data) {};

      RecorderClient.prototype.onScroll = function(data) {
        return console.log("scroll", data);
      };

      RecorderClient.prototype._record = function(action, data) {
        return $.post("http://127.0.0.1:3000/record", {
          action: action,
          data: data
        });
      };

      return RecorderClient;

    })();
  });

}).call(this);
