collection = require './collection.js'
log = require './log.js'

# A collection of collections which can be treated like a single collection
class librarian

  constructor: (@collections...) ->
    this

  names: () ->
    Object.keys(@collections)

  add: (name, path) ->
    @collections[name] = new collection(path, name)

  parse: () ->
    @names().forEach (key) =>
      @collections[key].parseSlides()

  select: (collection, slide) ->
    if not @collections[collection]?
      log.error('No collection is loaded with a name of', collection)
      process.exit()

    @collections[collection].selectSlide(slide)

  writeAllSync: (dir) ->
    @names().forEach (key) =>
      fullpath = path.join(dir, key)
      @collections[key].writeSync(fullpath)
