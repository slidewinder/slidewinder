slide = require './slide.js'
collection = require './collection.js'
log = require './log.js'
elasticlunr = require 'elasticlunr'
fs = require 'fs-extra'
et = require 'expand-tilde'
path = require 'path'
_ = require 'lodash'
promise = require 'promise'

# A collection of collections which can be treated like a single collection
class librarian

  ## **constructor**
  #
  # create a new librarian
  #
  # **given** zero or more collections
  # **then** add any given collections to the library
  # **and** return the librarian
  constructor: (cols, @app) ->
    @library = {}
    @index = elasticlunr () ->
      this.addField 'name'
      this.addField 'body'
      this.addField 'slide_author'
      this.addField 'tags'
    @collections = cols.reduce(@addReducer, {})
    this

  ## Collections

  ids: () => Object.keys(@library)

  size: () => _.size @library

  add: (c, to=@collections) =>
    if _.isString(c)
      c = @addByPath c
    else
      to[c.id] = c
      @app?.flush_collections()
    c

  addReducer: (all, c) => @add(c, all)

  addByPath: (dir, name) =>
    slides = fs.readdirSync(dir)
      .filter (file) -> path.extname(file).toLowerCase() is '.md'
      .map (file) -> new slide({ markdown: path.join(dir, file) })

    # add the individual slides
    slides.forEach @addSlide

    # create collection for this directory
    opts =
      dir: dir
      name: name
      slides: slides.map (s) -> s.id

    c =  new collection(opts)
    @add c

  drop: (id) =>
    @_checkID id
    delete @library[id]

  # Fetch a collection by ID
  collectionByID: (id) =>
    @_checkID id
    @collections[id]

  writeAllSync: (dir) =>
    @ids().forEach (key) =>
      fullpath = path.join(dir, key)
      @library[key].writeSync(fullpath)

  ## Slides

  # Add a slide to the library
  addSlide: (slide) =>
    @_addToIndex(slide)
    @library[slide.id] = slide

  # Add an array of slides to the library
  addSlides: (slides) => @addSlide(slide) for slide in slides

  # Search slides
  slideQuery: (term) =>
    term or= { query: '*' }
    if 'id' of term
      return @slideByID term.id
    else
      opts = term.opts || {}
      return @index.search(term.query, opts)

  # Autocomplete-compatible promise
  slideQueryAutocomplete: (term) =>
    sq = @slideQuery
    new promise (resolve) =>
      r = () -> resolve(sq(term))
      setTimeout(r, 400)

  # Fetch a slide by ID
  slideByID: (id, slide) -> @library[id]

  _addToIndex: (_slide) => @index.addDoc(_slide)

  _checkID: (id) => @_throwBadID(id) if not @library[id]?

  _throwBadID: (id) =>
    msg = "No collection is loaded with an id of #{id}"
    # log.error(msg)
    throw new Error(msg)


module.exports = librarian
