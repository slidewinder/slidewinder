log = require('./log.js')

fs = require 'fs-extra'
path = require 'path'
_ = require 'lodash'
configstore = require 'configstore'

librarian = require './librarian.js'
router = require './router.js'

module.exports = class slidewinder

  constructor: () ->
    @loadConfig()
    @loadLibrarian()
    this

  # Load the persistent config store, creating a new one with default
  # values if there isn't one already
  loadConfig: () ->
    @pkg = require '../package.json'
    defaults =
      datastore: '~/.slidewinder/data'
      setup: false
      issues_url: 'http://github.com/slidewinder/slidewinder/issues'
    @config = new configstore(@pkg.name, defaults)

  # Create the slide librarian, creating a default
  # collection if it doesn't exist already
  loadLibrarian: () ->
    ds = @config.get('datastore')
    fs.ensureDirSync(ds)
    collections = path.join(ds, c) for c in fs.readdirSync(ds).concat('default')
    @librarian = new librarian _.uniq(collections)

  # Run slidewinder interactively
  run: () =>
    routesDir = path.join(__dirname, '..', 'routes')
    router = new router(this).registerDir routesDir
    process.once('exit', router.navigate.bind(router, 'exit'))
    router.navigate('home')
