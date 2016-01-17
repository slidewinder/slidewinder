helper = require '../utils/helper.coffee'
librarian = helper.lib 'librarian.js'
slide = helper.lib 'slide.js'
should = require('chai').should()
dirs = helper.dirs
temp = require 'temp'
fs = require 'fs-extra'

describe 'librarian', ->

  it 'holds a bunch of collections', ->


  it 'can list names of its collections', ->


  it 'can add new collections', ->


  it 'can drop collections', ->


  it 'can search across all collections', ->
