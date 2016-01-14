log = require '../../../lib/log.js'
yaml = require 'js-yaml'

addGlobalsToSlide = (slide, globals) ->
  Object.keys(globals).forEach (key) ->
    slide.attributes[key] = globals[key]

mainHelper = (context) ->
  slideData = context.data.root

  bodies = slideData.slides.map (slide) ->
    yaml.dump(slide.attributes) + '\n' + slide.body

  bodies.join('\n---\n');

exports.processors = [ addGlobalsToSlide ]

exports.helpers =
  slidewinder: mainHelper
