(function() {
  define(['lodash', 'recording/node_map'], function(_, NodeMap) {
    var Serialzier;
    Serialzier = (function() {
      function Serialzier(knownNodesMap) {
        this.knownNodesMap = knownNodesMap != null ? knownNodesMap : new NodeMap();
      }

      Serialzier.prototype.serialize = function(node, recursive) {
        var data, docType, elm, id;
        if (recursive == null) {
          recursive = false;
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
        this._serializeStyle(node, data);
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
            if (elm.tagName.toLowerCase() === "link") {
              this._serializeLinkTag(node, data);
            }
            this._serializeAttributes(elm, data);
            if (recursive && elm.childNodes.length) {
              this._serializeChildNodes(elm, data);
            }
            break;
        }
        this.knownNodesMap.set(node, data);
        return data;
      };

      Serialzier.prototype._serializeAttributes = function(node, data) {
        var attrib, i, _results;
        data.attributes = {};
        i = 0;
        _results = [];
        while (i < node.attributes.length) {
          attrib = node.attributes[i];
          if (attrib.specified) {
            data.attributes[attrib.name] = attrib.value;
          }
          _results.push(i++);
        }
        return _results;
      };

      Serialzier.prototype._serializeChildNodes = function(node, data) {
        var child, _results;
        data.childNodes = [];
        child = node.firstChild;
        _results = [];
        while (child) {
          data.childNodes.push(this.serialize(child, true));
          _results.push(child = child.nextSibling);
        }
        return _results;
      };

      Serialzier.prototype._serializeStyle = function(node, data) {
        var res;
        res = _.chain(node.style).filter(function(value) {
          return !_.isEmpty(node.style[value]);
        }).map(function(value) {
          return [value, node.style[value]];
        }).compact().value();
        return data.styles = res;
      };

      Serialzier.prototype._serializeLinkTag = function(node, data) {
        if (node.sheet == null) {
          return;
        }
        return data.styleText = _.chain(node.sheet.rules).map(function(v) {
          return v.cssText;
        }).value().join("\n");
      };

      return Serialzier;

    })();
    return Serialzier;
  });

}).call(this);
