fs = require 'fs-extra'
et = require 'expand-tilde'
yaml = require 'js-yaml'
path = require 'path'
log = require('./log.js')()
uuid = require 'node-uuid'
_ = require 'lodash'

required_keys = [ 'name',
  'author',
  'body'
]

optional_keys = [ 'id',
  'parent',
  'children',
  'css',
  'js',
  'tags',
]

class slide

  constructor: (options) ->
    @parent = null
    @children = []
    @tags = []
    @data = {}
    if options and options.filepath and options.importer
      @loadFile(options)
    else if options
      @loadRaw(options)
    @_setid()
    this

  loadFile: (options) =>
    @status = { success: true, detail: [] }
    if options.importer.supports(options.filepath)
      slide = options.importer.read(options.filepath)
      Object.assign(this, slide)
    else
      @status.success = false
      @status.detail = 'File was not supported by importer'
    @status

  loadRaw: (raw) ->
    @status = { success: true, detail: [] }
    Object.assign(this, raw)

  dump: () =>
    _.omitBy(_.pick(this, Object.keys this), _.isFunction)

  _setid: () ->
    @_id or= uuid.v4()

  _setnewid: () ->
    @_id = uuid.v4()

  clone: () ->
    child = new slide()
    Object.assign(child, this)
    child.parent = @_id
    child._setnewid()
    @children.push child.id
    child

  writeSync: (dir) ->
    self = this
    attributes = @metadata
    required_keys.forEach (key) ->
      attributes[key] = self[key] unless key == 'body'
    optional_keys.forEach (key) ->
      attributes[key] = self[key] if (key of self) and self[key]?
    completeBody =
      "---\n#{yaml.dump(attributes)}" +
      "---\n#{@body}"
    filepath = path.join(et(dir), "#{@_id}.md")
    fs.outputFileSync(filepath, completeBody)

module.exports = slide
