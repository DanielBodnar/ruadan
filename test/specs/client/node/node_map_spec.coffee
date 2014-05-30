NodeMap = require('../../../../client/src/node/node_map.coffee')
NodeId = require('../../../../client/src/node/node_id.coffee')

describe 'NodeMap', ->
  beforeEach ->
    @sandbox = sinon.sandbox.create()
    @map = new NodeMap()
    @node = document.createElement('div')

  afterEach ->
    @sandbox.restore()

  describe 'registerNode', ->
    it 'should return null if no node is given', ->
      expect(@map.registerNode()).to.be.a('null')

    it 'should increment the id after each node is added', ->
      id = @map.registerNode(@node)
      expect(id).to.eq(0)
      anotherId = @map.registerNode(document.createElement('div'))
      expect(anotherId).to.be.above(id)

    it 'should return the id of the created node', ->
      id = @map.registerNode(@node)
      expect(@map.getNodeId(@node)).to.eq(id)

    context 'when given the node for the first time', ->
      it 'should register it', ->
        nextId = 44
        @sandbox.spy(@map, 'setNode')
        @sandbox.stub(@map, 'getNextId').returns(nextId)
        @map.registerNode(@node)

        @map.setNode.should.have.calledWith(@node, nextId)

    context 'when given the node for the second time', ->
      it 'should simply return it', ->
        @sandbox.spy(@map, 'setNode')
        first = @map.registerNode(@node)
        second = @map.registerNode(@node)

        expect(first).to.eq(second)
        @map.setNode.should.have.been.calledOnce

    describe 'setNode', ->
      before ->
        @id = 3

      it 'should return the node', ->
        expect(@map.setNode(@node, @id)).to.equal(@node)

      it 'should call setId to set the node ID', ->
        @sandbox.spy(NodeId, 'setId')
        @map.setNode(@node, @id)
        NodeId.setId.should.have.been.calledWith(@node, @id).callCount(1)
        expect(@map._nodeMap[@id]).to.equal(@node)

    describe 'getNodeId', ->
      it 'should return null if no node is given', ->
        expect(@map.getNodeId()).to.be.null

      it 'should return the correct nodeId', ->
        id = @map.registerNode(@node)
        expect(@map.getNodeId(@node)).to.equal(id)


    describe 'getNode', ->
      it 'should return null if no id is given', ->
        expect(@map.getNode()).to.be.null

      it 'should return the correct node', ->
        anotherNode = document.createElement('div')
        first = @map.registerNode(@node)
        second = @map.registerNode(anotherNode)

        expect(@map.getNode(second)).to.equal(anotherNode)

    describe 'getNextId', ->
      it 'should generate auto increment the result for each call', ->
        expect(@map.getNextId()).to.be.below(@map.getNextId())

    describe 'clear', ->
      it 'should reset the current ID and the map cache', ->
        @map.registerNode(@node)
        @map.clear()
        expect(@map.currId).to.equal(0)
        expect(@map._nodeMap).to.be.empty


