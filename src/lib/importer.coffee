path = require 'path'

class importer

  constructor: (path) ->
    raw = require path
    @name = raw['name']
    @exts = raw['file_extensions']
    @_read = raw['read']
    @type = raw['type']

  @supports = (filepath) ->
    path.extname(filepath) in @exts

  @importsSlides = () ->
    @type is 'slide'

  @importsDecks = () ->
    @type is 'deck'


