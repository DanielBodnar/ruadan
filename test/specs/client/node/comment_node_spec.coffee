CommentNode = require('../../../../client/src/node/serializers/comment_node.coffee')
Node = require('../../../../client/src/node/serializers/node.coffee')
shared = require('./shared')

describe 'CommentNode', ->
  shared.shouldBehaveLikeANode(CommentNode, Node.types.COMMENT_NODE)

  it 'should extract the relevant data from the dom node', ->
    commentData = "some commentData"
    comment = document.createComment(commentData)
    result = CommentNode._getNodeData(comment)
    expect(result).to.have.property('textContent', commentData)


