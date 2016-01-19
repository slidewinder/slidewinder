collection = require './collection.js'
log = require './log.js'
elasticlunr = require 'elasticlunr'

# A collection of collections which can be treated like a single collection
class librarian

  ## **constructor**
  #
  # create a new librarian
  #
  # **given** zero or more collections
  # **then** add any given collections to the library
  # **and** return the librarian
  constructor: (collections...) ->
    @library = {}
    @index = elasticlunr () ->
      this.addField('name')
      this.addField('body')
      this.addField('slide_author')
      this.addField('tags')
    @collections = collections.reduce(@addReducer, {})
    this

  ## Collections

  ids: () ->
    Object.keys(@library)

  size: () ->
    @ids().length

  add: (c, to=@library) ->
    c = new collection(c) if (typeof c is 'string')
    to[c.id] = c
    to

  addReducer: (all, c) =>
    @add(c, all)

  addByPath: (path, name) ->
    @add new collection(path, name)

  loadAll: () ->
    for id, c of @library
      c.load()
      @_addToIndex c

  drop: (id) ->
    @_checkID id
    delete @library[id]

  # Fetch a collection by ID
  collectionByID: (id) ->
    @_checkID id
    @library[id]

  writeAllSync: (dir) ->
    @ids().forEach (key) =>
      fullpath = path.join(dir, key)
      @library[key].wri teSync(fullpath)

  ## Slides

  # Add a slide to the library
  addSlide: (slide) -> @_addToIndex(slide) and @slides[slide.id] = slide

  # Add an array of slides to the library
  addSlides: (slides) -> @addSlide(slide) for slide in slides

  # Search slides
  slideQuery: (term) ->
    if 'id' of term
      return @slideByID term.id
    else
      opts = term.opts || {}
      return @index.search(term.query, opts)

  # Fetch a slide by ID
  slideByID: (id, slide) ->
    @library[id]

  # Write slide with the given ID

  _addToIndex: (_slide) => @index.addDoc(_slide)

  _checkID: (id) => @_throwBadID(id) if not @library[id]?

  _throwBadID: (id) =>
    msg = "No collection is loaded with an id of #{id}"
    # log.error(msg)
    throw new Error(msg)



module.exports = librarian
