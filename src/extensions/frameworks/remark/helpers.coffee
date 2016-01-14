yaml = require 'js-yaml'

addGlobalsToSlide = (slide, globals) ->
  Object.keys(globals).forEach (key) ->
    slide.attributes[key] = globals[key]

mainHelper = (context) ->
  slideData = context.data.root

  var bodies = slideData.slides.map (slide) ->
    yaml.dump(slide.attributes) + '\n' + slide.body

  bodies.join('\n---\n');

exports.slideProcessors = [ addGlobalsToSlide ]

exports.showHelpers =
  slidewinder: mainHelper
