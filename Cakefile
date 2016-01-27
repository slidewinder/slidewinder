# ** Cakefile Template ** is a Template for a common Cakefile that you
# may use in a coffeescript nodejs project.
#
# Modified from: https://github.com/twilson63/cakefile-template
#
# It comes baked in with 5 tasks:
#
# * build - compiles your src directory to your lib directory
# * test  - runs mocha test framework with istanbul coverage analysis
# * test-nocov - runs mocha without coverage
# * docs  - generates annotated documentation using docco
# * clean - clean generated .js files
dirs = [
  'lib'
  'routes'
  'extensions'
  'bin'
]

fs = require 'fs-extra'
path = require 'path'
{print} = require 'util'
child_process = require 'child_process'
spawnSync = child_process.spawnSync
util = require 'util'

# ANSI Terminal Colors
bold = '\x1b[0;1m'
green = '\x1b[0;32m'
reset = '\x1b[0m'
red = '\x1b[0;31m'

# Cakefile Tasks
#
# ## *docs*
#
# Generate Annotated Documentation
#
# <small>Usage</small>
#
# ```
# cake docs
# ```
task 'docs', 'generate documentation', -> docco()

# ## *build*
#
# Builds Source
#
# <small>Usage</small>
#
# ```
# cake build
# ```
task 'build', 'compile source', (options) -> clean -> build()

# ## *test-nocov*
#
# Runs your test suite without coverage analysis.
#
# <small>Usage</small>
#
# ```
# cake test-nocov
# ```
task 'test-nocov', 'run tests without coverage', -> clean -> build -> mocha()


# ## *test*
#
# Runs your test suite and collects coverage data.
#
# <small>Usage</small>
#
# ```
# cake test
# ```
task 'test', 'run test suite', -> clean -> build -> istanbul()


# ## *clean*
#
# Cleans up generated js files
#
# <small>Usage</small>
#
# ```
# cake clean
# ```
task 'clean', 'clean generated files', -> clean()

# ## *log*
#
# **given** string as a message
# **and** string as a color
# **and** optional string as an explanation
# **then** builds a statement and logs to console.
#
log = (message, color, explanation) ->
  console.log color + message + reset + ' ' + (explanation or '')

# ## *launch*
#
# **given** string as a cmd
# **and** optional array and option flags
# **and** optional callback
# **then** spawn cmd with options
# **and** pipe to process stdout and stderr respectively
# **and** on child process exit emit callback if set and status is 0
launch = (cmd, options=[], callback) ->
  _cmd = path.join('./node_modules/.bin', cmd)
  log('  running command:', green, [cmd].concat(options).join(' '))
  app = spawnSync(_cmd, options, { stdio: [0, 0, 0] })

  if app.status is 0
    callback?()
  else
    log('✗ command failed:', red, cmd)
    # process.exit(app.status);

# ## *build*
#
# **given** optional boolean as watch
# **and** optional function as callback
# **then** invoke launch passing coffee command
# **and** defaulted options to compile src to lib
build = (callback) ->
  options = ['-c', '-b', '--no-header', '-o']
  dirs.forEach (dir) ->
    launch('coffee', options.concat([dir, path.join('src', dir)]))

  log("  making binaries executable", green)
  fs.chmodSync('bin/slidewinder.js', '0755')
  log("  moving framework assets", green)
  fwsrc = 'src/extensions/frameworks'
  fwdst = 'extensions/frameworks'
  fs.readdirSync(fwsrc).forEach (d) ->
    fs.readdirSync(path.join(fwsrc, d)).forEach (f) ->
      return if f.match /\.coffee$/
      srcfile = path.join(fwsrc, d, f)
      dstfile = path.join(fwdst, d, f)
      fs.copySync(srcfile, dstfile)
  log('✓ compiled coffeescript', green)
  callback?()

# ## *clean*
#
# **given** optional function as callback
# **then** loop through dirs variable
# **and** call unlinkIfCoffeeFile on each
clean = (callback) ->
  for dir in dirs
    log('  removing dir:', green, dir)
    fs.removeSync(dir)
  log('✓ cleaned up old build files', green)
  callback?()

# ## *moduleExists*
#
# **given** name for module
# **when** trying to require module
# **and** not found
# **then* print not found message with install helper in red
# **and* return false if not found
moduleExists = (name) ->
  try
    require name
  catch err
    log "✗ #{name} required: npm install #{name}", red
    false

# ## *mocha*
#
# **given** optional array of option flags
# **and** optional function as callback
# **then** invoke launch passing mocha command
mocha = (options=[], callback) ->
  if typeof options is 'function'
    callback = options
    options = []

  # add coffee directive
  options.push '--compilers'
  options.push 'coffee:coffee-script/register'

  launch 'mocha', options, callback

# ## *instanbul*
#
# **given** optional function as callback
# **then** run instanbul coverage analysis
istanbul = (callback) ->
  options = ['cover', '_mocha', '--']
  # add coffee directive
  options.push '--compilers'
  options.push 'coffee:coffee-script/register'

  launch 'istanbul', options, callback

# ## *docco*
#
# **given** optional function as callback
# **then** invoke launch passing docco command
docco = (callback) ->
  coffee_files = []
  fs.walk('src')
    .on('data', (file) ->
      coffee_files.push(file.path) if /coffee$/.test(file.path)
    )
    .on('end', () ->
      launch 'docco', coffee_files, callback
    )
