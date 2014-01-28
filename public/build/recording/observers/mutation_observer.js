(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  define(['lodash', 'eventEmitter', 'recording/serializer'], function(_, EventEmitter, Serializer) {
    var MutationObserver;
    return MutationObserver = (function(_super) {
      __extends(MutationObserver, _super);

      function MutationObserver() {
        var _this = this;
        this.serializer = new Serializer();
        MutationObserver = window.MutationObserver || window.WebKitMutationObserver || window.MozMutationObserver;
        this.observer = new MutationObserver(function(mutations) {
          return _this._onChange(mutations);
        });
      }

      MutationObserver.prototype.initialize = function(element) {
        var currentState, eventData;
        this.element = element;
        currentState = this.serializer.serialize(this.element, true);
        eventData = {
          nodes: currentState,
          timestamp: new Date().getTime()
        };
        return this.trigger("initialize", [eventData]);
      };

      MutationObserver.prototype.observe = function(options) {
        var defaultOptions;
        if (options == null) {
          options = {};
        }
        defaultOptions = {
          childList: true,
          attributes: true,
          characterData: true,
          subtree: true,
          attributeOldValue: true,
          characterDataOldValue: true,
          cssProperties: true,
          cssPropertyOldValue: true,
          attributeFilter: []
        };
        return this.observer.observe(this.element, _.extend(defaultOptions, options));
      };

      MutationObserver.prototype.disconnect = function() {
        return this.observer.disconnect();
      };

      MutationObserver.prototype._onChange = function(mutations) {
        var _this = this;
        return _.each(mutations, function(mutation) {
          return _this._handleMutation(mutation);
        });
      };

      MutationObserver.prototype._handleMutation = function(mutation) {
        return console.log("mutation", mutation);
      };

      MutationObserver.prototype._hasAddedNodes = function(mutation) {
        return (mutation.addedNodes != null) && mutation.addedNodes.length > 0;
      };

      MutationObserver.prototype._handleAddedNodes = function(nodes) {
        var _this = this;
        return _.each(nodes, function(node) {
          return _this._handleAddedNode(node);
        });
      };

      MutationObserver.prototype._handleAddedNode = function(node) {
        var serializedNode;
        return serializedNode = this.serializer.serialize(node, true);
      };

      return MutationObserver;

    })(EventEmitter);
  });

}).call(this);
