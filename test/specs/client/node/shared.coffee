Node = require('../../../../client/src/node/node.coffee')

exports.shouldBehaveLikeANode = (CurrentNode, type)->
  it 'should have the correct type', ->
    expect(CurrentNode::type).to.equal(type)

  it 'should inherit from Node', ->
    expect(new CurrentNode).to.be.an.instanceof(Node)

