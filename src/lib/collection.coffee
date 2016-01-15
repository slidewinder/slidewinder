fs = require 'fs-extra'
path = require 'path'
log = require './log.js'

# An unordered collection of slides from which
# slides can be selected by name.
class collection

  constructor: (dir, @name) ->
    @dir = path.normalize(et(dir))
    @slides = {}
    this

  parse: () =>
    @slides = {}

    fs.readdirSync(@dir).forEach (file) =>
      if file.substr(-3) == '.md'
        filepath = path.resolve(@dir, file)
        data = fs.readFileSync(filepath, 'utf8')
        slide = fm data
        name = slide.attributes.name

        if @slides[name]
          log.error('Multiple slides have the name', name, 'in one collection!')
        else
          @slides[name] = slide

    log.info('Loaded', @length(), 'markdown slide files from', @dir)

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

module.exports = collection
