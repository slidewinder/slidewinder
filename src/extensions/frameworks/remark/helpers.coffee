log = require '../../../lib/log.js'
yaml = require 'js-yaml'
handlebars = require 'handlebars'
_ = require 'lodash'

slide_properties = [
  'name'
  'class'
  'background-image'
  'count'
  'template'
  'layout'
]

composeSlide = (slide) ->
  nprops = Object.keys(slide.properties).length
  (if nprops > 0 then yaml.dump(slide.properties) + '\n\n' else '') +
    slide.body

renderContextualData = (slide, data) ->
  slide.properties = _.pick(slide, slide_properties)
  render = handlebars.compile(slide.body)
  slide.body = render(data)
  slide

mainHelper = (context) ->
  bodies = context.data.root.slides.map composeSlide
  bodies.join('\n---\n');

module.exports.processors = [ renderContextualData ]

module.exports.helpers =
  slidewinder: mainHelper
