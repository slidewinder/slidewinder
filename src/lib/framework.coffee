fs = require 'fs-extra'
path = require 'path'
handlebars = require 'handlebars'
log = require('./log.js')()

# Class to manage the loading and execution of steps of a presentation
# framework.
class framework

  constructor: (framework) ->

    frameworkPath = path.join(__dirname, '../extensions/frameworks', framework)

    templatePath = path.join(frameworkPath, 'template.html')
    @template = fs.readFileSync(templatePath, 'utf8')

    helpersPath = path.join(frameworkPath, 'helpers.js')
    fwfuns = require helpersPath

    @renderer = handlebars.compile @template

    @processors = fwfuns['processors']
    @helpers = fwfuns['helpers']

  renderDeck: (context) =>
    Object.keys(@helpers).forEach (key) =>
        handlebars.registerHelper(key, @helpers[key])
    deck = @renderer(context)
    deck

  this

module.exports = framework
