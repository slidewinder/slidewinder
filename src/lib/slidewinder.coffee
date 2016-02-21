log = require('./log.js')()

fs = require 'fs-extra'
path = require 'path'
_ = require 'lodash'
et = require 'expand-tilde'
configstore = require 'configstore'
librarian = require './librarian.js'
router = require './router.js'
deck = require './deck.js'
slide = require './slide.js'

class slidewinder

  constructor: (@db) ->
    @log = log
    @loadConfig()
    @loadDB()
    @loadImporters()
    @loadLibrarian()
    this

  # Load the persistent config store, creating a new one with default
  # values if there isn't one already
  loadConfig: () =>
    @pkg = require '../package.json'
    defaults =
      datastore: path.join(et('~'), '.slidewinder/data')
      setup: false
      issues_url: 'http://github.com/slidewinder/slidewinder/issues'
      local: true
      collections: []
    @config = new configstore(@pkg.name, defaults)

  # Load the persistent data store
  loadDB: () =>
    @db.dbPath = @config.get('datastore')

  # Load the importers installed to slidewinder
  loadImporters: () =>
    dir = @config.get('importerdir')

    # If there is no directory set containing installed importers, set it up.
    unless dir
      dir = path.join(@config.get('datastore'), 'importers')
      fs.ensureDirSync dir
      @config.set('importerdir', dir)
      # Install default provided importers.
      slide = path.join dir, 'slide'
      deck = path.join dir, 'deck'
      fs.copySync path.join(__dirname, '../extensions/importers/slide'), slide
      fs.copySync path.join(__dirname, '../extensions/importers/deck'), deck

    # Now go through directory of installed slide importers and deck importers.
    # Add them to this objects @importers object.
    slide = path.join dir, 'slide'
    deck = path.join dir, 'deck'
    @importers =
        slide: {}
        deck: {}
    slideFiles = fs.readdirSync slide
    slideFiles.forEach (filename) =>
      slide_imptr = require path.join(slide, filename)
      @importers.slide[slide_imptr.importer_name] = slide_imptr
    deckFiles = fs.readdirSync deck
    deckFiles.forEach (filename) =>
      deck_imptr = require path.join(deck, filename)
      @importers.deck[deck_imptr.importer_name] = deck_imptr

  listImporters: (options) ->
    if options.installed
      if options.slide
        fs.readdirSync path.join(@config.get('importerdir'), 'slide')
      else if options.deck
        fs.readdirSync path.join(@config.get('importerdir'), 'deck')
    else if options.loaded
      if options.slide

      else if options.deck
      

  # Create the slide librarian, creating a default
  # collection if it doesn't exist already
  loadLibrarian: () =>
    ds = @config.get('datastore')
    fs.ensureDirSync(ds)
    @librarian = new librarian(this)

  # Run slidewinder interactively
  run: () =>
    routesDir = path.join(__dirname, '..', 'routes')
    router = new router(this).registerDir routesDir
    router.navigate('home')

  listFrameworks: () ->
    fs.readdirSync(path.join(__dirname, '../extensions/frameworks'))

  listDecks: (cb) =>
    @librarian.decks.find({}, cb)

  decksDir: () =>
    dir = @config.get('decksdir')
    unless dir
      dir = path.join(@config.get('datastore'), 'decks')
      fs.ensureDirSync dir
      @config.set('decksdir', dir)
    dir

  presentDeck: (data, framework='remark') =>
    d = new deck(@librarian, data, framework)
    deckdir = path.join(@decksDir(), d.data._id)
    fs.ensureDirSync deckdir
    d.present(deckdir)
    deckdir

module.exports =
  slidewinder: slidewinder
  slide: slide
  deck: deck
  librarian: librarian
