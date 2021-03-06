assert = require('chai').assert

global.library = __dirname + '/../'
{ Node, Resource } = require '../../'

node = new Node 'test', {}

userJane = new Resource node, 'user:jane', {}
userAndy = new Resource node, 'user:andy', {}
pathHome1 = new Resource node, 'path:/home', { deps: [ 'path:/etc'] }
pathHome2 = new Resource node, 'path:/home', { priority: 7 }
pathMultiple = new Resource node, 'path:/{a,b/c}', {}

module.exports =

  'constructor': ->
    assert.equal userJane.uri.href, 'user:jane'
    assert.ok userJane.scheme instanceof require '../../src/scheme/user'

  '#deps': ->
    assert.length pathHome1.deps(), 3
    assert.equal pathHome1.deps()[2], 'path:/etc'

  '.merge': ->
    assert.isNull Resource.merge null, null
    assert.isNull Resource.merge null, userJane
    assert.isNull Resource.merge userJane, null
    assert.isNull Resource.merge userJane, userAndy
    assert.equal pathHome1, Resource.merge pathHome1, pathHome1
    assert.equal pathHome2, Resource.merge pathHome1, pathHome2
    assert.equal pathHome2, Resource.merge pathHome2, pathHome1

  '#cmp': ->
    assert.ok userJane.cmp userJane
    assert.ok pathHome1.cmp pathHome1
    assert.ok not userJane.cmp userAndy
    assert.ok not pathHome1.cmp userJane
    assert.ok not pathHome1.cmp pathHome2

  '#decompose': ->
    assert.deepEqual pathMultiple.decompose(), [ 'path:/a', 'path:/b/c' ]
