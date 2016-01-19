fs = require 'fs-extra'
path = require 'path'


# -------

# HANDY pre-generated directory paths

helper = {}

dirs =
  datadir : path.join(__dirname, '..', 'data')
  exampledir : path.join(__dirname, '..', '..', 'examples')
  libdir : path.join(__dirname, '..', '..', 'lib')
  bindir : path.join(__dirname, '..', '..', 'bin')
  extensiondir : path.join(__dirname, '..', '..', 'extensions')

dirs.oa_figures = path.join(dirs.datadir, 'open_access_figures', 'data')
dirs.tortoises = path.join(dirs.oa_figures, 'tortoise')
dirs.tardigrades = path.join(dirs.oa_figures, 'tardigrades')

helper.dirs = dirs

# -------

# HANDY file finding and (optionally) reading

# ## *data*
#
# **given** a data filename
# **then** synchronously read that file from the data directory
helper.data = (file, read=true) ->
  filepath = path.join(dirs.datadir, file)
  if read then fs.readFileSync(filepath) else filepath

# ## *example*
#
# **given** an example filename
# **then** synchronously read that file from the example directory
helper.example = (file, read=true) ->
  filepath = path.join(dirs.exampledir, file)
  if read then fs.readFileSync(filepath) else filepath

# ## *lib*
#
# **given** a lib filename
# **then** require that file from the lib directory
helper.lib = (file, read=true) ->
  filepath = path.join(dirs.libdir, file)
  if read then require(filepath) else filepath

# ## *bin*
#
# **given** a bin filename
# **then** require that file from the bin directory
helper.bin = (file, read=true) ->
  filepath = path.join(dirs.bindir, file)
  if read then require(filepath) else filepath

# ## *extension*
#
# **given** an extension filename
# **then** require that file from the extension directory
helper.extension = (file, read=true) ->
  filepath = path.join(dirs.extensiondir, file)
  if read then require(filepath) else filepath

# -------

# HANDY instance generators

librarian = helper.lib 'librarian.js'

# console.log helper.lib('libraries')

helper.big_library = () ->
  new librarian(dirs.exampledir, dirs.tortoises, dirs.tardigrades)

module.exports = helper
