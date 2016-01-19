helper = require '../utils/helper.coffee'
collection = helper.lib 'collection.js'
slide = helper.lib 'slide.js'
should = require('chai').should()
dirs = helper.dirs
temp = require 'temp'
fs = require 'fs-extra'

describe 'collection', ->

  it 'can be loaded from a provided config', ->


  it 'populates itself with defaults if no config is provided', ->


  it 'can have tags', ->
    c = new collection()
    c.should.have.property('tags')
    c.tags.should.be.an.array
    c.tags.should.be.empty
    c.tags.push('tag')
    c.tags.length.should.equal(1)

  it 'must have a name, which can be the default name', ->


  it 'must have a description, which can be the default description', ->


  it 'can add slides', ->


  it 'can remove slides', ->


  it 'knows how many slides it contains', ->
