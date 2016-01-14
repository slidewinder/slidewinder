fs = require 'fs-extra'
path = require 'path'
logger = require('./log.js').logger()


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
