log = require('./log.js').logger()

fs = require 'fs-extra'
path = require 'path'
_ = require 'lodash'
yaml = require 'js-yaml'

framework = require './framework.js'
librarian = require './librarian.js'
deck = require './deck.js'

exports.yamlToSpec = (filepath) ->
  inputSpecification = fs.readFileSync(filepath, 'utf8')
  specification = yaml.load(inputSpecification)
  specification.slides.forEach (slide, index) ->
    specification.slides[index] = slide.split('.')
  specification

exports.compile = (spec, outdir) ->
  log.info('Compiling slideshow...')

  log.info('Loading presentation framework...')
  plugin = new framework spec.framework

  log.info('Loading slide collections...')
  collections = new librarian spec.collections
  collections.parse()

  log.info('Assembling slide deck...')
  deck = new deck(spec.title, spec.author, collections)
  deck.assemble(spec.slides)

  log.info('Pre Processing slides...')
  deck.preProcessSlides(plugin)

  log.info('Rendering slideshow...')
  deck.render(plugin)

  log.info('Writing slideshow...')
  deck.write(outdir)
