helper = require '../utils/helper.coffee'
slide = helper.lib 'slide.js'
chai = require('chai')
should = chai.should()
expect = chai.expect
dirs = helper.dirs

describe 'slide', ->

  it 'can be loaded from a markdown file', ->
    mdfile = helper.example('code.md', false)
    s = new slide({ markdown: mdfile })

    s.status.success.should.equal(true, s.status.detail)

    s.name.should.be.a.string
    s.name.should.equal('code')

    s.slide_author.should.be.a.string
    s.slide_author.should.match(/Richard/)

    s.body.should.be.a.string
    s.body.should.match(/some\ code/)

  it 'can be created via the API', ->
    opts =
      name: 'raw slide'
      slide_author: 'me'
      body: 'this is a simple slide'
    s = new slide opts

    s.status.success.should.equal(true, s.status.detail)

    s.name.should.be.a.string
    s.name.should.equal('raw slide')

    s.slide_author.should.be.a.string
    s.slide_author.should.equal('me')

    s.body.should.be.a.string
    s.body.should.match(/simple/)

  it 'should produce a uniquey identifier', ->
    mdfile = helper.example('code.md', false)
    first = new slide({ markdown: mdfile })
    hasha = first.identifier()

    hasha.should.be.a.string

    second = new slide({ markdown: mdfile })
    hashb = second.identifier()

    failmsg = 'two slides cannot have the same identifier'
    hasha.should.not.equal(hashb, failmsg)

  it 'can generate a clone of itself', ->
    mdfile = helper.example('code.md', false)
    parent = new slide({ markdown: mdfile })
    child = parent.clone()

    child.name.should.equal(parent.name)
    child.body.should.equal(parent.body)

  it 'should have a different identifier to its child', ->
    mdfile = helper.example('code.md', false)
    parent = new slide({ markdown: mdfile })
    child = parent.clone()

    child.identifier().should.not.equal(parent.identifier())

  it 'should know its own parent', ->
    mdfile = helper.example('code.md', false)
    parent = new slide({ markdown: mdfile })
    child = parent.clone()

    expect(parent.parent).to.be.a('null')
    child.parent.should.equal(parent.identifier())

  it 'knows the clones it has spawned', ->
    mdfile = helper.example('code.md', false)
    parent = new slide({ markdown: mdfile })
    child = parent.clone()

    parent.children.should.contain(child.identifier())

  it 'can be edited', ->
    mdfile = helper.example('code.md', false)
    parent = new slide({ markdown: mdfile })
    child = parent.clone()

    parent.children.should.contain(child.identifier())

  it 'keeps its original identifier when edited', ->
    opts =
      name: 'raw slide'
      slide_author: 'me'
      body: 'this is a simple slide'
    s = new slide opts
    orig_id = s.identifier()

    orig_id.should.be.a.string

    s.body = s.body + ' edited'

    s.identifier().should.equal(orig_id)

  it 'can have custom css', ->
    opts =
      name: 'raw slide'
      slide_author: 'me'
      body: 'this is a simple slide'
      css: 'color: white;'
    s = new slide opts

    s.css.should.be.a.string
    s.css.should.match(/white/)

  it 'can have custom javascript', ->
    opts =
      name: 'raw slide'
      slide_author: 'me'
      body: 'this is a simple slide'
      js: "console.log('custom js ftw')"
    s = new slide opts

    s.js.should.be.a.string
    s.js.should.match(/js ftw/)

  it 'can have tags', ->
    opts =
      name: 'raw slide'
      slide_author: 'me'
      body: 'this is a simple slide'
      tags: ['blue', 'not red']
    s = new slide opts

    s.tags.should.be.a.array
    s.tags.should.contain('not red')
