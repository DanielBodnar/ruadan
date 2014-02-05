(function() {
  define(['lodash', 'recording/node_map'], function(_, NodeMap) {
    var Serialzier;
    Serialzier = (function() {
      function Serialzier(knownNodesMap) {
        this.knownNodesMap = knownNodesMap != null ? knownNodesMap : new NodeMap();
      }

      Serialzier.prototype.serialize = function(node, recursive, withStyle) {
        var data, docType, elm, id;
        if (recursive == null) {
          recursive = false;
        }
        if (withStyle == null) {
          withStyle = true;
        }
        if (node == null) {
          return null;
        }
        data = this.knownNodesMap.get(node);
        if (data != null) {
          return data;
        }
        id = this.knownNodesMap.set(node);
        data = {
          nodeType: node.nodeType,
          id: id
        };
        if (withStyle) {
          data.styles = this._serializeStyle(node);
        }
        switch (data.nodeType) {
          case Node.DOCUMENT_NODE:
            elm = node;
            data.nodeTypeName = "DOCUMENT_NODE";
            data.url = elm.url;
            data.alinkColor = elm.alinkColor;
            data.dir = elm.dir;
            if (recursive && elm.childNodes.length) {
              this._serializeChildNodes(elm, data);
            }
            break;
          case Node.DOCUMENT_TYPE_NODE:
            docType = node;
            data.publicId = docType.publicId;
            data.systemId = docType.systemId;
            data.nodeTypeName = "DOCUMENT_TYPE_NODE";
            break;
          case Node.COMMENT_NODE:
          case Node.TEXT_NODE:
            data.textContent = node.textContent;
            data.nodeTypeName = "TEXT_NODE";
            break;
          case Node.ELEMENT_NODE:
            elm = node;
            data.nodeTypeName = "ELEMENT_NODE";
            data.tagName = elm.tagName;
            data.attributes = this._serializeAttributes(elm, data);
            if (data.tagName.toLowerCase() === "img") {
              data.attributes["src"] = elm.src;
            }
            if (elm.tagName.toLowerCase() === "link") {
              data.attributes["href"] = elm.href;
            }
            if (recursive && elm.childNodes.length) {
              this._serializeChildNodes(elm, data);
            }
            break;
        }
        this.knownNodesMap.set(node, data);
        return data;
      };

      Serialzier.prototype._serializeAttributes = function(node, data) {
        var attrib, attributes, _i, _len, _ref;
        attributes = {};
        _ref = node.attributes;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          attrib = _ref[_i];
          if (attrib.specified) {
            attributes[attrib.name] = attrib.value;
          }
        }
        return attributes;
      };

      Serialzier.prototype._serializeChildNodes = function(node, data) {
        var child, serializeStyle, serialized, _results;
        data.childNodes = [];
        child = node.firstChild;
        _results = [];
        while (child) {
          serializeStyle = node.tagName !== "HEAD";
          serialized = this.serialize(child, true, serializeStyle);
          data.childNodes.push(serialized);
          _results.push(child = child.nextSibling);
        }
        return _results;
      };

      Serialzier.prototype._serializeStyle = function(node) {
        return this._serializeCSSStyleDeclaration(node.style);
      };

      Serialzier.prototype._serializeCSSStyleDeclaration = function(style) {
        var i, key, result, value, _i, _ref;
        if (!style) {
          return {};
        }
        result = {};
        for (i = _i = 0, _ref = style.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
          key = style[i];
          value = style[key];
          if (!_.isEmpty(value)) {
            result[key] = value;
          }
        }
        return result;
      };

      return Serialzier;

    })();
    return Serialzier;
  });

}).call(this);
