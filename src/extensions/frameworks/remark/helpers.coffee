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

cleanupBgImg = (text) ->
  regex = /background\-image\: \'url\((.+)\)\'/
  replace = 'background-image: url($1)'
  text.replace(regex, replace)

composeSlide = (slide) ->
  nprops = Object.keys(slide.properties).length
  text = (if nprops > 0 then yaml.dump(slide.properties) + '\n\n' else '') +
    slide.body
  cleanupBgImg text

renderContextualData = (slide, data) ->
  slide.properties = _.pick(slide, slide_properties)
  render = handlebars.compile(slide.body)
  slide.body = render(data)
  slide

mainHelper = (context) ->
  bodies = context.data.root.slides.map composeSlide
  bodies.join('\n---\n')

module.exports.processors = [ renderContextualData ]

module.exports.helpers =
  slidewinder: mainHelper
