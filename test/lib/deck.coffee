helper = require '../utils/helper.coffee'
deck = helper.lib 'deck.js'
collection = helper.lib 'collection.js'
should = require('chai').should()


describe 'deck', ->

  it 'has a title, author and one or more associated collections', ->
    false.should.be.true

  it 'can list the names of its slides', ->
    false.should.be.true

  it 'can assemble slides', ->
    false.should.be.true

  it "can't assemble if it has no collections", ->
    false.should.be.true

  it 'can preprocess slides with a given framework', ->
    false.should.be.true

  it "can't preprocess slides if there's no framework provided", ->
    false.should.be.true

  it 'can render itself', ->
    false.should.be.true

  it "can't render itself if there are no slides assembled", ->
    false.should.be.true

  it 'can write itself to a file', ->
    false.should.be.true

  it "requires a filepath to write to before writing", ->
    false.should.be.true

  it "can generate a clone of itself", ->

  it "knows the clones it has spawned", ->
