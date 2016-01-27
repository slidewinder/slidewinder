fs = require 'fs-extra'
et = require 'expand-tilde'
yaml = require 'js-yaml'
frontmatter = require 'front-matter'
path = require 'path'
log = require('./log.js')()
uuid = require 'node-uuid'

required_keys = [ 'name',
  'slide_author',
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
    if options && options.markdown
      @loadMarkdown(options.markdown)
    else if options
      @loadRaw(options)
    @_setid()
    this

  loadMarkdown: (filepath) =>
    @status = { success: true, detail: [] }

    if filepath.slice(-3) == '.md'
      data = fs.readFileSync(filepath, 'utf8')
      raw = frontmatter data
      raw.attributes.body = raw.body
      Object.assign(this, raw.attributes)
    else
      @status.success = false
      @status.detail = 'file was not markdown'
    @status

  loadRaw: (options) ->
    @status = { success: true, detail: [] }
    if @loadRequiredProperties(options, @status.detail)
      @loadOptionalProperties(options)
    @status

  dump: () => {
    author: @author
    title: @title
    body: @body
    parent: @parent
    children: @children
    tags: @tags
    js: @js
    css: @css
    data: @data
  }

  _setid: () ->
    @id or= uuid.v4()

  _setnewid: () ->
    @id = uuid.v4()

  clone: () ->
    child = new slide()
    Object.assign(child, this)
    child.parent = @id
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
    filepath = path.join(et(dir), "#{@id}.md")
    fs.outputFileSync(filepath, completeBody)

module.exports = slide
