fs = require 'fs-extra'
path = require 'path'
handlebars = require 'handlebars'

# Class to manage the loading and execution of steps of a presentation
# framework.
class PresentationFramework
  constructor: (framework) ->
    log.info('Looking for presentation framework module: ', framework)
    frameworkPath = path.join(__dirname, '../extensions/frameworks', framework)
    templatePath = path.join(frameworkPath, 'template.html')
    @template = fs.readFileSync(templatePath, 'utf8')
    helpersPath = path.join(frameworkPath, 'helpers.js')
    fwfuns = require helpersPath
    @renderer = handlebars.compile @template
    @slideProcessors = fwfuns['slideProcessors']
    @showHelpers = fwfuns['showHelpers']
    @renderDeck = (renderContext) =>
      Object.keys(@showHelpers).forEach (key) =>
          handlebars.registerHelper(key, @showHelpers[key])
      deck = @renderer(renderContext)
      deck
    this
