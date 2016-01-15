slide = require './slide.js'
log = require('./log.js')()

fs = require 'fs-extra'
et = require 'expand-tilde'
path = require 'path'
uuid = require 'node-uuid'
elasticlunr = require 'elasticlunr'

# An unordered collection of slides.
# Slides can be retrieved very rapidly by id,
# or (less rapidly) searched by fulltext+metadata or any part of metadata
class collection

  constructor: (dir='', @name) ->
    @dir = path.normalize(et(dir))
    @slides = {}
    @tags = []
    @name or= 'unnamed collection'
    @index = elasticlunr () ->
      this.addField('name')
      this.addField('body')
      this.addField('slide_author')
      this.addField('tags')
    this

  add: (_slide) ->
    if (_slide instanceof String) or ('markdown' of _slide)
      newslide = new slide(_slide)
      @slides[newslide.id] = newslide
      @_addToIndex(newslide)
    else if _slide instanceof slide
      @slides[_slide.id] = _slide
      @_addToIndex(_slide)
    else
      throw new Error('tried to add unknown type of slide')
    true

  _addToIndex: (_slide) -> @index.addDoc(_slide)

  _setid: () -> @id or= uuid.v4()

  load: () ->
    fs.readdirSync(@dir).forEach (file) =>
      if file.substr(-3) == '.md'
        filepath = path.resolve(@dir, file)
        @add({ markdown: filepath })
    log.info('Loaded', @length(), 'markdown slide files from', @dir)

  get: (id) -> @slides[id]

  names: () -> (v.name for k, v in @slides)

  length: () -> Object.keys(@slides).length

  select: (term) ->
    if 'id' of term
      return @get term.id
    else
      opts = term.opts || {}
      return @index.search(term.query, opts)

  writeSync: () ->
    __slide.writeSync(@dir) for id, __slide of @slides

module.exports = collection
