fs = require 'fs-extra'
path = require 'path'

e =
  datadir : path.join(__dirname, '..', 'data')
  exampledir : path.join(__dirname, '..', '..', 'examples')
  libdir : path.join(__dirname, '..', '..', 'lib')
  bindir : path.join(__dirname, '..', '..', 'bin')
  extensiondir : path.join(__dirname, '..', '..', 'extensions')

# ## *data*
#
# **given** a data filename
# **then** synchronously read that file from the data directory
exports.data = (file, read=true) ->
  filepath = path.join(e.datadir, file)
  if read then fs.readFileSync(filepath) else filepath

# ## *example*
#
# **given** an example filename
# **then** synchronously read that file from the example directory
exports.example = (file, read=true) ->
  filepath = path.join(e.exampledir, file)
  if read then fs.readFileSync(filepath) else filepath

# ## *lib*
#
# **given** a lib filename
# **then** require that file from the lib directory
exports.lib = (file, read=true) ->
  filepath = path.join(e.libdir, file)
  if read then require(filepath) else filepath

# ## *bin*
#
# **given** a bin filename
# **then** require that file from the bin directory
exports.bin = (file, read=true) ->
  filepath = path.join(e.bindir, file)
  if read then require(filepath) else filepath

# ## *extension*
#
# **given** an extension filename
# **then** require that file from the extension directory
exports.extension = (file, read=true) ->
  filepath = path.join(e.extensiondir, file)
  if read then require(filepath) else filepath

exports.dirs = e
