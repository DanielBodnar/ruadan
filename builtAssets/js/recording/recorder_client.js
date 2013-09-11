(function() {
  define(['lodash', 'jquery', 'recording/serializer'], function(_, $, Serializer) {
    var RecorderClient;
    return RecorderClient = (function() {
      function RecorderClient(document) {
        this.document = document;
        this.viewport = {};
      }

      RecorderClient.prototype.initialize = function(rootElement) {
        var initialData;
        this.viewport || (this.viewport = {});
        this.serializer = new Serializer();
        initialData = {
          nodes: this.serializer.serialize(rootElement, true),
          viewport: {
            height: this.viewport.height,
            width: this.viewport.width
          }
        };
        return $.post("http://127.0.0.1:3000/record", {
          initialData: initialData
        });
      };

      RecorderClient.prototype.setViewportHeight = function(heightInPixels) {
        return this.viewport.height = heightInPixels;
      };

      RecorderClient.prototype.setViewportWidth = function(widthInPixels) {
        return this.viewport.width = widthInPixels;
      };

      RecorderClient.prototype.onChange = function(mutations) {
        var _this = this;
        return _.each(mutations, function(mutation) {
          return _this._handleMutation(mutation);
        });
      };

      RecorderClient.prototype._handleMutation = function(mutation) {
        console.log("mutation", mutation);
        if (this._hasAddedNodes(mutation)) {
          return this._handleAddedNodes(mutation.addedNodes);
        }
      };

      RecorderClient.prototype._hasAddedNodes = function(mutation) {
        return (mutation.addedNodes != null) && mutation.addedNodes.length > 0;
      };

      RecorderClient.prototype._handleAddedNodes = function(nodes) {
        var _this = this;
        return _.each(nodes, function(node) {
          return _this._handleAddedNode(node);
        });
      };

      RecorderClient.prototype._handleAddedNode = function(node) {
        var serializedNode;
        serializedNode = this.serializer.serialize(node, true);
        return console.log("serialized node", serializedNode);
      };

      return RecorderClient;

    })();
  });

}).call(this);
