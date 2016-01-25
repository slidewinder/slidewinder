helper = require '../utils/helper.coffee'
librarian = helper.lib 'librarian.js'
collection = helper.lib 'collection.js'
slide = helper.lib 'slide.js'
should = require('chai').should()
dirs = helper.dirs
temp = require 'temp'
fs = require 'fs-extra'

describe 'librarian', ->

  it 'holds all the slides bunch of collections', ->
    this.timeout(20000);
    l = helper.big_library()
    Object.keys(l.library).length.should.equal(3)

  it 'knows the ids of its collections', ->
    this.timeout(20000);
    l = helper.big_library()
    ids = l.ids()
    ids.should.exist
    ids.should.be.a.array
    ids.length.should.equal(3)

  it 'can add collections by path', ->
    l = new librarian()
    l.size().should.equal(0)

    l.add(dirs.exampledir)
    l.size().should.equal(1)

  it 'can add collections as objects', ->
    l = new librarian()
    l.size().should.equal(0)
    c = new collection()

    l.add(c)
    l.size().should.equal(1)

  it 'can drop collections', ->
    l = new librarian()

    l.add(dirs.exampledir)
    l.size().should.equal(1)
    l.drop(l.ids()[0])
    l.size().should.equal(0)

  it 'can search fulltext and metadata of its slides', ->
    this.timeout(20000);
    l = helper.big_library()
    l.loadAll()
    console.log l

    res = l.slideQuery({ query: 'simple' })
    res.length.should.equal(1, 'body')
    res[0].ref.should.equal(s1.id, 'body')

    res = l.slideQuery({ query: 'turtle' })
    res.length.should.equal(1, 'tags')
    res[0].ref.should.equal(s1.id, 'tags')

    res = l.slideQuery({ query: 'swim' })
    res.length.should.equal(1, 'author')
    res[0].ref.should.equal(s1.id, 'author')

    res = l.slideQuery({ query: 'Contextual' })
    res.length.should.equal(1,)
    res[0].ref.should.not.equal(s1.id)

  it 'can write out any collection', ->
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


  it 'can write out all collections', ->

  it 'can save itself to a directory', ->

  it 'can add slide objects', ->
    mdfile = helper.example('code.md', false)
    s = new slide({ markdown: mdfile })

    l = new librarian()
    c.addSlide(s)

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
