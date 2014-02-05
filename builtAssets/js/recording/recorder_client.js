(function() {
  define(['jquery'], function($) {
    var RecorderClient;
    return RecorderClient = (function() {
      function RecorderClient(document, rootElement) {
        this.document = document;
        this.rootElement = rootElement;
      }

      RecorderClient.prototype.setInitialMutationState = function(data) {
        return this._record("initialMutationState", data);
      };

      RecorderClient.prototype.setInitialScrollState = function(data) {
        return this._record("initialScrollState", data);
      };

      RecorderClient.prototype.setInitialViewportState = function(data) {
        return this._record("initialViewportState", data);
      };

      RecorderClient.prototype.setInitialSelection = function(selection) {
        return this._record("initialSelectState", selection);
      };

      RecorderClient.prototype.onSelect = function(selection) {
        return this._record("select", selection);
      };

      RecorderClient.prototype.onMutation = function(data) {
        return this._record("mutation", data);
      };

      RecorderClient.prototype.onMouseMove = function(data) {
        return this._record("mouse", data);
      };

      RecorderClient.prototype.onScroll = function(data) {
        return this._record("scroll", data);
      };

      RecorderClient.prototype._record = function(action, data) {
        console.log("recording ", action);
        return $.post("http://127.0.0.1:3000/record", {
          action: action,
          data: JSON.stringify(data)
        });
      };

      return RecorderClient;

    })();
  });

}).call(this);
