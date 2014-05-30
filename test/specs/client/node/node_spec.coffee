Node = require('../../../../client/src/node/node.coffee')

describe 'Node', ->
  beforeEach ->
    @node = new Node()

  describe 'instance', ->
    describe 'constructor', ->
      it 'when created should have an empty child nodes list', ->
        expect(@node.childNodes).to.be.empty


      it 'should set the data when building the object', ->
        data = {a:3}
        node = new Node(data)
        expect(node.data).to.eq(data)

    describe 'addChild', ->
      it 'should add a child node', ->
        expect(@node.childNodes.length).to.be.eq(0)
        @node.addChild({})
        expect(@node.childNodes.length).to.be.eq(1)

    describe 'setId', ->
      it 'should set the id', ->
        id = "aaa"
        @node.setId(id)
        expect(@node.nodeId).to.be.eq(id)

    describe 'toJson', ->
      context 'when there are no children', ->
        it 'should serialize correctly', ->
          type = "type"
          id = "id"
          data = {"da": "ta"}
          @node.type = type
          @node.setId(id)
          @node.data = data

          expected = {nodeId:id, type:type, data: data, childNodes: []}
          expect(@node.toJson()).to.deep.equal(expected)

  describe 'serialize', ->
    it 'should raise an exception when calling on the base class', ->
      expect(->Node.serialize(document.createComment("aaa"))).to.throw(Error)








