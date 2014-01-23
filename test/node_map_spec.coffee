define([
  '/js/node_map.js'
], (
  NodeMap
)->
  describe 'NodeMap', ->
    beforeEach ->
      @map = new NodeMap()

    node = document.createTextNode("text node");
    describe 'get', ->
      it 'should return defaultValue for nonexistant node', ->
        expect(@map.get(node)).toBeNull()
        expect(@map.get(node, 'something')).toEqual('something')

      it 'should return node if found', ->
        val = 'someValue'
        @map.set(node, val)
        expect(@map.get(node)).toEqual(val)

    describe 'set', ->

)
