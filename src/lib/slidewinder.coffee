log = require('./log.js')

fs = require 'fs-extra'
path = require 'path'
_ = require 'lodash'
configstore = require 'configstore'

librarian = require './librarian.js'
router = require './router.js'

class slidewinder

  constructor: () ->
    @loadConfig()
    @loadLibrarian()
    this

  # Load the persistent config store, creating a new one with default
  # values if there isn't one already
  loadConfig: () ->
    pkg = require '../package.json'
    defaults =
      datastore: '~/.slidewinder/data'
      setup: false
    @config = new configstore(pkg.name, defaults)

  # Create the slide librarian, creating a default
  # collection if it doesn't exist already
  loadLibrarian: () ->
    ds = @config.get('datastore')
    fs.ensureDirSync(ds)
    collections = path.join(ds, c) for c in fs.readdirSync(ds).concat('default')
    @librarian = new librarian _uniq(collections)

  # Run slidewinder interactively
  run: () =>
    router = new router(this).registerDir('./routes')
    process.once('exit', router.navigate.bind(router, 'exit')
    router.navigate 'home'
