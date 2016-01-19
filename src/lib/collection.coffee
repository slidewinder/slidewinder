slide = require './slide.js'
log = require('./log.js')()

fs = require 'fs-extra'
et = require 'expand-tilde'
path = require 'path'
uuid = require 'node-uuid'

# A set of slides stored by their ID only,
# which can have tags, a name, and an
# associated directory.
class collection

  # **collection**
  #
  # **given** an optional object opts
  # **then** store the provided options
  # **and** set the defaults for any options not provided
  constructor: (opts) ->
    @slides = new Set(opts?.slides)
    @dir = path.normalize(et(dir)) if dir of opts
    @name = opts?.name or
      "this collection doesn't have a name yet"
    @description = opts?.description or
      "this collection doesn't have a description yet"
    @id = opts?.id or @_setid()
    @tags = opts?.tags or []
    this

  addSlide: (id) -> @slides.add id

  dropSlide: (id) -> @slides.delete id

  length: () -> Object.keys(@slides).length

  _setid: () -> @id or= uuid.v4()

module.exports = collection
