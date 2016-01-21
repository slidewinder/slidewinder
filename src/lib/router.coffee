'use strict';
path = require 'path'
_ = require 'lodash'
titleize = require 'titleize'
humanizeString = require 'humanize-string'
readPkgUp = require 'read-pkg-up'
updateNotifier = require 'update-notifier'
configstore = require 'configstore'
fs = require 'fs-extra'

# The router handles `slidewinder` user interaction routes.
class router

  # @param  {Configstore} [conf] An optional config store instance
  constructor: (slidewinder) ->
    @routes = {}
    @slidewinder = slidewinder

  # Navigate to the specified route, passing an optional argument
  # to the route handler
  #
  # @param {String} name Route name
  # @param {*} arg A single argument to pass to the route handler
  router.prototype.navigate = (name, arg) =>
    if typeof @routes[name] is 'function'
      return @routes[name].call(null, this, arg)

    throw new Error('no routes called: ' + name)

  # Register a route handler
  #
  # @param {String} name Name of the route
  # @param {Function} handler Route handler
  router.prototype.register = (name, handler) =>
    @routes[name] = handler
    this

  # Register routes from a directory, naming them with the
  # base of their filename
  router.prototype.registerDir = (path) =>
    for file in fs.readdirSync(path)
      @register(path.basename(file, '.js'), file) if path.extname(file) is '.js'
    this
