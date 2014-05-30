NodeId = require('../../../../client/src/node/node_id.coffee')

describe "NodeId", ->

  beforeEach ->
    @node = document.createElement('div')

  describe "@getId", ->
    context 'when trying to get an id before it was set', ->
      it 'should return undefined', ->
        expect(NodeId.getId(@node)).to.be.an('undefined')

    context 'after setting an id', ->
      beforeEach ->
        @theID = 123
        NodeId.setId(@node, @theID)

      it 'should return the id', ->
        expect(NodeId.getId(@node)).to.eq(@theID)

  describe "@setId", ->
    it 'should return the node', ->
      expect(NodeId.setId(@node, @theID)).to.equal(@theID)


