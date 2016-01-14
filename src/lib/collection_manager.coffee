SlideCollection = require './collection.js'

# A collection of collections. Just to make picking out slides and such easier.
class CollectionManager
  constructor: (colpaths) ->
    @collections = {}
    Object.keys(colpaths).forEach (key) =>
      @addCollection(key, colpaths[key])
    this

  collectionNames: () ->
    Object.keys(@collections)

  addCollection: (name, path) ->
    @collections[name] = new SlideCollection(path, name)

  parseCollections: () ->
    @collectionNames().forEach (key) =>
      @collections[key].parseSlides()

  selectSlide: (collection, slide) ->
    if not @collections[collection]?
      log.error('No collection is loaded with a name of', collection)
      process.exit()
    @collections[collection].selectSlide(slide)

  writeAllSync: (dir) ->
    @collectionNames().forEach (key) =>
      fullpath = path.join(dir, key)
      @collections[key].writeSync(fullpath)
