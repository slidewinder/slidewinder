log = require('./log.js')()

fs = require 'fs-extra'
path = require 'path'
_ = require 'lodash'
et = require 'expand-tilde'
configstore = require 'configstore'

librarian = require './librarian.js'
router = require './router.js'

module.exports = class slidewinder

  constructor: () ->
    @log = log
    @loadConfig()
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

  # Create the slide librarian, creating a default
  # collection if it doesn't exist already
  loadLibrarian: () =>
    ds = @config.get('datastore')
    fs.ensureDirSync(ds)
    @librarian = new librarian(@config.get('collections') , this)

  flush_collections: () =>
    console.log 'flushing collections'
    @config.set('collections', @librarian.collections)

  # Run slidewinder interactively
  run: () =>
    routesDir = path.join(__dirname, '..', 'routes')
    router = new router(this).registerDir routesDir
    router.navigate('home')
