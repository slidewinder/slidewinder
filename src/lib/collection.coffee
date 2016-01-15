slide = require './slide.js'
log = require './log.js'

fs = require 'fs-extra'
et = require 'expand-tilde'
path = require 'path'
uuid = require 'node-uuid'

# An unordered collection of slides.
# Slides can be retrieved very rapidly by identifier,
# or (less rapidly) searched by fulltext+metadata or any part of metadata
class collection

  constructor: (dir, @name) ->
    @dir = path.normalize(et(dir))
    @slides = {}
    this

  add: (_slide) ->
    if _slide
      null

  identifier: () ->
    @_id or= uuid.v4()

  load: () ->
    @slides = {}

    fs.readdirSync(@dir).forEach (file) =>
      if file.substr(-3) == '.md'
        filepath = path.resolve(@dir, file)
        this_slide = new slide({ markdown: filepath })
        @slides[this_slide.identifier()] = this_slide

    log.info('Loaded', @length(), 'markdown slide files from', @dir)

  names: () ->
    @slides.map (s) -> s.name

  length: () ->
    @slides.length

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
