fixtures = require('js-fixtures')

Node = require('../../../../client/src/node/serializers/node.coffee')
DocumentNode = require('../../../../client/src/node/serializers/document_node')
shared = require('./shared')

describe 'DocumentNode', ->
  beforeEach ->
    fixtures.load('basic.html')
  afterEach ->
    fixtures.cleanUp()

  shared.shouldBehaveLikeANode(DocumentNode, Node.types.DOCUMENT_NODE)


  describe 'serialize', ->
    describe 'values', ->
      beforeEach ->
        @serialziedDoc = DocumentNode.serialize(fixtures.window().document)

      it 'should have correct number of child nodes', ->
        expect(@serialziedDoc.childNodes.length).to.be.eq(0)

#    it 'should return the correct values', ->
#      fixtures.window().document.dir="rtl"
#      serialziedDoc = DocumentNode.serialize(fixtures.window().document)
#      expected =
#        childNodes: []
#        data:
#          alinkColor: ""
#          attributes: {}
#          style: {}
#          dir: "rtl"
#          url: undefined
#      console.dir(expected)
#      console.dir(serialziedDoc)
#      debugger
#      expect(serialziedDoc).to.deep.eq(expected)

