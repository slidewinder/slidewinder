slide = require './slide.js'
collection = require './collection.js'
log = require './log.js'
elasticlunr = require 'elasticlunr'
fs = require 'fs-extra'
et = require 'expand-tilde'
path = require 'path'
_ = require 'lodash'
promise = require 'promise'
deasync = require 'deasync'
striptags = require 'striptags'
uuid = require 'node-uuid'


# A collection of collections which can be treated like a single collection
class librarian

  ## **constructor**
  #
  # create a new librarian
  #
  # **given** zero or more collections
  # **then** add any given collections to the library
  # **and** return the librarian
  constructor: (@app) ->
    db = @app.db
    dbpath = db.dbPath
    @slides = new db(
      'slide', {},
      { filename: path.join(dbpath, 'slide.db') }
    )
    @index = elasticlunr () ->
      this.addField 'name'
      this.addField 'body'
      this.addField 'author'
      this.addField 'tags'
      this.addField 'metadata'
    @decks = new db(
      'deck', {},
      { filename: path.join(dbpath, 'deck.db') }
    )
    @collections = new db(
      'collection', {},
      { filename: path.join(dbpath, 'collection.db') }
    )
    @slides.find {}, (err, res) =>
      res.forEach (s) =>
        s.id = s._id
        @_addToIndex s
    this

  ## Collections

  addCollection: (c) =>
    @collections.insert c.dump()
    c

  addByPath: (dir, name) =>
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
    @addCollection(c)


  # Fetch a collection by ID
  collectionByID: (id) => @collections.findOne({ _id: id })

  ## Slides

  # Add a slide to the library
  addSlide: (slide) =>
    @_addToIndex slide
    @slides.insert slide.dump()

  # Add an array of slides to the library
  addSlides: (slides) => @addSlide(slide) for slide in slides

  size: => @index.documentStore.length

  drop: (id) =>
    @slides.findOne { _id: id }, (err, doc) ->
      doc.remove () -> @index.removeDoc doc

  prettifySlide: (slide) ->
    truncopts =
      length: 80
      separator: /[,\.]? +/
      omission: ' [...]'
    namepart = if slide.name then "#{slide.name} - " else ''
    bodypart = _.truncate(striptags(slide.body), truncopts)
      .trim() # leading and trailing whitespace
      .replace(/\n/g, ' | ') # newlines to separators
      .replace(/\s+/g, ' ') # normalise spaces
      .replace(/#|\*|\_/g, '') # markdown stuff
    desc = "#{namepart}#{bodypart}"
    { name: desc, short: desc, value: slide._id }

  # Search slides
  findSlides: (term, cb) =>
    term or= { query: '' }
    term = { query: term } if _.isString(term)
    opts = term.opts || { expand: true, bool: "OR" }
    hits = @index.search(term.query, opts)
      .map (h) -> { _id: h.ref }
    if hits.length == 0
      cb(null, [])
    else
      @slides.find { $or: hits }, (err, res) =>
        cb err, res.map (s) => @prettifySlide(s)

  findSlidesPromise: (term) =>
    find = promise.denodeify(@findSlides)
    find(term)

  # Fetch a slide by ID
  slideByID: (id) => deasync @slides.findOne({ _id: id })

  slidesByID: (ids, cb) =>
    @slides.find({ $or: ({ _id: id } for id in ids) }, cb)

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

  # Decks
  createDeck: (deck) ->
    deck._id or= uuid.v4()
    @decks.insert deck

module.exports = librarian
