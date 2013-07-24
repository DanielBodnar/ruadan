define([
  '/js/node_map.js'
], (
  NodeMap
)->
  describe 'NodeMap', ->
    node = document.createTextNode("text node");
    describe 'get', ->
      it 'should return defaultValue for nonexistant node', ->
        map = new NodeMap()
        expect(map.get(node)).toBeNull()
        expect(map.get(node, 'something')).toEqual('something')

      it 'should return node if found', ->
        map = new NodeMap()
        val = 'someValue'
        map.set(node, val)
        expect(map.get(node)).toEqual(val)


)
