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
    @collections = if cols then cols.reduce(@addReduce, {}) else []
    this

  ## Collections

  flush: () =>
    @app?.flush_collections()
    @app?.flush_slides()

  add: (c, to=@collections) =>
    if _.isString(c)
      c = @addByPath(c, null, to)
    else
      to[c.id] = c
    c

  addReduce: (all, c) => @add(c, all)

  addByPath: (dir, name, to=@collections) =>
    fs.ensureDirSync(dir)
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
    @add(c, to)


  # Fetch a collection by ID
  collectionByID: (id) =>
    @_checkID id
    @collections[id]

  ## Slides

  # Add a slide to the library
  addSlide: (slide) =>
    @_addToIndex(slide)
    @library[slide.id] = slide

  # Add an array of slides to the library
  addSlides: (slides) => @addSlide(slide) for slide in slides

  ids: () => Object.keys(@library)

  size: () => _.size @library

  drop: (id) =>
    @_checkID id
    delete @library[id]

  # Search slides
  slideQuery: (term) =>
    term or= { query: '' }
    term = { query: term } if _.isString(term)
    opts = term.opts || {}
    @index.search(term.query, opts).map (s) =>
      { slide: @slideByID(s.ref) score: s.score }

  # Autocomplete-compatible promise
  slideQueryAutocomplete: (term) =>
    sq = @slideQuery
    new promise (resolve) =>
      r = () -> resolve(sq(term))
      setTimeout(r, 400)

  # Fetch a slide by ID
  slideByID: (id, slide) -> @library[id]

  # Write all slides to a dir
  writeAllSync: (dir) =>
    @ids().forEach (key) =>
      fullpath = path.join(dir, key)
      @library[key].writeSync(fullpath)

  _addToIndex: (_slide) => @index.addDoc(_slide)

  _checkID: (id) => @_throwBadID(id) if not @library[id]?

  _throwBadID: (id) =>
    msg = "No collection is loaded with an id of #{id}"
    # log.error(msg)
    throw new Error(msg)



module.exports = librarian
