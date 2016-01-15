helper = require '../utils/helper.coffee'
collection = helper.lib 'collection.js'
slide = helper.lib 'slide.js'
should = require('chai').should()
dirs = helper.dirs
temp = require 'temp'
fs = require 'fs-extra'

describe 'collection', ->

  it 'can have a name and directory', ->
    c = new collection(dirs.exampledir, 'name')

    c.name.should.be.a.string
    c.name.should.equal('name')

    c.dir.should.be.a.string
    c.dir.should.equal(dirs.exampledir)

  it 'is given a default name if none is provided', ->
    c = new collection()

    c.name.should.be.a.string
    c.name.should.not.be.empty

  it 'can add slide objects', ->
    mdfile = helper.example('code.md', false)
    s = new slide({ markdown: mdfile })

    c = new collection()
    c.add(s)

    stored = c.slides[s.id]
    stored.should.equal(s)

  it 'can add slides from markdown files', ->
    mdfile = helper.example('code.md', false)
    c = new collection()
    c.add({ markdown: mdfile })

    Object.keys(c.slides).length.should.equal(1)

  it 'can return slides by id', ->
    mdfile = helper.example('code.md', false)
    s = new slide({ markdown: mdfile })

    c = new collection()
    c.add(s)

    c.get(s.id).should.equal(s)

  it 'can populate itself from a directory', ->
    c = new collection(dirs.exampledir)
    c.load()

    c.length().should.equal(4)


  it 'can search fulltext and metadata of its slides', ->
    opts =
      name: 'raw slide'
      slide_author: 'swimming'
      body: 'this is a simple slide'
      tags: ['turtle', 'banana']
    s1 = new slide opts

    c = new collection(dirs.exampledir)
    c.load()
    c.add(s1)

    res = c.select({ query: 'simple' })
    res.length.should.equal(1, 'body')
    res[0].ref.should.equal(s1.id, 'body')

    res = c.select({ query: 'turtle' })
    res.length.should.equal(1, 'tags')
    res[0].ref.should.equal(s1.id, 'tags')

    res = c.select({ query: 'swim' })
    res.length.should.equal(1, 'author')
    res[0].ref.should.equal(s1.id, 'author')

    res = c.select({ query: 'Contextual' })
    res.length.should.equal(1,)
    res[0].ref.should.not.equal(s1.id)


  it 'can return slides by name', ->
    c = new collection(dirs.exampledir)
    c.load()

    res = c.select({ query: 'code' }, { name: { boost: 100 }})
    res.length.should.equal(2)

  it 'can return slides by tag', ->
    c = new collection(dirs.exampledir)
    c.load()

    res = c.select({ query: 'syntax' }, { tags: { boost: 100 }})
    res.length.should.equal(2)

  it 'can have tags', ->
    c = new collection()
    c.should.have.property('tags')
    c.tags.should.be.an.array
    c.tags.should.be.empty
    c.tags.push('tag')
    c.tags.length.should.equal(1)

  it 'can save itself to a directory', ->
    c = new collection(dirs.exampledir)
    c.load()
    temp.track()
    c.dir = temp.mkdirSync()
    c.writeSync()
    files = fs.readdirSync(c.dir)

    files.length.should.equal(4)

    c = new collection(c.dir)
    c.load()
    c.length().should.equal(4)
    temp.cleanupSync()
