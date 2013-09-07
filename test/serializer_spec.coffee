define([
#  '/test/libs/jasmine-fixture.js'
  '/js/serializer.js'
  '/js/node_map.js'
], (
#  affix
  Serializer
  NodeMap
)->
  describe 'Serializer', ->

    beforeEach ->
      @knownNodes = new NodeMap()
      @serializer = new Serializer(@knownNodes)

    describe 'serialize', ->
      it 'should return null if no node is given', ->
        expect(@serializer.serialize()).toBeNull()
      it 'should return the node if already serialized', ->
        node = $("<span>aaa</span>").get(0)
        res = @serializer.serialize(node)
        another = @serializer.serialize(node)
        expect(another).toEqual(res)

      it 'should give two nodes different ids', ->
        node = $("<span>aaa</span>").get(0)
        node2 = $("<span>aaa</span>").get(0)
        res = @serializer.serialize(node)
        another = @serializer.serialize(node2)
        expect(res.id).not.toEqual(another.id)
        expect(another).not.toEqual(res)

      it 'should be able to serialize a text node', ->
        node = $("<span>aaa</span>").get(0).firstChild
        res = @serializer.serialize(node)
        expect(res.textContent).toEqual("aaa")
        expect(res.nodeType).toEqual(Node.TEXT_NODE)

      it 'should be able to serialize document node', ->
#        node = $('<html lang="en-US" id="developer-mozilla-org"><head></head><body></body></html>').get(0)
#        res = @serializer.serialize(node)
#        expect(res.nodeType).toEqual(Node.TEXT_NODE)
#        expect(res.publicId).toEqual(1)


)
