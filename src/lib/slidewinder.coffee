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
    @loadLibrarian()
    @loadDB()
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

  # Create the slide librarian, creating a default
  # collection if it doesn't exist already
  loadLibrarian: () =>
    ds = @config.get('datastore')
    fs.ensureDirSync(ds)
    @librarian = new librarian(this, @db)

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
