fs = require 'fs-extra'
path = require 'path'

datadir = path.join(__dirname, '..', 'data')
exampledir = path.join(__dirname, '..', '..', 'examples')
libdir = path.join(__dirname, '..', '..', 'lib')
bindir = path.join(__dirname, '..', '..', 'bin')
extensiondir = path.join(__dirname, '..', '..', 'extensions')

# ## *data*
#
# **given** a data filename
# **then** synchronously read that file from the data directory
exports.data = (file) ->
  fs.readFileSync path.join(datadir, file)

# ## *example*
#
# **given** an example filename
# **then** synchronously read that file from the example directory
exports.example = (file) ->
  fs.readFileSync path.join(exampledir, file)

# ## *lib*
#
# **given** a lib filename
# **then** require that file from the lib directory
exports.lib = (file) ->
  require path.join(libdir, file)

# ## *bin*
#
# **given** a bin filename
# **then** require that file from the bin directory
exports.bin = (file) ->
  require path.join(bindir, file)

# ## *extension*
#
# **given** an extension filename
# **then** require that file from the extension directory
exports.extension = (file) ->
  require path.join(extensiondir, file)
