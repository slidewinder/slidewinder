fs = require 'fs-extra'
path = require 'path'
logger = require('./log.js').logger()


# An unordered collection of slides from which
# slides can be selected by name.
class collection

  constructor: (folder, @name) ->
    @folder = path.normalize(et(folder))
    @slides = {}
    this

  parse: () =>
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

  names: () ->
    Object.keys(@slides)

  length: () ->
    @names().length

  select: (name) ->
    if not @slides[name]?
      log.error('No slide exists in collection', @name, 'with a name of', name)
      process.exit()

    @slides[name]

  writeSync: (dir) ->
    @names().forEach (key) =>
      slide = @slides[key]
      completeBody = "---\n#{yaml.dump(slide.attributes)}---\n#{slide.body}"
      fs.outputFileSync(path.join(et(dir), "#{key}.md"),completeBody)
