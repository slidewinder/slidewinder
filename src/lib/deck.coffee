path = require 'path'
fs = require 'fs-extra'
et = require 'expand-tilde'
log = require './log.js'
open = require 'open'
framework = require './framework.js'

# Class for generating a presentation from an array of slides
# and some metadata
class deck
  constructor: (@librarian, @data, frameworkName="remark") ->
    @processedSlides = undefined
    @renderedDeck = undefined
    @framework = new framework(frameworkName)

  present: (outdir) =>
    @librarian.slidesByID @data.slides, (err, slides) =>
      @preprocess slides, => @render => @write(outdir, true)

  globalMetadata: () =>
    { name: @data.name, author: @data.author, tags: @data.tags }

  preprocess: (slides, cb) =>
    @processedSlides = slides.map (slide) =>
      @framework.processors.forEach (op) =>
        op(slide, { slide: slide, deck: @data })
      slide
    cb?()

  render: (cb) =>
    renderContext =
      deck: @globalMetadata()
      slides: @processedSlides
    @renderedDeck = @framework.renderDeck renderContext
    cb?()

  write: (outdir, openAfter=false) =>
    filepath = et outdir
    deckpath = path.join(outdir, 'index.html')
    fs.outputFileSync(deckpath, @renderedDeck)
    open deckpath if openAfter

module.exports = deck
