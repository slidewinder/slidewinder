# Slidewinder-Lib.
fs = require 'fs-extra'
et = require 'expand-tilde'
path = require 'path'
fm = require 'front-matter'
handlebars = require 'handlebars'
_ = require 'lodash'
mkdirp = require 'mkdirp'
logger = require './log.js'
yaml = require 'js-yaml'

log_colours =
  silly: 'magenta'
  input: 'grey'
  verbose: 'cyan'
  prompt: 'grey'
  debug: 'blue'
  info: 'green'
  data: 'grey'
  help: 'cyan'
  warn: 'yellow'
  error: 'red'


# A SlideCollection is a collection of slides. The collection of slides is
# Unorderd, and as such is a collection of slides which you pick and choose slides
# from by name.
class SlideCollection
  constructor: (folder, @name) ->
    @folder = path.normalize(et(folder))
    @slides = {}
    this

  parseSlides: () =>
    @slides = {}
    fs.readdirSync(@folder).forEach (file) =>
      if file.substr(-3) == '.md'
        filepath = path.resolve(@folder, file)
        data = fs.readFileSync(filepath, 'utf8')
        slide = fm data
        name = slide.attributes.name
        if @slides[name]
          log.error('Multiple slides have the name', name, 'in one collection!')
        else
          @slides[name] = slide
    log.info('Loaded', @nSlides(), 'markdown slide files from', @folder)

  slideNames: () ->
    Object.keys(@slides)

  nSlides: () ->
    @slideNames().length

  selectSlide: (name) ->
    if not @slides[name]?
      log.error('No slide exists in collection', @name, 'with a name of', name)
      process.exit()
    @slides[name]

  writeSync: (dir) ->
    @slideNames().forEach (key) =>
      slide = @slides[key]
      completeBody = "---\n#{yaml.dump(slide.attributes)}---\n#{slide.body}"
      fs.outputFileSync(path.join(et(dir), "#{key}.md"),completeBody)


# A collection of collections. Just to make picking out slides and such easier.
class CollectionManager
  constructor: (colpaths) ->
    @collections = {}
    Object.keys(colpaths).forEach (key) =>
      @addCollection(key, colpaths[key])
    this

  collectionNames: () ->
    Object.keys(@collections)

  addCollection: (name, path) ->
    @collections[name] = new SlideCollection(path, name)

  parseCollections: () ->
    @collectionNames().forEach (key) =>
      @collections[key].parseSlides()

  selectSlide: (collection, slide) ->
    if not @collections[collection]?
      log.error('No collection is loaded with a name of', collection)
      process.exit()
    @collections[collection].selectSlide(slide)

  writeAllSync: (dir) ->
    @collectionNames().forEach (key) =>
      fullpath = path.join(dir, key)
      @collections[key].writeSync(fullpath)


# Class for representing a slide deck. Unlike collections, order matters in a
# SlideDeck.
class SlideDeck
  constructor: (title, author, @collections) ->
    @globals =
      title: title
      author: author
    @rawSlides = [] # References to slides in @collections.
    @processedSlides = undefined # Copies of the @rawslides, that are manipped and processed.
    @renderedDeck = undefined

  slideNames: () ->
    names = []
    @rawSlides.forEach (slide) ->
      names.push slide.attributes.name
    names

  assemble: (selections) ->
    selections.forEach (selection) =>
      group = selection[0]
      slide = selection[1]
      @rawSlides.push(@collections.selectSlide(group, slide))


  preProcessSlides: (framework) ->
    @processedSlides = JSON.parse(JSON.stringify(@rawSlides))
    @processedSlides.forEach (slide) =>
      framework.slideProcessors.forEach (op) =>
        op(slide, @globals)

  render: (framework) ->
    renderContext =
      deck:
        title: @globals.title
        author: @globals.author
      slides: @processedSlides
    @renderedDeck = framework.renderDeck renderContext

  write: (filepath) ->
    filepath = et(filepath)
    fs.outputFileSync(path.join(filepath, 'index.html'), @renderedDeck)
    @collections.writeAllSync(path.join(filepath, 'collections'))


# Class to manage the loading and execution of steps of a presentation
# framework.
class PresentationFramework
  constructor: (framework) ->
    log.info('Looking for presentation framework module: ', framework)
    frameworkPath = path.join('extensions/frameworks', framework)
    templatePath = path.join(frameworkPath, 'template.html')
    @template = fs.readFileSync(templatePath, 'utf8')
    helpersPath = path.join('../', frameworkPath, 'helpers.js')
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


exports.yamlToSpec = (filepath) ->
  inputSpecification = fs.readFileSync(filepath, 'utf8')
  specification = yaml.load(inputSpecification)
  specification.slides.forEach (slide, index) ->
    specification.slides[index] = slide.split('.')
  specification

exports.compile = (spec, outdir) ->
  log.info('Compiling slideshow...')
  log.info('Loading presentation framework...')
  plugin = new PresentationFramework spec.framework
  log.info('Loading slide collections...')
  collections = new CollectionManager spec.collections
  collections.parseCollections()
  log.info('Assembling slide deck...')
  deck = new SlideDeck(spec.title, spec.author, collections)
  deck.assemble(spec.slides)
  log.info('Pre Processing slides...')
  deck.preProcessSlides(plugin)
  log.info('Rendering slideshow...')
  deck.render(plugin)
  log.info('Writing slideshow...')
  deck.write(outdir)

log = logger()
