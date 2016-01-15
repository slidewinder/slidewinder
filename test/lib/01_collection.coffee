helper = require '../utils/helper.coffee'
collection = helper.lib 'collection.js'
should = require('chai').should()
dirs = helper.dirs

describe 'collection', ->

  it 'has a name and directory', ->
    c = new collection(dirs.exampledir, 'name')

    c.name.should.be.a.string
    c.name.should.equal('name')

    c.dir.should.be.a.string
    c.dir.should.equal(dirs.exampledir)

  it 'can return slides by name', ->


  it 'can return slides by tag', ->

  it 'can search fulltext and metadata of its slides', ->

  it 'can have tags', ->

  it 'can save itself to a directory', ->

  it 'can populate itself from a git repo URL', ->

  it 'can populate itself by eating another collection', ->
