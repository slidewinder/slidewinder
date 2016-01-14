path = require 'path'
et = require 'expand-tilde'

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
