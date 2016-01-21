'use strict';
path = require 'path'
configstore = require 'configstore'
fs = require 'fs-extra'
log = require('../lib/log.js')()

# The router handles `slidewinder` user interaction routes.
module.exports = class router

  # @param  {Configstore} [conf] An optional config store instance
  constructor: (slidewinder) ->
    @routes = {}
    @slidewinder = slidewinder
    @config = slidewinder.config

  # Navigate to the specified route, passing an optional argument
  # to the route handler
  #
  # @param {String} name Route name
  # @param {*} arg A single argument to pass to the route handler
  navigate: (name, arg) =>
    if name of @routes and (typeof @routes[name] is 'function')
      return @routes[name].call(null, this, arg)

    log.error("Oh dear, I couldn't find a route with the name " + name)
    log.error("Please file a bug report at #{@config.get 'issues_url'}")
    @navigate 'home'

  # Register a route handler
  #
  # @param {String} name Name of the route
  # @param {Function} handler Route handler
  register: (name, handler) =>
    @routes[name] = require handler
    this

  # Register routes from a directory, naming them with the
  # base of their filename
  registerDir: (dir) =>
    for file in fs.readdirSync(dir)
      continue unless path.extname(file) is '.js'
      name = path.basename(file, '.js')
      handler_path = path.join(dir, file)
      @register(name, handler_path)
    this
