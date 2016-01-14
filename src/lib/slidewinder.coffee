# Slidewinder-Lib.
fs = require 'fs-extra'
path = require 'path'
_ = require 'lodash'
logger = require('./log.js').logger()
yaml = require 'js-yaml'
PresentationFramework = require './framework.js'
CollectionManager = require './manager.js'
SlideDeck = require './deck.js'

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
